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
import 'package:openrpg/screens/characters/creation/steps/background_step.dart';
import 'package:openrpg/screens/characters/creation/steps/species_race_step.dart';

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
    await _insertRace(
      database,
      id: 'race:elf',
      name: 'Elf',
      data: const {
        'name': 'Elf',
        'size': ['M'],
        'speed': 30,
        'darkvision': 60,
        'skillProficiencies': [
          {
            'choose': {
              'from': ['perception', 'survival'],
              'count': 1,
            },
          },
        ],
        'entries': [
          {
            'type': 'entries',
            'name': 'Darkvision',
            'entries': ['You can see in dim light and darkness.'],
          },
          {
            'type': 'entries',
            'name': 'Fey Ancestry',
            'entries': ['You resist charm magic.'],
          },
        ],
      },
    );
    await _insertRace(
      database,
      id: 'race:human',
      name: 'Human',
      data: const {
        'name': 'Human',
        'size': ['S', 'M'],
        'speed': 30,
        'skillProficiencies': [
          {'any': 1},
        ],
        'entries': [
          {
            'type': 'entries',
            'name': 'Resourceful',
            'entries': ['You draw on heroic inspiration.'],
          },
        ],
      },
    );
    await _insertBackground(
      database,
      id: 'background:acolyte',
      name: 'Acolyte',
      data: const {
        'name': 'Acolyte',
        'ability': [
          {
            'choose': {
              'weighted': {
                'from': ['int', 'wis', 'cha'],
                'weights': [2, 1],
              },
            },
          },
        ],
        'feats': [
          {'magic initiate; cleric|xphb': true},
        ],
        'skillProficiencies': [
          {'insight': true, 'religion': true},
        ],
        'toolProficiencies': [
          {"calligrapher's supplies": true},
        ],
        'startingEquipment': [
          {
            'A': [
              {'item': "calligrapher's supplies|xphb"},
              {'item': 'holy symbol|xphb'},
              {'value': 800},
            ],
            'B': [
              {'value': 5000},
            ],
          },
        ],
        'entries': [
          {
            'type': 'entries',
            'name': 'Shelter of the Faithful',
            'entries': ['Temples can offer modest help.'],
          },
        ],
      },
    );
    await _insertBackground(
      database,
      id: 'background:guard',
      name: 'Guard',
      data: const {
        'name': 'Guard',
        'skillProficiencies': [
          {'athletics': true, 'perception': true},
        ],
        'toolProficiencies': [
          {'gaming set': true},
        ],
        'entries': [
          {
            'type': 'entries',
            'name': 'Watch Station',
            'entries': ['Local guards recognize your service.'],
          },
        ],
      },
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('Species/Race step is incomplete with no choice selected', () async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress.stepStatuses[CharacterBuilderStepId.speciesRace],
      CharacterBuilderStepStatus.error,
    );
    expect(
      progress
          .issuesFor(CharacterBuilderStepId.speciesRace)
          .map((issue) => issue.title),
      contains('No species selected'),
    );
  });

  testWidgets('selecting a Species/Race updates the character draft', (
    tester,
  ) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpSpeciesRaceStep(tester, controller);
    final chooseElf = find.byKey(const Key('choose-species-race:race:elf'));
    await _scrollToFinder(tester, chooseElf);
    await tester.tap(chooseElf);
    await tester.pumpAndSettle();

    expect(controller.character!.raceRef?.displayName, 'Elf');
  });

  test('selected Species/Race is reflected in progress state', () async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await controller.setRace(
      const CharacterEntityRef(
        entityType: 'race',
        entityId: 'race:elf',
        rulesetId: 'test_rules',
        name: 'Elf',
      ),
    );

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress.stepStatuses[CharacterBuilderStepId.speciesRace],
      CharacterBuilderStepStatus.complete,
    );
  });

  testWidgets('Species/Race search filters cards by name', (tester) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpSpeciesRaceStep(tester, controller);
    await tester.enterText(
      find.byKey(const Key('guided-species-race-search')),
      'elf',
    );
    await tester.pumpAndSettle();

    expect(find.text('Elf'), findsOneWidget);
    expect(find.text('Human'), findsNothing);
  });

  testWidgets('Species/Race detail sheet opens and can choose an option', (
    tester,
  ) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpSpeciesRaceStep(tester, controller);
    final details = find.byKey(const Key('species-race-detail:race:elf'));
    await _scrollToFinder(tester, details);
    await tester.tap(details);
    await tester.pumpAndSettle();

    expect(find.text('Elf Details'), findsOneWidget);

    final chooseFromDetail = find.byKey(
      const Key('species-race-detail-choose:race:elf'),
    );
    await tester.tap(chooseFromDetail);
    await tester.pumpAndSettle();

    expect(controller.character!.raceRef?.displayName, 'Elf');
  });

  test('Background step is incomplete with no background selected', () async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress.stepStatuses[CharacterBuilderStepId.background],
      CharacterBuilderStepStatus.error,
    );
    expect(
      progress
          .issuesFor(CharacterBuilderStepId.background)
          .map((issue) => issue.title),
      contains('No background selected'),
    );
  });

  testWidgets('selecting a Background updates the character draft', (
    tester,
  ) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpBackgroundStep(tester, controller);
    final chooseAcolyte = find.byKey(
      const Key('choose-background:background:acolyte'),
    );
    await _scrollToFinder(tester, chooseAcolyte);
    await tester.tap(chooseAcolyte);
    await tester.pumpAndSettle();

    expect(controller.character!.backgroundRef?.displayName, 'Acolyte');
  });

  test('selected Background is reflected in progress state', () async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await controller.setBackground(
      const CharacterEntityRef(
        entityType: 'background',
        entityId: 'background:acolyte',
        rulesetId: 'test_rules',
        name: 'Acolyte',
      ),
    );

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress.stepStatuses[CharacterBuilderStepId.background],
      CharacterBuilderStepStatus.complete,
    );
  });

  testWidgets('Background search filters cards by name', (tester) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpBackgroundStep(tester, controller);
    await tester.enterText(
      find.byKey(const Key('guided-background-search')),
      'guard',
    );
    await tester.pumpAndSettle();

    expect(find.text('Guard'), findsOneWidget);
    expect(find.text('Acolyte'), findsNothing);
  });

  testWidgets('Background detail sheet opens and can choose an option', (
    tester,
  ) async {
    final controller = await _createController();
    addTearDown(controller.dispose);

    await _pumpBackgroundStep(tester, controller);
    final details = find.byKey(
      const Key('background-detail:background:acolyte'),
    );
    await _scrollToFinder(tester, details);
    await tester.tap(details);
    await tester.pumpAndSettle();

    expect(find.text('Acolyte Details'), findsOneWidget);

    final chooseFromDetail = find.byKey(
      const Key('background-detail-choose:background:acolyte'),
    );
    await tester.tap(chooseFromDetail);
    await tester.pumpAndSettle();

    expect(controller.character!.backgroundRef?.displayName, 'Acolyte');
  });
}

Future<CharacterEditorController> _createController() async {
  final created = await repository.createCharacter(
    name: 'Origin Tester',
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

Future<void> _pumpSpeciesRaceStep(
  WidgetTester tester,
  CharacterEditorController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => SpeciesRaceStep(controller: controller),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpBackgroundStep(
  WidgetTester tester,
  CharacterEditorController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => BackgroundStep(controller: controller),
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
          name: '2024 Test Rules',
          mode: 'editable',
          schemaVersion: '1.0.0',
          filePath: 'test.ruleset.json',
        ),
      );
}

Future<void> _insertRace(
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
          entityType: 'race',
          entityId: id,
          collectionKey: 'raceList',
          name: name,
          payloadJson: jsonEncode({'id': id, 'name': name, 'data': data}),
          sortName: drift.Value(name.toLowerCase()),
          searchText: drift.Value(jsonEncode(data).toLowerCase()),
        ),
      );
}

Future<void> _insertBackground(
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
          entityType: 'background',
          entityId: id,
          collectionKey: 'backgroundList',
          name: name,
          payloadJson: jsonEncode({'id': id, 'name': name, 'data': data}),
          sortName: drift.Value(name.toLowerCase()),
          searchText: drift.Value(jsonEncode(data).toLowerCase()),
        ),
      );
}
