import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/characters/data/character_build_resolver.dart';
import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/characters/data/character_repository.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';

void main() {
  late CompendiumDatabase database;
  late CompendiumBrowseRepository browseRepository;
  late CharacterRepository repository;
  late CharacterCompendiumService compendium;

  setUp(() async {
    database = CompendiumDatabase(executor: NativeDatabase.memory());
    browseRepository = CompendiumBrowseRepository(database: database);
    repository = CharacterRepository(
      database: database,
      browseRepository: browseRepository,
    );
    compendium = CharacterCompendiumService(
      database: database,
      browseRepository: browseRepository,
    );

    await _insertRuleset(database, id: 'old_ruleset', name: 'Old Ruleset');
    await _insertRuleset(database, id: 'new_ruleset', name: 'New Ruleset');

    await _insertEntity(
      database,
      rulesetId: 'old_ruleset',
      entityType: 'class',
      collectionKey: 'classList',
      entityId: 'class:wizard',
      name: 'Wizard',
      data: const {
        'name': 'Wizard',
        'primaryAbility': [
          {'int': 1},
        ],
        'proficiency': ['int', 'wis'],
      },
    );
    await _insertEntity(
      database,
      rulesetId: 'new_ruleset',
      entityType: 'class',
      collectionKey: 'classList',
      entityId: 'class:wizard',
      name: 'Wizard',
      data: const {
        'name': 'Wizard',
        'primaryAbility': [
          {'int': 1},
        ],
        'proficiency': ['int', 'wis'],
      },
    );
    await _insertEntity(
      database,
      rulesetId: 'old_ruleset',
      entityType: 'background',
      collectionKey: 'backgroundList',
      entityId: 'background:sage',
      name: 'Sage',
      data: const {'name': 'Sage'},
    );
    await _insertEntity(
      database,
      rulesetId: 'new_ruleset',
      entityType: 'background',
      collectionKey: 'backgroundList',
      entityId: 'background:sage',
      name: 'Sage',
      data: const {'name': 'Sage'},
    );
    await _insertEntity(
      database,
      rulesetId: 'old_ruleset',
      entityType: 'race',
      collectionKey: 'raceList',
      entityId: 'race:elf',
      name: 'Elf',
      data: const {'name': 'Elf'},
    );
    await _insertEntity(
      database,
      rulesetId: 'old_ruleset',
      entityType: 'subclass',
      collectionKey: 'subclassList',
      entityId: 'subclass:evoker',
      name: 'Evoker',
      data: const {'name': 'Evoker', 'className': 'Wizard'},
    );
    await _insertEntity(
      database,
      rulesetId: 'old_ruleset',
      entityType: 'spell',
      collectionKey: 'spellList',
      entityId: 'spell:fire_bolt',
      name: 'Fire Bolt',
      data: const {'name': 'Fire Bolt', 'level': 0},
    );
    await _insertEntity(
      database,
      rulesetId: 'old_ruleset',
      entityType: 'item',
      collectionKey: 'itemList',
      entityId: 'item:quarterstaff',
      name: 'Quarterstaff',
      data: const {
        'name': 'Quarterstaff',
        'dmg1': '1d6',
        'weaponCategory': 'simple',
      },
    );
    await _insertEntity(
      database,
      rulesetId: 'old_ruleset',
      entityType: 'deity',
      collectionKey: 'deityList',
      entityId: 'deity:mystra',
      name: 'Mystra',
      data: const {'name': 'Mystra'},
    );
    await _insertEntity(
      database,
      rulesetId: 'old_ruleset',
      entityType: 'skill',
      collectionKey: 'skillList',
      entityId: 'skill:arcana',
      name: 'Arcana',
      data: const {'name': 'Arcana', 'ability': 'int'},
    );
    await _insertEntity(
      database,
      rulesetId: 'new_ruleset',
      entityType: 'skill',
      collectionKey: 'skillList',
      entityId: 'skill:arcana',
      name: 'Arcana',
      data: const {'name': 'Arcana', 'ability': 'int'},
    );
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'changing the primary ruleset clears incompatible selections instead of preserving placeholders',
    () async {
      final imported = await repository.importCharacterJson(
        jsonEncode({
          'schemaVersion': '3.0.0',
          'name': 'Aria',
          'primaryRulesetId': 'old_ruleset',
          'classes': [
            {
              'classRef': _refJson(
                entityType: 'class',
                entityId: 'class:wizard',
                rulesetId: 'old_ruleset',
                name: 'Wizard',
              ),
              'subclassRef': _refJson(
                entityType: 'subclass',
                entityId: 'subclass:evoker',
                rulesetId: 'old_ruleset',
                name: 'Evoker',
              ),
              'level': 3,
            },
          ],
          'raceRef': _refJson(
            entityType: 'race',
            entityId: 'race:elf',
            rulesetId: 'old_ruleset',
            name: 'Elf',
          ),
          'backgroundRef': _refJson(
            entityType: 'background',
            entityId: 'background:sage',
            rulesetId: 'old_ruleset',
            name: 'Sage',
          ),
          'alignment': 'neutral',
          'abilityScores': {
            'values': {
              'str': 8,
              'dex': 14,
              'con': 12,
              'int': 16,
              'wis': 10,
              'cha': 10,
            },
          },
          'equipment': {
            'entries': [
              {
                'id': 'inventory-entry:quarterstaff',
                'name': 'Quarterstaff',
                'kind': 'weapon',
                'reference': _refJson(
                  entityType: 'item',
                  entityId: 'item:quarterstaff',
                  rulesetId: 'old_ruleset',
                  name: 'Quarterstaff',
                ),
              },
              {'id': 'inventory-entry:rope', 'name': 'Rope', 'kind': 'other'},
            ],
            'loadout': {'meleeEntryId': 'inventory-entry:quarterstaff'},
          },
          'spellcasting': {
            'spellSaveDC': 13,
            'spellAttackBonus': 5,
            'preparedSpells': [
              {
                'id': 'spell:fire_bolt',
                'name': 'Fire Bolt',
                'level': 0,
                'isPrepared': true,
                'reference': _refJson(
                  entityType: 'spell',
                  entityId: 'spell:fire_bolt',
                  rulesetId: 'old_ruleset',
                  name: 'Fire Bolt',
                ),
              },
            ],
            'knownSpells': const [],
          },
          'physicalDescription': {
            'deity': 'Mystra',
            'deityRef': _refJson(
              entityType: 'deity',
              entityId: 'deity:mystra',
              rulesetId: 'old_ruleset',
              name: 'Mystra',
            ),
          },
        }),
      );

      final controller = CharacterEditorController(
        characterId: imported.id,
        repository: repository,
        compendium: compendium,
        resolver: CharacterBuildResolver(compendium: compendium),
        sheetSchemaResolver: CharacterSheetSchemaResolver(
          compendium: compendium,
        ),
      );
      addTearDown(controller.dispose);

      await controller.initialize();
      await controller.changePrimaryRuleset('new_ruleset');

      final current = controller.character!;
      expect(current.primaryRulesetId, 'new_ruleset');
      expect(current.classes, hasLength(1));
      expect(current.classes.single.classRef?.rulesetId, 'new_ruleset');
      expect(current.classes.single.subclassRef, isNull);
      expect(current.backgroundRef?.rulesetId, 'new_ruleset');
      expect(current.raceRef, isNull);
      expect(current.spellcasting, isNull);
      expect(current.equipment.entries.map((entry) => entry.id), [
        'inventory-entry:rope',
      ]);
      expect(current.equipment.loadout.meleeEntryId, isNull);
      expect(current.physicalDescription.deityRef, isNull);
      expect(current.physicalDescription.deity, isEmpty);

      final persisted = await repository.loadCharacter(imported.id);
      expect(persisted.primaryRulesetId, 'new_ruleset');
      expect(persisted.raceRef, isNull);
      expect(persisted.classes.single.subclassRef, isNull);
      expect(persisted.spellcasting, isNull);
      expect(persisted.equipment.entries, hasLength(1));
      expect(persisted.equipment.entries.single.reference, isNull);
    },
  );
}

Future<void> _insertRuleset(
  CompendiumDatabase database, {
  required String id,
  required String name,
}) {
  return database
      .into(database.rulesetRecords)
      .insert(
        RulesetRecordsCompanion.insert(
          rulesetId: id,
          name: name,
          mode: 'editable',
          schemaVersion: '1.0.0',
          filePath: '$id.ruleset.json',
        ),
      );
}

Future<void> _insertEntity(
  CompendiumDatabase database, {
  required String rulesetId,
  required String entityType,
  required String collectionKey,
  required String entityId,
  required String name,
  required Map<String, dynamic> data,
}) {
  return database
      .into(database.entityRecords)
      .insert(
        EntityRecordsCompanion.insert(
          rulesetId: rulesetId,
          entityType: entityType,
          entityId: entityId,
          collectionKey: collectionKey,
          name: name,
          payloadJson: jsonEncode({'id': entityId, 'name': name, 'data': data}),
          sortName: drift.Value(name.toLowerCase()),
          searchText: drift.Value(name.toLowerCase()),
        ),
      );
}

Map<String, dynamic> _refJson({
  required String entityType,
  required String entityId,
  required String rulesetId,
  required String name,
}) {
  return {
    'entityType': entityType,
    'entityId': entityId,
    'rulesetId': rulesetId,
    'name': name,
  };
}
