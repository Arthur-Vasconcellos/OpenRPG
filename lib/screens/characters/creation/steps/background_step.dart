import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/characters/creation/widgets/guided_origin_picker.dart';

class BackgroundStep extends StatelessWidget {
  final CharacterEditorController controller;

  const BackgroundStep({super.key, required this.controller});

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
                  'Background',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the life path this character brings into the adventure. Skills, tools, languages, equipment, and story hooks can come from your background.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        '${resolved.backgroundFeatures.length} background features',
                      ),
                    ),
                    if (character.backgroundRef != null)
                      Chip(label: Text(character.backgroundRef!.rulesetId)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GuidedBackgroundPicker(controller: controller),
        if (character.backgroundRef != null) ...[
          const SizedBox(height: 16),
          BackgroundImpactSummary(controller: controller),
        ],
      ],
    );
  }
}
