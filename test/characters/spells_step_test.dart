import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/characters/data/character_build_resolver.dart';
import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/characters/data/character_repository.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/characters/creation/steps/spells_step.dart';

late CompendiumDatabase database;
late CompendiumBrowseRepository browseRepository;
late CharacterRepository repository;
late CharacterCompendiumService compendium;

void main() {
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

    await _insertRuleset(database);
    await _insertSkill(
      database,
      id: 'skill:arcana',
      name: 'Arcana',
      ability: 'int',
    );
    await _insertSkill(
      database,
      id: 'skill:athletics',
      name: 'Athletics',
      ability: 'str',
    );
    await _insertClass(
      database,
      id: 'class:fighter',
      name: 'Fighter',
      data: const {
        'name': 'Fighter',
        'primaryAbility': [
          {'str': true},
        ],
        'hd': {'number': 1, 'faces': 10},
        'proficiency': ['str', 'con'],
      },
    );
    await _insertClass(
      database,
      id: 'class:wizard',
      name: 'Wizard',
      data: const {
        'name': 'Wizard',
        'primaryAbility': [
          {'int': true},
        ],
        'hd': {'number': 1, 'faces': 6},
        'proficiency': ['int', 'wis'],
        'spellcastingAbility': 'int',
        'casterProgression': 'full',
        'cantripProgression': [2],
        'spellsKnownProgressionFixedByLevel': [2],
        'preparedSpellsProgression': [1],
        'classTableGroups': [
          {
            'rowsSpellProgression': [
              [2, 0, 0, 0, 0, 0, 0, 0, 0],
            ],
          },
        ],
      },
    );
    await _insertSpell(
      database,
      id: 'spell:fire-bolt',
      name: 'Fire Bolt',
      level: 0,
      school: 'Evocation',
    );
    await _insertSpell(
      database,
      id: 'spell:mage-armor',
      name: 'Mage Armor',
      level: 1,
      school: 'Abjuration',
    );
    await _insertSpell(
      database,
      id: 'spell:shield',
      name: 'Shield',
      level: 1,
      school: 'Abjuration',
    );
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('no spellcasting class shows clean empty state', (tester) async {
    final controller = await _createControllerWithClass(
      const CharacterEntityRef(
        entityType: 'class',
        entityId: 'class:fighter',
        rulesetId: 'test_rules',
        name: 'Fighter',
      ),
    );
    addTearDown(controller.dispose);

    await _pumpSpellsStep(tester, controller);

    expect(
      find.text('Your current class does not use spellcasting.'),
      findsOneWidget,
    );
  });

  testWidgets('spellcasting summary shows capacity counters', (tester) async {
    final controller = await _createWizardController();
    addTearDown(controller.dispose);
    await controller.addSpellSelection(_spellRef('fire-bolt'), prepared: false);
    await controller.addSpellSelection(
      _spellRef('mage-armor'),
      prepared: false,
    );
    await controller.addSpellSelection(_spellRef('shield'), prepared: true);
    await controller.flushPendingSave();

    await _pumpSpellsStep(tester, controller);

    expect(find.text('Spellcasting Summary'), findsOneWidget);
    expect(find.text('Cantrips'), findsWidgets);
    expect(find.text('Known Spells'), findsWidgets);
    expect(find.text('Prepared Spells'), findsWidgets);
    expect(find.text('1 / 2'), findsWidgets);
    expect(find.text('1 / 1'), findsWidgets);
  });

  testWidgets('over-capacity spell counts show inline warning', (tester) async {
    final controller = await _createWizardController();
    addTearDown(controller.dispose);
    await controller.addSpellSelection(_spellRef('mage-armor'), prepared: true);
    await controller.addSpellSelection(_spellRef('shield'), prepared: true);
    await controller.flushPendingSave();

    await _pumpSpellsStep(tester, controller);

    expect(
      find.textContaining('Prepared spells exceed capacity'),
      findsOneWidget,
    );
    expect(find.text('2 / 1'), findsWidgets);
  });

  testWidgets('advanced spell editor remains reachable', (tester) async {
    final controller = await _createWizardController();
    addTearDown(controller.dispose);

    await _pumpSpellsStep(tester, controller);
    await tester.scrollUntilVisible(
      find.text('Advanced Spell Editor'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Advanced Spell Editor'));
    await tester.pumpAndSettle();

    expect(find.text('Add Prepared Spell'), findsOneWidget);
    expect(find.text('Add Known Spell'), findsOneWidget);
  });
}

Future<void> _pumpSpellsStep(
  WidgetTester tester,
  CharacterEditorController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 900,
          height: 1200,
          child: SpellsStep(controller: controller),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<CharacterEditorController> _createWizardController() {
  return _createControllerWithClass(
    const CharacterEntityRef(
      entityType: 'class',
      entityId: 'class:wizard',
      rulesetId: 'test_rules',
      name: 'Wizard',
    ),
  );
}

Future<CharacterEditorController> _createControllerWithClass(
  CharacterEntityRef classRef,
) async {
  final created = await repository.createCharacter(
    name: 'Spell Tester',
    primaryRulesetId: 'test_rules',
  );
  final controller = CharacterEditorController(
    characterId: created.id,
    repository: repository,
    compendium: compendium,
    resolver: CharacterBuildResolver(compendium: compendium),
    sheetSchemaResolver: CharacterSheetSchemaResolver(compendium: compendium),
  );
  await controller.initialize();
  await controller.addClassEntry();
  await controller.setClassEntry(0, classRef: classRef, level: 1);
  await controller.flushPendingSave();
  return controller;
}

CharacterEntityRef _spellRef(String slug) {
  return CharacterEntityRef(
    entityType: 'spell',
    entityId: 'spell:$slug',
    rulesetId: 'test_rules',
    name: switch (slug) {
      'fire-bolt' => 'Fire Bolt',
      'mage-armor' => 'Mage Armor',
      'shield' => 'Shield',
      _ => slug,
    },
  );
}

Future<void> _insertRuleset(CompendiumDatabase database) {
  return database
      .into(database.rulesetRecords)
      .insert(
        RulesetRecordsCompanion.insert(
          rulesetId: 'test_rules',
          name: 'Test Rules',
          mode: 'editable',
          schemaVersion: '1.0.0',
          filePath: 'test.ruleset.json',
        ),
      );
}

Future<void> _insertClass(
  CompendiumDatabase database, {
  required String id,
  required String name,
  required Map<String, dynamic> data,
}) {
  return database
      .into(database.entityRecords)
      .insert(
        EntityRecordsCompanion.insert(
          rulesetId: 'test_rules',
          entityType: 'class',
          entityId: id,
          collectionKey: 'classList',
          name: name,
          payloadJson: jsonEncode({'id': id, 'name': name, 'data': data}),
          sortName: drift.Value(name.toLowerCase()),
          searchText: drift.Value(name.toLowerCase()),
        ),
      );
}

Future<void> _insertSkill(
  CompendiumDatabase database, {
  required String id,
  required String name,
  required String ability,
}) {
  return database
      .into(database.entityRecords)
      .insert(
        EntityRecordsCompanion.insert(
          rulesetId: 'test_rules',
          entityType: 'skill',
          entityId: id,
          collectionKey: 'skillList',
          name: name,
          payloadJson: jsonEncode({
            'id': id,
            'name': name,
            'data': {'name': name, 'ability': ability},
          }),
          sortName: drift.Value(name.toLowerCase()),
          searchText: drift.Value(name.toLowerCase()),
        ),
      );
}

Future<void> _insertSpell(
  CompendiumDatabase database, {
  required String id,
  required String name,
  required int level,
  required String school,
}) {
  return database
      .into(database.entityRecords)
      .insert(
        EntityRecordsCompanion.insert(
          rulesetId: 'test_rules',
          entityType: 'spell',
          entityId: id,
          collectionKey: 'spellList',
          name: name,
          payloadJson: jsonEncode({
            'id': id,
            'name': name,
            'data': {
              'name': name,
              'level': level,
              'school': school,
              'duration': 'Instantaneous',
            },
          }),
          sortName: drift.Value(name.toLowerCase()),
          searchText: drift.Value(name.toLowerCase()),
        ),
      );
}
