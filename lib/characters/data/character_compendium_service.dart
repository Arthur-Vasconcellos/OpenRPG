import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_database_provider.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/models/character.dart';

class CharacterCompendiumSearchResult {
  final CharacterEntityRef ref;
  final String? rulesetName;
  final String snippet;
  final int inboundReferenceCount;
  final int characterUsageCount;

  const CharacterCompendiumSearchResult({
    required this.ref,
    required this.rulesetName,
    this.snippet = '',
    this.inboundReferenceCount = 0,
    this.characterUsageCount = 0,
  });
}

class CharacterResolvedEntity {
  final CharacterEntityRef ref;
  final String? rulesetName;
  final CompendiumEntityDetail detail;

  const CharacterResolvedEntity({
    required this.ref,
    required this.rulesetName,
    required this.detail,
  });
}

class CharacterCompendiumService {
  final CompendiumDatabase _database;
  final CompendiumBrowseRepository _browseRepository;
  final Map<String, Future<CharacterResolvedEntity?>> _resolvedEntityCache =
      <String, Future<CharacterResolvedEntity?>>{};

  CharacterCompendiumService({
    CompendiumDatabase? database,
    CompendiumBrowseRepository? browseRepository,
  }) : _database = database ?? sharedCompendiumDatabase,
       _browseRepository =
           browseRepository ??
           CompendiumBrowseRepository(
             database: database ?? sharedCompendiumDatabase,
           );

  CompendiumBrowseRepository get browseRepository => _browseRepository;

  Future<List<RulesetSummary>> loadInstalledRulesets() {
    return _browseRepository.loadInstalledRulesets();
  }

  Future<List<CharacterCompendiumSearchResult>> searchEntities({
    required List<String> rulesetIds,
    required List<String> entityTypes,
    String query = '',
    int limit = 100,
  }) async {
    final trimmed = query.trim();
    final rulesetNames = await _rulesetNames();
    if (trimmed.isEmpty && entityTypes.length == 1 && rulesetIds.length == 1) {
      final page = await _browseRepository.loadCollectionPage(
        rulesetId: rulesetIds.first,
        entityType: entityTypes.first,
        page: 0,
        pageSize: limit,
      );
      return page.items
          .map(
            (item) => CharacterCompendiumSearchResult(
              ref: CharacterEntityRef(
                entityType: item.entityType,
                entityId: item.entityId,
                rulesetId: item.rulesetId,
                name: item.name,
              ),
              rulesetName: rulesetNames[item.rulesetId],
              snippet: item.snippet,
              inboundReferenceCount: item.inboundReferenceCount,
              characterUsageCount: item.characterUsageCount,
            ),
          )
          .toList(growable: false);
    }

    final results = await _browseRepository.searchEntityPreviews(
      CompendiumSearchQuery(
        text: trimmed,
        rulesetIds: rulesetIds,
        entityTypes: entityTypes,
        limit: limit,
      ),
    );

    return results
        .map(
          (result) => CharacterCompendiumSearchResult(
            ref: CharacterEntityRef(
              entityType: result.preview.entityType,
              entityId: result.preview.entityId,
              rulesetId: result.preview.rulesetId,
              name: result.preview.name,
            ),
            rulesetName: rulesetNames[result.preview.rulesetId],
            snippet: result.snippet.trim().isEmpty
                ? result.preview.snippet
                : result.snippet,
            inboundReferenceCount: result.preview.inboundReferenceCount,
            characterUsageCount: result.preview.characterUsageCount,
          ),
        )
        .toList(growable: false);
  }

  Future<List<CharacterCompendiumSearchResult>> loadSubclassesForClass({
    required List<String> rulesetIds,
    required String className,
    String query = '',
  }) async {
    final trimmed = query.trim().toLowerCase();
    final selection = _database.select(_database.entityRecords)
      ..where((tbl) => tbl.entityType.equals('subclass'));

    if (rulesetIds.isNotEmpty) {
      selection.where((tbl) => tbl.rulesetId.isIn(rulesetIds));
    }

    selection.orderBy([(tbl) => drift.OrderingTerm.asc(tbl.sortName)]);

    final rows = await selection.get();
    final rulesetNames = await _rulesetNames();
    final matches = <CharacterCompendiumSearchResult>[];
    for (final row in rows) {
      final payload = jsonDecode(row.payloadJson);
      if (payload is! Map<String, dynamic>) {
        continue;
      }

      final data = CompendiumJsonUtils.jsonMap(payload['data']);
      final entityClassName = data['className']?.toString() ?? '';
      if (!entityClassName.trim().toLowerCase().contains(
        className.trim().toLowerCase(),
      )) {
        continue;
      }

      if (trimmed.isNotEmpty &&
          !row.name.toLowerCase().contains(trimmed) &&
          !(row.sortName.toLowerCase()).contains(trimmed)) {
        continue;
      }

      matches.add(
        CharacterCompendiumSearchResult(
          ref: CharacterEntityRef(
            entityType: row.entityType,
            entityId: row.entityId,
            rulesetId: row.rulesetId,
            name: row.name,
          ),
          rulesetName: rulesetNames[row.rulesetId],
          snippet: row.searchText,
        ),
      );
    }

    return matches;
  }

  Future<CharacterResolvedEntity?> loadResolvedEntity(
    CharacterEntityRef ref,
  ) async {
    if (!ref.isResolved) {
      return null;
    }

    final cacheKey = '${ref.rulesetId}:${ref.entityType}:${ref.entityId}';
    return _resolvedEntityCache.putIfAbsent(cacheKey, () async {
      try {
        final detail = await _browseRepository.loadEntityDetail(
          rulesetId: ref.rulesetId,
          entityType: ref.entityType,
          entityId: ref.entityId,
        );
        final rulesetNames = await _rulesetNames();
        return CharacterResolvedEntity(
          ref: ref,
          rulesetName: rulesetNames[ref.rulesetId],
          detail: detail,
        );
      } catch (_) {
        return null;
      }
    });
  }

  Future<CharacterEntityRef?> resolveCandidate(
    CompendiumLinkCandidate candidate, {
    required String preferredRulesetId,
  }) async {
    final resolved = await _browseRepository.resolveLink(
      candidate,
      preferredRulesetId: preferredRulesetId,
    );
    if (resolved == null) {
      return null;
    }

    return CharacterEntityRef(
      entityType: resolved.preview.entityType,
      entityId: resolved.preview.entityId,
      rulesetId: resolved.preview.rulesetId,
      name: resolved.preview.name,
    );
  }

  Future<CharacterEntityRef?> resolveEntityByName({
    required String rulesetId,
    required String entityType,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || rulesetId.trim().isEmpty) {
      return null;
    }

    final directMatches =
        await (_database.select(_database.entityRecords)
              ..where((tbl) => tbl.rulesetId.equals(rulesetId))
              ..where((tbl) => tbl.entityType.equals(entityType))
              ..where((tbl) => tbl.name.equals(trimmed)))
            .get();
    if (directMatches.length == 1) {
      return _refFromRow(directMatches.single);
    }
    if (directMatches.length > 1) {
      return null;
    }

    final rows =
        await (_database.select(_database.entityRecords)
              ..where((tbl) => tbl.rulesetId.equals(rulesetId))
              ..where((tbl) => tbl.entityType.equals(entityType)))
            .get();
    final normalizedTarget = CompendiumJsonUtils.slugify(trimmed);
    CharacterEntityRef? resolved;
    for (final row in rows) {
      if (CompendiumJsonUtils.slugify(row.name) == normalizedTarget) {
        if (resolved != null) {
          return null;
        }
        resolved = _refFromRow(row);
      }
    }

    return resolved;
  }

  Future<CharacterEntityRef?> resolveEntityById({
    required String rulesetId,
    required String entityType,
    required String entityId,
  }) async {
    final trimmedEntityId = entityId.trim();
    if (rulesetId.trim().isEmpty ||
        entityType.trim().isEmpty ||
        trimmedEntityId.isEmpty) {
      return null;
    }

    final row =
        await (_database.select(_database.entityRecords)
              ..where((tbl) => tbl.rulesetId.equals(rulesetId))
              ..where((tbl) => tbl.entityType.equals(entityType))
              ..where((tbl) => tbl.entityId.equals(trimmedEntityId)))
            .getSingleOrNull();
    if (row == null) {
      return null;
    }

    return _refFromRow(row);
  }

  Future<Character> canonicalizeSelections(Character character) async {
    if (character.primaryRulesetId.trim().isEmpty) {
      return character;
    }

    final canonicalRace = await _canonicalizeRef(character.raceRef);
    final canonicalBackground = await _canonicalizeRef(character.backgroundRef);

    final canonicalClasses = <CharacterClassLevel>[];
    for (final entry in character.classes) {
      final classRef = await _canonicalizeRef(entry.classRef);
      final subclassRef = await _canonicalizeRef(entry.subclassRef);
      if (classRef == null) {
        continue;
      }
      canonicalClasses.add(
        entry.copyWith(
          classRef: classRef,
          subclassRef: subclassRef,
          clearSubclassRef: subclassRef == null,
        ),
      );
    }

    final canonicalSpellcasting = await _canonicalizeSpellcasting(
      character.spellcasting,
    );
    final canonicalEquipment = await _canonicalizeEquipment(
      character.equipment,
    );
    final canonicalDeity = await _canonicalizeRef(
      character.physicalDescription.deityRef,
    );

    return character.copyWith(
      raceRef: canonicalRace,
      clearRaceRef: canonicalRace == null,
      backgroundRef: canonicalBackground,
      clearBackgroundRef: canonicalBackground == null,
      classes: canonicalClasses,
      spellcasting: canonicalSpellcasting,
      equipment: canonicalEquipment,
      physicalDescription: character.physicalDescription.copyWith(
        deity: canonicalDeity?.displayName ?? '',
        deityRef: canonicalDeity,
        clearDeityRef:
            canonicalDeity == null &&
            character.physicalDescription.deityRef != null,
      ),
      clearSpellcasting:
          canonicalSpellcasting == null && character.spellcasting != null,
    );
  }

  Future<SpellcastingInfo?> _canonicalizeSpellcasting(
    SpellcastingInfo? spellcasting,
  ) async {
    if (spellcasting == null) {
      return null;
    }

    Future<Spell> canonicalizeSpell(Spell spell) async {
      final ref = await _canonicalizeRef(spell.reference);
      return spell.copyWith(reference: ref, clearReference: ref == null);
    }

    final prepared = await Future.wait(
      spellcasting.preparedSpells.map(canonicalizeSpell),
    );
    final known = await Future.wait(
      spellcasting.knownSpells.map(canonicalizeSpell),
    );
    return spellcasting.copyWith(preparedSpells: prepared, knownSpells: known);
  }

  Future<Equipment> _canonicalizeEquipment(Equipment equipment) async {
    if (equipment.entries.isEmpty) {
      return equipment;
    }

    final entries = await Future.wait(
      equipment.entries.map((entry) async {
        final ref = await _canonicalizeRef(entry.reference);
        return entry.copyWith(reference: ref, clearReference: ref == null);
      }),
    );

    return equipment.copyWith(entries: entries);
  }

  Future<CharacterEntityRef?> _canonicalizeRef(CharacterEntityRef? ref) async {
    final current = ref;
    if (current == null) {
      return null;
    }
    if (!current.isResolved) {
      return null;
    }

    return resolveEntityById(
      rulesetId: current.rulesetId,
      entityType: current.entityType,
      entityId: current.entityId,
    );
  }

  Future<Map<String, String>> _rulesetNames() async {
    final rulesets = await _browseRepository.loadInstalledRulesets();
    return {for (final ruleset in rulesets) ruleset.id: ruleset.name};
  }

  CharacterEntityRef _refFromRow(EntityRecord row) {
    return CharacterEntityRef(
      entityType: row.entityType,
      entityId: row.entityId,
      rulesetId: row.rulesetId,
      name: row.name,
    );
  }
}
