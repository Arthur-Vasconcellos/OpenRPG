import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';

class BuilderBottomBar extends StatelessWidget {
  final CharacterEditorController controller;
  final CharacterBuilderStepId currentStep;
  final CharacterCreationProgress progress;
  final VoidCallback? onBack;
  final VoidCallback onReview;
  final VoidCallback onContinue;

  const BuilderBottomBar({
    super.key,
    required this.controller,
    required this.currentStep,
    required this.progress,
    required this.onBack,
    required this.onReview,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final colorScheme = Theme.of(context).colorScheme;
    final currentIssues = progress.issuesFor(currentStep);
    final hasCurrentErrors = currentIssues.any(
      (issue) => issue.severity == CharacterBuilderIssueSeverity.error,
    );
    final continueLabel = currentStep == CharacterBuilderStepId.review
        ? 'Open Sheet'
        : hasCurrentErrors
        ? 'Fix Required'
        : 'Continue';
    final initiative = character.combatStats.initiative;
    final summary =
        'AC ${character.combatStats.armorClass} | HP ${character.health.currentHitPoints}/${character.health.maxHitPoints} | Init ${initiative >= 0 ? '+$initiative' : '$initiative'} | Speed ${character.combatStats.speed} ft';

    return Material(
      elevation: 8,
      color: colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.end,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 220),
                child: Text(
                  progress.totalVisibleSteps == 0
                      ? 'Preview updates as choices are completed.'
                      : summary,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
              OutlinedButton.icon(
                onPressed: onReview,
                icon: const Icon(Icons.checklist_outlined),
                label: Text(
                  progress.errorCount + progress.warningCount == 0
                      ? 'Review'
                      : 'Review issues (${progress.errorCount + progress.warningCount})',
                ),
              ),
              FilledButton.icon(
                onPressed: onContinue,
                icon: Icon(
                  currentStep == CharacterBuilderStepId.review
                      ? Icons.open_in_new
                      : Icons.arrow_forward,
                ),
                label: Text(continueLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
