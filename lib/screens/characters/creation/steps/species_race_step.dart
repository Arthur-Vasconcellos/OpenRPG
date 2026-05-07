import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/characters/creation/species_race_terms.dart';
import 'package:openrpg/screens/characters/creation/widgets/guided_origin_picker.dart';

class SpeciesRaceStep extends StatelessWidget {
  final CharacterEditorController controller;

  const SpeciesRaceStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final terminology = speciesRaceTerminologyForController(controller);
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
                  terminology.displayLabel,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose ${terminology.articleLabel} for movement, traits, senses, languages, and other benefits when the rules list them.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text('Speed ${resolved.expectedSpeed} ft')),
                    Chip(label: Text('${resolved.raceTraits.length} traits')),
                    if (character.raceRef != null)
                      Chip(label: Text(character.raceRef!.rulesetId)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GuidedSpeciesRacePicker(
          controller: controller,
          terminology: terminology,
        ),
        if (character.raceRef != null) ...[
          const SizedBox(height: 16),
          SpeciesRaceImpactSummary(
            controller: controller,
            terminology: terminology,
          ),
        ],
      ],
    );
  }
}
