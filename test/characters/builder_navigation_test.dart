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
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';
import 'package:openrpg/screens/characters/creation/steps/review_finish_step.dart';
import 'package:openrpg/screens/characters/creation/widgets/builder_bottom_bar.dart';
import 'package:openrpg/screens/characters/creation/widgets/builder_step_rail.dart';

void main() {
  testWidgets('step rail allows navigation while current step has an error', (
    tester,
  ) async {
    CharacterBuilderStepId? selectedStep;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BuilderStepRail(
            steps: characterBuilderStepDescriptors,
            currentStep: CharacterBuilderStepId.basics,
            progress: _progress(
              issues: [
                _issue(
                  severity: CharacterBuilderIssueSeverity.error,
                  stepId: CharacterBuilderStepId.basics,
                  title: 'No character name',
                ),
              ],
            ),
            onStepSelected: (step) => selectedStep = step,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Equipment'));
    await tester.pump();

    expect(selectedStep, CharacterBuilderStepId.equipment);
  });

  testWidgets('finish is blocked with error severity issues', (tester) async {
    final controller = await _createController();
    var openedSheet = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewFinishStep(
            controller: controller,
            progress: _progress(
              issues: [
                _issue(
                  severity: CharacterBuilderIssueSeverity.error,
                  stepId: CharacterBuilderStepId.basics,
                  title: 'No character name',
                ),
              ],
            ),
            onGoToStep: (_) {},
            onOpenSheet: () => openedSheet = true,
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(find.text('Resolve Blocking Issues'), 300);
    await tester.tap(find.text('Resolve Blocking Issues'));
    await tester.pump();

    expect(openedSheet, isFalse);
    expect(
      find.text('Finish is blocked until checklist errors are resolved.'),
      findsOneWidget,
    );
  });

  testWidgets('warnings do not block finishing the guided checklist', (
    tester,
  ) async {
    final controller = await _createController();
    var openedSheet = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewFinishStep(
            controller: controller,
            progress: _progress(
              issues: [
                _issue(
                  severity: CharacterBuilderIssueSeverity.warning,
                  stepId: CharacterBuilderStepId.equipment,
                  title: 'No equipment selected',
                ),
              ],
            ),
            onGoToStep: (_) {},
            onOpenSheet: () => openedSheet = true,
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(find.text('Finish Guided Builder'), 300);
    await tester.tap(find.text('Finish Guided Builder'));
    await tester.pumpAndSettle();

    expect(openedSheet, isTrue);
  });

  testWidgets('bottom bar issue summary shows counts and next blocker', (
    tester,
  ) async {
    final controller = await _createController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BuilderBottomBar(
            controller: controller,
            currentStep: CharacterBuilderStepId.basics,
            progress: _progress(
              issues: [
                _issue(
                  severity: CharacterBuilderIssueSeverity.error,
                  stepId: CharacterBuilderStepId.basics,
                  title: 'No character name',
                ),
                _issue(
                  severity: CharacterBuilderIssueSeverity.error,
                  stepId: CharacterBuilderStepId.classLevel,
                  title: 'No class selected',
                ),
                _issue(
                  severity: CharacterBuilderIssueSeverity.warning,
                  stepId: CharacterBuilderStepId.equipment,
                  title: 'No equipment selected',
                ),
              ],
            ),
            onBack: null,
            onReview: () {},
            onContinue: () {},
          ),
        ),
      ),
    );

    expect(find.text('Errors 2'), findsOneWidget);
    expect(find.text('Warnings 1'), findsOneWidget);
    expect(find.text('Next blocking issue: No character name'), findsOneWidget);
  });
}

CharacterCreationProgress _progress({
  List<CharacterBuilderIssue> issues = const <CharacterBuilderIssue>[],
}) {
  final statuses = <CharacterBuilderStepId, CharacterBuilderStepStatus>{
    for (final descriptor in characterBuilderStepDescriptors)
      descriptor.id: _statusFor(descriptor.id, issues),
  };
  final completed = statuses.values
      .where((status) => status == CharacterBuilderStepStatus.complete)
      .length;
  return CharacterCreationProgress(
    stepStatuses: statuses,
    issues: issues,
    completedVisibleSteps: completed,
    totalVisibleSteps: characterBuilderStepDescriptors.length,
    completionRatio: completed / characterBuilderStepDescriptors.length,
  );
}

CharacterBuilderStepStatus _statusFor(
  CharacterBuilderStepId stepId,
  List<CharacterBuilderIssue> issues,
) {
  final stepIssues = issues.where((issue) => issue.stepId == stepId);
  if (stepIssues.any(
    (issue) => issue.severity == CharacterBuilderIssueSeverity.error,
  )) {
    return CharacterBuilderStepStatus.error;
  }
  if (stepIssues.any(
    (issue) => issue.severity == CharacterBuilderIssueSeverity.warning,
  )) {
    return CharacterBuilderStepStatus.warning;
  }
  return CharacterBuilderStepStatus.complete;
}

CharacterBuilderIssue _issue({
  required CharacterBuilderIssueSeverity severity,
  required CharacterBuilderStepId stepId,
  required String title,
}) {
  return CharacterBuilderIssue(
    severity: severity,
    stepId: stepId,
    title: title,
    message: '$title message',
    actionLabel: 'Review',
  );
}

Future<CharacterEditorController> _createController() async {
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
  await database
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
  final created = await repository.createCharacter(
    name: 'Checklist Tester',
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
  return controller;
}
