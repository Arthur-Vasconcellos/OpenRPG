import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/currency_display.dart';

class EquipmentTab extends StatelessWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const EquipmentTab({
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
            // Currency
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
                        Icon(Icons.monetization_on_outlined,
                            color: colorScheme.secondary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'CURRENCY',
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
                    CurrencyDisplay(wealth: character.wealth),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Equipment
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
                        Icon(Icons.backpack_outlined,
                            color: colorScheme.onSurface, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'EQUIPMENT',
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
                    if (character.equipment.inventory.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No equipment items',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ...character.equipment.inventory
                        .map((item) => _buildEquipmentItem(item, colorScheme)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Armor
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
                        Icon(Icons.shield_outlined,
                            color: colorScheme.onSurface, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ARMOR',
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
                    if (character.equipment.armor.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No armor equipped',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ...character.equipment.armor
                        .map((armor) => _buildArmorItem(armor, colorScheme)),
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

  Widget _buildEquipmentItem(EquipmentItem item, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Checkbox(
          value: item.isEquipped,
          onChanged: (value) {
            // TODO: Update equipment
          },
          activeColor: colorScheme.primary,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          'Qty: ${item.quantity} • Weight: ${item.weight} lb',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline,
              color: colorScheme.onSurface.withOpacity(0.5)),
          onPressed: () {
            // TODO: Remove equipment
          },
        ),
      ),
    );
  }

  Widget _buildArmorItem(Armor armor, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Checkbox(
          value: armor.isEquipped,
          onChanged: (value) {
            // TODO: Update armor
          },
          activeColor: colorScheme.primary,
        ),
        title: Text(
          armor.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AC ${armor.baseAC} • ${armor.armorType}',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
            if (armor.stealthDisadvantage)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Icon(Icons.visibility_off, size: 12, color: colorScheme.error),
                    const SizedBox(width: 4),
                    Text(
                      'Stealth Disadvantage',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}