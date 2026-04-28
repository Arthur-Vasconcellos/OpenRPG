import 'dart:convert';
import 'dart:isolate';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_database_provider.dart';
import 'package:openrpg/compendium/data/ruleset_portability.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_browse_asset.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/compendium/models/ruleset.dart';

typedef AssetStringLoader = Future<String> Function(String path);
typedef RulesetDocumentLoader =
    Future<Uint8List?> Function(String sourceReference);
typedef ImportedRulesetDocumentPersister =
    Future<String> Function({
      required String sourceReference,
      required String fileName,
    });

enum CompendiumImportPhase {
  fileRead,
  decode,
  normalize,
  shardPreparation,
  dbWrite,
  finalize,
}

class CompendiumImportProgress {
  final CompendiumImportPhase phase;
  final double progress;
  final String message;

  const CompendiumImportProgress({
    required this.phase,
    required this.progress,
    required this.message,
  });
}

typedef CompendiumImportProgressCallback =
    void Function(CompendiumImportProgress progress);

class CompendiumRepository {
  static const List<String> bundledRulesetAssets = <String>[
    'assets/rulesets/starter_2024_srd.ruleset.json',
  ];

  final CompendiumDatabase _database;
  final AssetStringLoader _assetLoader;
  final CompendiumBrowseRepository _browseRepository;
  final RulesetDocumentLoader _documentLoader;
  final ImportedRulesetDocumentPersister _documentPersister;

  CompendiumRepository({
    CompendiumDatabase? database,
    AssetStringLoader? assetLoader,
    RulesetDocumentLoader? documentLoader,
    ImportedRulesetDocumentPersister? documentPersister,
  }) : _database = database ?? sharedCompendiumDatabase,
       _assetLoader = assetLoader ?? rootBundle.loadString,
       _documentLoader = documentLoader ?? loadRulesetImportBytes,
       _documentPersister =
           documentPersister ?? persistImportedRulesetJsonDocument,
       _browseRepository = CompendiumBrowseRepository(
         database: database ?? sharedCompendiumDatabase,
       );

  Future<void> seedBundledRulesets() async {
    return;
  }

  Future<List<RulesetSummary>> loadInstalledRulesets() async {
    final query = _database.select(_database.rulesetRecords)
      ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.name)]);
    final records = await query.get();
    return records.map(_mapRulesetSummary).toList(growable: false);
  }

  Future<Ruleset> createRuleset({
    required String name,
    String description = '',
  }) async {
    final ruleset = Ruleset.createBlank(
      id: _availableRulesetId(name),
      name: name.trim(),
      description: description.trim(),
    );
    await saveRuleset(ruleset);
    return ruleset;
  }

  Future<Ruleset> duplicateRuleset(String rulesetId, {String? newName}) async {
    final source = await loadRuleset(rulesetId);
    final duplicateName = newName?.trim().isNotEmpty == true
        ? newName!.trim()
        : '${source.name} Copy';
    final duplicate = source.copyWith(
      id: _availableRulesetId(duplicateName),
      name: duplicateName,
      mode: RulesetMode.editable,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await saveRuleset(duplicate);
    return duplicate;
  }

  Future<Ruleset> loadRuleset(String rulesetId) async {
    final record = await (_database.select(
      _database.rulesetRecords,
    )..where((tbl) => tbl.rulesetId.equals(rulesetId))).getSingleOrNull();
    if (record == null) {
      throw StateError('Ruleset $rulesetId was not found.');
    }

    return _decodeStoredRuleset(record);
  }

  Future<void> saveRuleset(Ruleset ruleset) async {
    final normalized = ruleset.copyWith(
      schemaVersion: kCurrentRulesetSchemaVersion,
      updatedAt: DateTime.now(),
    );
    await _indexRuleset(normalized, _storageReferenceFor(normalized));
  }

  Future<void> deleteRuleset(String rulesetId) async {
    final ruleset = await loadRuleset(rulesetId);
    if (ruleset.mode == RulesetMode.bundled) {
      throw StateError('Bundled rulesets are read-only.');
    }

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

  Future<void> saveEntity({
    required String rulesetId,
    required CompendiumEntity entity,
  }) async {
    final ruleset = await loadRuleset(rulesetId);
    if (ruleset.mode == RulesetMode.bundled) {
      throw StateError('Bundled rulesets are read-only.');
    }

    await saveRuleset(ruleset.upsertEntity(entity));
  }

  Future<void> deleteEntity({
    required String rulesetId,
    required String entityType,
    required String entityId,
  }) async {
    final ruleset = await loadRuleset(rulesetId);
    if (ruleset.mode == RulesetMode.bundled) {
      throw StateError('Bundled rulesets are read-only.');
    }

    await saveRuleset(ruleset.removeEntity(entityType, entityId));
  }

  Future<Ruleset> importRulesetJson(
    String jsonString, {
    CompendiumImportProgressCallback? onProgress,
  }) async {
    _reportImportProgress(
      onProgress,
      phase: CompendiumImportPhase.decode,
      progress: 0.15,
      message: 'Decoding ruleset JSON…',
    );
    final prepared = await _prepareImportedRuleset(
      Uint8List.fromList(utf8.encode(jsonString)),
      includePayloadJson: true,
      onProgress: onProgress,
    );
    _reportImportProgress(
      onProgress,
      phase: CompendiumImportPhase.dbWrite,
      progress: 0.85,
      message: 'Writing ruleset data…',
    );
    await _persistPreparedImport(
      prepared: prepared,
      filePath: '${prepared.rulesetId}.ruleset.json',
      payloadJson: prepared.payloadJson ?? '{}',
    );
    _reportImportProgress(
      onProgress,
      phase: CompendiumImportPhase.finalize,
      progress: 1,
      message: 'Import complete.',
    );
    return prepared.toLightweightRuleset();
  }

  Future<Ruleset> importRulesetFile(
    String sourceReference, {
    CompendiumImportProgressCallback? onProgress,
  }) async {
    final bytes = await _documentLoader(sourceReference);
    if (bytes == null || bytes.isEmpty) {
      throw StateError('Unable to read the selected file on this platform.');
    }
    _reportImportProgress(
      onProgress,
      phase: CompendiumImportPhase.fileRead,
      progress: 0.1,
      message: 'Reading selected file…',
    );

    final prepared = await _prepareImportedRuleset(
      bytes,
      includePayloadJson: false,
      onProgress: onProgress,
    );
    final persistedPath = await _documentPersister(
      sourceReference: sourceReference,
      fileName: '${prepared.rulesetId}.ruleset.json',
    );
    _reportImportProgress(
      onProgress,
      phase: CompendiumImportPhase.dbWrite,
      progress: 0.85,
      message: 'Writing ruleset data…',
    );
    await _persistPreparedImport(
      prepared: prepared,
      filePath: persistedPath,
      payloadJson: '{}',
    );
    _reportImportProgress(
      onProgress,
      phase: CompendiumImportPhase.finalize,
      progress: 1,
      message: 'Import complete.',
    );
    return prepared.toLightweightRuleset();
  }

  Future<String> exportRulesetJson(String rulesetId) async {
    final ruleset = await loadRuleset(rulesetId);
    return const JsonEncoder.withIndent('  ').convert(ruleset.toJson());
  }

  Future<RulesetExportResult> exportRulesetFile(String rulesetId) async {
    final ruleset = await loadRuleset(rulesetId);
    final jsonString = const JsonEncoder.withIndent(
      '  ',
    ).convert(ruleset.toJson());
    return exportRulesetJsonDocument(
      fileName: '${ruleset.id}.ruleset.json',
      jsonString: jsonString,
    );
  }

  Future<CompendiumCollectionPage> getCollectionPage({
    required String rulesetId,
    required String entityType,
    String query = '',
    int page = 0,
    int pageSize = 100,
  }) async {
    return _browseRepository.loadCollectionPage(
      rulesetId: rulesetId,
      entityType: entityType,
      query: query,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<List<CompendiumSearchResult>> searchEntities(
    CompendiumSearchQuery query,
  ) async {
    return _browseRepository.searchEntityPreviews(query);
  }

  Future<CompendiumEntityDetail> getEntityDetail({
    required String rulesetId,
    required String entityType,
    required String entityId,
  }) async {
    return _browseRepository.loadEntityDetail(
      rulesetId: rulesetId,
      entityType: entityType,
      entityId: entityId,
    );
  }

  Future<CompendiumSearchResult?> resolveLink(
    CompendiumLinkCandidate candidate, {
    String? preferredRulesetId,
  }) async {
    return _browseRepository.resolveLink(
      candidate,
      preferredRulesetId: preferredRulesetId,
    );
  }

  RulesetSummary _mapRulesetSummary(RulesetRecord record) {
    return RulesetSummary(
      id: record.rulesetId,
      name: record.name,
      description: record.description,
      mode: record.mode,
      schemaVersion: record.schemaVersion,
      author: record.author,
      version: record.version,
      license: record.license,
      entityCount: record.entityCount,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      filePath: record.filePath,
    );
  }

  Ruleset _normalizeRuleset(
    Map<String, dynamic> json, {
    RulesetMode? forcedMode,
  }) {
    return Ruleset.fromJson(
      _normalizeRulesetJsonMap(json, forcedMode: forcedMode),
    );
  }

  Future<void> _indexRuleset(Ruleset ruleset, String filePath) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.entityLinks,
      )..where((tbl) => tbl.rulesetId.equals(ruleset.id))).go();
      await (_database.delete(
        _database.entityRecords,
      )..where((tbl) => tbl.rulesetId.equals(ruleset.id))).go();
      await (_database.delete(
        _database.rulesetCollectionStats,
      )..where((tbl) => tbl.rulesetId.equals(ruleset.id))).go();

      await _database
          .into(_database.rulesetRecords)
          .insertOnConflictUpdate(
            RulesetRecordsCompanion.insert(
              rulesetId: ruleset.id,
              name: ruleset.name,
              description: drift.Value(ruleset.description),
              mode: ruleset.mode.name,
              schemaVersion: ruleset.schemaVersion,
              author: drift.Value(ruleset.author),
              version: drift.Value(ruleset.version),
              license: drift.Value(ruleset.license),
              entityCount: drift.Value(ruleset.totalEntityCount),
              createdAt: drift.Value(ruleset.createdAt),
              updatedAt: drift.Value(ruleset.updatedAt),
              filePath: filePath,
              payloadJson: drift.Value(jsonEncode(ruleset.toJson())),
              extraJson: drift.Value(jsonEncode(ruleset.extra)),
            ),
          );

      for (final view in ruleset.collectionViews) {
        await _database
            .into(_database.rulesetCollectionStats)
            .insertOnConflictUpdate(
              RulesetCollectionStatsCompanion.insert(
                rulesetId: ruleset.id,
                entityType: view.definition.entityType,
                collectionKey: view.definition.collectionKey,
                label: view.definition.label,
                entityCount: drift.Value(view.entities.length),
              ),
            );
      }

      for (final entity in ruleset.allEntities) {
        await _database
            .into(_database.entityRecords)
            .insertOnConflictUpdate(
              EntityRecordsCompanion.insert(
                rulesetId: ruleset.id,
                entityType: entity.entityType,
                entityId: entity.id,
                collectionKey: entity.collectionKey,
                name: entity.displayName,
                source: const drift.Value(''),
                sourceFile: const drift.Value(''),
                edition: const drift.Value(null),
                sortName: drift.Value(
                  CompendiumJsonUtils.sortName(entity.displayName),
                ),
                searchText: drift.Value(
                  CompendiumJsonUtils.flattenedSearchText(
                    entity.toJson(),
                  ).toLowerCase(),
                ),
                payloadJson: jsonEncode(entity.toJson()),
              ),
            );

        final links = _extractLinks(entity);
        for (final link in links) {
          await _database
              .into(_database.entityLinks)
              .insert(
                EntityLinksCompanion.insert(
                  rulesetId: ruleset.id,
                  sourceEntityType: entity.entityType,
                  sourceEntityId: entity.id,
                  targetTag: link.tag,
                  rawReference: link.rawReference,
                  displayText: link.displayText,
                  sourceHint: const drift.Value(null),
                  targetEntityType: drift.Value(link.targetEntityType),
                ),
              );
        }
      }
    });
  }

  List<CompendiumLinkCandidate> _extractLinks(CompendiumEntity entity) {
    return _extractLinksFromValue(entity.data);
  }

  Future<Ruleset> _decodeStoredRuleset(RulesetRecord record) async {
    if (_hasStoredPayload(record.payloadJson)) {
      return _decodeRulesetJson(record.payloadJson);
    }

    final indexedRuleset = await _decodeIndexedRuleset(record);
    if (indexedRuleset != null) {
      return indexedRuleset;
    }

    if (record.mode == RulesetMode.bundled.name &&
        bundledRulesetAssets.contains(record.filePath)) {
      final jsonString = await _assetLoader(record.filePath);
      final ruleset = _normalizeRuleset(
        jsonDecode(jsonString) as Map<String, dynamic>,
        forcedMode: RulesetMode.bundled,
      );
      await _indexRuleset(ruleset, record.filePath);
      return ruleset;
    }

    throw StateError('Ruleset ${record.rulesetId} could not be loaded.');
  }

  Ruleset _decodeRulesetJson(String jsonString) {
    return _normalizeRuleset(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  Future<Ruleset?> _decodeIndexedRuleset(RulesetRecord record) async {
    final rows =
        await (_database.select(_database.entityRecords)
              ..where((tbl) => tbl.rulesetId.equals(record.rulesetId))
              ..orderBy([
                (tbl) => drift.OrderingTerm.asc(tbl.entityType),
                (tbl) => drift.OrderingTerm.asc(tbl.sortName),
              ]))
            .get();

    if (rows.isEmpty) {
      final statRows = await (_database.select(
        _database.rulesetCollectionStats,
      )..where((tbl) => tbl.rulesetId.equals(record.rulesetId))).get();
      if (statRows.isEmpty) {
        return null;
      }
    }

    final collections = <String, List<CompendiumEntity>>{
      for (final descriptor in compendiumEntityDescriptors)
        descriptor.collection.collectionKey: <CompendiumEntity>[],
    };

    for (final row in rows) {
      final payload = jsonDecode(row.payloadJson);
      if (payload is! Map) {
        continue;
      }

      final entity = parseEntityJson(
        row.entityType,
        payload.cast<String, dynamic>(),
      );
      if (entity == null) {
        continue;
      }

      collections.putIfAbsent(row.collectionKey, () => <CompendiumEntity>[]);
      collections[row.collectionKey]!.add(entity);
    }

    return Ruleset(
      schemaVersion: record.schemaVersion,
      id: record.rulesetId,
      name: record.name,
      description: record.description,
      author: record.author,
      version: record.version,
      license: record.license,
      mode: _parseRulesetMode(record.mode) ?? RulesetMode.imported,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      collections: collections,
      extra: _decodeExtraJson(record.extraJson),
    );
  }

  Map<String, dynamic> _decodeExtraJson(String extraJson) {
    final trimmed = extraJson.trim();
    if (trimmed.isEmpty || trimmed == '{}') {
      return const <String, dynamic>{};
    }

    final decoded = jsonDecode(trimmed);
    if (decoded is! Map) {
      return const <String, dynamic>{};
    }

    return decoded.cast<String, dynamic>();
  }

  bool _hasStoredPayload(String payloadJson) {
    final trimmed = payloadJson.trim();
    return trimmed.isNotEmpty && trimmed != '{}';
  }

  RulesetMode? _parseRulesetMode(String modeName) {
    for (final mode in RulesetMode.values) {
      if (mode.name == modeName) {
        return mode;
      }
    }

    return null;
  }

  String _storageReferenceFor(Ruleset ruleset) {
    if (ruleset.mode == RulesetMode.bundled) {
      final assetPath = bundledRulesetAssets.cast<String?>().firstWhere(
        (candidate) =>
            candidate?.contains('${ruleset.id}.ruleset.json') == true,
        orElse: () => null,
      );
      if (assetPath != null) {
        return assetPath;
      }
    }

    return '${ruleset.id}.ruleset.json';
  }

  String _availableRulesetId(String name) {
    final base = CompendiumJsonUtils.slugify(name.isEmpty ? 'ruleset' : name);
    return base.isEmpty ? 'ruleset' : base;
  }

  void _reportImportProgress(
    CompendiumImportProgressCallback? callback, {
    required CompendiumImportPhase phase,
    required double progress,
    required String message,
  }) {
    callback?.call(
      CompendiumImportProgress(
        phase: phase,
        progress: progress.clamp(0, 1).toDouble(),
        message: message,
      ),
    );
  }

  Future<_PreparedRulesetImportData> _prepareImportedRuleset(
    Uint8List bytes, {
    required bool includePayloadJson,
    CompendiumImportProgressCallback? onProgress,
  }) async {
    _reportImportProgress(
      onProgress,
      phase: CompendiumImportPhase.decode,
      progress: 0.25,
      message: 'Decoding ruleset content…',
    );
    final raw = await _prepareImportedRulesetMap(
      bytes,
      includePayloadJson: includePayloadJson,
      onProgress: onProgress,
    );
    _reportImportProgress(
      onProgress,
      phase: CompendiumImportPhase.shardPreparation,
      progress: 0.7,
      message: 'Preparing indexed records…',
    );
    return _PreparedRulesetImportData.fromJson(raw);
  }

  Future<Map<String, dynamic>> _prepareImportedRulesetMap(
    Uint8List bytes, {
    required bool includePayloadJson,
    CompendiumImportProgressCallback? onProgress,
  }) async {
    if (kIsWeb) {
      _reportImportProgress(
        onProgress,
        phase: CompendiumImportPhase.normalize,
        progress: 0.45,
        message: 'Normalizing imported content…',
      );
      return _prepareRulesetImportMapFromBytes(
        bytes,
        includePayloadJson: includePayloadJson,
      );
    }

    final transferable = TransferableTypedData.fromList([bytes]);
    _reportImportProgress(
      onProgress,
      phase: CompendiumImportPhase.normalize,
      progress: 0.45,
      message: 'Normalizing imported content…',
    );
    return Isolate.run<Map<String, dynamic>>(
      () => _prepareRulesetImportMapFromTransferable(
        transferable,
        includePayloadJson: includePayloadJson,
      ),
    );
  }

  Future<void> _persistPreparedImport({
    required _PreparedRulesetImportData prepared,
    required String filePath,
    required String payloadJson,
  }) async {
    await _clearRulesetIndex(prepared.rulesetId);
    try {
      await _insertPreparedShards(prepared);
      await _database.transaction(() async {
        await _database
            .into(_database.rulesetRecords)
            .insertOnConflictUpdate(
              RulesetRecordsCompanion.insert(
                rulesetId: prepared.rulesetId,
                name: prepared.name,
                description: drift.Value(prepared.description),
                mode: prepared.mode.name,
                schemaVersion: prepared.schemaVersion,
                author: drift.Value(prepared.author),
                version: drift.Value(prepared.version),
                license: drift.Value(prepared.license),
                entityCount: drift.Value(prepared.entityCount),
                createdAt: drift.Value(prepared.createdAt),
                updatedAt: drift.Value(prepared.updatedAt),
                filePath: filePath,
                payloadJson: drift.Value(payloadJson),
                extraJson: drift.Value(prepared.extraJson),
              ),
            );

        for (final stat in prepared.collectionStats) {
          await _database
              .into(_database.rulesetCollectionStats)
              .insertOnConflictUpdate(
                RulesetCollectionStatsCompanion.insert(
                  rulesetId: prepared.rulesetId,
                  entityType: stat.entityType,
                  collectionKey: stat.collectionKey,
                  label: stat.label,
                  entityCount: drift.Value(stat.entityCount),
                ),
              );
        }
      });
    } catch (_) {
      await _clearRulesetIndex(prepared.rulesetId);
      rethrow;
    }
  }

  Future<void> _insertPreparedShards(
    _PreparedRulesetImportData prepared,
  ) async {
    const chunkSize = 250;

    for (final shard in prepared.shards) {
      final entityRows = shard.entityRows;
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
                    rulesetId: prepared.rulesetId,
                    entityType: shard.entityType,
                    entityId: row.entityId,
                    collectionKey: shard.collectionKey,
                    name: row.name,
                    source: const drift.Value(''),
                    sourceFile: const drift.Value(''),
                    edition: const drift.Value(null),
                    sortName: drift.Value(row.sortName),
                    searchText: drift.Value(row.searchText),
                    payloadJson: row.payloadJson,
                  ),
                )
                .toList(growable: false),
          );
        });
        if (kIsWeb) {
          await Future<void>.delayed(Duration.zero);
        }
      }

      final linkRows = shard.linkRows;
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
                    rulesetId: prepared.rulesetId,
                    sourceEntityType: row.sourceEntityType,
                    sourceEntityId: row.sourceEntityId,
                    targetTag: row.targetTag,
                    rawReference: row.rawReference,
                    displayText: row.displayText,
                    sourceHint: const drift.Value(null),
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
  }

  Future<void> _clearRulesetIndex(String rulesetId) async {
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
}

class _PreparedRulesetImportData {
  final String rulesetId;
  final String schemaVersion;
  final String name;
  final String description;
  final String author;
  final String version;
  final String license;
  final RulesetMode mode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int entityCount;
  final String extraJson;
  final String? payloadJson;
  final List<CompendiumBrowseCollectionStatAsset> collectionStats;
  final List<CompendiumBrowseShardPayload> shards;

  const _PreparedRulesetImportData({
    required this.rulesetId,
    required this.schemaVersion,
    required this.name,
    required this.description,
    required this.author,
    required this.version,
    required this.license,
    required this.mode,
    required this.createdAt,
    required this.updatedAt,
    required this.entityCount,
    required this.extraJson,
    required this.payloadJson,
    required this.collectionStats,
    required this.shards,
  });

  factory _PreparedRulesetImportData.fromJson(Map<String, dynamic> json) {
    final schemaVersion = json['schemaVersion']?.toString().trim() ?? '';
    if (schemaVersion != kCurrentRulesetSchemaVersion) {
      throw FormatException(
        'Unsupported ruleset schema version "$schemaVersion".',
      );
    }
    return _PreparedRulesetImportData(
      rulesetId: json['rulesetId']?.toString() ?? '',
      schemaVersion: schemaVersion,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      version: json['version']?.toString() ?? '1.0.0',
      license: json['license']?.toString() ?? '',
      mode: RulesetMode.fromValue(
        json['mode']?.toString() ?? RulesetMode.imported.name,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      entityCount: (json['entityCount'] as num?)?.toInt() ?? 0,
      extraJson: json['extraJson']?.toString() ?? '{}',
      payloadJson: json['payloadJson']?.toString(),
      collectionStats: (json['collectionStats'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (entry) => CompendiumBrowseCollectionStatAsset.fromJson(
              entry.cast<String, dynamic>(),
            ),
          )
          .toList(growable: false),
      shards: (json['shards'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (entry) => CompendiumBrowseShardPayload.fromJson(
              entry.cast<String, dynamic>(),
            ),
          )
          .toList(growable: false),
    );
  }

  Ruleset toLightweightRuleset() {
    return Ruleset(
      schemaVersion: schemaVersion,
      id: rulesetId,
      name: name,
      description: description,
      author: author,
      version: version,
      license: license,
      mode: mode,
      createdAt: createdAt,
      updatedAt: updatedAt,
      collections: {
        for (final descriptor in compendiumEntityDescriptors)
          descriptor.collection.collectionKey: const <CompendiumEntity>[],
      },
    );
  }
}

Map<String, dynamic> _normalizeRulesetJsonMap(
  Map<String, dynamic> json, {
  RulesetMode? forcedMode,
}) {
  final normalized = CompendiumJsonUtils.jsonMap(json);
  final rawMode = normalized['mode']?.toString().trim() ?? '';
  if (rawMode.isNotEmpty &&
      !RulesetMode.values.any((mode) => mode.name == rawMode)) {
    throw FormatException(
      'Ruleset "mode" must be one of: ${RulesetMode.values.map((mode) => mode.name).join(', ')}.',
    );
  }

  final rawId = normalized['id']?.toString().trim() ?? '';
  final rawName = normalized['name']?.toString().trim() ?? '';
  if (rawId.isEmpty && rawName.isEmpty) {
    throw const FormatException(
      'Ruleset import requires a non-empty "name" or "id".',
    );
  }

  final rawSchemaVersion = normalized['schemaVersion']?.toString().trim() ?? '';
  if (rawSchemaVersion != kCurrentRulesetSchemaVersion) {
    throw FormatException(
      'Unsupported ruleset schema version "$rawSchemaVersion".',
    );
  }
  normalized['schemaVersion'] = kCurrentRulesetSchemaVersion;
  normalized['mode'] =
      forcedMode?.name ??
      (rawMode.isNotEmpty ? rawMode : RulesetMode.imported.name);
  normalized['id'] = rawId.isNotEmpty
      ? rawId
      : CompendiumJsonUtils.slugify(rawName);
  normalized['name'] = rawName.isNotEmpty
      ? rawName
      : normalized['id'].toString();
  normalized['description'] = normalized['description']?.toString() ?? '';
  normalized['author'] = normalized['author']?.toString() ?? '';
  normalized['version'] = normalized['version']?.toString() ?? '1.0.0';
  normalized['license'] = normalized['license']?.toString() ?? '';
  return normalized;
}

Map<String, dynamic> _prepareRulesetImportMapFromTransferable(
  TransferableTypedData transferable, {
  required bool includePayloadJson,
}) {
  final bytes = transferable.materialize().asUint8List();
  return _prepareRulesetImportMapFromBytes(
    bytes,
    includePayloadJson: includePayloadJson,
  );
}

Map<String, dynamic> _prepareRulesetImportMapFromBytes(
  Uint8List bytes, {
  required bool includePayloadJson,
}) {
  final jsonString = utf8.decode(bytes);
  final decoded = jsonDecode(jsonString);
  if (decoded is! Map) {
    throw const FormatException(
      'The selected ruleset file must contain a JSON object at the root.',
    );
  }

  final normalized = _normalizeRulesetJsonMap(
    decoded.cast<String, dynamic>(),
    forcedMode: RulesetMode.imported,
  );
  final rulesetId = normalized['id']?.toString() ?? 'ruleset';
  final knownTopLevelKeys = <String>{
    'schemaVersion',
    'id',
    'name',
    'description',
    'author',
    'version',
    'license',
    'mode',
    'createdAt',
    'updatedAt',
    ...compendiumEntityDescriptors.map(
      (descriptor) => descriptor.collection.collectionKey,
    ),
  };

  final extra = <String, dynamic>{};
  for (final entry in normalized.entries) {
    if (knownTopLevelKeys.contains(entry.key) || entry.value is List) {
      continue;
    }
    extra[entry.key] = CompendiumJsonUtils.deepCopy(entry.value);
  }

  final collectionStats = <Map<String, dynamic>>[];
  final shards = <Map<String, dynamic>>[];
  final normalizedCollections = <String, List<Map<String, dynamic>>>{
    for (final descriptor in compendiumEntityDescriptors)
      descriptor.collection.collectionKey: <Map<String, dynamic>>[],
  };
  var entityCount = 0;
  final usedEntityIdsByType = <String, Set<String>>{};

  for (final descriptor in compendiumEntityDescriptors) {
    final entityRows = <Map<String, dynamic>>[];
    final linkRows = <Map<String, dynamic>>[];
    final rawList = normalized[descriptor.collection.collectionKey];
    if (rawList != null && rawList is! List) {
      throw FormatException(
        'Ruleset collection "${descriptor.collection.collectionKey}" must be a JSON array.',
      );
    }
    if (rawList is List) {
      for (var index = 0; index < rawList.length; index += 1) {
        final item = rawList[index];
        if (item is! Map) {
          throw FormatException(
            'Ruleset collection "${descriptor.collection.collectionKey}" entry ${index + 1} must be an object.',
          );
        }

        final entityJson = CompendiumJsonUtils.jsonMap(item);
        late final CompendiumEntity entity;
        try {
          entity = descriptor.fromJson(entityJson);
        } on FormatException catch (error) {
          throw FormatException(
            'Invalid ${descriptor.collection.entityType} entry at '
            '"${descriptor.collection.collectionKey}[${index + 1}]": ${error.message}',
          );
        } catch (error) {
          throw FormatException(
            'Invalid ${descriptor.collection.entityType} entry at '
            '"${descriptor.collection.collectionKey}[${index + 1}]": $error',
          );
        }

        if (entity.displayName.trim().isEmpty) {
          throw FormatException(
            'Ruleset collection "${descriptor.collection.collectionKey}" entry ${index + 1} is missing a usable name.',
          );
        }

        final payload = entity.toJson();
        final entityId = _resolveUniqueImportedEntityId(
          entityType: descriptor.collection.entityType,
          payload: payload,
          usedIds: usedEntityIdsByType.putIfAbsent(
            descriptor.collection.entityType,
            () => <String>{},
          ),
        );
        payload['id'] = entityId;
        normalizedCollections[descriptor.collection.collectionKey]!.add(
          CompendiumJsonUtils.deepCopyMap(payload),
        );
        entityRows.add({
          'entityId': entityId,
          'name': entity.displayName,
          'source': '',
          'sourceFile': '',
          'edition': null,
          'sortName': CompendiumJsonUtils.sortName(entity.displayName),
          'searchText': CompendiumJsonUtils.flattenedSearchText(
            payload,
          ).toLowerCase(),
          'payloadJson': jsonEncode(payload),
        });
        entityCount += 1;

        for (final link in _extractLinksFromValue(entity.data)) {
          linkRows.add({
            'sourceEntityType': entity.entityType,
            'sourceEntityId': entityId,
            'targetTag': link.tag,
            'rawReference': link.rawReference,
            'displayText': link.displayText,
            'sourceHint': null,
            'targetEntityType': link.targetEntityType,
          });
        }
      }
    }

    collectionStats.add({
      'entityType': descriptor.collection.entityType,
      'collectionKey': descriptor.collection.collectionKey,
      'label': descriptor.collection.label,
      'entityCount': entityRows.length,
    });
    if (entityRows.isNotEmpty || linkRows.isNotEmpty) {
      shards.add({
        'rulesetId': rulesetId,
        'entityType': descriptor.collection.entityType,
        'collectionKey': descriptor.collection.collectionKey,
        'entityRows': entityRows,
        'linkRows': linkRows,
      });
    }
  }

  final createdAt = normalized['createdAt'] != null
      ? DateTime.tryParse(normalized['createdAt'].toString())?.toIso8601String()
      : null;
  final exportedRuleset = <String, dynamic>{
    'schemaVersion':
        normalized['schemaVersion']?.toString() ?? kCurrentRulesetSchemaVersion,
    'id': rulesetId,
    'name': normalized['name']?.toString() ?? rulesetId,
    'description': normalized['description']?.toString() ?? '',
    'author': normalized['author']?.toString() ?? '',
    'version': normalized['version']?.toString() ?? '1.0.0',
    'license': normalized['license']?.toString() ?? '',
    'mode': RulesetMode.imported.name,
    if (createdAt != null) 'createdAt': createdAt,
    'updatedAt': DateTime.now().toIso8601String(),
    ...CompendiumJsonUtils.deepCopyMap(extra),
  };
  for (final descriptor in compendiumEntityDescriptors) {
    exportedRuleset[descriptor.collection.collectionKey] =
        normalizedCollections[descriptor.collection.collectionKey]!
            .map(CompendiumJsonUtils.deepCopyMap)
            .toList(growable: false);
  }

  return {
    'rulesetId': rulesetId,
    'schemaVersion':
        normalized['schemaVersion']?.toString() ?? kCurrentRulesetSchemaVersion,
    'name': normalized['name']?.toString() ?? rulesetId,
    'description': normalized['description']?.toString() ?? '',
    'author': normalized['author']?.toString() ?? '',
    'version': normalized['version']?.toString() ?? '1.0.0',
    'license': normalized['license']?.toString() ?? '',
    'mode': RulesetMode.imported.name,
    'createdAt': createdAt,
    'updatedAt': DateTime.now().toIso8601String(),
    'entityCount': entityCount,
    'extraJson': jsonEncode(extra),
    if (includePayloadJson) 'payloadJson': jsonEncode(exportedRuleset),
    'collectionStats': collectionStats,
    'shards': shards,
  };
}

List<CompendiumLinkCandidate> _extractLinksFromValue(dynamic value) {
  final links = <CompendiumLinkCandidate>[];
  final seen = <String>{};

  void addLink(CompendiumLinkCandidate candidate) {
    final fingerprint =
        '${candidate.tag}|${candidate.rawReference}|${candidate.targetEntityType ?? ''}';
    if (seen.add(fingerprint)) {
      links.add(candidate);
    }
  }

  void visit(dynamic candidate, {String? currentKey}) {
    if (candidate is String) {
      for (final link in CompendiumLinkParser.extractAll(candidate)) {
        addLink(link);
      }
      final plainReference = CompendiumLinkParser.tryParsePlainReference(
        candidate,
        hintedFieldKey: currentKey,
      );
      if (plainReference != null) {
        addLink(plainReference);
      }
      return;
    }

    if (candidate is List) {
      for (final item in candidate) {
        visit(item, currentKey: currentKey);
      }
      return;
    }

    if (candidate is Map) {
      final asMap = candidate.cast<String, dynamic>();
      final mappedReference = CompendiumLinkParser.extractReferenceFromMap(
        asMap,
      );
      if (mappedReference != null) {
        addLink(mappedReference);
      }
      for (final entry in asMap.entries) {
        visit(entry.value, currentKey: entry.key);
      }
    }
  }

  visit(value);
  return links;
}

String _resolveUniqueImportedEntityId({
  required String entityType,
  required Map<String, dynamic> payload,
  required Set<String> usedIds,
}) {
  final baseId = CompendiumJsonUtils.stableEntityId(
    entityType: entityType,
    payload: payload,
  );
  if (usedIds.add(baseId)) {
    return baseId;
  }

  final fingerprinted =
      '$baseId:${CompendiumJsonUtils.stableDisambiguator(payload)}';
  if (usedIds.add(fingerprinted)) {
    return fingerprinted;
  }

  var suffix = 2;
  while (true) {
    final candidate = '$fingerprinted:$suffix';
    if (usedIds.add(candidate)) {
      return candidate;
    }
    suffix += 1;
  }
}
