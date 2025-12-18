import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class HitPointsWidget extends StatelessWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const HitPointsWidget({
    super.key,
    required this.character,
    required this.onCharacterUpdated,
  });

  void _updateHitPoints(int change) {
    final newCurrentHP = (character.health.currentHitPoints + change)
        .clamp(0, character.health.maxHitPoints);
    final newHealth = character.health.copyWith(currentHitPoints: newCurrentHP);

    final newCharacter = Character(
      id: character.id,
      name: character.name,
      playerName: character.playerName, // Added missing playerName
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
                Icon(Icons.favorite_border, color: colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Text(
                  'HIT POINTS',
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: colorScheme.error),
                  onPressed: () => _updateHitPoints(-1),
                ),
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${character.health.currentHitPoints}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: ' / ${character.health.maxHitPoints}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Temp HP: ${character.health.temporaryHitPoints}',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
                  onPressed: () => _updateHitPoints(1),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (character.health.hitDice.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HIT DICE',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: character.health.hitDice
                        .map((hd) => Chip(
                      label: Text('${hd.remaining}/${hd.count}d${hd.sides}'),
                      backgroundColor: colorScheme.surfaceVariant,
                    ))
                        .toList(),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHitDieButton('Use 1', colorScheme, onPressed: () {
                  // TODO: Implement hit dice usage
                }),
                _buildHitDieButton('Short Rest', colorScheme, onPressed: () {
                  // TODO: Implement short rest
                }),
                _buildHitDieButton('Long Rest', colorScheme, onPressed: () {
                  // TODO: Implement long rest
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHitDieButton(String text, ColorScheme colorScheme, {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.surfaceVariant,
        foregroundColor: colorScheme.onSurfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}