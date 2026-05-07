import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/characters/data/character_repository.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/models/character.dart';

const String _currentCharacterJson = '''
{
  "schemaVersion": "3.0.0",
  "name": "Aria",
  "primaryRulesetId": "starter_2024_srd",
  "classes": [
    {
      "classRef": {
        "entityType": "class",
        "entityId": "class:wizard",
        "rulesetId": "starter_2024_srd",
        "name": "Wizard"
      },
      "level": 3
    }
  ],
  "raceRef": {
    "entityType": "race",
    "entityId": "race:elf",
    "rulesetId": "starter_2024_srd",
    "name": "Elf"
  },
  "backgroundRef": {
    "entityType": "background",
    "entityId": "background:sage",
    "rulesetId": "starter_2024_srd",
    "name": "Sage"
  },
  "alignment": "neutral",
  "abilityScores": {
    "values": {
      "str": 8,
      "dex": 14,
      "con": 12,
      "int": 16,
      "wis": 10,
      "cha": 10
    }
  },
  "proficiencies": {
    "proficiencyBonus": 2,
    "skills": {
      "proficiencies": {
        "arcana": "proficient",
        "history": "expertise"
      }
    },
    "savingThrows": {
      "proficientAbilityIds": ["int", "wis"]
    }
  },
  "equipment": {
    "entries": [
      {
        "id": "inventory-entry:spellbook",
        "name": "Spellbook",
        "kind": "other",
        "reference": {
          "entityType": "item",
          "entityId": "item:spellbook",
          "rulesetId": "starter_2024_srd",
          "name": "Spellbook"
        }
      }
    ]
  },
  "physicalDescription": {
    "deity": "Mystra",
    "deityRef": {
      "entityType": "deity",
      "entityId": "deity:mystra",
      "rulesetId": "starter_2024_srd",
      "name": "Mystra"
    }
  },
  "notes": {
    "backstory": "Imported from the current schema."
  },
  "extraData": {
    "ui": {
      "sheetMode": "compact"
    }
  }
}
''';

void main() {
  late CompendiumDatabase database;
  late CharacterRepository repository;

  setUp(() async {
    database = CompendiumDatabase(executor: NativeDatabase.memory());
    await database
        .into(database.rulesetRecords)
        .insert(
          RulesetRecordsCompanion.insert(
            rulesetId: 'starter_2024_srd',
            name: 'Built-in 2024 SRD Starter',
            mode: 'bundled',
            schemaVersion: '1.0.0',
            filePath: 'assets/rulesets/starter_2024_srd.ruleset.json',
          ),
        );
    repository = CharacterRepository(
      database: database,
      browseRepository: CompendiumBrowseRepository(database: database),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'repository creates, duplicates, and exports saved characters',
    () async {
      final created = await repository.createCharacter(
        name: 'Mira',
        primaryRulesetId: 'starter_2024_srd',
      );

      expect(created.name, 'Mira');
      expect(created.primaryRulesetName, 'Built-in 2024 SRD Starter');
      expect(created.primaryRulesetMissing, isFalse);

      final loaded = await repository.loadCharacter(created.id);
      expect(loaded.name, 'Mira');
      expect(loaded.primaryRulesetId, 'starter_2024_srd');
      expect(loaded.classes, isEmpty);

      final duplicated = await repository.duplicateCharacter(created.id);
      expect(duplicated.name, 'Mira Copy');
      expect(duplicated.primaryRulesetId, 'starter_2024_srd');

      final exported = await repository.exportCharacterJson(created.id);
      expect(exported, contains('"name": "Mira"'));
      expect(exported, contains('"primaryRulesetId": "starter_2024_srd"'));
    },
  );

  test('repository imports reference-authoritative character JSON', () async {
    final summary = await repository.importCharacterJson(
      _currentCharacterJson,
      fileName: 'aria.character.json',
    );

    final imported = await repository.loadCharacter(summary.id);
    expect(imported.name, 'Aria');
    expect(imported.primaryRulesetId, 'starter_2024_srd');
    expect(imported.classes, hasLength(1));
    expect(imported.classes.single.classRef, isNotNull);
    expect(imported.classes.single.classRef!.entityType, 'class');
    expect(imported.classes.single.classRef!.displayName, 'Wizard');
    expect(imported.classes.single.subclassRef, isNull);
    expect(imported.classes.single.level, 3);
    expect(imported.raceRef, isNotNull);
    expect(imported.raceRef!.entityType, 'race');
    expect(imported.raceRef!.displayName, 'Elf');
    expect(imported.backgroundRef, isNotNull);
    expect(imported.backgroundRef!.entityType, 'background');
    expect(imported.backgroundRef!.displayName, 'Sage');
    expect(imported.equipment.entries, hasLength(1));
    expect(imported.equipment.entries.single.reference, isNotNull);
    expect(imported.physicalDescription.deity, 'Mystra');
    expect(imported.physicalDescription.deityRef, isNotNull);
    expect(imported.physicalDescription.deityRef!.entityType, 'deity');
    expect(imported.alignment, 'neutral');
    expect(imported.abilityScores.scoreFor('int'), 16);
    expect(
      imported.proficiencies.skills.proficiencyFor('history'),
      'expertise',
    );
    expect(imported.proficiencies.savingThrows.isProficient('wis'), isTrue);
    expect(imported.extraData['ui'], isA<Map<String, dynamic>>());
    expect(imported.notes.backstory, 'Imported from the current schema.');

    final summaries = await repository.loadCharacters();
    expect(
      summaries.map((entry) => entry.id),
      containsAll(<String>[summary.id]),
    );
  });

  test('repository rejects removed character payloads', () async {
    await expectLater(
      () => repository.importCharacterJson('''
{
  "name": "Removed Aria",
  "primaryRulesetId": "starter_2024_srd",
  "characterClass": "wizard",
  "subclass": "none",
  "level": 3,
  "race": "elf",
  "background": "sage",
  "moralAlignment": "neutral"
}
''', fileName: 'removed_aria.character.json'),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('removed character schema'),
        ),
      ),
    );
  });

  test('repository rejects superseded schema versions', () async {
    await expectLater(
      () => repository.importCharacterJson('''
{
  "schemaVersion": "2.0.0",
  "name": "Old Schema Aria",
  "primaryRulesetId": "starter_2024_srd",
  "classes": []
}
'''),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('Unsupported character schema version "2.0.0"'),
        ),
      ),
    );
  });

  test(
    'repository rejects payloads without an explicit current schema',
    () async {
      await expectLater(
        () => repository.importCharacterJson('''
{
  "name": "Schema-less Aria",
  "primaryRulesetId": "starter_2024_srd",
  "classes": []
}
'''),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('Unsupported character schema version ""'),
          ),
        ),
      );
    },
  );

  test(
    'repository rejects removed nested shapes inside schema 3 payloads',
    () async {
      await expectLater(
        () => repository.importCharacterJson('''
{
  "schemaVersion": "3.0.0",
  "name": "Shape Drift",
  "primaryRulesetId": "starter_2024_srd",
  "classes": [],
  "abilityScores": {
    "strength": 10,
    "dexterity": 10
  }
}
'''),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('abilityScores.values'),
          ),
        ),
      );
    },
  );

  test('repository rejects non-canonical skill training values', () async {
    await expectLater(
      () => repository.importCharacterJson('''
{
  "schemaVersion": "3.0.0",
  "name": "Skill Drift",
  "primaryRulesetId": "starter_2024_srd",
  "classes": [],
  "abilityScores": {
    "values": {
      "str": 10,
      "dex": 10,
      "con": 10,
      "int": 10,
      "wis": 10,
      "cha": 10
    }
  },
  "proficiencies": {
    "skills": {
      "proficiencies": {
        "arcana": "prof"
      }
    }
  }
}
'''),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('Unsupported skill training'),
        ),
      ),
    );
  });

  test('repository rejects unknown equipment kinds', () async {
    await expectLater(
      () => repository.importCharacterJson('''
{
  "schemaVersion": "3.0.0",
  "name": "Equipment Drift",
  "primaryRulesetId": "starter_2024_srd",
  "classes": [],
  "abilityScores": {
    "values": {
      "str": 10,
      "dex": 10,
      "con": 10,
      "int": 10,
      "wis": 10,
      "cha": 10
    }
  },
  "equipment": {
    "entries": [
      {
        "id": "inventory-entry:broken",
        "name": "Broken Gear",
        "kind": "gear"
      }
    ]
  }
}
'''),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('Unsupported equipment kind'),
        ),
      ),
    );
  });

  test(
    'character summaries count unresolved current-schema references',
    () async {
      final summary = await repository.importCharacterJson('''
{
  "schemaVersion": "3.0.0",
  "name": "Broken Pack",
  "primaryRulesetId": "starter_2024_srd",
  "classes": [],
  "alignment": "neutral",
  "abilityScores": {
    "values": {
      "str": 10,
      "dex": 10,
      "con": 10,
      "int": 10,
      "wis": 10,
      "cha": 10
    }
  },
  "equipment": {
    "entries": [
      {
        "id": "inventory-entry:broken",
        "name": "Broken Wand",
        "kind": "other",
        "reference": {
          "entityType": "item",
          "entityId": "",
          "rulesetId": "starter_2024_srd",
          "name": "Broken Wand"
        }
      }
    ]
  },
  "physicalDescription": {
    "deity": "Broken God",
    "deityRef": {
      "entityType": "deity",
      "entityId": "",
      "rulesetId": "starter_2024_srd",
      "name": "Broken God"
    }
  }
}
''');

      expect(summary.unresolvedSelectionCount, 2);
    },
  );

  test(
    'repository preserves open timestamps separately from edit timestamps',
    () async {
      final created = await repository.createCharacter(
        name: 'Timestamp Test',
        primaryRulesetId: 'starter_2024_srd',
      );

      final createdSummary = (await repository.loadCharacters()).singleWhere(
        (entry) => entry.id == created.id,
      );
      expect(createdSummary.lastOpenedAt, isNull);

      await repository.markOpened(created.id);
      final openedSummary = (await repository.loadCharacters()).singleWhere(
        (entry) => entry.id == created.id,
      );
      expect(openedSummary.lastOpenedAt, isNotNull);
      expect(openedSummary.updatedAt, createdSummary.updatedAt);

      final originalOpenedAt = openedSummary.lastOpenedAt!;
      final originalUpdatedAt = openedSummary.updatedAt;
      await Future<void>.delayed(const Duration(milliseconds: 1100));

      final loaded = await repository.loadCharacter(created.id);
      await repository.saveCharacter(loaded.copyWith(playerName: 'Tester'));

      final savedSummary = (await repository.loadCharacters()).singleWhere(
        (entry) => entry.id == created.id,
      );
      expect(savedSummary.lastOpenedAt, originalOpenedAt);
      expect(savedSummary.updatedAt.isAfter(originalUpdatedAt), isTrue);
    },
  );
}
