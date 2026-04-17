import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_database_provider.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';

class CompendiumBrowseRepository {
  final CompendiumDatabase _database;

  CompendiumBrowseRepository({CompendiumDatabase? database})
    : _database = database ?? sharedCompendiumDatabase;

  Stream<List<RulesetSummary>> watchInstalledRulesets() {
    final query = _database.select(_database.rulesetRecords)
      ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.name)]);
    return query.watch().map(
      (rows) => rows.map(_mapRulesetSummary).toList(growable: false),
    );
  }

  Future<List<RulesetSummary>> loadInstalledRulesets() async {
    final query = _database.select(_database.rulesetRecords)
      ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.name)]);
    final rows = await query.get();
    return rows.map(_mapRulesetSummary).toList(growable: false);
  }

  Future<RulesetSummary> loadRulesetSummary(String rulesetId) async {
    final record = await (_database.select(
      _database.rulesetRecords,
    )..where((tbl) => tbl.rulesetId.equals(rulesetId))).getSingleOrNull();
    if (record == null) {
      throw StateError('Ruleset $rulesetId was not found.');
    }

    return _mapRulesetSummary(record);
  }

  Future<List<RulesetCollectionSummary>> loadCollectionSummaries(
    String rulesetId,
  ) async {
    final rows =
        await (_database.select(_database.rulesetCollectionStats)
              ..where((tbl) => tbl.rulesetId.equals(rulesetId))
              ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.label)]))
            .get();
    return rows
        .map(
          (row) => RulesetCollectionSummary(
            rulesetId: row.rulesetId,
            entityType: row.entityType,
            collectionKey: row.collectionKey,
            label: row.label,
            entityCount: row.entityCount,
          ),
        )
        .toList(growable: false);
  }

  Future<CompendiumCollectionPage> loadCollectionPage({
    required String rulesetId,
    required String entityType,
    String query = '',
    int page = 0,
    int pageSize = 100,
  }) async {
    final selection = _database.select(_database.entityRecords)
      ..where((tbl) => tbl.rulesetId.equals(rulesetId))
      ..where((tbl) => tbl.entityType.equals(entityType));

    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isNotEmpty) {
      selection.where((tbl) => tbl.searchText.like('%$trimmedQuery%'));
    }

    selection.orderBy([(tbl) => drift.OrderingTerm.asc(tbl.sortName)]);

    final totalCount = await selection.get().then((rows) => rows.length);
    selection.limit(pageSize, offset: page * pageSize);

    final rows = await selection.get();
    final items = rows.map(_mapEntityPreview).toList(growable: false);

    return CompendiumCollectionPage(
      rulesetId: rulesetId,
      entityType: entityType,
      items: items,
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      hasMore: (page + 1) * pageSize < totalCount,
    );
  }

  Future<List<CompendiumSearchResult>> searchEntityPreviews(
    CompendiumSearchQuery query,
  ) async {
    final selection = _database.select(_database.entityRecords);

    if (query.rulesetIds.isNotEmpty) {
      selection.where((tbl) => tbl.rulesetId.isIn(query.rulesetIds));
    }

    if (query.entityTypes.isNotEmpty) {
      selection.where((tbl) => tbl.entityType.isIn(query.entityTypes));
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
        .map((row) => CompendiumSearchResult(preview: _mapEntityPreview(row)))
        .toList(growable: false);
  }

  Future<CompendiumEntityDetail> loadEntityDetail({
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
      CompendiumJsonUtils.sanitizeEntityJson(
        jsonDecode(row.payloadJson) as Map<String, dynamic>,
      ),
    );
    if (entity == null) {
      throw StateError('Entity $entityId could not be decoded.');
    }

    final links =
        await (_database.select(_database.entityLinks)
              ..where((tbl) => tbl.rulesetId.equals(rulesetId))
              ..where((tbl) => tbl.sourceEntityType.equals(entityType))
              ..where((tbl) => tbl.sourceEntityId.equals(entityId)))
            .get();

    return CompendiumEntityDetail(
      rulesetId: rulesetId,
      entity: entity,
      outgoingLinks: links
          .map(
            (link) => CompendiumLinkCandidate(
              tag: link.targetTag,
              rawReference: link.rawReference,
              displayText: link.displayText,
              lookupName: link.displayText,
              targetEntityType: link.targetEntityType,
            ),
          )
          .toList(growable: false),
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
      ..where((tbl) => tbl.name.equals(candidate.lookupName));

    selection.limit(20);
    final initialRows = await selection.get();
    final rows = initialRows.where((row) {
      final payload = jsonDecode(row.payloadJson);
      if (payload is! Map<String, dynamic>) {
        return false;
      }
      return _matchesSemanticReference(
        entityType: candidate.targetEntityType!,
        payload: CompendiumJsonUtils.sanitizeEntityJson(payload),
        candidate: candidate,
      );
    }).toList(growable: false);
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

    return CompendiumSearchResult(preview: _mapEntityPreview(rows.first));
  }

  CompendiumEntityPreview _mapEntityPreview(EntityRecord row) {
    return CompendiumEntityPreview(
      rulesetId: row.rulesetId,
      entityType: row.entityType,
      entityId: row.entityId,
      name: row.name,
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

  bool _matchesSemanticReference({
    required String entityType,
    required Map<String, dynamic> payload,
    required CompendiumLinkCandidate candidate,
  }) {
    final parts = candidate.parts;
    final data = CompendiumJsonUtils.jsonMap(payload['data']);
    switch (entityType) {
      case 'classFeature':
        if (parts.length >= 2 &&
            (data['className']?.toString() ?? '') != parts[1]) {
          return false;
        }
        if (parts.length >= 3) {
          final expectedLevel = int.tryParse(
            parts[_looksLikeLegacyClassFeature(parts) ? 3 : 2],
          );
          if (expectedLevel != null && data['level'] != expectedLevel) {
            return false;
          }
        }
        return true;
      case 'subclass':
        return parts.length < 2 ||
            (data['className']?.toString() ?? '') == parts[1];
      case 'subclassFeature':
        if (parts.length < 2) {
          return true;
        }
        final expectedClassName = parts[1];
        final expectedSubclassShortName = parts[
            _looksLikeLegacySubclassFeature(parts) ? 3 : 2];
        final expectedLevel = int.tryParse(
          parts[_looksLikeLegacySubclassFeature(parts) ? 5 : 3],
        );
        if ((data['className']?.toString() ?? '') != expectedClassName) {
          return false;
        }
        if ((data['subclassShortName']?.toString() ?? '') !=
            expectedSubclassShortName) {
          return false;
        }
        return expectedLevel == null || data['level'] == expectedLevel;
      case 'subrace':
        return parts.length < 2 ||
            (data['raceName']?.toString() ?? '') == parts[1];
      default:
        return true;
    }
  }

  bool _looksLikeLegacyClassFeature(List<String> parts) {
    return parts.length >= 4 && int.tryParse(parts[2]) == null;
  }

  bool _looksLikeLegacySubclassFeature(List<String> parts) {
    return parts.length >= 6 && int.tryParse(parts[2]) == null;
  }
}
