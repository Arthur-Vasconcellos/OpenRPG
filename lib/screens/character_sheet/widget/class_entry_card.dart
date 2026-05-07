import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/build_selection_card.dart';
import 'package:openrpg/screens/character_sheet/widget/character_compendium_picker.dart';

class ClassEntryCard extends StatelessWidget {
  final CharacterEditorController controller;
  final int index;
  final CharacterClassLevel entry;
  final bool canRemove;

  const ClassEntryCard({
    super.key,
    required this.controller,
    required this.index,
    required this.entry,
    this.canRemove = true,
  });

  @override
  Widget build(BuildContext context) {
    final totalLevel = controller.character!.totalLevel;
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
            Text(
              totalLevel == 0
                  ? 'This class slot is ready to define the character build.'
                  : 'Contributes ${entry.level} of $totalLevel total character levels and adds class features.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            BuildSelectionCard(
              title: 'Class',
              icon: Icons.class_outlined,
              reference: entry.classRef,
              service: controller.compendium,
              emptyLabel: 'No class selected yet.',
              helperText:
                  'Class controls hit dice, spellcasting progression, and most build-defining features.',
              onSelect: () => _pickClass(context),
              selectLabel: entry.classRef == null ? 'Choose Class' : 'Change',
            ),
            const SizedBox(height: 12),
            BuildSelectionCard(
              title: 'Subclass',
              icon: Icons.account_tree_outlined,
              reference: entry.subclassRef,
              service: controller.compendium,
              emptyLabel: entry.classRef == null
                  ? 'Select a class first to narrow the subclass list.'
                  : 'No subclass selected yet.',
              helperText:
                  'Subclass is scoped to the selected class and adds specialized features as you level up.',
              onSelect: entry.classRef == null
                  ? null
                  : () => _pickSubclass(context),
              onClear: entry.subclassRef == null
                  ? null
                  : () => controller.setClassEntry(
                      index,
                      classRef: entry.classRef,
                      clearSubclass: true,
                    ),
              selectLabel: entry.subclassRef == null
                  ? 'Choose Subclass'
                  : 'Change',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Level', style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                IconButton(
                  tooltip: 'Decrease level',
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
                SizedBox(
                  width: 42,
                  child: Text(
                    '${entry.level}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Increase level',
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
