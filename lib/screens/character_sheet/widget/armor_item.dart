import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class ArmorItemWidget extends StatelessWidget {
  final Armor armor;

  const ArmorItemWidget({
    super.key,
    required this.armor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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