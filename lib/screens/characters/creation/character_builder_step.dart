import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';

enum CharacterBuilderStepId {
  basics,
  classLevel,
  speciesRace,
  background,
  abilityScores,
  proficiencies,
  spells,
  equipment,
  story,
  review,
}

enum CharacterBuilderStepStatus {
  complete,
  warning,
  error,
  notStarted,
  skipped,
}

class CharacterBuilderStepDescriptor {
  final CharacterBuilderStepId id;
  final String title;
  final String shortTitle;
  final IconData icon;
  final bool Function(CharacterEditorController controller) isVisible;

  const CharacterBuilderStepDescriptor({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.icon,
    required this.isVisible,
  });
}

final List<CharacterBuilderStepDescriptor> characterBuilderStepDescriptors =
    <CharacterBuilderStepDescriptor>[
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.basics,
        title: 'Basics & Ruleset',
        shortTitle: 'Basics',
        icon: Icons.badge_outlined,
        isVisible: (_) => true,
      ),
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.classLevel,
        title: 'Class & Level',
        shortTitle: 'Class',
        icon: Icons.class_outlined,
        isVisible: (_) => true,
      ),
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.speciesRace,
        title: 'Species / Race',
        shortTitle: 'Species',
        icon: Icons.people_outline,
        isVisible: (_) => true,
      ),
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.background,
        title: 'Background',
        shortTitle: 'Background',
        icon: Icons.work_outline,
        isVisible: (_) => true,
      ),
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.abilityScores,
        title: 'Ability Scores',
        shortTitle: 'Abilities',
        icon: Icons.fitness_center_outlined,
        isVisible: (_) => true,
      ),
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.proficiencies,
        title: 'Proficiencies',
        shortTitle: 'Training',
        icon: Icons.verified_outlined,
        isVisible: (_) => true,
      ),
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.spells,
        title: 'Spells',
        shortTitle: 'Spells',
        icon: Icons.auto_awesome_outlined,
        isVisible: (controller) {
          final spellcasting = controller.character?.spellcasting;
          return controller.resolvedBuild.hasSpellcasting ||
              (spellcasting?.allSpells.isNotEmpty ?? false);
        },
      ),
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.equipment,
        title: 'Equipment',
        shortTitle: 'Gear',
        icon: Icons.backpack_outlined,
        isVisible: (_) => true,
      ),
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.story,
        title: 'Story & Notes',
        shortTitle: 'Story',
        icon: Icons.notes_outlined,
        isVisible: (_) => true,
      ),
      CharacterBuilderStepDescriptor(
        id: CharacterBuilderStepId.review,
        title: 'Review & Finish',
        shortTitle: 'Review',
        icon: Icons.checklist_outlined,
        isVisible: (_) => true,
      ),
    ];

extension CharacterBuilderStepIdLabel on CharacterBuilderStepId {
  CharacterBuilderStepDescriptor get descriptor {
    return characterBuilderStepDescriptors.firstWhere(
      (entry) => entry.id == this,
    );
  }
}
