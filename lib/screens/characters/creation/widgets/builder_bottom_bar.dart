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
    final continueLabel = currentStep == CharacterBuilderStepId.review
        ? progress.hasBlockingIssues
              ? 'Review Errors'
              : 'Finish Guided Builder'
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final alignActions = constraints.maxWidth < 760
                  ? WrapAlignment.start
                  : WrapAlignment.end;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ChecklistIssueSummary(progress: progress),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: alignActions,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 220),
                        child: Text(
                          progress.totalVisibleSteps == 0
                              ? 'Guided checklist updates as choices are completed.'
                              : 'Checklist ${progress.completedVisibleSteps}/${progress.totalVisibleSteps} complete | $summary',
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
                              ? 'Review Checklist'
                              : 'Review issues (${progress.errorCount + progress.warningCount})',
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: onContinue,
                        icon: Icon(
                          currentStep == CharacterBuilderStepId.review
                              ? Icons.check_circle_outline
                              : Icons.arrow_forward,
                        ),
                        label: Text(continueLabel),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChecklistIssueSummary extends StatelessWidget {
  final CharacterCreationProgress progress;

  const _ChecklistIssueSummary({required this.progress});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final nextBlockingIssue = progress.nextBlockingIssue;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Chip(
            visualDensity: VisualDensity.compact,
            avatar: Icon(
              progress.errorCount == 0
                  ? Icons.check_circle_outline
                  : Icons.error_outline,
              size: 18,
              color: progress.errorCount == 0
                  ? colorScheme.primary
                  : colorScheme.error,
            ),
            label: Text('Errors ${progress.errorCount}'),
          ),
          Chip(
            visualDensity: VisualDensity.compact,
            avatar: Icon(
              progress.warningCount == 0
                  ? Icons.check_circle_outline
                  : Icons.warning_amber_outlined,
              size: 18,
              color: progress.warningCount == 0
                  ? colorScheme.primary
                  : colorScheme.tertiary,
            ),
            label: Text('Warnings ${progress.warningCount}'),
          ),
          if (nextBlockingIssue == null)
            Text(
              progress.warningCount == 0
                  ? 'No blocking checklist issues.'
                  : 'Warnings can be reviewed, but they do not block finish.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            Text(
              'Next blocking issue: ${nextBlockingIssue.title}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
