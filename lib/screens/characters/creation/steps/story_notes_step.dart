import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';

class StoryNotesStep extends StatelessWidget {
  final CharacterEditorController controller;

  const StoryNotesStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
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
                  'Story & Notes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'These fields add flavor and table context without blocking mechanical completion.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: character.traits.personalityTraits,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Personality traits',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      controller.setStoryFields(personalityTraits: value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: character.traits.ideals,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Ideals',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      controller.setStoryFields(ideals: value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: character.traits.bonds,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Bonds',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => controller.setStoryFields(bonds: value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: character.traits.flaws,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Flaws',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => controller.setStoryFields(flaws: value),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: character.notes.backstory,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Backstory',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      controller.setStoryFields(backstory: value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: character.notes.appearance,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Appearance',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      controller.setStoryFields(appearance: value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: character.notes.otherNotes,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Other notes',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      controller.setStoryFields(otherNotes: value),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 620;
                return GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: narrow ? 1 : 3,
                    childAspectRatio: narrow ? 4 : 2.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  children: [
                    TextFormField(
                      initialValue: character.physicalDescription.height,
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          controller.setStoryFields(height: value),
                    ),
                    TextFormField(
                      initialValue: character.physicalDescription.eyes,
                      decoration: const InputDecoration(
                        labelText: 'Eyes',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          controller.setStoryFields(eyes: value),
                    ),
                    TextFormField(
                      initialValue: character.physicalDescription.hair,
                      decoration: const InputDecoration(
                        labelText: 'Hair',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          controller.setStoryFields(hair: value),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
