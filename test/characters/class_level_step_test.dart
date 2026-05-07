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
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';
import 'package:openrpg/screens/characters/creation/steps/class_level_step.dart';

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
      id: 'skill:athletics',
      name: 'Athletics',
      ability: 'str',
    );
    await _insertSkill(
      database,
      id: 'skill:arcana',
      name: 'Arcana',
      ability: 'int',
    );
    await _insertClass(
      database,
      id: 'class:barbarian',
      name: 'Barbarian',
      data: const {
        'name': 'Barbarian',
        'primaryAbility': [
          {'str': true},
        ],
        'hd': {'number': 1, 'faces': 12},
        'proficiency': ['str', 'con'],
        'startingProficiencies': {
          'armor': ['light', 'medium', 'shield'],
          'weapons': ['simple', 'martial'],
          'skills': [
            {
              'choose': {
                'from': ['athletics', 'intimidation'],
                'count': 2,
              },
            },
          ],
        },
        'classFeatures': ['Rage|Barbarian|XPHB|1'],
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
        'startingProficiencies': {
          'weapons': ['simple'],
          'skills': [
            {
              'choose': {
                'from': ['arcana', 'history'],
                'count': 2,
              },
            },
          ],
        },
        'classFeatures': [
          'Spellcasting|Wizard|XPHB|1',
          'Arcane Recovery|Wizard|XPHB|1',
        ],
      },
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('Class & Level step is incomplete with no class selected', () async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress.stepStatuses[CharacterBuilderStepId.classLevel],
      CharacterBuilderStepStatus.error,
    );
    expect(
      progress
          .issuesFor(CharacterBuilderStepId.classLevel)
          .map((issue) => issue.title),
      contains('No class selected'),
    );
  });

  testWidgets('selecting a class updates the character draft', (tester) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpClassLevelStep(tester, controller);
    final chooseWizard = find.byKey(const Key('choose-class:class:wizard'));
    await _scrollToFinder(tester, chooseWizard);
    await tester.tap(chooseWizard);
    await tester.pumpAndSettle();

    expect(controller.character!.classes.first.classRef?.displayName, 'Wizard');
  });

  test('selected class is reflected in progress state', () async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await controller.addClassEntry();
    await controller.setClassEntry(
      0,
      classRef: const CharacterEntityRef(
        entityType: 'class',
        entityId: 'class:wizard',
        rulesetId: 'test_rules',
        name: 'Wizard',
      ),
      level: 1,
    );

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress.stepStatuses[CharacterBuilderStepId.classLevel],
      CharacterBuilderStepStatus.complete,
    );
  });

  test('level outside valid range is blocked by progress', () async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await controller.addClassEntry();
    await controller.setClassEntry(
      0,
      classRef: const CharacterEntityRef(
        entityType: 'class',
        entityId: 'class:wizard',
        rulesetId: 'test_rules',
        name: 'Wizard',
      ),
      level: 21,
    );

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress.stepStatuses[CharacterBuilderStepId.classLevel],
      CharacterBuilderStepStatus.error,
    );
    expect(
      progress
          .issuesFor(CharacterBuilderStepId.classLevel)
          .map((issue) => issue.title),
      contains('Total level is above 20'),
    );
  });

  testWidgets('search filters class cards by name', (tester) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpClassLevelStep(tester, controller);
    await tester.enterText(find.byKey(const Key('guided-class-search')), 'wiz');
    await tester.pumpAndSettle();

    expect(find.text('Wizard'), findsOneWidget);
    expect(find.text('Barbarian'), findsNothing);
  });

  testWidgets('spellcaster filter shows spellcasting classes', (tester) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpClassLevelStep(tester, controller);
    await tester.tap(find.text('Spellcaster'));
    await tester.pumpAndSettle();

    expect(find.text('Wizard'), findsOneWidget);
    expect(find.text('Barbarian'), findsNothing);
  });

  testWidgets('class detail view opens and can choose a class', (tester) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpClassLevelStep(tester, controller);
    final detailWizard = find.byKey(const Key('class-detail:class:wizard'));
    await _scrollToFinder(tester, detailWizard);
    await tester.tap(detailWizard);
    await tester.pumpAndSettle();

    expect(find.text('Wizard Details'), findsOneWidget);

    final chooseFromDetail = find.byKey(
      const Key('class-detail-choose:class:wizard'),
    );
    await tester.ensureVisible(chooseFromDetail);
    await tester.tap(chooseFromDetail);
    await tester.pumpAndSettle();

    expect(controller.character!.classes.first.classRef?.displayName, 'Wizard');
  });
}

Future<CharacterEditorController> _createController() async {
  final created = await repository.createCharacter(
    name: 'Class Tester',
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
  return controller;
}

Future<void> _pumpClassLevelStep(
  WidgetTester tester,
  CharacterEditorController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => ClassLevelStep(controller: controller),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _scrollToFinder(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
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
          searchText: drift.Value(jsonEncode(data).toLowerCase()),
        ),
      );
}
