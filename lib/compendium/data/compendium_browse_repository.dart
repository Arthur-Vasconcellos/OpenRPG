import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_database_provider.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
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
    String? source,
    String? edition,
    int page = 0,
    int pageSize = 100,
  }) async {
    final selection = _database.select(_database.entityRecords)
      ..where((tbl) => tbl.rulesetId.equals(rulesetId))
      ..where((tbl) => tbl.entityType.equals(entityType));

    if (source != null && source.trim().isNotEmpty) {
      selection.where((tbl) => tbl.source.equals(source.trim()));
    }

    if (edition != null && edition.trim().isNotEmpty) {
      selection.where((tbl) => tbl.edition.equals(edition.trim()));
    }

    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isNotEmpty) {
      selection.where((tbl) => tbl.searchText.like('%$trimmedQuery%'));
    }

    selection.orderBy([(tbl) => drift.OrderingTerm.asc(tbl.sortName)]);

    final totalCount = await selection.get().then((rows) => rows.length);
    selection.limit(pageSize, offset: page * pageSize);

    final rows = await selection.get();
    final items = rows.map(_mapEntityPreview).toList(growable: false);
    final facets = await loadSearchFacets(
      rulesetId: rulesetId,
      entityType: entityType,
    );

    return CompendiumCollectionPage(
      rulesetId: rulesetId,
      entityType: entityType,
      items: items,
      availableSources: facets.sources,
      availableEditions: facets.editions,
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      hasMore: (page + 1) * pageSize < totalCount,
    );
  }

  Future<CompendiumSearchFacets> loadSearchFacets({
    required String rulesetId,
    String? entityType,
  }) async {
    final selection = _database.select(_database.entityRecords)
      ..where((tbl) => tbl.rulesetId.equals(rulesetId));

    if (entityType != null && entityType.trim().isNotEmpty) {
      selection.where((tbl) => tbl.entityType.equals(entityType.trim()));
    }

    selection.orderBy([(tbl) => drift.OrderingTerm.asc(tbl.sortName)]);
    final rows = await selection.get();

    final sources = <String>{};
    final editions = <String>{};
    for (final row in rows) {
      final source = row.source.trim();
      if (source.isNotEmpty) {
        sources.add(source);
      }

      final edition = row.edition?.trim();
      if (edition != null && edition.isNotEmpty) {
        editions.add(edition);
      }
    }

    return CompendiumSearchFacets(
      sources: sources.toList(growable: false)..sort(),
      editions: editions.toList(growable: false)..sort(),
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

    if (query.source != null && query.source!.trim().isNotEmpty) {
      selection.where((tbl) => tbl.source.equals(query.source!.trim()));
    }

    if (query.edition != null && query.edition!.trim().isNotEmpty) {
      selection.where((tbl) => tbl.edition.equals(query.edition!.trim()));
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
      jsonDecode(row.payloadJson) as Map<String, dynamic>,
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
              source: link.sourceHint,
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

    return CompendiumSearchResult(preview: _mapEntityPreview(rows.first));
  }

  CompendiumEntityPreview _mapEntityPreview(EntityRecord row) {
    return CompendiumEntityPreview(
      rulesetId: row.rulesetId,
      entityType: row.entityType,
      entityId: row.entityId,
      name: row.name,
      source: row.source,
      sourceFile: row.sourceFile,
      edition: row.edition,
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
}
