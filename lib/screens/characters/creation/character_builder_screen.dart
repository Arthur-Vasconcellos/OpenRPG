import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/character_sheet/character_sheet_screen.dart';
import 'package:openrpg/screens/characters/creation/character_builder_shell.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_mode.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';
import 'package:openrpg/screens/characters/creation/steps/ability_scores_step.dart';
import 'package:openrpg/screens/characters/creation/steps/background_step.dart';
import 'package:openrpg/screens/characters/creation/steps/basics_ruleset_step.dart';
import 'package:openrpg/screens/characters/creation/steps/class_level_step.dart';
import 'package:openrpg/screens/characters/creation/steps/equipment_step.dart';
import 'package:openrpg/screens/characters/creation/steps/proficiencies_step.dart';
import 'package:openrpg/screens/characters/creation/steps/review_finish_step.dart';
import 'package:openrpg/screens/characters/creation/steps/species_race_step.dart';
import 'package:openrpg/screens/characters/creation/steps/spells_step.dart';
import 'package:openrpg/screens/characters/creation/steps/story_notes_step.dart';
import 'package:openrpg/screens/characters/creation/widgets/builder_bottom_bar.dart';

class CharacterBuilderScreen extends StatefulWidget {
  final String characterId;
  final CharacterBuilderStepId initialStep;

  const CharacterBuilderScreen({
    super.key,
    required this.characterId,
    this.initialStep = CharacterBuilderStepId.basics,
  });

  @override
  State<CharacterBuilderScreen> createState() => _CharacterBuilderScreenState();
}

class _CharacterBuilderScreenState extends State<CharacterBuilderScreen> {
  late final CharacterEditorController _controller = CharacterEditorController(
    characterId: widget.characterId,
  )..initialize();
  late CharacterBuilderStepId _currentStep;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (_controller.loadError != null || _controller.character == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Guided Builder')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 56),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load character.\n${_controller.loadError ?? 'Unknown error'}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _controller.reload,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final character = _controller.character!;
        final progress = CharacterCreationProgressResolver(
          _controller,
        ).resolve();
        final visibleSteps = characterBuilderStepDescriptors
            .where((descriptor) => descriptor.isVisible(_controller))
            .toList(growable: false);
        final currentStep = _effectiveCurrentStep(visibleSteps);

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name.trim().isEmpty
                      ? 'Unnamed Character'
                      : character.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Guided Checklist - ${currentStep.descriptor.title}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Open character sheet',
                onPressed: () => _openSheet(replace: false),
                icon: const Icon(Icons.article_outlined),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'expert':
                      _openSheet(replace: true);
                      break;
                    case 'exit':
                      Navigator.of(context).maybePop();
                      break;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'expert',
                    child: Text('Switch to Expert Builder'),
                  ),
                  PopupMenuItem(value: 'exit', child: Text('Exit Builder')),
                ],
              ),
            ],
          ),
          body: CharacterBuilderShell(
            controller: _controller,
            visibleSteps: visibleSteps,
            currentStep: currentStep,
            progress: progress,
            onStepSelected: (step) => setState(() => _currentStep = step),
            child: _buildStep(currentStep, progress),
          ),
          bottomNavigationBar: BuilderBottomBar(
            controller: _controller,
            currentStep: currentStep,
            progress: progress,
            onBack: _previousStep(visibleSteps, currentStep) == null
                ? null
                : () => setState(() {
                    _currentStep = _previousStep(visibleSteps, currentStep)!;
                  }),
            onReview: () => setState(() {
              _currentStep = CharacterBuilderStepId.review;
            }),
            onContinue: () => _continue(visibleSteps, currentStep, progress),
          ),
        );
      },
    );
  }

  CharacterBuilderStepId _effectiveCurrentStep(
    List<CharacterBuilderStepDescriptor> visibleSteps,
  ) {
    if (visibleSteps.any((step) => step.id == _currentStep)) {
      return _currentStep;
    }
    return visibleSteps.isEmpty
        ? CharacterBuilderStepId.basics
        : visibleSteps.first.id;
  }

  CharacterBuilderStepId? _previousStep(
    List<CharacterBuilderStepDescriptor> visibleSteps,
    CharacterBuilderStepId currentStep,
  ) {
    final index = visibleSteps.indexWhere((step) => step.id == currentStep);
    if (index <= 0) {
      return null;
    }
    return visibleSteps[index - 1].id;
  }

  CharacterBuilderStepId? _nextStep(
    List<CharacterBuilderStepDescriptor> visibleSteps,
    CharacterBuilderStepId currentStep,
  ) {
    final index = visibleSteps.indexWhere((step) => step.id == currentStep);
    if (index < 0 || index >= visibleSteps.length - 1) {
      return null;
    }
    return visibleSteps[index + 1].id;
  }

  Future<void> _continue(
    List<CharacterBuilderStepDescriptor> visibleSteps,
    CharacterBuilderStepId currentStep,
    CharacterCreationProgress progress,
  ) async {
    if (currentStep == CharacterBuilderStepId.review) {
      if (progress.hasBlockingIssues && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Finish is blocked by ${progress.errorCount} error${progress.errorCount == 1 ? '' : 's'}. Review keeps the checklist open.',
            ),
          ),
        );
        return;
      }
      await _finishAndOpenSheet();
      return;
    }
    final blockingIssues = progress
        .issuesFor(currentStep)
        .where((issue) => issue.severity == CharacterBuilderIssueSeverity.error)
        .toList(growable: false);
    final next = _nextStep(visibleSteps, currentStep);
    if (next == null) {
      setState(() {
        _currentStep = CharacterBuilderStepId.review;
      });
      return;
    }
    setState(() {
      _currentStep = next;
    });
    if (blockingIssues.isNotEmpty && mounted) {
      final firstIssue = blockingIssues.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Checklist issue saved for Review: ${firstIssue.title}.',
          ),
        ),
      );
    }
  }

  Widget _buildStep(
    CharacterBuilderStepId step,
    CharacterCreationProgress progress,
  ) {
    return switch (step) {
      CharacterBuilderStepId.basics => BasicsRulesetStep(
        controller: _controller,
      ),
      CharacterBuilderStepId.classLevel => ClassLevelStep(
        controller: _controller,
      ),
      CharacterBuilderStepId.speciesRace => SpeciesRaceStep(
        controller: _controller,
      ),
      CharacterBuilderStepId.background => BackgroundStep(
        controller: _controller,
      ),
      CharacterBuilderStepId.abilityScores => AbilityScoresStep(
        controller: _controller,
      ),
      CharacterBuilderStepId.proficiencies => ProficienciesStep(
        controller: _controller,
        onGoToStep: (step) => setState(() => _currentStep = step),
      ),
      CharacterBuilderStepId.spells => SpellsStep(
        controller: _controller,
        onGoToStep: (step) => setState(() => _currentStep = step),
      ),
      CharacterBuilderStepId.equipment => EquipmentStep(
        controller: _controller,
        onGoToStep: (step) => setState(() => _currentStep = step),
      ),
      CharacterBuilderStepId.story => StoryNotesStep(controller: _controller),
      CharacterBuilderStepId.review => ReviewFinishStep(
        controller: _controller,
        progress: progress,
        onGoToStep: (step) => setState(() => _currentStep = step),
        onOpenSheet: () => _openSheet(replace: true),
      ),
    };
  }

  Future<void> _finishAndOpenSheet() async {
    await _controller.markCreationComplete(
      mode: CharacterCreationMode.guided.storageValue,
    );
    await _controller.flushPendingSave();
    if (!mounted) {
      return;
    }
    _openSheet(replace: true);
  }

  void _openSheet({required bool replace}) {
    final route = MaterialPageRoute(
      builder: (_) => CharacterSheetScreen(characterId: widget.characterId),
    );
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }
}
