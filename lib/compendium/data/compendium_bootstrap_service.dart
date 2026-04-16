import 'dart:convert';
import 'dart:isolate';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_database_provider.dart';
import 'package:openrpg/compendium/models/compendium_browse_asset.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';

const String kCompendiumBrowseManifestAssetPath =
    'assets/rulesets/browse_manifest.json';

typedef AssetStringReader = Future<String> Function(String path);
typedef AssetBinaryReader = Future<ByteData> Function(String path);

enum CompendiumBootstrapFailureStage {
  manifestLoad('manifest load'),
  manifestParse('manifest parse'),
  manifestValidation('manifest validation'),
  shardLoad('shard load'),
  shardDecode('shard decode'),
  dbImport('DB import');

  final String label;

  const CompendiumBootstrapFailureStage(this.label);
}

class CompendiumBootstrapFailure implements Exception {
  final CompendiumBootstrapFailureStage stage;
  final String message;

  const CompendiumBootstrapFailure({
    required this.stage,
    required this.message,
  });

  @override
  String toString() => '${stage.label} failed: $message';
}

class CompendiumBootstrapService {
  final CompendiumDatabase _database;
  final AssetStringReader _stringReader;
  final AssetBinaryReader _binaryReader;

  Future<void>? _ongoingBootstrap;

  CompendiumBootstrapService({
    CompendiumDatabase? database,
    AssetStringReader? stringReader,
    AssetBinaryReader? binaryReader,
  }) : _database = database ?? sharedCompendiumDatabase,
       _stringReader = stringReader ?? rootBundle.loadString,
       _binaryReader = binaryReader ?? rootBundle.load;

  Future<CompendiumBrowseManifest> loadManifest() async {
    final manifestJson = await _readManifestJson();
    try {
      final decoded = jsonDecode(manifestJson);
      if (decoded is! Map) {
        throw const FormatException('The manifest root must be a JSON object.');
      }

      return CompendiumBrowseManifest.fromJson(decoded.cast<String, dynamic>());
    } catch (error) {
      throw _wrapBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.manifestParse,
        error: error,
        fallbackMessage:
            'Unable to decode $kCompendiumBrowseManifestAssetPath.',
      );
    }
  }

  Stream<CompendiumBootstrapStatus> watchStatus(String rulesetId) {
    return (_database.select(
      _database.compendiumBootstrapStates,
    )..where((tbl) => tbl.rulesetId.equals(rulesetId))).watchSingleOrNull().map(
      (row) => row == null
          ? CompendiumBootstrapStatus.idle(rulesetId: rulesetId)
          : _mapStatus(row),
    );
  }

  Future<CompendiumBootstrapStatus> loadStatus(String rulesetId) async {
    final row = await (_database.select(
      _database.compendiumBootstrapStates,
    )..where((tbl) => tbl.rulesetId.equals(rulesetId))).getSingleOrNull();
    return row == null
        ? CompendiumBootstrapStatus.idle(rulesetId: rulesetId)
        : _mapStatus(row);
  }

  Future<void> ensureBootstrapped() async {
    final manifest = await loadManifest();
    return ensureBootstrappedWithManifest(manifest);
  }

  Future<void> ensureBootstrappedWithManifest(
    CompendiumBrowseManifest manifest,
  ) {
    return _ongoingBootstrap ??= _runBootstrapWithManifest(manifest)
        .whenComplete(() {
          _ongoingBootstrap = null;
        });
  }

  Future<String> _readManifestJson() async {
    try {
      return await _stringReader(kCompendiumBrowseManifestAssetPath);
    } catch (error) {
      throw _wrapBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.manifestLoad,
        error: error,
        fallbackMessage: 'Unable to open $kCompendiumBrowseManifestAssetPath.',
      );
    }
  }

  Future<void> _runBootstrapWithManifest(
    CompendiumBrowseManifest manifest,
  ) async {
    final rulesets = _validatedRulesets(manifest);
    for (final ruleset in rulesets) {
      final status = await loadStatus(ruleset.rulesetId);
      final installed =
          await (_database.select(_database.rulesetRecords)
                ..where((tbl) => tbl.rulesetId.equals(ruleset.rulesetId)))
              .getSingleOrNull();
      if (status.isReady &&
          status.assetVersion == manifest.assetVersion &&
          installed != null) {
        continue;
      }

      try {
        await _preflightRuleset(ruleset);
        await _bootstrapRuleset(
          assetVersion: manifest.assetVersion,
          ruleset: ruleset,
        );
      } catch (error) {
        await _writeFailureStateSafely(
          rulesetId: ruleset.rulesetId,
          assetVersion: manifest.assetVersion,
          lastError: _describeBootstrapError(error),
        );
        rethrow;
      }
    }
  }

  List<CompendiumBrowseRulesetAsset> _validatedRulesets(
    CompendiumBrowseManifest manifest,
  ) {
    if (manifest.rulesets.isEmpty) {
      throw const CompendiumBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.manifestValidation,
        message: 'The bundled starter manifest does not list any rulesets.',
      );
    }

    return manifest.rulesets;
  }

  Future<void> _preflightRuleset(CompendiumBrowseRulesetAsset ruleset) async {
    final rulesetId = ruleset.rulesetId.trim();
    if (rulesetId.isEmpty) {
      throw const CompendiumBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.manifestValidation,
        message: 'The bundled starter manifest is missing a ruleset id.',
      );
    }

    if (ruleset.shards.isEmpty) {
      throw CompendiumBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.manifestValidation,
        message:
            'Bundled ruleset "${_displayRulesetName(ruleset)}" does not list any browse shards.',
      );
    }

    final firstShard = ruleset.shards.first;
    final assetPath = firstShard.assetPath.trim();
    if (assetPath.isEmpty) {
      throw CompendiumBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.manifestValidation,
        message:
            'Bundled ruleset "${_displayRulesetName(ruleset)}" contains an empty shard asset path.',
      );
    }

    await _loadShardBytes(assetPath);
  }

  Future<void> _writeFailureStateSafely({
    required String rulesetId,
    required String assetVersion,
    required String lastError,
  }) async {
    try {
      await _writeBootstrapState(
        rulesetId: rulesetId,
        assetVersion: assetVersion,
        phase: CompendiumBootstrapPhase.failed,
        progress: 0,
        lastError: lastError,
      );
    } catch (_) {
      // Preserve the original bootstrap error when the failure state itself
      // cannot be written.
    }
  }

  String _displayRulesetName(CompendiumBrowseRulesetAsset ruleset) {
    final name = ruleset.name.trim();
    if (name.isNotEmpty) {
      return name;
    }

    return ruleset.rulesetId.trim().isNotEmpty
        ? ruleset.rulesetId.trim()
        : 'unknown ruleset';
  }

  String _describeBootstrapError(Object error) {
    if (error is CompendiumBootstrapFailure) {
      return error.toString();
    }

    return _errorMessage(error);
  }

  CompendiumBootstrapFailure _wrapBootstrapFailure({
    required CompendiumBootstrapFailureStage stage,
    required Object error,
    required String fallbackMessage,
  }) {
    final detail = _errorMessage(error).trim();
    if (detail.isEmpty || detail == fallbackMessage) {
      return CompendiumBootstrapFailure(stage: stage, message: fallbackMessage);
    }

    return CompendiumBootstrapFailure(
      stage: stage,
      message: '$fallbackMessage $detail',
    );
  }

  String _errorMessage(Object error) {
    final message = error.toString().trim();
    if (error is CompendiumBootstrapFailure) {
      return error.message;
    }

    if (message.isEmpty) {
      return 'No additional details were provided.';
    }

    return message;
  }

  Future<ByteData> _loadShardBytes(String assetPath) async {
    try {
      return await _binaryReader(assetPath);
    } catch (error) {
      throw _wrapBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.shardLoad,
        error: error,
        fallbackMessage: 'Unable to read asset "$assetPath".',
      );
    }
  }

  Future<void> _runDbImportStep(
    Future<void> Function() operation, {
    required String actionDescription,
  }) async {
    try {
      await operation();
    } catch (error) {
      throw _wrapBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.dbImport,
        error: error,
        fallbackMessage: 'Unable to $actionDescription.',
      );
    }
  }

  Future<void> _bootstrapRuleset({
    required String assetVersion,
    required CompendiumBrowseRulesetAsset ruleset,
  }) async {
    await _writeBootstrapState(
      rulesetId: ruleset.rulesetId,
      assetVersion: assetVersion,
      phase: CompendiumBootstrapPhase.running,
      progress: 0,
      lastError: null,
    );
    await _runDbImportStep(
      () => _clearRulesetData(ruleset.rulesetId),
      actionDescription: 'clear existing data for ${ruleset.rulesetId}',
    );

    final shardCount = ruleset.shards.length;
    for (var index = 0; index < shardCount; index++) {
      final shard = ruleset.shards[index];
      final bytes = await _loadShardBytes(shard.assetPath);
      final payload = await _decodeShardPayload(
        bytes,
        assetPath: shard.assetPath,
      );
      await _runDbImportStep(
        () =>
            _insertShardPayload(rulesetId: ruleset.rulesetId, payload: payload),
        actionDescription: 'import shard "${shard.assetPath}"',
      );
      await _writeBootstrapState(
        rulesetId: ruleset.rulesetId,
        assetVersion: assetVersion,
        phase: CompendiumBootstrapPhase.running,
        progress: (index + 1) / shardCount,
        lastError: null,
      );
      if (kIsWeb) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    await _runDbImportStep(
      () =>
          _finalizeRulesetImport(assetVersion: assetVersion, ruleset: ruleset),
      actionDescription: 'finalize the bundled starter import',
    );
  }

  Future<void> _clearRulesetData(String rulesetId) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.entityLinks,
      )..where((tbl) => tbl.rulesetId.equals(rulesetId))).go();
      await (_database.delete(
        _database.entityRecords,
      )..where((tbl) => tbl.rulesetId.equals(rulesetId))).go();
      await (_database.delete(
        _database.rulesetCollectionStats,
      )..where((tbl) => tbl.rulesetId.equals(rulesetId))).go();
      await (_database.delete(
        _database.rulesetRecords,
      )..where((tbl) => tbl.rulesetId.equals(rulesetId))).go();
    });
  }

  Future<void> _finalizeRulesetImport({
    required String assetVersion,
    required CompendiumBrowseRulesetAsset ruleset,
  }) async {
    await _database.transaction(() async {
      await _database
          .into(_database.rulesetRecords)
          .insertOnConflictUpdate(
            RulesetRecordsCompanion.insert(
              rulesetId: ruleset.rulesetId,
              name: ruleset.name,
              description: drift.Value(ruleset.description),
              mode: ruleset.mode,
              schemaVersion: ruleset.schemaVersion,
              author: drift.Value(ruleset.author),
              version: drift.Value(ruleset.version),
              license: drift.Value(ruleset.license),
              entityCount: drift.Value(ruleset.entityCount),
              createdAt: drift.Value(ruleset.createdAt),
              updatedAt: drift.Value(ruleset.updatedAt),
              filePath: ruleset.filePath,
              payloadJson: const drift.Value('{}'),
              extraJson: const drift.Value('{}'),
            ),
          );

      await (_database.delete(
        _database.rulesetCollectionStats,
      )..where((tbl) => tbl.rulesetId.equals(ruleset.rulesetId))).go();

      for (final stat in ruleset.collectionStats) {
        await _database
            .into(_database.rulesetCollectionStats)
            .insertOnConflictUpdate(
              RulesetCollectionStatsCompanion.insert(
                rulesetId: ruleset.rulesetId,
                entityType: stat.entityType,
                collectionKey: stat.collectionKey,
                label: stat.label,
                entityCount: drift.Value(stat.entityCount),
              ),
            );
      }

      await _database
          .into(_database.compendiumBootstrapStates)
          .insertOnConflictUpdate(
            CompendiumBootstrapStatesCompanion.insert(
              rulesetId: ruleset.rulesetId,
              assetVersion: drift.Value(assetVersion),
              state: drift.Value(CompendiumBootstrapPhase.ready.name),
              progress: const drift.Value(1),
              lastError: const drift.Value.absent(),
              updatedAt: drift.Value(DateTime.now()),
            ),
          );
    });
  }

  Future<void> _insertShardPayload({
    required String rulesetId,
    required CompendiumBrowseShardPayload payload,
  }) async {
    const chunkSize = 250;

    final entityRows = payload.entityRows;
    for (var start = 0; start < entityRows.length; start += chunkSize) {
      final end = start + chunkSize > entityRows.length
          ? entityRows.length
          : start + chunkSize;
      final chunk = entityRows.sublist(start, end);
      await _database.batch((batch) {
        batch.insertAll(
          _database.entityRecords,
          chunk
              .map(
                (row) => EntityRecordsCompanion.insert(
                  rulesetId: rulesetId,
                  entityType: payload.entityType,
                  entityId: row.entityId,
                  collectionKey: payload.collectionKey,
                  name: row.name,
                  source: drift.Value(row.source),
                  sourceFile: drift.Value(row.sourceFile),
                  edition: drift.Value(row.edition),
                  sortName: drift.Value(row.sortName),
                  searchText: drift.Value(row.searchText),
                  payloadJson: row.payloadJson,
                ),
              )
              .toList(growable: false),
          mode: drift.InsertMode.insertOrReplace,
        );
      });
      if (kIsWeb) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    final linkRows = payload.linkRows;
    for (var start = 0; start < linkRows.length; start += chunkSize) {
      final end = start + chunkSize > linkRows.length
          ? linkRows.length
          : start + chunkSize;
      final chunk = linkRows.sublist(start, end);
      await _database.batch((batch) {
        batch.insertAll(
          _database.entityLinks,
          chunk
              .map(
                (row) => EntityLinksCompanion.insert(
                  rulesetId: rulesetId,
                  sourceEntityType: row.sourceEntityType,
                  sourceEntityId: row.sourceEntityId,
                  targetTag: row.targetTag,
                  rawReference: row.rawReference,
                  displayText: row.displayText,
                  sourceHint: drift.Value(row.sourceHint),
                  targetEntityType: drift.Value(row.targetEntityType),
                ),
              )
              .toList(growable: false),
        );
      });
      if (kIsWeb) {
        await Future<void>.delayed(Duration.zero);
      }
    }
  }

  Future<CompendiumBrowseShardPayload> _decodeShardPayload(
    ByteData data, {
    required String assetPath,
  }) async {
    try {
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      if (kIsWeb) {
        return CompendiumBrowseShardPayload.fromJson(
          jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>,
        );
      }

      final transferable = TransferableTypedData.fromList([bytes]);
      final decoded = await Isolate.run<Map<String, dynamic>>(
        () => _decodeShardPayloadMap(transferable),
      );
      return CompendiumBrowseShardPayload.fromJson(decoded);
    } catch (error) {
      throw _wrapBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.shardDecode,
        error: error,
        fallbackMessage: 'Unable to decode asset "$assetPath".',
      );
    }
  }

  Future<void> _writeBootstrapState({
    required String rulesetId,
    required String assetVersion,
    required CompendiumBootstrapPhase phase,
    required double progress,
    required String? lastError,
  }) async {
    await _database
        .into(_database.compendiumBootstrapStates)
        .insertOnConflictUpdate(
          CompendiumBootstrapStatesCompanion.insert(
            rulesetId: rulesetId,
            assetVersion: drift.Value(assetVersion),
            state: drift.Value(phase.name),
            progress: drift.Value(progress.clamp(0, 1).toDouble()),
            lastError: drift.Value(lastError),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
  }

  CompendiumBootstrapStatus _mapStatus(CompendiumBootstrapState row) {
    final phase = CompendiumBootstrapPhase.values.firstWhere(
      (candidate) => candidate.name == row.state,
      orElse: () => CompendiumBootstrapPhase.idle,
    );
    return CompendiumBootstrapStatus(
      rulesetId: row.rulesetId,
      assetVersion: row.assetVersion,
      phase: phase,
      progress: row.progress,
      lastError: row.lastError,
      updatedAt: row.updatedAt,
    );
  }
}

Map<String, dynamic> _decodeShardPayloadMap(
  TransferableTypedData transferable,
) {
  final bytes = transferable.materialize().asUint8List();
  return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
}
