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
import 'package:openrpg/screens/characters/creation/ability_score_generation.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';
import 'package:openrpg/screens/characters/creation/steps/ability_scores_step.dart';

void main() {
  test('Point Buy starts with six 8s and 27 points remaining', () {
    final evaluation = PointBuyEvaluation.starting(abilityIds: _abilityIds);

    expect(evaluation.scores.values, everyElement(8));
    expect(evaluation.spent, 0);
    expect(evaluation.remaining, 27);
  });

  test('increasing 14 to 15 costs 2 more points', () {
    final atFourteen = PointBuyEvaluation.fromVisibleScores(
      abilityIds: _abilityIds,
      scores: _scores(str: 14),
    );
    final atFifteen = PointBuyEvaluation.fromVisibleScores(
      abilityIds: _abilityIds,
      scores: _scores(str: 15),
    );

    expect(atFifteen.spent - atFourteen.spent, 2);
  });

  test('cannot increase above 15 in Point Buy', () {
    final evaluation = PointBuyEvaluation.fromVisibleScores(
      abilityIds: _abilityIds,
      scores: _scores(str: 15),
    );

    expect(evaluation.canIncrement('str'), isFalse);
  });

  test('cannot exceed 27 points in Point Buy', () {
    final evaluation = PointBuyEvaluation.fromVisibleScores(
      abilityIds: _abilityIds,
      scores: _scores(str: 15, dex: 15, con: 15),
    );

    expect(evaluation.spent, 27);
    expect(evaluation.canIncrement('int'), isFalse);
  });

  test('cannot decrement below 8 in Point Buy', () {
    final evaluation = PointBuyEvaluation.starting(abilityIds: _abilityIds);

    expect(evaluation.canDecrement('str'), isFalse);
  });

  test('switching methods preserves previous allocations', () {
    var state = CharacterCreationAbilityScores.defaults(
      currentScores: AbilityScores(values: _scores(str: 12, dex: 13)),
    );

    state = state.withManualScore('str', 16);
    state = state.withMethod(AbilityScoreGenerationMethod.pointBuy);
    state = state.withPointBuyScore('dex', 15);
    state = state.withMethod(AbilityScoreGenerationMethod.standardArray);
    state = state.withStandardArrayAssignment('con', 15);

    expect(state.manual.scoreFor('str'), 16);
    expect(state.pointBuy.scoreFor('dex'), 15);
    expect(state.standardArray.assignedScoreFor('con'), 15);

    expect(
      state.withMethod(AbilityScoreGenerationMethod.manualRolled).baseScores,
      containsPair('str', 16),
    );
    expect(
      state.withMethod(AbilityScoreGenerationMethod.pointBuy).baseScores,
      containsPair('dex', 15),
    );
    expect(
      state.withMethod(AbilityScoreGenerationMethod.standardArray).baseScores,
      containsPair('con', 15),
    );
  });

  test('valid Point Buy assignment marks Ability Scores complete', () {
    var state = CharacterCreationAbilityScores.defaults().withMethod(
      AbilityScoreGenerationMethod.pointBuy,
    );
    for (final entry in _scores(str: 15, dex: 15, con: 15).entries) {
      state = state.withPointBuyScore(entry.key, entry.value);
    }
    final character = applyCreationAbilityScoresToCharacter(
      _characterWithScores(_scores()),
      state,
    );

    final validation = validateAbilityScoreGeneration(
      character: character,
      abilities: _abilities,
      creation: characterCreationData(character.extraData),
      pointBuyRules: PointBuyRules.defaults,
      creationAbilityScores: state,
    );

    expect(validation.status, AbilityScoreValidationStatus.ready);
    expect(validation.blocksProgress, isFalse);
  });

  test('invalid Point Buy blocks Guided Builder progress', () async {
    final database = CompendiumDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final browseRepository = CompendiumBrowseRepository(database: database);
    final repository = CharacterRepository(
      database: database,
      browseRepository: browseRepository,
    );
    final compendium = CharacterCompendiumService(
      database: database,
      browseRepository: browseRepository,
    );
    await _insertRuleset(database);
    for (final ability in _abilities) {
      await _insertSkill(database, ability);
    }
    final created = await repository.createCharacter(
      name: 'Point Buyer',
      primaryRulesetId: 'test_rules',
    );
    final controller = CharacterEditorController(
      characterId: created.id,
      repository: repository,
      compendium: compendium,
      resolver: CharacterBuildResolver(compendium: compendium),
      sheetSchemaResolver: CharacterSheetSchemaResolver(compendium: compendium),
    );
    addTearDown(controller.dispose);

    await controller.initialize();
    var state = CharacterCreationAbilityScores.fromCharacter(
      controller.character!,
    ).withMethod(AbilityScoreGenerationMethod.pointBuy);
    for (final ability in _abilities) {
      state = state.withPointBuyScore(ability.id, 15);
    }
    await controller.setCreationAbilityScores(state);

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress.stepStatuses[CharacterBuilderStepId.abilityScores],
      CharacterBuilderStepStatus.error,
    );
    expect(
      progress
          .issuesFor(CharacterBuilderStepId.abilityScores)
          .map((issue) => issue.title),
      contains('Point Buy is over budget'),
    );
  });

  test('Standard Array missing assignments block progress', () {
    final state = CharacterCreationAbilityScores.defaults()
        .withMethod(AbilityScoreGenerationMethod.standardArray)
        .withStandardArrayAssignment('str', 15);
    final character = applyCreationAbilityScoresToCharacter(
      _characterWithScores(_scores()),
      state,
    );

    final validation = validateAbilityScoreGeneration(
      character: character,
      abilities: _abilities,
      creation: characterCreationData(character.extraData),
      pointBuyRules: PointBuyRules.defaults,
      creationAbilityScores: state,
    );

    expect(validation.status, AbilityScoreValidationStatus.invalid);
    expect(validation.title, 'Standard Array needs attention');
    expect(validation.blocksProgress, isTrue);
  });

  test('Standard Array duplicate assignments block progress', () {
    const assignments = <String, int>{
      'str': 15,
      'dex': 15,
      'con': 13,
      'int': 12,
      'wis': 10,
      'cha': 8,
    };
    final state = CharacterCreationAbilityScores.defaults().copyWith(
      method: AbilityScoreGenerationMethod.standardArray,
      standardArray: const StandardArrayCreationAbilityScores(
        assignments: assignments,
      ),
    );
    final character = applyCreationAbilityScoresToCharacter(
      _characterWithScores(_scores()),
      state,
    );

    final validation = validateAbilityScoreGeneration(
      character: character,
      abilities: _abilities,
      creation: characterCreationData(character.extraData),
      pointBuyRules: PointBuyRules.defaults,
      creationAbilityScores: state,
    );

    expect(validation.status, AbilityScoreValidationStatus.invalid);
    expect(validation.message, 'Use each Standard Array score once.');
  });

  test('Standard Array validation still accepts complete assignments', () {
    const assignments = <String, int>{
      'str': 15,
      'dex': 14,
      'con': 13,
      'int': 12,
      'wis': 10,
      'cha': 8,
    };
    final state = CharacterCreationAbilityScores.defaults().copyWith(
      method: AbilityScoreGenerationMethod.standardArray,
      standardArray: const StandardArrayCreationAbilityScores(
        assignments: assignments,
      ),
    );
    final character = applyCreationAbilityScoresToCharacter(
      _characterWithScores(_scores()),
      state,
    );

    final validation = validateAbilityScoreGeneration(
      character: character,
      abilities: _abilities,
      creation: characterCreationData(character.extraData),
      pointBuyRules: PointBuyRules.defaults,
      creationAbilityScores: state,
    );

    expect(validation.status, AbilityScoreValidationStatus.ready);
  });

  test('final Character ability scores update through the resolver', () {
    final original = _characterWithScores(
      _scores(str: 10, dex: 10, con: 10, intelligence: 10, wis: 10, cha: 10),
    );
    final state = CharacterCreationAbilityScores.defaults()
        .withMethod(AbilityScoreGenerationMethod.pointBuy)
        .withPointBuyScore('str', 15);

    final updated = applyCreationAbilityScoresToCharacter(original, state);
    final creation = characterCreationData(updated.extraData);
    final storedAbilityScores =
        creation[kCreationAbilityScoresExtraKey] as Map<String, dynamic>;

    expect(updated.abilityScores.scoreFor('str'), 15);
    expect(updated.abilityScores.scoreFor('dex'), 8);
    expect(storedAbilityScores['method'], 'pointBuy');
    expect(
      (storedAbilityScores['baseScores'] as Map<String, dynamic>)['str'],
      15,
    );
  });

  test('Acolyte-like +2/+1 selection applies final scores correctly', () {
    final options = _backgroundOptions();
    final mode = options.modeById('2,1')!;
    final original = _characterWithScores(
      _scores(str: 10, dex: 10, con: 10, intelligence: 10, wis: 10, cha: 10),
    ).copyWith(backgroundRef: _backgroundRef());
    var state = CharacterCreationAbilityScores.defaults(
      currentScores: original.abilityScores,
    ).withBackgroundAbilityBonusMode(options, mode);
    state = state
        .withBackgroundAbilityBonusAssignment(options, mode, 0, 'int')
        .withBackgroundAbilityBonusAssignment(options, mode, 1, 'wis');

    final updated = applyCreationAbilityScoresToCharacter(
      original,
      state,
      backgroundAbilityOptions: options,
    );

    expect(updated.abilityScores.scoreFor('int'), 12);
    expect(updated.abilityScores.scoreFor('wis'), 11);
    expect(updated.abilityScores.scoreFor('cha'), 10);
  });

  test('+1/+1/+1 background selection applies correctly', () {
    final options = _backgroundOptions();
    final mode = options.modeById('1,1,1')!;
    final original = _characterWithScores(
      _scores(str: 10, dex: 10, con: 10, intelligence: 10, wis: 10, cha: 10),
    ).copyWith(backgroundRef: _backgroundRef());
    var state = CharacterCreationAbilityScores.defaults(
      currentScores: original.abilityScores,
    ).withBackgroundAbilityBonusMode(options, mode);
    state = state
        .withBackgroundAbilityBonusAssignment(options, mode, 0, 'int')
        .withBackgroundAbilityBonusAssignment(options, mode, 1, 'wis')
        .withBackgroundAbilityBonusAssignment(options, mode, 2, 'cha');

    final updated = applyCreationAbilityScoresToCharacter(
      original,
      state,
      backgroundAbilityOptions: options,
    );

    expect(updated.abilityScores.scoreFor('int'), 11);
    expect(updated.abilityScores.scoreFor('wis'), 11);
    expect(updated.abilityScores.scoreFor('cha'), 11);
  });

  test('duplicate ability in +2/+1 background selection is invalid', () {
    final options = _backgroundOptions();
    final mode = options.modeById('2,1')!;
    final character = _characterWithScores(
      _scores(str: 12, dex: 10, con: 10, intelligence: 10, wis: 10, cha: 10),
    ).copyWith(backgroundRef: _backgroundRef());
    var state = CharacterCreationAbilityScores.defaults(
      currentScores: character.abilityScores,
    ).withBackgroundAbilityBonusMode(options, mode);
    state = state
        .withBackgroundAbilityBonusAssignment(options, mode, 0, 'int')
        .withBackgroundAbilityBonusAssignment(options, mode, 1, 'int');

    final validation = validateAbilityScoreGeneration(
      character: character,
      abilities: _abilities,
      creation: characterCreationData(character.extraData),
      pointBuyRules: PointBuyRules.defaults,
      creationAbilityScores: state,
      backgroundAbilityOptions: options,
    );

    expect(validation.status, AbilityScoreValidationStatus.invalid);
    expect(
      validation.message,
      'Choose a different ability for each background increase.',
    );
  });

  test('background change invalidates the saved bonus', () {
    final oldOptions = _backgroundOptions(sourceName: 'Acolyte');
    final newOptions = _backgroundOptions(
      sourceKey: 'test_rules:background:background:artisan',
      sourceName: 'Artisan',
    );
    final mode = oldOptions.modeById('2,1')!;
    final character =
        _characterWithScores(
          _scores(
            str: 12,
            dex: 10,
            con: 10,
            intelligence: 10,
            wis: 10,
            cha: 10,
          ),
        ).copyWith(
          backgroundRef: _backgroundRef(
            id: 'background:artisan',
            name: 'Artisan',
          ),
        );
    var state = CharacterCreationAbilityScores.defaults(
      currentScores: character.abilityScores,
    ).withBackgroundAbilityBonusMode(oldOptions, mode);
    state = state
        .withBackgroundAbilityBonusAssignment(oldOptions, mode, 0, 'int')
        .withBackgroundAbilityBonusAssignment(oldOptions, mode, 1, 'wis');

    final validation = validateAbilityScoreGeneration(
      character: character,
      abilities: _abilities,
      creation: characterCreationData(character.extraData),
      pointBuyRules: PointBuyRules.defaults,
      creationAbilityScores: state,
      backgroundAbilityOptions: newOptions,
    );
    final updated = applyCreationAbilityScoresToCharacter(
      character,
      state,
      backgroundAbilityOptions: newOptions,
    );

    expect(validation.status, AbilityScoreValidationStatus.invalid);
    expect(validation.title, 'Background ability increase needs review');
    expect(updated.abilityScores.scoreFor('int'), 10);
    expect(updated.abilityScores.scoreFor('wis'), 10);
  });

  test('missing background ability selection blocks progress', () async {
    final controller = await _controllerWithBackground(
      backgroundData: _backgroundData(),
    );
    addTearDown(controller.dispose);

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress.stepStatuses[CharacterBuilderStepId.abilityScores],
      CharacterBuilderStepStatus.error,
    );
    expect(
      progress
          .issuesFor(CharacterBuilderStepId.abilityScores)
          .map((issue) => issue.title),
      contains('Background ability increase needed'),
    );
  });

  test(
    'background with no ability data produces warning, not hard blocker',
    () async {
      final controller = await _controllerWithBackground(
        backgroundData: const {'name': 'Blank Background'},
        backgroundName: 'Blank Background',
      );
      addTearDown(controller.dispose);
      final variedState = CharacterCreationAbilityScores.fromCharacter(
        controller.character!,
      ).withManualScore('str', 12);
      await controller.setCreationAbilityScores(variedState);

      final progress = CharacterCreationProgressResolver(controller).resolve();

      expect(
        progress.stepStatuses[CharacterBuilderStepId.abilityScores],
        CharacterBuilderStepStatus.warning,
      );
      expect(
        progress
            .issuesFor(CharacterBuilderStepId.abilityScores)
            .map((issue) => issue.title),
        contains('No background ability increases found'),
      );
      expect(
        progress
            .issuesFor(CharacterBuilderStepId.abilityScores)
            .any(
              (issue) => issue.severity == CharacterBuilderIssueSeverity.error,
            ),
        isFalse,
      );
    },
  );

  testWidgets('Ability Scores point buy shows remaining budget', (
    tester,
  ) async {
    final controller = await _controllerWithBackground(
      backgroundData: const {'name': 'Blank Background'},
      backgroundName: 'Blank Background',
    );
    addTearDown(controller.dispose);
    final state = CharacterCreationAbilityScores.fromCharacter(
      controller.character!,
    ).withMethod(AbilityScoreGenerationMethod.pointBuy);
    await controller.setCreationAbilityScores(state);

    await _pumpAbilityScoresStep(tester, controller);

    expect(find.text('Point Buy Budget'), findsOneWidget);
    expect(find.text('Points remaining'), findsOneWidget);
    expect(find.text('Available now'), findsOneWidget);
  });

  testWidgets('Ability Scores shows background bonus section when available', (
    tester,
  ) async {
    final controller = await _controllerWithBackground(
      backgroundData: _backgroundData(),
    );
    addTearDown(controller.dispose);

    await _pumpAbilityScoresStep(tester, controller);

    await tester.scrollUntilVisible(
      find.text('Background Ability Increase'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Background Ability Increase'), findsOneWidget);
    expect(
      find.textContaining('D&D 2024 background ability increases'),
      findsOneWidget,
    );
  });

  testWidgets('Ability Scores shows final score breakdown', (tester) async {
    final controller = await _controllerWithBackground(
      backgroundData: const {'name': 'Blank Background'},
      backgroundName: 'Blank Background',
    );
    addTearDown(controller.dispose);

    await _pumpAbilityScoresStep(tester, controller);

    await tester.scrollUntilVisible(
      find.text('Final Score Breakdown'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Final Score Breakdown'), findsOneWidget);
    expect(find.text('Base'), findsWidgets);
    expect(find.text('Background'), findsWidgets);
    expect(find.text('Final'), findsWidgets);
    expect(find.text('Modifier'), findsWidgets);
  });

  testWidgets('Ability Scores manual mode warns for unusual D&D scores', (
    tester,
  ) async {
    final controller = await _controllerWithBackground(
      backgroundData: const {'name': 'Blank Background'},
      backgroundName: 'Blank Background',
    );
    addTearDown(controller.dispose);
    final state = CharacterCreationAbilityScores.fromCharacter(
      controller.character!,
    ).withManualScore('str', 19);
    await controller.setCreationAbilityScores(state);

    await _pumpAbilityScoresStep(tester, controller);

    await tester.scrollUntilVisible(
      find.text('Manual score warning'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Manual score warning'), findsOneWidget);
    expect(find.textContaining('usually do not exceed 18'), findsOneWidget);
  });
}

Future<void> _pumpAbilityScoresStep(
  WidgetTester tester,
  CharacterEditorController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 900,
          height: 1200,
          child: AbilityScoresStep(controller: controller),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

const _abilities = <CharacterAbilityDescriptor>[
  CharacterAbilityDescriptor(id: 'str', label: 'Strength', abbreviation: 'STR'),
  CharacterAbilityDescriptor(
    id: 'dex',
    label: 'Dexterity',
    abbreviation: 'DEX',
  ),
  CharacterAbilityDescriptor(
    id: 'con',
    label: 'Constitution',
    abbreviation: 'CON',
  ),
  CharacterAbilityDescriptor(
    id: 'int',
    label: 'Intelligence',
    abbreviation: 'INT',
  ),
  CharacterAbilityDescriptor(id: 'wis', label: 'Wisdom', abbreviation: 'WIS'),
  CharacterAbilityDescriptor(id: 'cha', label: 'Charisma', abbreviation: 'CHA'),
];

const _abilityIds = <String>['str', 'dex', 'con', 'int', 'wis', 'cha'];

Map<String, int> _scores({
  int str = 8,
  int dex = 8,
  int con = 8,
  int intelligence = 8,
  int wis = 8,
  int cha = 8,
}) {
  return <String, int>{
    'str': str,
    'dex': dex,
    'con': con,
    'int': intelligence,
    'wis': wis,
    'cha': cha,
  };
}

Character _characterWithScores(
  Map<String, int> scores, {
  Map<String, dynamic> creation = const <String, dynamic>{},
}) {
  return Character.createBlank(
    id: 'character:test',
    name: 'Tester',
    primaryRulesetId: 'test_rules',
  ).copyWith(
    abilityScores: AbilityScores(values: scores),
    extraData: creation.isEmpty
        ? const <String, dynamic>{}
        : <String, dynamic>{'creation': creation},
  );
}

DndBackgroundAbilityBonusOptions _backgroundOptions({
  String sourceKey = 'test_rules:background:background:acolyte',
  String sourceName = 'Acolyte',
}) {
  return backgroundAbilityBonusOptionsFromData(
    sourceKey: sourceKey,
    sourceName: sourceName,
    data: _backgroundData(name: sourceName),
  );
}

Map<String, dynamic> _backgroundData({String name = 'Acolyte'}) {
  return {
    'name': name,
    'ability': [
      {
        'choose': {
          'weighted': {
            'from': ['int', 'wis', 'cha'],
            'weights': [2, 1],
          },
        },
      },
      {
        'choose': {
          'weighted': {
            'from': ['int', 'wis', 'cha'],
            'weights': [1, 1, 1],
          },
        },
      },
    ],
  };
}

CharacterEntityRef _backgroundRef({
  String id = 'background:acolyte',
  String name = 'Acolyte',
}) {
  return CharacterEntityRef(
    entityType: 'background',
    entityId: id,
    rulesetId: 'test_rules',
    name: name,
  );
}

Future<CharacterEditorController> _controllerWithBackground({
  required Map<String, dynamic> backgroundData,
  String backgroundId = 'background:acolyte',
  String backgroundName = 'Acolyte',
}) async {
  final database = CompendiumDatabase(executor: NativeDatabase.memory());
  addTearDown(database.close);
  final browseRepository = CompendiumBrowseRepository(database: database);
  final repository = CharacterRepository(
    database: database,
    browseRepository: browseRepository,
  );
  final compendium = CharacterCompendiumService(
    database: database,
    browseRepository: browseRepository,
  );
  await _insertRuleset(database);
  for (final ability in _abilities) {
    await _insertSkill(database, ability);
  }
  await _insertBackground(
    database,
    id: backgroundId,
    name: backgroundName,
    data: backgroundData,
  );
  final created = await repository.createCharacter(
    name: 'Background Builder',
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
  await controller.setBackground(
    _backgroundRef(id: backgroundId, name: backgroundName),
  );
  return controller;
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
          searchText: drift.Value(name.toLowerCase()),
        ),
      );
}

Future<void> _insertSkill(
  CompendiumDatabase database,
  CharacterAbilityDescriptor ability,
) {
  return database
      .into(database.entityRecords)
      .insert(
        EntityRecordsCompanion.insert(
          rulesetId: 'test_rules',
          entityType: 'skill',
          entityId: 'skill:${ability.id}',
          collectionKey: 'skillList',
          name: '${ability.label} Skill',
          payloadJson: jsonEncode({
            'id': 'skill:${ability.id}',
            'name': '${ability.label} Skill',
            'data': {'name': '${ability.label} Skill', 'ability': ability.id},
          }),
          sortName: drift.Value(ability.label.toLowerCase()),
          searchText: drift.Value(ability.label.toLowerCase()),
        ),
      );
}
