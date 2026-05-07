import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/character_sheet/tabs/spells_tab.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';

class SpellsStep extends StatelessWidget {
  final CharacterEditorController controller;
  final ValueChanged<CharacterBuilderStepId>? onGoToStep;

  const SpellsStep({super.key, required this.controller, this.onGoToStep});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final spellcasting = character.spellcasting;
    final hasSpellRows = spellcasting?.allSpells.isNotEmpty ?? false;
    if (!controller.resolvedBuild.hasSpellcasting && !hasSpellRows) {
      final colorScheme = Theme.of(context).colorScheme;
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a spellcasting class first',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The D&D spell checklist appears after Class & Level resolves a spellcasting profile. Pick or adjust the class, then come back here if spells are available.',
                    style: TextStyle(color: colorScheme.onSecondaryContainer),
                  ),
                  if (onGoToStep != null) ...[
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          onGoToStep!(CharacterBuilderStepId.classLevel),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go to Class & Level'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
    }
    return SpellsTab(controller: controller);
  }
}
