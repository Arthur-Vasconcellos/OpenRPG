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
                  actionLabel: 'Go to Basics',
                ),
              ],
            ),
            onGoToStep: (_) {},
            onOpenSheet: () => openedSheet = true,
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Finish Blocked'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Finish Blocked'));
    await tester.pump();

    expect(openedSheet, isFalse);
    expect(
      find.text('Finish is blocked until checklist errors are resolved.'),
      findsOneWidget,
    );
  });

  testWidgets('review splits blockers warnings and notes', (tester) async {
    final controller = await _createController();

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
                _issue(
                  severity: CharacterBuilderIssueSeverity.warning,
                  stepId: CharacterBuilderStepId.equipment,
                  title: 'No equipment selected',
                ),
                _issue(
                  severity: CharacterBuilderIssueSeverity.info,
                  stepId: CharacterBuilderStepId.story,
                  title: 'Story fields are blank',
                ),
              ],
            ),
            onGoToStep: (_) {},
            onOpenSheet: () {},
          ),
        ),
      ),
    );

    expect(find.text('Blockers'), findsOneWidget);
    expect(find.text('Warnings'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Notes'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Notes'), findsOneWidget);
  });

  testWidgets('issue action navigates to relevant step', (tester) async {
    final controller = await _createController();
    CharacterBuilderStepId? selectedStep;

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
                  actionLabel: 'Go to Basics',
                ),
              ],
            ),
            onGoToStep: (step) => selectedStep = step,
            onOpenSheet: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go to Basics').first);
    await tester.pump();

    expect(selectedStep, CharacterBuilderStepId.basics);
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

    await tester.scrollUntilVisible(
      find.text('Finish Guided Builder'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Finish Guided Builder'));
    await tester.pumpAndSettle();

    expect(openedSheet, isTrue);
  });

  testWidgets('finish succeeds without errors', (tester) async {
    final controller = await _createController();
    var openedSheet = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewFinishStep(
            controller: controller,
            progress: _progress(),
            onGoToStep: (_) {},
            onOpenSheet: () => openedSheet = true,
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Finish Guided Builder'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Finish Guided Builder'));
    await tester.pumpAndSettle();

    final creation = controller.character!.extraData['creation'] as Map;
    expect(openedSheet, isTrue);
    expect(creation['mode'], 'guided');
    expect(creation['completedAt'], isNotNull);
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

  testWidgets('bottom bar shows saving indicator', (tester) async {
    final controller = await _createController();
    await controller.setName('Saving Tester');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BuilderBottomBar(
            controller: controller,
            currentStep: CharacterBuilderStepId.basics,
            progress: _progress(),
            onBack: null,
            onReview: () {},
            onContinue: () {},
          ),
        ),
      ),
    );

    expect(find.text('Saving...'), findsOneWidget);
    await controller.flushPendingSave();
  });

  testWidgets('bottom bar shows save error and retry action', (tester) async {
    final controller = await _createController(
      repositoryFactory: (database, browseRepository) => _FailingSaveRepository(
        database: database,
        browseRepository: browseRepository,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BuilderBottomBar(
            controller: controller,
            currentStep: CharacterBuilderStepId.basics,
            progress: _progress(),
            onBack: null,
            onReview: () {},
            onContinue: () {},
          ),
        ),
      ),
    );

    expect(find.text('Save failed'), findsOneWidget);
    expect(find.text('Retry Save'), findsOneWidget);
  });

  testWidgets('finish flushes pending save before opening sheet', (
    tester,
  ) async {
    late _TrackingSaveRepository trackingRepository;
    final controller = await _createController(
      repositoryFactory: (database, browseRepository) {
        trackingRepository = _TrackingSaveRepository(
          database: database,
          browseRepository: browseRepository,
        );
        return trackingRepository;
      },
    );
    final savesBeforePendingChange = trackingRepository.saveCount;
    await controller.setName('Pending Finish Name');
    var openedSheet = false;
    int? saveCountWhenOpened;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewFinishStep(
            controller: controller,
            progress: _progress(),
            onGoToStep: (_) {},
            onOpenSheet: () {
              openedSheet = true;
              saveCountWhenOpened = trackingRepository.saveCount;
            },
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Finish Guided Builder'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Finish Guided Builder'));
    await tester.pumpAndSettle();

    expect(openedSheet, isTrue);
    expect(saveCountWhenOpened, greaterThan(savesBeforePendingChange));
  });

  testWidgets('finish surfaces save errors before navigation', (tester) async {
    final controller = await _createController(
      repositoryFactory: (database, browseRepository) => _FailingSaveRepository(
        database: database,
        browseRepository: browseRepository,
      ),
    );
    var openedSheet = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewFinishStep(
            controller: controller,
            progress: _progress(),
            onGoToStep: (_) {},
            onOpenSheet: () => openedSheet = true,
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Finish Guided Builder'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Finish Guided Builder'));
    await tester.pump();

    expect(openedSheet, isFalse);
    expect(find.textContaining('Save failed:'), findsOneWidget);
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
  String actionLabel = 'Review',
}) {
  return CharacterBuilderIssue(
    severity: severity,
    stepId: stepId,
    title: title,
    message: '$title message',
    actionLabel: actionLabel,
  );
}

Future<CharacterEditorController> _createController({
  CharacterRepository Function(
    CompendiumDatabase database,
    CompendiumBrowseRepository browseRepository,
  )?
  repositoryFactory,
}) async {
  final database = CompendiumDatabase(executor: NativeDatabase.memory());
  addTearDown(database.close);
  final browseRepository = CompendiumBrowseRepository(database: database);
  final creationRepository = CharacterRepository(
    database: database,
    browseRepository: browseRepository,
  );
  final repository =
      repositoryFactory?.call(database, browseRepository) ?? creationRepository;
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
  final created = await creationRepository.createCharacter(
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

class _TrackingSaveRepository extends CharacterRepository {
  int saveCount = 0;

  _TrackingSaveRepository({
    required CompendiumDatabase database,
    required CompendiumBrowseRepository browseRepository,
  }) : super(database: database, browseRepository: browseRepository);

  @override
  Future<void> saveCharacter(Character character) async {
    saveCount++;
    await super.saveCharacter(character);
  }
}

class _FailingSaveRepository extends CharacterRepository {
  _FailingSaveRepository({
    required CompendiumDatabase database,
    required CompendiumBrowseRepository browseRepository,
  }) : super(database: database, browseRepository: browseRepository);

  @override
  Future<void> saveCharacter(Character character) async {
    throw StateError('test save failure');
  }
}
