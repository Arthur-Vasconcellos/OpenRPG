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

  void _updateCurrentHP(int change) {
    final newCurrentHP = (character.health.currentHitPoints + change)
        .clamp(0, character.health.maxHitPoints);
    final newHealth = character.health.copyWith(currentHitPoints: newCurrentHP);

    final newCharacter = character.copyWith(health: newHealth);
    onCharacterUpdated(newCharacter);
  }

  void _updateTempHP(int change) {
    final newTempHP = (character.health.temporaryHitPoints + change).clamp(0, 999);
    final newHealth = character.health.copyWith(temporaryHitPoints: newTempHP);

    final newCharacter = character.copyWith(health: newHealth);
    onCharacterUpdated(newCharacter);
  }

  void _updateMaxHP(int change) {
    final newMaxHP = (character.health.maxHitPoints + change).clamp(1, 999);
    final newHealth = character.health.copyWith(maxHitPoints: newMaxHP);

    // Also adjust current HP if it's higher than new max
    final adjustedCurrentHP = character.health.currentHitPoints > newMaxHP
        ? newMaxHP
        : character.health.currentHitPoints;

    final finalHealth = newHealth.copyWith(currentHitPoints: adjustedCurrentHP);
    final newCharacter = character.copyWith(health: finalHealth);

    onCharacterUpdated(newCharacter);
  }

  void _showHPEditDialog(BuildContext context) {
    final currentHPController = TextEditingController(
      text: character.health.currentHitPoints.toString(),
    );
    final maxHPController = TextEditingController(
      text: character.health.maxHitPoints.toString(),
    );
    final tempHPController = TextEditingController(
      text: character.health.temporaryHitPoints.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Hit Points'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentHPController,
              decoration: const InputDecoration(
                labelText: 'Current HP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: maxHPController,
              decoration: const InputDecoration(
                labelText: 'Maximum HP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tempHPController,
              decoration: const InputDecoration(
                labelText: 'Temporary HP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final currentHP = int.tryParse(currentHPController.text) ?? character.health.currentHitPoints;
              final maxHP = int.tryParse(maxHPController.text) ?? character.health.maxHitPoints;
              final tempHP = int.tryParse(tempHPController.text) ?? character.health.temporaryHitPoints;

              final newHealth = character.health.copyWith(
                currentHitPoints: currentHP.clamp(0, maxHP),
                maxHitPoints: maxHP.clamp(1, 999),
                temporaryHitPoints: tempHP.clamp(0, 999),
              );

              final newCharacter = character.copyWith(health: newHealth);
              onCharacterUpdated(newCharacter);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentHP = character.health.currentHitPoints;
    final maxHP = character.health.maxHitPoints;
    final tempHP = character.health.temporaryHitPoints;
    final hpPercentage = maxHP > 0 ? (currentHP / maxHP) : 0.0;

    Color hpColor;
    if (hpPercentage > 0.5) {
      hpColor = colorScheme.primary;
    } else if (hpPercentage > 0.25) {
      hpColor = Colors.orange;
    } else {
      hpColor = colorScheme.error;
    }

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
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.edit, size: 18),
                  onPressed: () => _showHPEditDialog(context),
                  tooltip: 'Edit HP',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // HP Progress Bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                widthFactor: hpPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: hpColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Current HP Display
            GestureDetector(
              onTap: () => _showHPEditDialog(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: colorScheme.error),
                    onPressed: () => _updateCurrentHP(-1),
                  ),
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$currentHP',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: hpColor,
                              ),
                            ),
                            TextSpan(
                              text: ' / $maxHP',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (tempHP > 0)
                        Text(
                          'Temp HP: $tempHP',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
                    onPressed: () => _updateCurrentHP(1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Adjustment Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Current HP',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 16),
                          onPressed: () => _updateCurrentHP(-5),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, size: 16),
                          onPressed: () => _updateCurrentHP(5),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Max HP',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 16),
                          onPressed: () => _updateMaxHP(-5),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, size: 16),
                          onPressed: () => _updateMaxHP(5),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Temp HP',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 16),
                          onPressed: () => _updateTempHP(-5),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, size: 16),
                          onPressed: () => _updateTempHP(5),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Hit Dice Section
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
                    runSpacing: 4,
                    children: character.health.hitDice
                        .map((hd) => Chip(
                      label: Text('${hd.remaining}/${hd.count}d${hd.sides}'),
                      backgroundColor: hd.remaining > 0
                          ? colorScheme.surfaceVariant
                          : colorScheme.error.withOpacity(0.2),
                    ))
                        .toList(),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Rest Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRestButton('Use Hit Die', colorScheme, onPressed: () {
                  // TODO: Implement hit dice usage
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hit dice usage not implemented yet')),
                  );
                }),
                _buildRestButton('Short Rest', colorScheme, onPressed: () {
                  // TODO: Implement short rest
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Short rest not implemented yet')),
                  );
                }),
                _buildRestButton('Long Rest', colorScheme, onPressed: () {
                  // TODO: Implement long rest
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Long rest not implemented yet')),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestButton(String text, ColorScheme colorScheme, {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.surfaceVariant,
        foregroundColor: colorScheme.onSurfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}