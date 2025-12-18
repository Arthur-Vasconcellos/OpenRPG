import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/death_saves_widget.dart';
import 'package:openrpg/screens/character_sheet/widget/hit_points_widget.dart';
import 'package:openrpg/screens/character_sheet/widget/weapon_row.dart';

class CombatTab extends StatelessWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const CombatTab({
    super.key,
    required this.character,
    required this.onCharacterUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Combat Stats Grid
            _buildCombatStatsGrid(context, colorScheme),
            const SizedBox(height: 20),

            // Hit Points
            HitPointsWidget(
              character: character,
              onCharacterUpdated: onCharacterUpdated,
            ),

            const SizedBox(height: 20),

            // Death Saves
            DeathSavesWidget(
              character: character,
              onCharacterUpdated: onCharacterUpdated,
            ),

            const SizedBox(height: 20),

            // Weapons
            _buildWeaponsCard(colorScheme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatStatsGrid(BuildContext context, ColorScheme colorScheme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard('ARMOR CLASS', '${character.combatStats.armorClass}', colorScheme.primary, colorScheme),
        _buildStatCard('INITIATIVE', '${character.combatStats.initiative}', colorScheme.secondary, colorScheme),
        _buildStatCard('SPEED', '${character.combatStats.speed} ft', colorScheme.tertiary, colorScheme),
        _buildStatCard('PROFICIENCY', '+${character.proficiencies.proficiencyBonus}', colorScheme.primary, colorScheme),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 2),
              ),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaponsCard(ColorScheme colorScheme) {
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
            _buildSectionTitle('WEAPONS', Icons.gavel_outlined, colorScheme),
            const SizedBox(height: 16),
            if (character.equipment.weapons.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No weapons equipped',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ...character.equipment.weapons
                .take(3)
                .map((weapon) => WeaponRow(weapon: weapon)),
            if (character.equipment.weapons.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton(
                  onPressed: () {
                    // TODO: Show all weapons
                  },
                  child: const Text('Show all weapons...'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.onSurface, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: colorScheme.onSurface.withOpacity(0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}