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

  Future<Map<String, dynamic>> loadRulesetExtraData(String rulesetId) async {
    final record = await (_database.select(
      _database.rulesetRecords,
    )..where((tbl) => tbl.rulesetId.equals(rulesetId))).getSingleOrNull();
    if (record == null || record.extraJson.trim().isEmpty) {
      return const <String, dynamic>{};
    }

    final decoded = jsonDecode(record.extraJson);
    if (decoded is! Map) {
      return const <String, dynamic>{};
    }
    return decoded.cast<String, dynamic>();
  }

  Future<List<RulesetCollectionSummary>> loadCollectionSummaries(
    String rulesetId,
  ) async {
    final statRows =
        await (_database.select(_database.rulesetCollectionStats)
              ..where((tbl) => tbl.rulesetId.equals(rulesetId))
              ..orderBy([(tbl) => drift.OrderingTerm.asc(tbl.label)]))
            .get();
    final visibleRows = await _loadVisibleEntityRowsForRuleset(rulesetId);
    final grouped = <String, List<EntityRecord>>{};
    for (final row in visibleRows) {
      grouped.putIfAbsent(row.collectionKey, () => <EntityRecord>[]).add(row);
    }

    return statRows
        .map(
          (row) => RulesetCollectionSummary(
            rulesetId: row.rulesetId,
            entityType: row.entityType,
            collectionKey: row.collectionKey,
            label: row.label,
            entityCount: grouped[row.collectionKey]?.length ?? 0,
            representativeEntries:
                (grouped[row.collectionKey] ?? const <EntityRecord>[])
                    .take(3)
                    .map(_mapEntityPreview)
                    .toList(growable: false),
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

    final rows = await selection.get();
    final archivedKeys = await _archivedKeysForRuleset(rulesetId);
    final visibleRows = rows
        .where((row) => !_isArchived(row, archivedKeys))
        .toList(growable: false);
    final totalCount = visibleRows.length;
    final pageRows = visibleRows
        .skip(page * pageSize)
        .take(pageSize)
        .toList(growable: false);
    final usageCounts = await _characterUsageCounts(
      rulesetId: rulesetId,
      entityType: entityType,
      entityIds: pageRows.map((row) => row.entityId).toSet(),
    );
    final inboundCounts = await _inboundReferenceCounts(
      rulesetId: rulesetId,
      entityType: entityType,
      entityNamesById: {for (final row in pageRows) row.entityId: row.name},
    );
    final items = pageRows
        .map(
          (row) => _mapEntityPreview(
            row,
            snippet: _snippetForQuery(row.searchText, trimmedQuery),
            inboundReferenceCount: inboundCounts[row.entityId] ?? 0,
            characterUsageCount: usageCounts[row.entityId] ?? 0,
          ),
        )
        .toList(growable: false);

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
      ..limit(query.limit * 3);

    final rows = await selection.get();
    final visibleRows = await _filterArchivedRows(rows);
    final limitedRows = visibleRows.take(query.limit).toList(growable: false);
    final usageCounts = await _characterUsageCountsForRows(limitedRows);
    final inboundCounts = await _inboundReferenceCountsForRows(limitedRows);

    return limitedRows
        .map(
          (row) => CompendiumSearchResult(
            preview: _mapEntityPreview(
              row,
              snippet: _snippetForQuery(row.searchText, trimmed),
              inboundReferenceCount: inboundCounts[row.entityId] ?? 0,
              characterUsageCount: usageCounts[row.entityId] ?? 0,
            ),
            snippet: _snippetForQuery(row.searchText, trimmed),
          ),
        )
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

  Future<CompendiumEntityImpact> loadEntityImpact({
    required String rulesetId,
    required String entityType,
    required String entityId,
    required String entityName,
  }) async {
    final usageCounts = await _characterUsageCounts(
      rulesetId: rulesetId,
      entityType: entityType,
      entityIds: {entityId},
    );
    final inboundCounts = await _inboundReferenceCounts(
      rulesetId: rulesetId,
      entityType: entityType,
      entityNamesById: {entityId: entityName},
    );
    return CompendiumEntityImpact(
      inboundReferenceCount: inboundCounts[entityId] ?? 0,
      characterUsageCount: usageCounts[entityId] ?? 0,
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
    final visibleRows = await _filterArchivedRows(initialRows);
    final rows = visibleRows
        .where((row) {
          final payload = jsonDecode(row.payloadJson);
          if (payload is! Map<String, dynamic>) {
            return false;
          }
          return _matchesSemanticReference(
            entityType: candidate.targetEntityType!,
            payload: CompendiumJsonUtils.sanitizeEntityJson(payload),
            candidate: candidate,
          );
        })
        .toList(growable: false);
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

  CompendiumEntityPreview _mapEntityPreview(
    EntityRecord row, {
    String snippet = '',
    int inboundReferenceCount = 0,
    int characterUsageCount = 0,
    bool archived = false,
  }) {
    return CompendiumEntityPreview(
      rulesetId: row.rulesetId,
      entityType: row.entityType,
      entityId: row.entityId,
      name: row.name,
      snippet: snippet,
      inboundReferenceCount: inboundReferenceCount,
      characterUsageCount: characterUsageCount,
      archived: archived,
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

  Future<List<EntityRecord>> _loadVisibleEntityRowsForRuleset(
    String rulesetId,
  ) async {
    final rows =
        await (_database.select(_database.entityRecords)
              ..where((tbl) => tbl.rulesetId.equals(rulesetId))
              ..orderBy([
                (tbl) => drift.OrderingTerm.asc(tbl.collectionKey),
                (tbl) => drift.OrderingTerm.asc(tbl.sortName),
              ]))
            .get();
    final archivedKeys = await _archivedKeysForRuleset(rulesetId);
    return rows
        .where((row) => !_isArchived(row, archivedKeys))
        .toList(growable: false);
  }

  Future<List<EntityRecord>> _filterArchivedRows(
    List<EntityRecord> rows,
  ) async {
    final archivedByRuleset = <String, Set<String>>{};
    final filtered = <EntityRecord>[];
    for (final row in rows) {
      final archivedKeys = archivedByRuleset.putIfAbsent(
        row.rulesetId,
        () => <String>{},
      );
      if (archivedKeys.isEmpty) {
        archivedByRuleset[row.rulesetId] = await _archivedKeysForRuleset(
          row.rulesetId,
        );
      }
      if (!_isArchived(row, archivedByRuleset[row.rulesetId]!)) {
        filtered.add(row);
      }
    }
    return filtered;
  }

  Future<Set<String>> _archivedKeysForRuleset(String rulesetId) async {
    final record = await (_database.select(
      _database.rulesetRecords,
    )..where((tbl) => tbl.rulesetId.equals(rulesetId))).getSingleOrNull();
    if (record == null || record.extraJson.trim().isEmpty) {
      return const <String>{};
    }

    final decoded = jsonDecode(record.extraJson);
    if (decoded is! Map<String, dynamic>) {
      return const <String>{};
    }

    final rawValues = decoded['archivedEntityKeys'];
    if (rawValues is! List) {
      return const <String>{};
    }

    return rawValues
        .map((value) => value.toString().trim())
        .where((value) => value.isNotEmpty)
        .toSet();
  }

  bool _isArchived(EntityRecord row, Set<String> archivedKeys) {
    return archivedKeys.contains(_entityKey(row.entityType, row.entityId));
  }

  String _entityKey(String entityType, String entityId) =>
      '$entityType:$entityId';

  String _snippetForQuery(String searchText, String query) {
    if (query.trim().isEmpty) {
      return '';
    }

    final normalizedText = searchText.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalizedText.isEmpty) {
      return '';
    }

    final lower = normalizedText.toLowerCase();
    final startIndex = lower.indexOf(query);
    if (startIndex < 0) {
      return normalizedText.length <= 140
          ? normalizedText
          : '${normalizedText.substring(0, 137)}...';
    }

    final snippetStart = (startIndex - 48).clamp(0, normalizedText.length);
    final snippetEnd = (startIndex + query.length + 72).clamp(
      0,
      normalizedText.length,
    );
    final prefix = snippetStart > 0 ? '...' : '';
    final suffix = snippetEnd < normalizedText.length ? '...' : '';
    return '$prefix${normalizedText.substring(snippetStart, snippetEnd)}$suffix';
  }

  Future<Map<String, int>> _characterUsageCountsForRows(
    List<EntityRecord> rows,
  ) async {
    final grouped = <String, Set<String>>{};
    for (final row in rows) {
      grouped.putIfAbsent(row.rulesetId, () => <String>{}).add(row.entityType);
    }

    final results = <String, int>{};
    for (final row in rows) {
      results[row.entityId] = 0;
    }

    final characterRows = await _database
        .select(_database.characterRecords)
        .get();
    for (final characterRow in characterRows) {
      final decoded = jsonDecode(characterRow.payloadJson);
      if (decoded is! Map<String, dynamic>) {
        continue;
      }

      final usedKeys = <String>{};
      _collectCharacterReferences(decoded, usedKeys);
      for (final row in rows) {
        final key = _characterRefKey(
          rulesetId: row.rulesetId,
          entityType: row.entityType,
          entityId: row.entityId,
        );
        if (usedKeys.contains(key)) {
          results.update(row.entityId, (current) => current + 1);
        }
      }
    }

    return results;
  }

  Future<Map<String, int>> _characterUsageCounts({
    required String rulesetId,
    required String entityType,
    required Set<String> entityIds,
  }) async {
    if (entityIds.isEmpty) {
      return const <String, int>{};
    }

    final results = <String, int>{
      for (final entityId in entityIds) entityId: 0,
    };
    final characterRows = await _database
        .select(_database.characterRecords)
        .get();
    for (final characterRow in characterRows) {
      final decoded = jsonDecode(characterRow.payloadJson);
      if (decoded is! Map<String, dynamic>) {
        continue;
      }

      final usedKeys = <String>{};
      _collectCharacterReferences(decoded, usedKeys);
      for (final entityId in entityIds) {
        final key = _characterRefKey(
          rulesetId: rulesetId,
          entityType: entityType,
          entityId: entityId,
        );
        if (usedKeys.contains(key)) {
          results.update(entityId, (current) => current + 1);
        }
      }
    }

    return results;
  }

  void _collectCharacterReferences(dynamic node, Set<String> target) {
    if (node is Map) {
      final map = node.cast<String, dynamic>();
      final entityType = map['entityType']?.toString();
      final entityId = map['entityId']?.toString();
      final rulesetId = map['rulesetId']?.toString();
      if (entityType != null &&
          entityId != null &&
          rulesetId != null &&
          entityType.trim().isNotEmpty &&
          entityId.trim().isNotEmpty &&
          rulesetId.trim().isNotEmpty) {
        target.add(
          _characterRefKey(
            rulesetId: rulesetId,
            entityType: entityType,
            entityId: entityId,
          ),
        );
      }
      for (final value in map.values) {
        _collectCharacterReferences(value, target);
      }
      return;
    }

    if (node is List) {
      for (final value in node) {
        _collectCharacterReferences(value, target);
      }
    }
  }

  String _characterRefKey({
    required String rulesetId,
    required String entityType,
    required String entityId,
  }) => '$rulesetId|$entityType|$entityId';

  Future<Map<String, int>> _inboundReferenceCountsForRows(
    List<EntityRecord> rows,
  ) async {
    final groupedByRuleset = <String, Map<String, Map<String, String>>>{};
    for (final row in rows) {
      groupedByRuleset.putIfAbsent(
        row.rulesetId,
        () => <String, Map<String, String>>{},
      );
      final typeMap = groupedByRuleset[row.rulesetId]!.putIfAbsent(
        row.entityType,
        () => <String, String>{},
      );
      typeMap[row.entityId] = row.name;
    }

    final counts = <String, int>{for (final row in rows) row.entityId: 0};
    for (final entry in groupedByRuleset.entries) {
      for (final typeEntry in entry.value.entries) {
        final partial = await _inboundReferenceCounts(
          rulesetId: entry.key,
          entityType: typeEntry.key,
          entityNamesById: typeEntry.value,
        );
        for (final countEntry in partial.entries) {
          counts[countEntry.key] = countEntry.value;
        }
      }
    }
    return counts;
  }

  Future<Map<String, int>> _inboundReferenceCounts({
    required String rulesetId,
    required String entityType,
    required Map<String, String> entityNamesById,
  }) async {
    if (entityNamesById.isEmpty) {
      return const <String, int>{};
    }

    final counts = {for (final entityId in entityNamesById.keys) entityId: 0};
    final nameIndex = <String, List<String>>{};
    for (final entry in entityNamesById.entries) {
      final normalized = CompendiumJsonUtils.slugify(entry.value);
      nameIndex.putIfAbsent(normalized, () => <String>[]).add(entry.key);
    }

    final links =
        await (_database.select(_database.entityLinks)
              ..where((tbl) => tbl.rulesetId.equals(rulesetId))
              ..where((tbl) => tbl.targetEntityType.equals(entityType)))
            .get();
    for (final link in links) {
      final matchingIds =
          nameIndex[CompendiumJsonUtils.slugify(link.displayText)];
      if (matchingIds == null) {
        continue;
      }
      for (final entityId in matchingIds) {
        counts.update(entityId, (current) => current + 1);
      }
    }
    return counts;
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
        if (parts.length > 4) {
          return false;
        }
        if (parts.length >= 2 &&
            (data['className']?.toString() ?? '') != parts[1]) {
          return false;
        }
        if (parts.length >= 3) {
          final expectedLevel = int.tryParse(parts[2]);
          if (expectedLevel == null) {
            return false;
          }
          if (data['level'] != expectedLevel) {
            return false;
          }
        }
        return true;
      case 'subclass':
        return parts.length < 2 ||
            (data['className']?.toString() ?? '') == parts[1];
      case 'subclassFeature':
        if (parts.length > 5) {
          return false;
        }
        if (parts.length < 2) {
          return true;
        }
        final expectedClassName = parts[1];
        final expectedSubclassShortName = parts.length >= 3 ? parts[2] : '';
        final expectedLevel = parts.length >= 4 ? int.tryParse(parts[3]) : null;
        if ((data['className']?.toString() ?? '') != expectedClassName) {
          return false;
        }
        if ((data['subclassShortName']?.toString() ?? '') !=
            expectedSubclassShortName) {
          return false;
        }
        if (parts.length >= 4 && expectedLevel == null) {
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
}
