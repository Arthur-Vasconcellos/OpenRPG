import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/services.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/ruleset_portability.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/compendium/models/ruleset.dart';

typedef AssetStringLoader = Future<String> Function(String path);

class CompendiumRepository {
  static const List<String> bundledRulesetAssets = <String>[
    'assets/rulesets/default_srd.ruleset.json',
  ];

  final CompendiumDatabase _database;
  final AssetStringLoader _assetLoader;

  CompendiumRepository({
    CompendiumDatabase? database,
    AssetStringLoader? assetLoader,
  }) : _database = database ?? const _CompendiumDatabaseFactory().instance,
       _assetLoader = assetLoader ?? rootBundle.loadString;

  Future<void> seedBundledRulesets() async {
    for (final assetPath in bundledRulesetAssets) {
      final jsonString = await _assetLoader(assetPath);
      final ruleset = _normalizeRuleset(
        jsonDecode(jsonString) as Map<String, dynamic>,
        forcedMode: RulesetMode.bundled,
      );
      await _indexRuleset(ruleset, assetPath);
    }
  }

  Future<List<RulesetSummary>> loadInstalledRulesets() async {
    await seedBundledRulesets();

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

  Future<Ruleset> importRulesetJson(String jsonString) async {
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final ruleset = _normalizeRuleset(
      jsonMap,
      forcedMode: RulesetMode.imported,
    );
    await saveRuleset(ruleset);
    return ruleset;
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
    String? source,
  }) async {
    final descriptor = descriptorForType(entityType);
    if (descriptor == null) {
      throw StateError('Unknown entity type $entityType.');
    }

    final selection = _database.select(_database.entityRecords)
      ..where((tbl) => tbl.rulesetId.equals(rulesetId))
      ..where((tbl) => tbl.entityType.equals(entityType));

    if (source != null && source.trim().isNotEmpty) {
      selection.where((tbl) => tbl.source.equals(source.trim()));
    }

    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isNotEmpty) {
      selection.where((tbl) => tbl.searchText.like('%$trimmedQuery%'));
    }

    selection.orderBy([(tbl) => drift.OrderingTerm.asc(tbl.sortName)]);

    final rows = await selection.get();
    final items = rows
        .map(
          (row) => parseEntityJson(
            entityType,
            jsonDecode(row.payloadJson) as Map<String, dynamic>,
          ),
        )
        .whereType<CompendiumEntity>()
        .toList(growable: false);

    final sources = <String>{
      for (final row in rows)
        if (row.source.trim().isNotEmpty) row.source.trim(),
    }.toList()..sort();

    return CompendiumCollectionPage(
      rulesetId: rulesetId,
      entityType: entityType,
      items: items,
      availableSources: sources,
    );
  }

  Future<List<CompendiumSearchResult>> searchEntities(
    CompendiumSearchQuery query,
  ) async {
    final selection = _database.select(_database.entityRecords);

    if (query.rulesetIds.isNotEmpty) {
      selection.where((tbl) => tbl.rulesetId.isIn(query.rulesetIds));
    }

    if (query.entityTypes.isNotEmpty) {
      selection.where((tbl) => tbl.entityType.isIn(query.entityTypes));
    }

    if (query.source != null && query.source!.trim().isNotEmpty) {
      selection.where((tbl) => tbl.source.equals(query.source!.trim()));
    }

    final trimmed = query.text.trim().toLowerCase();
    if (trimmed.isNotEmpty) {
      selection.where((tbl) => tbl.searchText.like('%$trimmed%'));
    }

    selection
      ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.sortName)])
      ..limit(query.limit);

    final rows = await selection.get();
    return rows
        .map(
          (row) => CompendiumSearchResult(
            rulesetId: row.rulesetId,
            entity: parseEntityJson(
              row.entityType,
              jsonDecode(row.payloadJson) as Map<String, dynamic>,
            )!,
          ),
        )
        .toList(growable: false);
  }

  Future<CompendiumEntityDetail> getEntityDetail({
    required String rulesetId,
    required String entityType,
    required String entityId,
  }) async {
    final row =
        await (_database.select(_database.entityRecords)
              ..where((tbl) => tbl.rulesetId.equals(rulesetId))
              ..where((tbl) => tbl.entityType.equals(entityType))
              ..where((tbl) => tbl.entityId.equals(entityId)))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Entity $entityId was not found.');
    }

    final entity = parseEntityJson(
      entityType,
      jsonDecode(row.payloadJson) as Map<String, dynamic>,
    )!;

    return CompendiumEntityDetail(
      rulesetId: rulesetId,
      entity: entity,
      outgoingLinks: _extractLinks(entity),
    );
  }

  Future<CompendiumSearchResult?> resolveLink(
    CompendiumLinkCandidate candidate, {
    String? preferredRulesetId,
  }) async {
    if (candidate.targetEntityType == null) {
      return null;
    }

    final selection = _database.select(_database.entityRecords)
      ..where((tbl) => tbl.entityType.equals(candidate.targetEntityType!))
      ..where((tbl) => tbl.name.equals(candidate.displayText));

    if (candidate.source != null && candidate.source!.trim().isNotEmpty) {
      selection.where((tbl) => tbl.source.equals(candidate.source!.trim()));
    }

    selection.limit(20);
    final rows = await selection.get();
    if (rows.isEmpty) {
      return null;
    }

    rows.sort((left, right) {
      final leftPreferred =
          preferredRulesetId != null && left.rulesetId == preferredRulesetId;
      final rightPreferred =
          preferredRulesetId != null && right.rulesetId == preferredRulesetId;
      if (leftPreferred != rightPreferred) {
        return leftPreferred ? -1 : 1;
      }

      return left.name.compareTo(right.name);
    });

    final row = rows.first;
    return CompendiumSearchResult(
      rulesetId: row.rulesetId,
      entity: parseEntityJson(
        row.entityType,
        jsonDecode(row.payloadJson) as Map<String, dynamic>,
      )!,
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
    final normalized = Map<String, dynamic>.from(json);
    normalized['schemaVersion'] =
        normalized['schemaVersion']?.toString().trim().isNotEmpty == true
        ? normalized['schemaVersion']
        : kCurrentRulesetSchemaVersion;
    normalized['mode'] =
        forcedMode?.name ??
        normalized['mode']?.toString() ??
        RulesetMode.imported.name;
    normalized['id'] = normalized['id']?.toString().trim().isNotEmpty == true
        ? normalized['id']
        : CompendiumJsonUtils.slugify(
            normalized['name']?.toString() ?? 'ruleset',
          );
    normalized['name'] =
        normalized['name']?.toString() ?? normalized['id'].toString();
    normalized['description'] = normalized['description']?.toString() ?? '';
    normalized['author'] = normalized['author']?.toString() ?? '';
    normalized['version'] = normalized['version']?.toString() ?? '1.0.0';
    normalized['license'] = normalized['license']?.toString() ?? '';
    return Ruleset.fromJson(normalized);
  }

  Future<void> _indexRuleset(Ruleset ruleset, String filePath) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.entityLinks,
      )..where((tbl) => tbl.rulesetId.equals(ruleset.id))).go();
      await (_database.delete(
        _database.entityRecords,
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
                source: drift.Value(entity.source),
                sourceFile: drift.Value(entity.sourceFile),
                edition: drift.Value(entity.edition),
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
                  sourceHint: drift.Value(link.source),
                  targetEntityType: drift.Value(link.targetEntityType),
                ),
              );
        }
      }
    });
  }

  List<CompendiumLinkCandidate> _extractLinks(CompendiumEntity entity) {
    final links = <CompendiumLinkCandidate>[];
    void visit(dynamic value) {
      if (value is String) {
        links.addAll(CompendiumLinkParser.extractAll(value));
        return;
      }

      if (value is List) {
        for (final item in value) {
          visit(item);
        }
        return;
      }

      if (value is Map) {
        for (final item in value.values) {
          visit(item);
        }
      }
    }

    visit(entity.data);
    return links;
  }

  Future<Ruleset> _decodeStoredRuleset(RulesetRecord record) async {
    if (_hasStoredPayload(record.payloadJson)) {
      return _decodeRulesetJson(record.payloadJson);
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

    final legacyJson = await loadLegacyRulesetJson(record.filePath);
    if (legacyJson != null) {
      final ruleset = _normalizeRuleset(
        jsonDecode(legacyJson) as Map<String, dynamic>,
        forcedMode: _parseRulesetMode(record.mode),
      );
      await _indexRuleset(ruleset, record.filePath);
      return ruleset;
    }

    throw StateError('Ruleset ${record.rulesetId} could not be loaded.');
  }

  Ruleset _decodeRulesetJson(String jsonString) {
    return _normalizeRuleset(jsonDecode(jsonString) as Map<String, dynamic>);
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
}

class _CompendiumDatabaseFactory {
  const _CompendiumDatabaseFactory();

  static final CompendiumDatabase _shared = CompendiumDatabase();

  CompendiumDatabase get instance => _shared;
}
