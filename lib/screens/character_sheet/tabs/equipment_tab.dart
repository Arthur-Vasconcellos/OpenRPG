import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/character_compendium_picker.dart';
import 'package:openrpg/screens/character_sheet/widget/currency_display.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';

class EquipmentTab extends StatelessWidget {
  final CharacterEditorController controller;

  const EquipmentTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final entries = character.equipment.entries;
    final armorOptions = entries
        .where((entry) => entry.kind == CharacterInventoryKind.armor)
        .toList(growable: false);
    final weaponOptions = entries
        .where((entry) => entry.kind == CharacterInventoryKind.weapon)
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _InventorySummaryCard(
          character: character,
          onAddFromCompendium: () => _pickCompendiumItem(context),
        ),
        const SizedBox(height: 20),
        _LoadoutCard(
          controller: controller,
          armorOptions: armorOptions,
          weaponOptions: weaponOptions,
        ),
        const SizedBox(height: 20),
        _InventoryEntriesCard(controller: controller, entries: entries),
        const SizedBox(height: 20),
        _TreasureCard(wealth: character.wealth),
        const SizedBox(height: 32),
      ],
    );
  }

  Future<void> _pickCompendiumItem(BuildContext context) async {
    final primaryRulesetId = controller.character?.primaryRulesetId ?? '';
    if (primaryRulesetId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Choose a primary ruleset first so inventory items can come from the compendium.',
          ),
        ),
      );
      return;
    }

    final result = await showCharacterCompendiumPicker(
      context,
      service: controller.compendium,
      installedRulesets: controller.installedRulesets,
      primaryRulesetId: primaryRulesetId,
      entityTypes: const ['item'],
      title: 'Add Inventory Item',
    );
    if (result != null) {
      await controller.addInventoryItem(result.ref);
    }
  }
}

class _InventorySummaryCard extends StatelessWidget {
  final Character character;
  final VoidCallback onAddFromCompendium;

  const _InventorySummaryCard({
    required this.character,
    required this.onAddFromCompendium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final equippedCount = character.equipment.entries
        .where((entry) => entry.equipped)
        .length;
    final attunedCount = character.equipment.entries
        .where((entry) => entry.attuned)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.backpack_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'INVENTORY',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: onAddFromCompendium,
                  icon: const Icon(Icons.add),
                  label: const Text('Add From Compendium'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Inventory now drives equipment choices and combat loadout. Add items from the compendium, mark them equipped or attuned, and assign them into your active armor and weapon slots.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    '${character.equipment.entries.length} inventory entr${character.equipment.entries.length == 1 ? 'y' : 'ies'}',
                  ),
                ),
                Chip(label: Text('$equippedCount equipped')),
                Chip(label: Text('$attunedCount attuned')),
                Chip(
                  label: Text(
                    'Tracked weight ${character.equipment.effectiveTotalWeight.toStringAsFixed(1)} lb',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadoutCard extends StatelessWidget {
  final CharacterEditorController controller;
  final List<CharacterInventoryEntry> armorOptions;
  final List<CharacterInventoryEntry> weaponOptions;

  const _LoadoutCard({
    required this.controller,
    required this.armorOptions,
    required this.weaponOptions,
  });

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final loadout = character.equipment.loadout;
    final armorEntry = _findById(armorOptions, loadout.armorEntryId);
    final meleeEntry = _findById(weaponOptions, loadout.meleeEntryId);
    final rangedEntry = _findById(weaponOptions, loadout.rangedEntryId);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'EQUIPPED LOADOUT',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Choose which inventory entries are currently driving your armor class and your melee and ranged combat expectations.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _LoadoutSelector(
              label: 'Armor',
              icon: Icons.shield_outlined,
              entries: armorOptions,
              selectedEntryId: loadout.armorEntryId,
              onChanged: (value) => controller.setEquipmentLoadout(
                armorEntryId: value,
                clearArmor: value == null,
              ),
            ),
            const SizedBox(height: 12),
            _LoadoutSelector(
              label: 'Melee Weapon',
              icon: Icons.gavel_outlined,
              entries: weaponOptions,
              selectedEntryId: loadout.meleeEntryId,
              onChanged: (value) => controller.setEquipmentLoadout(
                meleeEntryId: value,
                clearMelee: value == null,
              ),
            ),
            const SizedBox(height: 12),
            _LoadoutSelector(
              label: 'Ranged Weapon',
              icon: Icons.ads_click_outlined,
              entries: weaponOptions,
              selectedEntryId: loadout.rangedEntryId,
              onChanged: (value) => controller.setEquipmentLoadout(
                rangedEntryId: value,
                clearRanged: value == null,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _SelectedLoadoutEntryCard(
                  title: 'Armor Slot',
                  entry: armorEntry,
                  browseRepository: controller.compendium.browseRepository,
                ),
                _SelectedLoadoutEntryCard(
                  title: 'Melee Slot',
                  entry: meleeEntry,
                  browseRepository: controller.compendium.browseRepository,
                ),
                _SelectedLoadoutEntryCard(
                  title: 'Ranged Slot',
                  entry: rangedEntry,
                  browseRepository: controller.compendium.browseRepository,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CharacterInventoryEntry? _findById(
    List<CharacterInventoryEntry> entries,
    String? id,
  ) {
    if (id == null) {
      return null;
    }
    for (final entry in entries) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }
}

class _LoadoutSelector extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<CharacterInventoryEntry> entries;
  final String? selectedEntryId;
  final ValueChanged<String?> onChanged;

  const _LoadoutSelector({
    required this.label,
    required this.icon,
    required this.entries,
    required this.selectedEntryId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      initialValue: selectedEntryId,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('None')),
        ...entries.map(
          (entry) => DropdownMenuItem<String?>(
            value: entry.id,
            child: Text(entry.displayName),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

class _SelectedLoadoutEntryCard extends StatelessWidget {
  final String title;
  final CharacterInventoryEntry? entry;
  final CompendiumBrowseRepository browseRepository;

  const _SelectedLoadoutEntryCard({
    required this.title,
    required this.entry,
    required this.browseRepository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedEntry = entry;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          if (selectedEntry == null)
            Text(
              'No selection yet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            _InventoryEntryLabel(
              entry: selectedEntry,
              browseRepository: browseRepository,
            ),
        ],
      ),
    );
  }
}

class _InventoryEntriesCard extends StatelessWidget {
  final CharacterEditorController controller;
  final List<CharacterInventoryEntry> entries;

  const _InventoryEntriesCard({
    required this.controller,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inventory Entries', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Every entry can preview its compendium source, track quantity and attunement, and be assigned into the active loadout.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (entries.isEmpty)
              Text(
                'No inventory entries yet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _InventoryEntryTile(
                    controller: controller,
                    entry: entry,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InventoryEntryTile extends StatelessWidget {
  final CharacterEditorController controller;
  final CharacterInventoryEntry entry;

  const _InventoryEntryTile({required this.controller, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loadout = controller.character!.equipment.loadout;
    final unresolvedSource =
        entry.reference != null && !entry.reference!.isResolved;
    final isArmorSlot = loadout.armorEntryId == entry.id;
    final isMeleeSlot = loadout.meleeEntryId == entry.id;
    final isRangedSlot = loadout.rangedEntryId == entry.id;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: entry.equipped,
                  onChanged: (value) =>
                      controller.toggleInventoryItem(entry.id, value ?? false),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InventoryEntryLabel(
                        entry: entry,
                        browseRepository:
                            controller.compendium.browseRepository,
                      ),
                      const SizedBox(height: 6),
                      if (entry.description.trim().isNotEmpty)
                        Text(
                          entry.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'preview':
                        final ref = entry.reference;
                        if (ref != null) {
                          await showCompendiumEntityPreviewSurface(
                            context,
                            rulesetId: ref.rulesetId,
                            entityType: ref.entityType,
                            entityId: ref.entityId,
                            entityName: ref.displayName,
                            browseRepository:
                                controller.compendium.browseRepository,
                          );
                        }
                        break;
                      case 'melee':
                        await controller.setEquipmentLoadout(
                          meleeEntryId: entry.id,
                        );
                        break;
                      case 'ranged':
                        await controller.setEquipmentLoadout(
                          rangedEntryId: entry.id,
                        );
                        break;
                      case 'armor':
                        await controller.setEquipmentLoadout(
                          armorEntryId: entry.id,
                        );
                        break;
                      case 'notes':
                        await _editNotes(context);
                        break;
                      case 'remove':
                        await controller.removeInventoryItem(entry.id);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (entry.reference != null)
                      const PopupMenuItem<String>(
                        value: 'preview',
                        child: Text('Preview'),
                      ),
                    if (entry.kind == CharacterInventoryKind.weapon)
                      const PopupMenuItem<String>(
                        value: 'melee',
                        child: Text('Use as melee slot'),
                      ),
                    if (entry.kind == CharacterInventoryKind.weapon)
                      const PopupMenuItem<String>(
                        value: 'ranged',
                        child: Text('Use as ranged slot'),
                      ),
                    if (entry.kind == CharacterInventoryKind.armor)
                      const PopupMenuItem<String>(
                        value: 'armor',
                        child: Text('Use as armor slot'),
                      ),
                    const PopupMenuItem<String>(
                      value: 'notes',
                      child: Text('Edit notes'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'remove',
                      child: Text('Remove from inventory'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CompendiumTypeBadge(entityType: _kindLabel(entry.kind)),
                Chip(
                  label: Text(
                    'Qty ${entry.quantity} | ${entry.weight.toStringAsFixed(1)} lb',
                  ),
                ),
                if (entry.attuned) const Chip(label: Text('Attuned')),
                if (entry.equipped) const Chip(label: Text('Equipped')),
                if (isArmorSlot) const Chip(label: Text('Armor Slot')),
                if (isMeleeSlot) const Chip(label: Text('Melee Slot')),
                if (isRangedSlot) const Chip(label: Text('Ranged Slot')),
                if (unresolvedSource)
                  const Chip(label: Text('Unresolved Source')),
              ],
            ),
            if (unresolvedSource) ...[
              const SizedBox(height: 8),
              Text(
                'This saved item no longer resolves in the installed compendium. Replace or remove it to keep previews and loadout-derived combat accurate.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
            if (entry.notes.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                entry.notes,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => controller.updateInventoryEntryQuantity(
                    entry.id,
                    entry.quantity - 1,
                  ),
                  icon: const Icon(Icons.remove),
                  label: const Text('Less'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () => controller.updateInventoryEntryQuantity(
                    entry.id,
                    entry.quantity + 1,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('More'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Attuned'),
                  selected: entry.attuned,
                  onSelected: (value) =>
                      controller.setInventoryEntryAttuned(entry.id, value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editNotes(BuildContext context) async {
    final notesController = TextEditingController(text: entry.notes);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Inventory Notes'),
        content: TextField(
          controller: notesController,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText:
                'Charges used, condition, custom nickname, or table notes',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved == true) {
      await controller.setInventoryEntryNotes(entry.id, notesController.text);
    }
  }

  String _kindLabel(CharacterInventoryKind kind) {
    switch (kind) {
      case CharacterInventoryKind.weapon:
        return 'weapon';
      case CharacterInventoryKind.armor:
        return 'armor';
      case CharacterInventoryKind.other:
        return 'item';
    }
  }
}

class _InventoryEntryLabel extends StatelessWidget {
  final CharacterInventoryEntry entry;
  final CompendiumBrowseRepository browseRepository;

  const _InventoryEntryLabel({
    required this.entry,
    required this.browseRepository,
  });

  @override
  Widget build(BuildContext context) {
    final ref = entry.reference;
    final text = Text(
      entry.displayName,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
    if (ref == null) {
      return text;
    }
    return CompendiumReferenceAnchor(
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
          entityName: ref.displayName,
          browseRepository: browseRepository,
        );
      },
      child: text,
    );
  }
}

class _TreasureCard extends StatelessWidget {
  final Wealth wealth;

  const _TreasureCard({required this.wealth});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Treasure and Currency',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            CurrencyDisplay(wealth: wealth),
          ],
        ),
      ),
    );
  }
}
