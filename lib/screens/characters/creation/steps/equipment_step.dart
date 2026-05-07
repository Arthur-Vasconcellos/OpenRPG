import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/character_sheet/tabs/equipment_tab.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';

class EquipmentStep extends StatelessWidget {
  final CharacterEditorController controller;
  final ValueChanged<CharacterBuilderStepId>? onGoToStep;

  const EquipmentStep({super.key, required this.controller, this.onGoToStep});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    if (character.primaryRulesetId.trim().isEmpty) {
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
                    'Choose a ruleset before equipment',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The D&D equipment checklist uses the selected ruleset for compendium items and previews. Pick the ruleset in Basics, then come back here.',
                    style: TextStyle(color: colorScheme.onSecondaryContainer),
                  ),
                  if (onGoToStep != null) ...[
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          onGoToStep!(CharacterBuilderStepId.basics),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go to Basics'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
    }
    return EquipmentTab(controller: controller);
  }
}
