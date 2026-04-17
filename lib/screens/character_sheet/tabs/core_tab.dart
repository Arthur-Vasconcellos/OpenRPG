import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';
import 'package:openrpg/screens/character_sheet/widget/attribute_card.dart';
import 'package:openrpg/screens/character_sheet/widget/character_compendium_picker.dart';
import 'package:openrpg/screens/character_sheet/widget/character_entity_summary_card.dart';
import 'package:openrpg/screens/character_sheet/widget/saving_throw_grid.dart';

class CoreTab extends StatelessWidget {
  final CharacterEditorController controller;

  const CoreTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CharacterIdentityCard(controller: controller),
          const SizedBox(height: 16),
          _BuildSelectionsCard(controller: controller),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    title: 'Attributes',
                    icon: Icons.fitness_center_outlined,
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 0.86,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      AttributeCard(
                        abbreviation: 'STR',
                        name: 'Strength',
                        value: character.abilityScores.strength,
                        modifier: character.modifiers.strength,
                        onDecrement: () => _adjustAbility('strength', -1),
                        onIncrement: () => _adjustAbility('strength', 1),
                      ),
                      AttributeCard(
                        abbreviation: 'DEX',
                        name: 'Dexterity',
                        value: character.abilityScores.dexterity,
                        modifier: character.modifiers.dexterity,
                        onDecrement: () => _adjustAbility('dexterity', -1),
                        onIncrement: () => _adjustAbility('dexterity', 1),
                      ),
                      AttributeCard(
                        abbreviation: 'CON',
                        name: 'Constitution',
                        value: character.abilityScores.constitution,
                        modifier: character.modifiers.constitution,
                        onDecrement: () => _adjustAbility('constitution', -1),
                        onIncrement: () => _adjustAbility('constitution', 1),
                      ),
                      AttributeCard(
                        abbreviation: 'INT',
                        name: 'Intelligence',
                        value: character.abilityScores.intelligence,
                        modifier: character.modifiers.intelligence,
                        onDecrement: () => _adjustAbility('intelligence', -1),
                        onIncrement: () => _adjustAbility('intelligence', 1),
                      ),
                      AttributeCard(
                        abbreviation: 'WIS',
                        name: 'Wisdom',
                        value: character.abilityScores.wisdom,
                        modifier: character.modifiers.wisdom,
                        onDecrement: () => _adjustAbility('wisdom', -1),
                        onIncrement: () => _adjustAbility('wisdom', 1),
                      ),
                      AttributeCard(
                        abbreviation: 'CHA',
                        name: 'Charisma',
                        value: character.abilityScores.charisma,
                        modifier: character.modifiers.charisma,
                        onDecrement: () => _adjustAbility('charisma', -1),
                        onIncrement: () => _adjustAbility('charisma', 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SkillsCard(controller: controller),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    title: 'Saving Throws',
                    icon: Icons.shield_outlined,
                  ),
                  const SizedBox(height: 12),
                  SavingThrowGrid(
                    character: character,
                    onCharacterUpdated: (updated) {
                      controller.updateManual((_) => updated);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (controller.isResolving) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Refreshing compendium-backed build selections and derived features...',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _adjustAbility(String ability, int delta) {
    final character = controller.character!;
    final scores = character.abilityScores;
    final next = switch (ability) {
      'strength' => scores.copyWith(
        strength: (scores.strength + delta).clamp(1, 30),
      ),
      'dexterity' => scores.copyWith(
        dexterity: (scores.dexterity + delta).clamp(1, 30),
      ),
      'constitution' => scores.copyWith(
        constitution: (scores.constitution + delta).clamp(1, 30),
      ),
      'intelligence' => scores.copyWith(
        intelligence: (scores.intelligence + delta).clamp(1, 30),
      ),
      'wisdom' => scores.copyWith(wisdom: (scores.wisdom + delta).clamp(1, 30)),
      _ => scores.copyWith(charisma: (scores.charisma + delta).clamp(1, 30)),
    };
    controller.updateManual((current) => current.copyWith(abilityScores: next));
  }
}

class _CharacterIdentityCard extends StatelessWidget {
  final CharacterEditorController controller;

  const _CharacterIdentityCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final rulesets = controller.installedRulesets;
    final selectedRulesetId = character.primaryRulesetId.trim().isEmpty
        ? (rulesets.isEmpty ? null : rulesets.first.id)
        : character.primaryRulesetId;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              title: 'Character Basics',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: character.name,
              decoration: const InputDecoration(
                labelText: 'Character name',
                border: OutlineInputBorder(),
              ),
              onChanged: controller.setName,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedRulesetId,
              decoration: const InputDecoration(
                labelText: 'Primary ruleset',
                border: OutlineInputBorder(),
              ),
              items: rulesets
                  .map(
                    (ruleset) => DropdownMenuItem<String>(
                      value: ruleset.id,
                      child: Text(ruleset.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: rulesets.isEmpty
                  ? null
                  : (value) async {
                      if (value == null ||
                          value == character.primaryRulesetId) {
                        return;
                      }
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Change Primary Ruleset'),
                          content: const Text(
                            'Changing the primary ruleset keeps manual notes and stats, but any class, race, background, or spell selections that no longer resolve will be cleared.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Change'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await controller.changePrimaryRuleset(value);
                      }
                    },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<MoralAlignment>(
              initialValue: character.moralAlignment,
              decoration: const InputDecoration(
                labelText: 'Alignment',
                border: OutlineInputBorder(),
              ),
              items: MoralAlignment.values
                  .map(
                    (alignment) => DropdownMenuItem<MoralAlignment>(
                      value: alignment,
                      child: Text(alignment.displayName),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                controller.updateManual(
                  (current) => current.copyWith(moralAlignment: value),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildSelectionsCard extends StatelessWidget {
  final CharacterEditorController controller;

  const _BuildSelectionsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              title: 'Build Selections',
              icon: Icons.auto_stories_outlined,
            ),
            const SizedBox(height: 16),
            _SelectionTile(
              title: 'Race',
              value: character.raceRef?.displayName ?? 'Choose a race',
              icon: Icons.people_outline,
              onTap: () => _pickRace(context),
              onClear: character.raceRef == null
                  ? null
                  : () => controller.setRace(null),
            ),
            if (character.raceRef != null) ...[
              const SizedBox(height: 12),
              CharacterEntitySummaryCard(
                title: 'Selected Race',
                reference: character.raceRef,
                service: controller.compendium,
              ),
            ],
            const SizedBox(height: 12),
            _SelectionTile(
              title: 'Background',
              value:
                  character.backgroundRef?.displayName ?? 'Choose a background',
              icon: Icons.work_outline,
              onTap: () => _pickBackground(context),
              onClear: character.backgroundRef == null
                  ? null
                  : () => controller.setBackground(null),
            ),
            if (character.backgroundRef != null) ...[
              const SizedBox(height: 12),
              CharacterEntitySummaryCard(
                title: 'Selected Background',
                reference: character.backgroundRef,
                service: controller.compendium,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Classes', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: controller.addClassEntry,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Class'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (character.classes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No classes selected yet.'),
              ),
            ...character.classes.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ClassEntryCard(
                  controller: controller,
                  index: entry.key,
                  entry: entry.value,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _pickRace(BuildContext context) async {
    final result = await showCharacterCompendiumPicker(
      context,
      service: controller.compendium,
      installedRulesets: controller.installedRulesets,
      primaryRulesetId: controller.character!.primaryRulesetId,
      entityTypes: const ['race'],
      title: 'Choose Race',
    );
    if (result != null) {
      await controller.setRace(result.ref);
    }
  }

  Future<void> _pickBackground(BuildContext context) async {
    final result = await showCharacterCompendiumPicker(
      context,
      service: controller.compendium,
      installedRulesets: controller.installedRulesets,
      primaryRulesetId: controller.character!.primaryRulesetId,
      entityTypes: const ['background'],
      title: 'Choose Background',
    );
    if (result != null) {
      await controller.setBackground(result.ref);
    }
  }
}

class _ClassEntryCard extends StatelessWidget {
  final CharacterEditorController controller;
  final int index;
  final CharacterClassLevel entry;

  const _ClassEntryCard({
    required this.controller,
    required this.index,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final canRemove = controller.character!.classes.length > 1;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Class ${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (canRemove)
                  IconButton(
                    tooltip: 'Remove class',
                    onPressed: () => controller.removeClassEntry(index),
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _SelectionTile(
              title: 'Class',
              value: entry.classRef?.displayName ?? 'Choose a class',
              icon: Icons.class_outlined,
              onTap: () => _pickClass(context),
            ),
            const SizedBox(height: 8),
            _SelectionTile(
              title: 'Subclass',
              value: entry.subclassRef?.displayName ?? 'Choose a subclass',
              icon: Icons.account_tree_outlined,
              onTap: entry.classRef == null
                  ? null
                  : () => _pickSubclass(context),
              onClear: entry.subclassRef == null
                  ? null
                  : () => controller.setClassEntry(
                      index,
                      classRef: entry.classRef,
                      clearSubclass: true,
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Level', style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                IconButton(
                  onPressed: entry.level <= 1
                      ? null
                      : () => controller.setClassEntry(
                          index,
                          classRef: entry.classRef,
                          subclassRef: entry.subclassRef,
                          level: entry.level - 1,
                        ),
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  '${entry.level}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: entry.level >= 20
                      ? null
                      : () => controller.setClassEntry(
                          index,
                          classRef: entry.classRef,
                          subclassRef: entry.subclassRef,
                          level: entry.level + 1,
                        ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (entry.classRef != null) ...[
              const SizedBox(height: 8),
              CharacterEntitySummaryCard(
                title: 'Selected Class',
                reference: entry.classRef,
                service: controller.compendium,
              ),
            ],
            if (entry.subclassRef != null) ...[
              const SizedBox(height: 8),
              CharacterEntitySummaryCard(
                title: 'Selected Subclass',
                reference: entry.subclassRef,
                service: controller.compendium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickClass(BuildContext context) async {
    final result = await showCharacterCompendiumPicker(
      context,
      service: controller.compendium,
      installedRulesets: controller.installedRulesets,
      primaryRulesetId: controller.character!.primaryRulesetId,
      entityTypes: const ['class'],
      title: 'Choose Class',
    );
    if (result != null) {
      await controller.setClassEntry(
        index,
        classRef: result.ref,
        clearSubclass: true,
        level: entry.level,
      );
    }
  }

  Future<void> _pickSubclass(BuildContext context) async {
    final classRef = entry.classRef;
    if (classRef == null) {
      return;
    }

    final result = await showCharacterCompendiumPicker(
      context,
      service: controller.compendium,
      installedRulesets: controller.installedRulesets,
      primaryRulesetId: controller.character!.primaryRulesetId,
      entityTypes: const ['subclass'],
      classNameForSubclasses: classRef.displayName,
      title: 'Choose Subclass',
    );
    if (result != null) {
      await controller.setClassEntry(
        index,
        classRef: classRef,
        subclassRef: result.ref,
        level: entry.level,
      );
    }
  }
}

class _SkillsCard extends StatelessWidget {
  final CharacterEditorController controller;

  const _SkillsCard({required this.controller});

  static const List<(Skill, String, String)> _skillRows = [
    (Skill.acrobatics, 'Acrobatics', 'DEX'),
    (Skill.animalHandling, 'Animal Handling', 'WIS'),
    (Skill.arcana, 'Arcana', 'INT'),
    (Skill.athletics, 'Athletics', 'STR'),
    (Skill.deception, 'Deception', 'CHA'),
    (Skill.history, 'History', 'INT'),
    (Skill.insight, 'Insight', 'WIS'),
    (Skill.intimidation, 'Intimidation', 'CHA'),
    (Skill.investigation, 'Investigation', 'INT'),
    (Skill.medicine, 'Medicine', 'WIS'),
    (Skill.nature, 'Nature', 'INT'),
    (Skill.perception, 'Perception', 'WIS'),
    (Skill.performance, 'Performance', 'CHA'),
    (Skill.persuasion, 'Persuasion', 'CHA'),
    (Skill.religion, 'Religion', 'INT'),
    (Skill.sleightOfHand, 'Sleight of Hand', 'DEX'),
    (Skill.stealth, 'Stealth', 'DEX'),
    (Skill.survival, 'Survival', 'WIS'),
  ];

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              title: 'Skills',
              icon: Icons.psychology_outlined,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _skillRows.length,
              itemBuilder: (context, index) {
                final row = _skillRows[index];
                final skill = row.$1;
                final proficiency =
                    character.proficiencies.skills.proficiencies[skill] ??
                    ProficiencyLevel.none;
                final modifier = character.proficiencies.skills.getModifier(
                  skill,
                  character.modifiers,
                  character.proficiencies.proficiencyBonus,
                );

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _cycleSkill(skill, proficiency),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: proficiency == ProficiencyLevel.none
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
                                row.$2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                row.$3,
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
                            Text(switch (proficiency) {
                              ProficiencyLevel.none => 'None',
                              ProficiencyLevel.proficient => 'Prof.',
                              ProficiencyLevel.expert => 'Expert',
                              ProficiencyLevel.jackOfAllTrades => 'Half',
                            }, style: Theme.of(context).textTheme.labelSmall),
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

  void _cycleSkill(Skill skill, ProficiencyLevel current) {
    final next = switch (current) {
      ProficiencyLevel.none => ProficiencyLevel.proficient,
      ProficiencyLevel.proficient => ProficiencyLevel.expert,
      ProficiencyLevel.expert => ProficiencyLevel.none,
      ProficiencyLevel.jackOfAllTrades => ProficiencyLevel.none,
    };

    controller.updateManual((character) {
      final proficiencies = Map<Skill, ProficiencyLevel>.from(
        character.proficiencies.skills.proficiencies,
      );
      proficiencies[skill] = next;
      return character.copyWith(
        proficiencies: character.proficiencies.copyWith(
          skills: character.proficiencies.skills.copyWith(
            proficiencies: proficiencies,
          ),
        ),
      );
    });
  }
}

class _SelectionTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  const _SelectionTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onClear != null)
              IconButton(
                tooltip: 'Clear selection',
                onPressed: onClear,
                icon: const Icon(Icons.clear),
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
