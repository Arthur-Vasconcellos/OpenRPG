import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_mode.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';
import 'package:openrpg/screens/characters/creation/widgets/builder_issue_card.dart';

class ReviewFinishStep extends StatelessWidget {
  final CharacterEditorController controller;
  final CharacterCreationProgress progress;
  final ValueChanged<CharacterBuilderStepId> onGoToStep;
  final VoidCallback onOpenSheet;

  const ReviewFinishStep({
    super.key,
    required this.controller,
    required this.progress,
    required this.onGoToStep,
    required this.onOpenSheet,
  });

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final errors = _issues(CharacterBuilderIssueSeverity.error);
    final warnings = _issues(CharacterBuilderIssueSeverity.warning);
    final infos = _issues(CharacterBuilderIssueSeverity.info);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review & Finish',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  progress.hasBlockingIssues
                      ? '${progress.errorCount} blocking issue${progress.errorCount == 1 ? '' : 's'} need attention before this character is ready for play.'
                      : warnings.isEmpty
                      ? 'Ready for play: class, species/race, background, abilities, and ruleset references are complete.'
                      : '${warnings.length} warning${warnings.length == 1 ? '' : 's'} remain. They do not block opening the sheet.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: progress.completionRatio),
                const SizedBox(height: 8),
                Text(
                  '${progress.completedVisibleSteps} of ${progress.totalVisibleSteps} visible steps complete',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _IssueSection(
          title: 'Blocking Issues',
          emptyLabel: 'No blocking issues.',
          issues: errors,
          onGoToStep: onGoToStep,
        ),
        const SizedBox(height: 16),
        _IssueSection(
          title: 'Warnings',
          emptyLabel: 'No warnings.',
          issues: warnings,
          onGoToStep: onGoToStep,
        ),
        if (infos.isNotEmpty) ...[
          const SizedBox(height: 16),
          _IssueSection(
            title: 'Notes',
            emptyLabel: '',
            issues: infos,
            onGoToStep: onGoToStep,
          ),
        ],
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Character Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(character.name)),
                    Chip(label: Text('Level ${character.totalLevel}')),
                    Chip(
                      label: Text(
                        character.classes.isEmpty
                            ? 'No class'
                            : character.classes
                                  .map(
                                    (entry) =>
                                        '${entry.className} ${entry.level}',
                                  )
                                  .join(' / '),
                      ),
                    ),
                    Chip(
                      label: Text(
                        character.raceRef?.displayName ?? 'No species/race',
                      ),
                    ),
                    Chip(
                      label: Text(
                        character.backgroundRef?.displayName ?? 'No background',
                      ),
                    ),
                    Chip(label: Text('AC ${character.combatStats.armorClass}')),
                    Chip(
                      label: Text(
                        'HP ${character.health.currentHitPoints}/${character.health.maxHitPoints}',
                      ),
                    ),
                    Chip(
                      label: Text('Speed ${character.combatStats.speed} ft'),
                    ),
                    Chip(
                      label: Text(
                        '${controller.resolvedBuild.allFeatures.length} features',
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${character.spellcasting?.allSpells.length ?? 0} spells',
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${character.equipment.entries.length} items',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: () => _finish(context),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(
                    progress.hasBlockingIssues
                        ? 'Fix Required'
                        : 'Open Character Sheet',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Character is saved in the builder.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Stay in Builder'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _export(context),
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Export Character'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<CharacterBuilderIssue> _issues(CharacterBuilderIssueSeverity severity) {
    return progress.issues
        .where((issue) => issue.severity == severity)
        .toList(growable: false);
  }

  Future<void> _finish(BuildContext context) async {
    if (progress.hasBlockingIssues) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fix the choices that need attention before finishing Guided Builder.',
          ),
        ),
      );
      return;
    }
    await controller.markCreationComplete(
      mode: CharacterCreationMode.guided.storageValue,
    );
    await controller.flushPendingSave();
    onOpenSheet();
  }

  Future<void> _export(BuildContext context) async {
    try {
      final result = await controller.exportCharacter();
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to ${result.locationDescription}.')),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

class _IssueSection extends StatelessWidget {
  final String title;
  final String emptyLabel;
  final List<CharacterBuilderIssue> issues;
  final ValueChanged<CharacterBuilderStepId> onGoToStep;

  const _IssueSection({
    required this.title,
    required this.emptyLabel,
    required this.issues,
    required this.onGoToStep,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (issues.isEmpty)
              Text(emptyLabel)
            else
              ...issues.map(
                (issue) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BuilderIssueCard(
                    issue: issue,
                    onAction: () => onGoToStep(issue.stepId),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
