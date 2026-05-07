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
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/characters/creation/ability_score_generation.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';

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

  test('valid Point Buy assignment marks Ability Scores complete', () {
    final validation = validateAbilityScoreGeneration(
      character: _characterWithScores(
        _scores(str: 15, dex: 15, con: 15),
        creation: const {kAbilityScoreMethodExtraKey: 'pointBuy'},
      ),
      abilities: _abilities,
      creation: const {kAbilityScoreMethodExtraKey: 'pointBuy'},
      pointBuyRules: PointBuyRules.defaults,
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
    await controller.setCreationExtraValue(
      kAbilityScoreMethodExtraKey,
      'pointBuy',
    );
    for (final ability in _abilities) {
      await controller.setAbilityScore(ability.id, 15);
    }

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

  test('Standard Array validation still accepts complete assignments', () {
    const assignments = <String, int>{
      'str': 15,
      'dex': 14,
      'con': 13,
      'int': 12,
      'wis': 10,
      'cha': 8,
    };
    final validation = validateAbilityScoreGeneration(
      character: _characterWithScores(
        assignments,
        creation: const {
          kAbilityScoreMethodExtraKey: 'standardArray',
          kStandardArrayAssignmentsExtraKey: assignments,
        },
      ),
      abilities: _abilities,
      creation: const {
        kAbilityScoreMethodExtraKey: 'standardArray',
        kStandardArrayAssignmentsExtraKey: assignments,
      },
      pointBuyRules: PointBuyRules.defaults,
    );

    expect(validation.status, AbilityScoreValidationStatus.ready);
  });
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
