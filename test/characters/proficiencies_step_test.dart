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
import 'package:openrpg/screens/characters/creation/steps/proficiencies_step.dart';

void main() {
  testWidgets('class saving throws appear in guided proficiencies', (
    tester,
  ) async {
    final controller = await _createControllerWithClassAndBackground();

    await _pumpProficienciesStep(tester, controller);

    expect(find.text('Class Proficiencies'), findsOneWidget);
    expect(find.text('Saving Throws'), findsOneWidget);
    expect(find.text('Strength'), findsOneWidget);
    expect(find.text('Constitution'), findsOneWidget);
  });

  testWidgets('background skills and tools appear when data has them', (
    tester,
  ) async {
    final controller = await _createControllerWithClassAndBackground();

    await _pumpProficienciesStep(tester, controller);
    await tester.scrollUntilVisible(
      find.text('Background Proficiencies'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Background Proficiencies'), findsOneWidget);
    expect(find.text('Insight'), findsOneWidget);
    expect(find.text('Religion'), findsOneWidget);
    expect(find.text("Calligrapher's Supplies"), findsOneWidget);
    expect(find.text('Celestial'), findsOneWidget);
  });

  testWidgets('manual advanced skill editor remains available', (tester) async {
    final controller = await _createControllerWithClassAndBackground();

    await _pumpProficienciesStep(tester, controller);
    await tester.scrollUntilVisible(
      find.text('Advanced: Manual Skill Editor'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Advanced: Manual Skill Editor'), findsOneWidget);
  });

  test('no trained skills warning still appears', () async {
    final controller = await _createControllerWithClassAndBackground();

    final progress = CharacterCreationProgressResolver(controller).resolve();

    expect(
      progress
          .issuesFor(CharacterBuilderStepId.proficiencies)
          .map((issue) => issue.title),
      contains('No trained skills'),
    );
    expect(
      progress
          .issuesFor(CharacterBuilderStepId.proficiencies)
          .firstWhere((issue) => issue.title == 'No trained skills')
          .severity,
      CharacterBuilderIssueSeverity.warning,
    );
  });
}

Future<void> _pumpProficienciesStep(
  WidgetTester tester,
  CharacterEditorController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 900,
          height: 1200,
          child: ProficienciesStep(controller: controller),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}

Future<CharacterEditorController>
_createControllerWithClassAndBackground() async {
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
  await _insertSkill(
    database,
    id: 'skill:athletics',
    name: 'Athletics',
    ability: 'str',
  );
  await _insertSkill(
    database,
    id: 'skill:insight',
    name: 'Insight',
    ability: 'wis',
  );
  await _insertSkill(
    database,
    id: 'skill:religion',
    name: 'Religion',
    ability: 'int',
  );
  await _insertClass(database);
  await _insertBackground(database);
  final created = await repository.createCharacter(
    name: 'Proficiency Tester',
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
  await controller.addClassEntry();
  await controller.setClassEntry(
    0,
    classRef: const CharacterEntityRef(
      entityType: 'class',
      entityId: 'class:fighter',
      rulesetId: 'test_rules',
      name: 'Fighter',
    ),
    level: 1,
  );
  await controller.setBackground(
    const CharacterEntityRef(
      entityType: 'background',
      entityId: 'background:acolyte',
      rulesetId: 'test_rules',
      name: 'Acolyte',
    ),
  );
  await controller.flushPendingSave();
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

Future<void> _insertClass(CompendiumDatabase database) {
  return database
      .into(database.entityRecords)
      .insert(
        EntityRecordsCompanion.insert(
          rulesetId: 'test_rules',
          entityType: 'class',
          entityId: 'class:fighter',
          collectionKey: 'classList',
          name: 'Fighter',
          payloadJson: jsonEncode({
            'id': 'class:fighter',
            'name': 'Fighter',
            'data': {
              'name': 'Fighter',
              'primaryAbility': [
                {'str': true},
              ],
              'hd': {'number': 1, 'faces': 10},
              'proficiency': ['str', 'con'],
              'startingProficiencies': {
                'armor': ['light', 'medium', 'heavy', 'shield'],
                'weapons': ['simple', 'martial'],
                'tools': ['smith tools'],
                'skills': [
                  {
                    'choose': {
                      'from': ['athletics', 'insight'],
                      'count': 2,
                    },
                  },
                ],
              },
            },
          }),
          sortName: const drift.Value('fighter'),
          searchText: const drift.Value('fighter'),
        ),
      );
}

Future<void> _insertBackground(CompendiumDatabase database) {
  return database
      .into(database.entityRecords)
      .insert(
        EntityRecordsCompanion.insert(
          rulesetId: 'test_rules',
          entityType: 'background',
          entityId: 'background:acolyte',
          collectionKey: 'backgroundList',
          name: 'Acolyte',
          payloadJson: jsonEncode({
            'id': 'background:acolyte',
            'name': 'Acolyte',
            'data': {
              'name': 'Acolyte',
              'skillProficiencies': [
                {'insight': true, 'religion': true},
              ],
              'toolProficiencies': [
                {"calligrapher's supplies": true},
              ],
              'languageProficiencies': [
                {'celestial': true},
              ],
            },
          }),
          sortName: const drift.Value('acolyte'),
          searchText: const drift.Value('acolyte'),
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
