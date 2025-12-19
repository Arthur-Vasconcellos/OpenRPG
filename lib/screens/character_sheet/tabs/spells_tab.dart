import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/spell_slots_widget.dart';

class SpellsTab extends StatelessWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const SpellsTab({
    super.key,
    required this.character,
    required this.onCharacterUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (character.spellcasting == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_outlined,
                size: 80, color: colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 20),
            Text(
              'No Spellcasting',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${character.classes[0].characterClass} does not have spellcasting',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Spellcasting Stats
            Card(
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
                        Icon(Icons.auto_awesome_outlined,
                            color: colorScheme.tertiary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'SPELLCASTING',
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSpellStat('SPELL DC',
                            '${character.spellcasting!.spellSaveDC}', colorScheme),
                        _buildSpellStat('ATTACK BONUS',
                            '+${character.spellcasting!.spellAttackBonus}', colorScheme),
                        _buildSpellStat('ABILITY',
                            character.spellcasting!.spellcastingAbility
                                ?.toUpperCase() ??
                                '', colorScheme),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Spell Slots
            Card(
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
                        Icon(Icons.layers_outlined,
                            color: colorScheme.onSurface, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'SPELL SLOTS',
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
                    SpellSlotsWidget(spellcasting: character.spellcasting),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Prepared Spells
            Card(
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
                        Icon(Icons.book_outlined,
                            color: colorScheme.onSurface, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'PREPARED SPELLS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (character.spellcasting!.preparedSpells.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No spells prepared',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ...character.spellcasting!.preparedSpells
                        .take(5)
                        .map((spell) => _buildSpellRow(spell, colorScheme)),
                    if (character.spellcasting!.preparedSpells.length > 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextButton(
                          onPressed: () {
                            // TODO: Show all spells
                          },
                          child: const Text('Show all spells...'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellStat(String label, String value, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.tertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.tertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpellRow(Spell spell, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.tertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              spell.level == 0 ? 'C' : '${spell.level}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: colorScheme.tertiary,
              ),
            ),
          ),
        ),
        title: Text(
          spell.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          spell.school,
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            if (spell.isRitual)
              Chip(
                label: Text('Ritual',
                    style: TextStyle(fontSize: 10, color: colorScheme.primary)),
                backgroundColor: colorScheme.primary.withOpacity(0.1),
              ),
            if (spell.isConcentration)
              Chip(
                label: Text('Conc.',
                    style: TextStyle(fontSize: 10, color: colorScheme.secondary)),
                backgroundColor: colorScheme.secondary.withOpacity(0.1),
              ),
          ],
        ),
      ),
    );
  }
}