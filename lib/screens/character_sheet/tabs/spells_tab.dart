import 'package:flutter/material.dart';
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
                        Chip(
                          label: Text(
                            'Ability: ${spellcasting.spellcastingAbility!.toUpperCase()}',
                          ),
                        ),
                      Chip(
                        label: Text(
                          'Spell Save DC: ${spellcasting.spellSaveDC}',
                        ),
                      ),
                      Chip(
                        label: Text(
                          'Attack Bonus: +${spellcasting.spellAttackBonus}',
                        ),
                      ),
                      if (controller.resolvedBuild.preparedSpellCapacity !=
                          null)
                        Chip(
                          label: Text(
                            'Prepared Capacity: ${controller.resolvedBuild.preparedSpellCapacity}',
                          ),
                        ),
                      if (controller.resolvedBuild.knownSpellCapacity != null)
                        Chip(
                          label: Text(
                            'Known Capacity: ${controller.resolvedBuild.knownSpellCapacity}',
                          ),
                        ),
                      if (controller.resolvedBuild.cantripCapacity != null)
                        Chip(
                          label: Text(
                            'Cantrips: ${controller.resolvedBuild.cantripCapacity}',
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
          onRemove: (spell) => controller.removeSpell(spell.id, prepared: true),
          onTogglePrepared: (spell, prepared) =>
              controller.togglePreparedSpell(spell, prepared),
        ),
        const SizedBox(height: 16),
        _SpellSection(
          title: 'Known Spells',
          emptyLabel: 'No known spells yet.',
          spells: spellcasting?.knownSpells ?? const <Spell>[],
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
  final ValueChanged<Spell> onRemove;
  final Future<void> Function(Spell spell, bool prepared) onTogglePrepared;

  const _SpellSection({
    required this.title,
    required this.emptyLabel,
    required this.spells,
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
              ...spells.map(
                (spell) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SpellRow(
                    spell: spell,
                    onRemove: () => onRemove(spell),
                    onTogglePrepared: (prepared) =>
                        onTogglePrepared(spell, prepared),
                  ),
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
  final VoidCallback onRemove;
  final Future<void> Function(bool prepared) onTogglePrepared;

  const _SpellRow({
    required this.spell,
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
        title: Text(spell.name),
        subtitle: Text(
          [
            if (spell.school.trim().isNotEmpty) spell.school,
            if (spell.isRitual) 'Ritual',
            if (spell.isConcentration) 'Concentration',
          ].join(' • '),
        ),
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
