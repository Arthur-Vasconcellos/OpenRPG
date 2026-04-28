import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/character_compendium_picker.dart';
import 'package:openrpg/screens/character_sheet/widget/spell_slots_widget.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';

class SpellsTab extends StatelessWidget {
  final CharacterEditorController controller;

  const SpellsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final spellcasting = character.spellcasting;
    final hasSpellcasting =
        spellcasting != null &&
        (controller.resolvedBuild.hasSpellcasting ||
            spellcasting.preparedSpells.isNotEmpty ||
            spellcasting.knownSpells.isNotEmpty);
    final unresolvedSpellCount = spellcasting == null
        ? 0
        : spellcasting.allSpells
              .where(
                (spell) =>
                    spell.reference != null && !spell.reference!.isResolved,
              )
              .length;
    final rulesetNames = {
      for (final ruleset in controller.installedRulesets)
        ruleset.id: ruleset.name,
    };

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
                  'Spells',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  hasSpellcasting
                      ? 'Add known or prepared spells from installed rulesets, then preview them or drill into linked references.'
                      : 'This build does not currently resolve to a spellcasting profile, but you can still add spell references manually if you need them.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        '${spellcasting?.preparedSpells.length ?? 0} prepared',
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${spellcasting?.knownSpells.length ?? 0} known',
                      ),
                    ),
                    if (unresolvedSpellCount > 0)
                      Chip(
                        label: Text('$unresolvedSpellCount unresolved refs'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => _pickSpell(context, prepared: true),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Prepared Spell'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => _pickSpell(context, prepared: false),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Known Spell'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (spellcasting != null) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spellcasting Summary',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (spellcasting.spellcastingAbility != null)
                        Tooltip(
                          message:
                              'The resolved spellcasting ability for the current build.',
                          child: Chip(
                            label: Text(
                              'Ability: ${spellcasting.spellcastingAbility!.toUpperCase()}',
                            ),
                          ),
                        ),
                      Tooltip(
                        message:
                            'The current spell save DC after the resolved build and manual character stats are applied.',
                        child: Chip(
                          label: Text(
                            'Spell Save DC: ${spellcasting.spellSaveDC}',
                          ),
                        ),
                      ),
                      Tooltip(
                        message:
                            'The current spell attack bonus after the resolved build and manual character stats are applied.',
                        child: Chip(
                          label: Text(
                            'Attack Bonus: +${spellcasting.spellAttackBonus}',
                          ),
                        ),
                      ),
                      if (controller.resolvedBuild.preparedSpellCapacity !=
                          null)
                        Tooltip(
                          message:
                              'How many prepared spells the current compendium-backed build expects.',
                          child: Chip(
                            label: Text(
                              'Prepared Capacity: ${controller.resolvedBuild.preparedSpellCapacity}',
                            ),
                          ),
                        ),
                      if (controller.resolvedBuild.knownSpellCapacity != null)
                        Tooltip(
                          message:
                              'How many known spells the current compendium-backed build expects.',
                          child: Chip(
                            label: Text(
                              'Known Capacity: ${controller.resolvedBuild.knownSpellCapacity}',
                            ),
                          ),
                        ),
                      if (controller.resolvedBuild.cantripCapacity != null)
                        Tooltip(
                          message:
                              'How many cantrips the current compendium-backed build expects.',
                          child: Chip(
                            label: Text(
                              'Cantrips: ${controller.resolvedBuild.cantripCapacity}',
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SpellSlotsWidget(spellcasting: spellcasting),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        _SpellSection(
          title: 'Prepared Spells',
          emptyLabel: 'No prepared spells yet.',
          spells: spellcasting?.preparedSpells ?? const <Spell>[],
          browseRepository: controller.compendium.browseRepository,
          rulesetNames: rulesetNames,
          onRemove: (spell) => controller.removeSpell(spell.id, prepared: true),
          onTogglePrepared: (spell, prepared) =>
              controller.togglePreparedSpell(spell, prepared),
        ),
        const SizedBox(height: 16),
        _SpellSection(
          title: 'Known Spells',
          emptyLabel: 'No known spells yet.',
          spells: spellcasting?.knownSpells ?? const <Spell>[],
          browseRepository: controller.compendium.browseRepository,
          rulesetNames: rulesetNames,
          onRemove: (spell) =>
              controller.removeSpell(spell.id, prepared: false),
          onTogglePrepared: (spell, prepared) =>
              controller.togglePreparedSpell(spell, prepared),
        ),
      ],
    );
  }

  Future<void> _pickSpell(
    BuildContext context, {
    required bool prepared,
  }) async {
    final result = await showCharacterCompendiumPicker(
      context,
      service: controller.compendium,
      installedRulesets: controller.installedRulesets,
      primaryRulesetId: controller.character!.primaryRulesetId,
      entityTypes: const ['spell'],
      title: prepared ? 'Choose Prepared Spell' : 'Choose Known Spell',
    );
    if (result != null) {
      await controller.addSpellSelection(result.ref, prepared: prepared);
    }
  }
}

class _SpellSection extends StatelessWidget {
  final String title;
  final String emptyLabel;
  final List<Spell> spells;
  final CompendiumBrowseRepository browseRepository;
  final Map<String, String> rulesetNames;
  final ValueChanged<Spell> onRemove;
  final Future<void> Function(Spell spell, bool prepared) onTogglePrepared;

  const _SpellSection({
    required this.title,
    required this.emptyLabel,
    required this.spells,
    required this.browseRepository,
    required this.rulesetNames,
    required this.onRemove,
    required this.onTogglePrepared,
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
            if (spells.isEmpty)
              Text(emptyLabel, style: Theme.of(context).textTheme.bodyMedium)
            else
              ..._groupSpellsByLevel(spells).entries.map(
                (group) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.key == 0 ? 'Cantrips' : 'Level ${group.key}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 10),
                    ...group.value.map(
                      (spell) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SpellRow(
                          spell: spell,
                          browseRepository: browseRepository,
                          rulesetLabel: spell.reference == null
                              ? null
                              : rulesetNames[spell.reference!.rulesetId],
                          onRemove: () => onRemove(spell),
                          onTogglePrepared: (prepared) =>
                              onTogglePrepared(spell, prepared),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SpellRow extends StatelessWidget {
  final Spell spell;
  final CompendiumBrowseRepository browseRepository;
  final String? rulesetLabel;
  final VoidCallback onRemove;
  final Future<void> Function(bool prepared) onTogglePrepared;

  const _SpellRow({
    required this.spell,
    required this.browseRepository,
    required this.rulesetLabel,
    required this.onRemove,
    required this.onTogglePrepared,
  });

  @override
  Widget build(BuildContext context) {
    final ref = spell.reference;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(spell.level == 0 ? 'C' : '${spell.level}'),
        ),
        title: ref == null
            ? Text(spell.name)
            : CompendiumReferenceAnchor(
                rulesetId: ref.rulesetId,
                entityType: ref.entityType,
                entityId: ref.entityId,
                entityName: ref.displayName,
                browseRepository: browseRepository,
                onTap: () {
                  showCompendiumEntityPreviewSurface(
                    context,
                    rulesetId: ref.rulesetId,
                    entityType: ref.entityType,
                    entityId: ref.entityId,
                    browseRepository: browseRepository,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(spell.name),
                ),
              ),
        subtitle: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (rulesetLabel != null)
              Chip(
                label: Text(rulesetLabel!),
                visualDensity: VisualDensity.compact,
              ),
            if (spell.school.trim().isNotEmpty)
              Tooltip(
                message: 'Spell school',
                child: Chip(
                  label: Text(spell.school),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            if (spell.isRitual)
              Tooltip(
                message: 'Can be cast as a ritual when allowed.',
                child: const Chip(
                  label: Text('Ritual'),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            if (spell.isConcentration)
              Tooltip(
                message: 'Requires concentration while active.',
                child: const Chip(
                  label: Text('Concentration'),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        onTap: ref == null
            ? null
            : () {
                showCompendiumEntityPreviewSurface(
                  context,
                  rulesetId: ref.rulesetId,
                  entityType: ref.entityType,
                  entityId: ref.entityId,
                  browseRepository: browseRepository,
                );
              },
        trailing: Wrap(
          spacing: 4,
          children: [
            if (ref != null)
              IconButton(
                tooltip: 'Preview',
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () {
                  showCompendiumEntityPreviewSurface(
                    context,
                    rulesetId: ref.rulesetId,
                    entityType: ref.entityType,
                    entityId: ref.entityId,
                    browseRepository: browseRepository,
                  );
                },
              ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'prepare':
                    onTogglePrepared(true);
                    break;
                  case 'unprepare':
                    onTogglePrepared(false);
                    break;
                  case 'remove':
                    onRemove();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'prepare',
                  child: Text('Add to prepared spells'),
                ),
                const PopupMenuItem(
                  value: 'unprepare',
                  child: Text('Remove from prepared spells'),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove from this list'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Map<int, List<Spell>> _groupSpellsByLevel(List<Spell> spells) {
  final grouped = <int, List<Spell>>{};
  final sorted = List<Spell>.from(spells)
    ..sort((left, right) {
      final levelOrder = left.level.compareTo(right.level);
      if (levelOrder != 0) {
        return levelOrder;
      }
      return left.name.compareTo(right.name);
    });
  for (final spell in sorted) {
    grouped.putIfAbsent(spell.level, () => <Spell>[]).add(spell);
  }
  return grouped;
}
