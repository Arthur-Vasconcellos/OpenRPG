import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/class_entry_card.dart';
import 'package:openrpg/screens/characters/creation/widgets/guided_class_picker.dart';

class ClassLevelStep extends StatefulWidget {
  final CharacterEditorController controller;

  const ClassLevelStep({super.key, required this.controller});

  @override
  State<ClassLevelStep> createState() => _ClassLevelStepState();
}

class _ClassLevelStepState extends State<ClassLevelStep> {
  bool _requestedInitialClass = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_requestedInitialClass &&
        (widget.controller.character?.classes.isEmpty ?? false)) {
      _requestedInitialClass = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            (widget.controller.character?.classes.isEmpty ?? false)) {
          widget.controller.addClassEntry();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.controller.character!;
    final firstEntry = character.classes.isEmpty
        ? null
        : character.classes.first;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ClassLevelHeader(controller: widget.controller),
        const SizedBox(height: 16),
        if (firstEntry == null)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Preparing class choices...'),
            ),
          )
        else ...[
          GuidedClassPicker(
            controller: widget.controller,
            entry: firstEntry,
            index: 0,
          ),
          const SizedBox(height: 16),
          _LevelSelector(
            controller: widget.controller,
            entry: firstEntry,
            index: 0,
          ),
          if (firstEntry.classRef != null) ...[
            const SizedBox(height: 16),
            _ClassImpactSummary(controller: widget.controller),
          ],
        ],
        const SizedBox(height: 8),
        ExpansionTile(
          title: const Text('Advanced: Add another class'),
          subtitle: const Text(
            'Use this only when your table is allowing multiclass characters.',
          ),
          childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          children: [
            ...character.classes.skip(1).toList().asMap().entries.map((entry) {
              final index = entry.key + 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ClassEntryCard(
                  controller: widget.controller,
                  index: index,
                  entry: entry.value,
                  canRemove: true,
                ),
              );
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: widget.controller.addClassEntry,
                icon: const Icon(Icons.add),
                label: const Text('Add Class'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClassLevelHeader extends StatelessWidget {
  final CharacterEditorController controller;

  const _ClassLevelHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final build = controller.resolvedBuild;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class & Level',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the class that defines this character in play. Your class sets hit points, saving throws, proficiencies, class features, and spellcasting when available.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Total level ${character.totalLevel}')),
                Chip(
                  label: Text(
                    build.hitDice.isEmpty
                        ? 'Hit dice pending'
                        : build.hitDice
                              .map((die) => '${die.count}d${die.sides}')
                              .join(' / '),
                  ),
                ),
                Chip(
                  label: Text(
                    'Proficiency +${character.proficiencies.proficiencyBonus}',
                  ),
                ),
                Chip(
                  label: Text(
                    build.hasSpellcasting
                        ? 'Spellcasting: ${build.spellcastingClassName ?? 'available'}'
                        : 'No spellcasting from your class yet',
                  ),
                ),
                Chip(
                  label: Text('${build.classFeatures.length} class features'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  final CharacterEditorController controller;
  final CharacterClassLevel entry;
  final int index;

  const _LevelSelector({
    required this.controller,
    required this.entry,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final level = entry.level.clamp(1, 20).toInt();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Starting Level',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Chip(label: Text('Level $level')),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    'Proficiency +${controller.character!.proficiencies.proficiencyBonus}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Class features may change at higher levels. Subclass and feature choices are handled in later builder passes.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton.filledTonal(
                  tooltip: 'Decrease level',
                  onPressed: level <= 1 ? null : () => _setLevel(level - 1),
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Slider(
                    key: const Key('guided-class-level-slider'),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: 'Level $level',
                    value: level.toDouble(),
                    onChanged: (value) => _setLevel(value.round()),
                  ),
                ),
                IconButton.filled(
                  tooltip: 'Increase level',
                  onPressed: level >= 20 ? null : () => _setLevel(level + 1),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _setLevel(int level) {
    controller.setClassEntry(
      index,
      classRef: entry.classRef,
      subclassRef: entry.subclassRef,
      level: level.clamp(1, 20).toInt(),
    );
  }
}

class _ClassImpactSummary extends StatelessWidget {
  final CharacterEditorController controller;

  const _ClassImpactSummary({required this.controller});

  @override
  Widget build(BuildContext context) {
    final build = controller.resolvedBuild;
    final character = controller.character!;
    final hitDice = build.hitDice.isEmpty
        ? 'Hit points update from your class Hit Die.'
        : 'Hit dice: ${build.hitDice.map((die) => '${die.count}d${die.sides}').join(' / ')}';
    final savingThrows = build.savingThrowDefaults.proficientAbilityIds.isEmpty
        ? 'Saving throws will appear when the selected rules list them.'
        : 'Saving throws: ${build.savingThrowDefaults.proficientAbilityIds.map((id) => controller.sheetSchema.abilityLabel(id)).join(', ')}';
    final proficiencies = <String>[
      if (build.armorProficiencies.isNotEmpty)
        'Armor training: ${build.armorProficiencies.join(', ')}',
      if (build.weaponProficiencies.isNotEmpty)
        'Weapon training: ${build.weaponProficiencies.join(', ')}',
      if (build.toolProficiencies.isNotEmpty)
        'Tool proficiencies: ${build.toolProficiencies.join(', ')}',
    ];
    final spellcasting = build.hasSpellcasting
        ? 'Spellcasting: ${build.spellcastingClassName ?? character.classes.first.className}'
        : 'Spellcasting is not listed for this class at the current level.';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What This Class Affects',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'This is a play summary, not a checklist. The review step will call out anything that needs attention.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(hitDice)),
                Chip(label: Text(savingThrows)),
                ...proficiencies.map((text) => Chip(label: Text(text))),
                Chip(label: Text(spellcasting)),
                const Chip(
                  label: Text('Skill choices continue in Proficiencies'),
                ),
                const Chip(label: Text('Later class features unlock by level')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
