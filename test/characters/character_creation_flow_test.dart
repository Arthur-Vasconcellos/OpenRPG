import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/screens/character_sheet/character_sheet_screen.dart';
import 'package:openrpg/screens/characters/character_creation_flow.dart';
import 'package:openrpg/screens/characters/creation/character_builder_screen.dart';
import 'package:openrpg/screens/characters/creation/character_creation_mode.dart';
import 'package:openrpg/screens/rulesets/ruleset_detail_screen.dart';

void main() {
  testWidgets('no-ruleset recovery dialog shows recovery actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => const CharacterRulesetRecoveryDialog(
                        canImportRuleset: true,
                      ),
                    );
                  },
                  child: const Text('Start'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Characters need a ruleset to calculate classes, features, spells, items, and stats.',
      ),
      findsOneWidget,
    );
    expect(find.text('Restore Bundled Ruleset'), findsOneWidget);
    expect(find.text('Open Ruleset Library'), findsOneWidget);
    expect(find.text('Import Ruleset JSON'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  test('Guided mode targets CharacterBuilderScreen', () {
    expect(
      characterCreationDestination(
        characterId: 'character:test',
        mode: CharacterCreationMode.guided,
      ),
      isA<CharacterBuilderScreen>(),
    );
  });

  test('Expert mode targets CharacterSheetScreen', () {
    expect(
      characterCreationDestination(
        characterId: 'character:test',
        mode: CharacterCreationMode.expert,
      ),
      isA<CharacterSheetScreen>(),
    );
  });

  testWidgets('ruleset detail no longer exposes builder mode', (tester) async {
    final database = CompendiumDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final browseRepository = CompendiumBrowseRepository(database: database);
    final repository = CompendiumRepository(database: database);
    final created = await repository.createRuleset(
      name: 'Home Rules',
      description: 'Table rules.',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: RulesetDetailScreen(
          rulesetId: created.id,
          browseRepository: browseRepository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Browse'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Use In Character Builder'), findsNothing);
    expect(find.text('Create Character Using This Ruleset'), findsOneWidget);
  });
}
