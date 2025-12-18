import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';

class SkillsGrid extends StatelessWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const SkillsGrid({
    super.key,
    required this.character,
    required this.onCharacterUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final skills = [
      {'skill': Skill.acrobatics, 'name': 'Acrobatics'},
      {'skill': Skill.animalHandling, 'name': 'Animal Handling'},
      {'skill': Skill.arcana, 'name': 'Arcana'},
      {'skill': Skill.athletics, 'name': 'Athletics'},
      {'skill': Skill.deception, 'name': 'Deception'},
      {'skill': Skill.history, 'name': 'History'},
      {'skill': Skill.insight, 'name': 'Insight'},
      {'skill': Skill.intimidation, 'name': 'Intimidation'},
      {'skill': Skill.investigation, 'name': 'Investigation'},
      {'skill': Skill.medicine, 'name': 'Medicine'},
      {'skill': Skill.nature, 'name': 'Nature'},
      {'skill': Skill.perception, 'name': 'Perception'},
      {'skill': Skill.performance, 'name': 'Performance'},
      {'skill': Skill.persuasion, 'name': 'Persuasion'},
      {'skill': Skill.religion, 'name': 'Religion'},
      {'skill': Skill.sleightOfHand, 'name': 'Sleight of Hand'},
      {'skill': Skill.stealth, 'name': 'Stealth'},
      {'skill': Skill.survival, 'name': 'Survival'},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 6,
      crossAxisSpacing: 12,
      mainAxisSpacing: 8,
      children: skills.map((skillData) {
        final skill = skillData['skill'] as Skill;
        final name = skillData['name'] as String;
        final mod = character.proficiencies.skills.getModifier(
            skill, character.modifiers, character.proficiencies.proficiencyBonus);
        final proficiency =
            character.proficiencies.skills.proficiencies[skill] ??
                ProficiencyLevel.none;

        return GestureDetector(
          onTap: () {
            _toggleSkillProficiency(skill, proficiency);
          },
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: proficiency != ProficiencyLevel.none
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (proficiency == ProficiencyLevel.expert)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.star,
                            size: 14,
                            color: colorScheme.secondary,
                          ),
                        ),
                      if (proficiency == ProficiencyLevel.proficient)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.check_circle,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          mod >= 0 ? '+$mod' : '$mod',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _toggleSkillProficiency(Skill skill, ProficiencyLevel current) {
    final newProficiencies = Map<Skill, ProficiencyLevel>.from(
        character.proficiencies.skills.proficiencies);

    newProficiencies[skill] = current == ProficiencyLevel.none
        ? ProficiencyLevel.proficient
        : current == ProficiencyLevel.proficient
        ? ProficiencyLevel.expert
        : ProficiencyLevel.none;

    final newSkills = SkillProficiencies(proficiencies: newProficiencies);
    final newProficiencySet = ProficiencySet(
      proficiencyBonus: character.proficiencies.proficiencyBonus,
      skills: newSkills,
      savingThrows: character.proficiencies.savingThrows,
      languages: character.proficiencies.languages,
      tools: character.proficiencies.tools,
      weapons: character.proficiencies.weapons,
      armor: character.proficiencies.armor,
      other: character.proficiencies.other,
    );

    final newCharacter = Character(
      id: character.id,
      name: character.name,
      characterClass: character.characterClass,
      subclass: character.subclass,
      race: character.race,
      background: character.background,
      moralAlignment: character.moralAlignment,
      level: character.level,
      experiencePoints: character.experiencePoints,
      inspiration: character.inspiration,
      abilityScores: character.abilityScores,
      modifiers: character.modifiers,
      proficiencies: newProficiencySet,
      combatStats: character.combatStats,
      health: character.health,
      equipment: character.equipment,
      wealth: character.wealth,
      spellcasting: character.spellcasting,
      traits: character.traits,
      features: character.features,
      racialTraits: character.racialTraits,
      backgroundTraits: character.backgroundTraits,
      physicalDescription: character.physicalDescription,
      notes: character.notes,
      createdAt: character.createdAt,
      updatedAt: DateTime.now(),
    ).copyWithCalculatedValues();

    onCharacterUpdated(newCharacter);
  }
}