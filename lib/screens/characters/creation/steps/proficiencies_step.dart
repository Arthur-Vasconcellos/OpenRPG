import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/saving_throw_grid.dart';

class ProficienciesStep extends StatelessWidget {
  final CharacterEditorController controller;

  const ProficienciesStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final resolved = controller.resolvedBuild;
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
                  'Proficiencies From Your Choices',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Proficiencies from your class and rules appear first. Manual skill and saving throw edits are treated as table adjustments.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...resolved.savingThrowDefaults.proficientAbilityIds.map(
                      (id) => Chip(label: Text('Save ${id.toUpperCase()}')),
                    ),
                    ...resolved.armorProficiencies.map(
                      (value) => Chip(label: Text('Armor: $value')),
                    ),
                    ...resolved.weaponProficiencies.map(
                      (value) => Chip(label: Text('Weapon: $value')),
                    ),
                    ...resolved.toolProficiencies.map(
                      (value) => Chip(label: Text('Tool: $value')),
                    ),
                    if (resolved
                            .savingThrowDefaults
                            .proficientAbilityIds
                            .isEmpty &&
                        resolved.armorProficiencies.isEmpty &&
                        resolved.weaponProficiencies.isEmpty &&
                        resolved.toolProficiencies.isEmpty)
                      const Chip(label: Text('Proficiencies pending')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _SkillTrainingCard(controller: controller),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manual Saving Throw Overrides',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SavingThrowGrid(
                  character: character,
                  controller: controller,
                  abilities: controller.sheetSchema.abilities,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillTrainingCard extends StatelessWidget {
  final CharacterEditorController controller;

  const _SkillTrainingCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final skills = controller.sheetSchema.skills;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skill Training',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap a skill to cycle none, proficient, and expertise. Custom rules can still be adjusted by hand.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.sizeOf(context).width < 620 ? 1 : 2,
                childAspectRatio: 3.25,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final skill = skills[index];
                final proficiency = character.proficiencies.skills
                    .proficiencyFor(skill.id);
                final modifier = controller.skillModifierFor(skill);
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => controller.cycleSkillTraining(skill.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: proficiency == SkillTrainingLevel.none
                            ? colorScheme.outlineVariant
                            : colorScheme.primary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                skill.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                controller.sheetSchema.abilityAbbreviation(
                                  skill.abilityId,
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              modifier >= 0 ? '+$modifier' : '$modifier',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              SkillTrainingLevel.shortLabel(proficiency),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
