import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class DeathSavesWidget extends StatelessWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const DeathSavesWidget({
    super.key,
    required this.character,
    required this.onCharacterUpdated,
  });

  void _updateDeathSaves({int? successes, int? failures}) {
    final newDeathSaves = DeathSaves(
      successes: successes ?? character.health.deathSaves.successes,
      failures: failures ?? character.health.deathSaves.failures,
    );

    final newHealth = character.health.copyWith(deathSaves: newDeathSaves);

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
      proficiencies: character.proficiencies,
      combatStats: character.combatStats,
      health: newHealth,
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
    );

    onCharacterUpdated(newCharacter);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_information_outlined,
                    color: colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Text(
                  'DEATH SAVES',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Successes',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          )),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return GestureDetector(
                            onTap: () {
                              _updateDeathSaves(successes: index + 1);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index <
                                    character.health.deathSaves.successes
                                    ? colorScheme.primary
                                    : colorScheme.surfaceVariant,
                                border: Border.all(
                                  color: colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              child: index <
                                  character.health.deathSaves.successes
                                  ? Icon(Icons.check,
                                  size: 20, color: Colors.white)
                                  : null,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 80,
                  color: colorScheme.outline.withOpacity(0.2),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Failures',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          )),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return GestureDetector(
                            onTap: () {
                              _updateDeathSaves(failures: index + 1);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index <
                                    character.health.deathSaves.failures
                                    ? colorScheme.error
                                    : colorScheme.surfaceVariant,
                                border: Border.all(
                                  color: colorScheme.error,
                                  width: 2,
                                ),
                              ),
                              child: index <
                                  character.health.deathSaves.failures
                                  ? Icon(Icons.close,
                                  size: 20, color: Colors.white)
                                  : null,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}