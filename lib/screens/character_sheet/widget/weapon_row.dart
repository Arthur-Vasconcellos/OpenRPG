import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class WeaponRow extends StatelessWidget {
  final Weapon weapon;

  const WeaponRow({
    super.key,
    required this.weapon,
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
        leading: Icon(Icons.gavel_outlined, color: colorScheme.primary),
        title: Text(
          weapon.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          '${weapon.damage} ${weapon.damageType}',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '+${weapon.attackBonus}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ),
        onTap: () {
          // TODO: Show weapon details
        },
      ),
    );
  }
}