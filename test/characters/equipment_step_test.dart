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
import 'package:openrpg/screens/characters/creation/steps/equipment_step.dart';

void main() {
  testWidgets('background starting equipment choices render', (tester) async {
    final controller = await _createControllerWithClassAndBackground();

    await _pumpEquipmentStep(tester, controller);

    expect(find.text('Starting Equipment'), findsOneWidget);
    expect(find.text('Background: Acolyte'), findsOneWidget);
    expect(find.text('Book (Prayers)'), findsOneWidget);
    expect(find.text('50 GP'), findsWidgets);
  });

  test('empty equipment remains a warning only', () async {
    final controller = await _createControllerWithClassAndBackground();

    final progress = CharacterCreationProgressResolver(controller).resolve();
    final issue = progress
        .issuesFor(CharacterBuilderStepId.equipment)
        .firstWhere((issue) => issue.title == 'No equipment selected');

    expect(issue.severity, CharacterBuilderIssueSeverity.warning);
  });

  testWidgets('empty equipment warning is visible', (tester) async {
    final controller = await _createControllerWithClassAndBackground();

    await _pumpEquipmentStep(tester, controller);
    await tester.scrollUntilVisible(
      find.textContaining('No equipment selected'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.textContaining('No equipment selected'), findsOneWidget);
  });

  testWidgets('loadout warning appears when inventory has no loadout', (
    tester,
  ) async {
    final controller = await _createControllerWithClassAndBackground();
    await controller.updateManual((character) {
      return character.copyWith(
        equipment: character.equipment.copyWith(
          entries: const [
            CharacterInventoryEntry(
              id: 'inventory-entry:test:rope',
              name: 'Hempen Rope',
            ),
          ],
          loadout: const EquipmentLoadout(),
        ),
      );
    });
    await controller.flushPendingSave();

    final progress = CharacterCreationProgressResolver(controller).resolve();
    final issue = progress
        .issuesFor(CharacterBuilderStepId.equipment)
        .firstWhere((issue) => issue.title == 'No equipped loadout');

    await _pumpEquipmentStep(tester, controller);
    await tester.scrollUntilVisible(
      find.textContaining('Inventory exists, but no armor or weapon slots'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(issue.severity, CharacterBuilderIssueSeverity.warning);
    expect(
      find.textContaining('Inventory exists, but no armor or weapon slots'),
      findsOneWidget,
    );
  });

  testWidgets('manual inventory editor remains available', (tester) async {
    final controller = await _createControllerWithClassAndBackground();

    await _pumpEquipmentStep(tester, controller);
    await tester.scrollUntilVisible(
      find.text('Advanced Inventory'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Advanced Inventory'));
    await tester.pumpAndSettle();

    expect(find.text('Add From Compendium'), findsOneWidget);
  });
}

Future<void> _pumpEquipmentStep(
  WidgetTester tester,
  CharacterEditorController controller,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 900,
          height: 1200,
          child: EquipmentStep(controller: controller),
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
  await _insertClass(database);
  await _insertBackground(database);
  final created = await repository.createCharacter(
    name: 'Equipment Tester',
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
              'startingEquipment': {
                'additionalFromBackground': true,
                'defaultData': [
                  {
                    'A': [
                      {'item': 'longsword|xphb'},
                      {'item': 'shield|xphb'},
                      {'value': 1000},
                    ],
                    'B': [
                      {'value': 5000},
                    ],
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
              'startingEquipment': [
                {
                  'A': [
                    {'item': 'book|xphb', 'displayName': 'Book (Prayers)'},
                    {'item': "calligrapher's supplies|xphb"},
                    {'value': 800},
                  ],
                  'B': [
                    {'value': 5000},
                  ],
                },
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
