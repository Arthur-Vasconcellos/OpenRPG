import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/ability_score_grid.dart';
import 'package:openrpg/screens/character_sheet/widget/build_selection_card.dart';
import 'package:openrpg/screens/character_sheet/widget/character_compendium_picker.dart';
import 'package:openrpg/screens/character_sheet/widget/class_entry_card.dart';
import 'package:openrpg/screens/character_sheet/widget/saving_throw_grid.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';

class CoreTab extends StatelessWidget {
  final CharacterEditorController controller;

  const CoreTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final schema = controller.sheetSchema;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CharacterIdentityCard(controller: controller),
          const SizedBox(height: 16),
          _BuildHealthCard(controller: controller),
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
                  AbilityScoreGrid(
                    controller: controller,
                    abilities: schema.abilities,
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
                    controller: controller,
                    abilities: schema.abilities,
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
            TextFormField(
              initialValue: character.alignment,
              decoration: const InputDecoration(
                labelText: 'Alignment',
                border: OutlineInputBorder(),
              ),
              onChanged: controller.setAlignment,
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
            BuildSelectionCard(
              title: 'Race',
              icon: Icons.people_outline,
              reference: character.raceRef,
              service: controller.compendium,
              emptyLabel: 'No race selected yet.',
              helperText:
                  'Race drives ancestry traits, movement, proficiencies, and other derived features.',
              onSelect: () => _pickRace(context),
              onClear: character.raceRef == null
                  ? null
                  : () => controller.setRace(null),
              selectLabel: character.raceRef == null ? 'Choose Race' : 'Change',
            ),
            const SizedBox(height: 12),
            BuildSelectionCard(
              title: 'Background',
              icon: Icons.work_outline,
              reference: character.backgroundRef,
              service: controller.compendium,
              emptyLabel: 'No background selected yet.',
              helperText:
                  'Background contributes proficiencies, starting flavor, and compendium-linked notes.',
              onSelect: () => _pickBackground(context),
              onClear: character.backgroundRef == null
                  ? null
                  : () => controller.setBackground(null),
              selectLabel: character.backgroundRef == null
                  ? 'Choose Background'
                  : 'Change',
            ),
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
                child: ClassEntryCard(
                  controller: controller,
                  index: entry.key,
                  entry: entry.value,
                  canRemove: character.classes.length > 1,
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

class _SkillsCard extends StatelessWidget {
  final CharacterEditorController controller;

  const _SkillsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final colorScheme = Theme.of(context).colorScheme;
    final skills = controller.sheetSchema.skills;
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

class _BuildHealthCard extends StatelessWidget {
  final CharacterEditorController controller;

  const _BuildHealthCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final previewController = CompendiumPreviewControllerScope.maybeOf(context);
    final unresolvedSelections = controller.unresolvedSelectionCount;
    final hasWidePreviewLayout = MediaQuery.sizeOf(context).width >= 720;
    final trackedSpellCount =
        (character.spellcasting?.preparedSpells.length ?? 0) +
        (character.spellcasting?.knownSpells.length ?? 0);
    final compendiumEquipmentCount = character.equipment.entries
        .where((entry) => entry.reference != null)
        .length;
    final rulesetInstalled =
        character.primaryRulesetId.trim().isNotEmpty &&
        controller.installedRulesets.any(
          (ruleset) => ruleset.id == character.primaryRulesetId,
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              title: 'Build Health',
              icon: Icons.health_and_safety_outlined,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    unresolvedSelections == 0
                        ? 'All selections resolved'
                        : '$unresolvedSelections unresolved',
                  ),
                ),
                Chip(
                  label: Text(
                    '${controller.resolvedBuild.allFeatures.length} derived features',
                  ),
                ),
                Chip(
                  label: Text(
                    trackedSpellCount == 0
                        ? 'No tracked spells'
                        : '$trackedSpellCount tracked spells',
                  ),
                ),
                Chip(
                  label: Text(
                    compendiumEquipmentCount == 0
                        ? 'No linked equipment'
                        : '$compendiumEquipmentCount linked equipment',
                  ),
                ),
                Chip(
                  label: Text(
                    rulesetInstalled
                        ? 'Ruleset installed'
                        : character.primaryRulesetId.trim().isEmpty
                        ? 'No primary ruleset'
                        : 'Ruleset missing',
                  ),
                ),
                if (hasWidePreviewLayout)
                  Chip(
                    label: Text(
                      previewController?.hasPinnedPreview == true
                          ? 'Preview rail pinned'
                          : 'Preview rail available',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              unresolvedSelections == 0
                  ? 'Every current core selection resolves cleanly against the installed compendium, so combat, features, and spells can derive from a stable build.'
                  : 'Resolve the highlighted selections below to restore full compendium-backed derivation for combat, features, notes, and spells.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (hasWidePreviewLayout) ...[
              const SizedBox(height: 8),
              Text(
                previewController?.hasPinnedPreview == true
                    ? 'The pinned preview rail is active on this layout, so nested reference browsing stays visible while you edit the build.'
                    : 'On wider layouts, previewing a compendium-backed name can stay pinned beside the character sheet for quick comparison.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
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
