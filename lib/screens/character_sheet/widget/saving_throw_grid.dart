import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class SavingThrowGrid extends StatelessWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const SavingThrowGrid({
    super.key,
    required this.character,
    required this.onCharacterUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final saves = [
      {
        'name': 'STR',
        'mod': character.proficiencies.savingThrows.getModifier(
            'strength',
            character.modifiers,
            character.proficiencies.proficiencyBonus),
        'proficient': character.proficiencies.savingThrows.strength
      },
      {
        'name': 'DEX',
        'mod': character.proficiencies.savingThrows.getModifier(
            'dexterity',
            character.modifiers,
            character.proficiencies.proficiencyBonus),
        'proficient': character.proficiencies.savingThrows.dexterity
      },
      {
        'name': 'CON',
        'mod': character.proficiencies.savingThrows.getModifier(
            'constitution',
            character.modifiers,
            character.proficiencies.proficiencyBonus),
        'proficient': character.proficiencies.savingThrows.constitution
      },
      {
        'name': 'INT',
        'mod': character.proficiencies.savingThrows.getModifier(
            'intelligence',
            character.modifiers,
            character.proficiencies.proficiencyBonus),
        'proficient': character.proficiencies.savingThrows.intelligence
      },
      {
        'name': 'WIS',
        'mod': character.proficiencies.savingThrows.getModifier('wisdom',
            character.modifiers, character.proficiencies.proficiencyBonus),
        'proficient': character.proficiencies.savingThrows.wisdom
      },
      {
        'name': 'CHA',
        'mod': character.proficiencies.savingThrows.getModifier(
            'charisma',
            character.modifiers,
            character.proficiencies.proficiencyBonus),
        'proficient': character.proficiencies.savingThrows.charisma
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: saves.map((save) {
        final name = save['name'] as String;
        final mod = save['mod'] as int;
        final proficient = save['proficient'] as bool;

        return GestureDetector(
          onTap: () {
            _toggleSavingThrow(name, proficient);
          },
          child: Container(
            decoration: BoxDecoration(
              color: proficient
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: proficient
                    ? colorScheme.primary
                    : colorScheme.outline.withOpacity(0.3),
                width: proficient ? 2 : 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: proficient
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mod >= 0 ? '+$mod' : '$mod',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (proficient)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.check_circle,
                        size: 12,
                        color: colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _toggleSavingThrow(String ability, bool current) {
    final newSavingThrows = SavingThrowProficiencies(
      strength: ability == 'STR' ? !current : character.proficiencies.savingThrows.strength,
      dexterity: ability == 'DEX' ? !current : character.proficiencies.savingThrows.dexterity,
      constitution: ability == 'CON' ? !current : character.proficiencies.savingThrows.constitution,
      intelligence: ability == 'INT' ? !current : character.proficiencies.savingThrows.intelligence,
      wisdom: ability == 'WIS' ? !current : character.proficiencies.savingThrows.wisdom,
      charisma: ability == 'CHA' ? !current : character.proficiencies.savingThrows.charisma,
    );

    final newProficiencies = ProficiencySet(
      proficiencyBonus: character.proficiencies.proficiencyBonus,
      skills: character.proficiencies.skills,
      savingThrows: newSavingThrows,
      languages: character.proficiencies.languages,
      tools: character.proficiencies.tools,
      weapons: character.proficiencies.weapons,
      armor: character.proficiencies.armor,
      other: character.proficiencies.other,
    );

    final newCharacter = Character(
      id: character.id,
      name: character.name,
      classes: character.classes,
      race: character.race,
      background: character.background,
      moralAlignment: character.moralAlignment,
      experiencePoints: character.experiencePoints,
      inspiration: character.inspiration,
      abilityScores: character.abilityScores,
      modifiers: character.modifiers,
      proficiencies: newProficiencies,
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
      equippedCombatStats: character.equippedCombatStats,
    ).copyWithCalculatedValues();

    onCharacterUpdated(newCharacter);
  }
}