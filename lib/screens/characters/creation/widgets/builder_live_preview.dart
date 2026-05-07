import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';

class BuilderLivePreview extends StatelessWidget {
  final CharacterEditorController controller;

  const BuilderLivePreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final rulesetName = controller.installedRulesets
        .where((ruleset) => ruleset.id == character.primaryRulesetId)
        .map((ruleset) => ruleset.name)
        .cast<String?>()
        .firstWhere((name) => name != null, orElse: () => null);
    final spellCount = character.spellcasting?.allSpells.length ?? 0;
    final classSummary = character.classes.isEmpty
        ? 'No class yet'
        : character.classes
              .map((entry) => '${entry.className} ${entry.level}')
              .join(' / ');

    return Card(
      child: SizedBox(
        width: 310,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Live Preview',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              character.name.trim().isEmpty
                  ? 'Unnamed Character'
                  : character.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(classSummary),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(rulesetName ?? 'No ruleset')),
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
              ],
            ),
            const SizedBox(height: 16),
            _PreviewStatGrid(
              stats: [
                _PreviewStat(
                  label: 'AC',
                  value: '${character.combatStats.armorClass}',
                ),
                _PreviewStat(
                  label: 'HP',
                  value:
                      '${character.health.currentHitPoints}/${character.health.maxHitPoints}',
                ),
                _PreviewStat(
                  label: 'Speed',
                  value: '${character.combatStats.speed}',
                ),
                _PreviewStat(
                  label: 'Prof.',
                  value: '+${character.proficiencies.proficiencyBonus}',
                ),
                _PreviewStat(
                  label: 'Features',
                  value: '${controller.resolvedBuild.allFeatures.length}',
                ),
                _PreviewStat(label: 'Spells', value: '$spellCount'),
                _PreviewStat(
                  label: 'Gear',
                  value: '${character.equipment.entries.length}',
                ),
                _PreviewStat(
                  label: 'Needs attention',
                  value: '${controller.unresolvedSelectionCount}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Live preview updates from saved character data and rules references.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewStat {
  final String label;
  final String value;

  const _PreviewStat({required this.label, required this.value});
}

class _PreviewStatGrid extends StatelessWidget {
  final List<_PreviewStat> stats;

  const _PreviewStatGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.55,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(stat.label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 4),
              Text(stat.value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        );
      },
    );
  }
}
