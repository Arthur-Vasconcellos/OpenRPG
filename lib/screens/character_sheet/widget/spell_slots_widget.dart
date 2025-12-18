import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class SpellSlotsWidget extends StatelessWidget {
  final SpellcastingInfo? spellcasting;

  const SpellSlotsWidget({
    super.key,
    required this.spellcasting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (spellcasting == null) {
      return Container();
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(9, (index) {
        final slot = spellcasting!.spellSlots.firstWhere(
              (s) => s.level == index + 1,
          orElse: () => SpellSlot(level: index + 1, total: 0, used: 0),
        );

        if (slot.total == 0) return Container();

        final remaining = slot.remaining; // Using the getter from your model
        final isLow = remaining <= slot.total * 0.3;

        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isLow
                ? colorScheme.error.withOpacity(0.1)
                : colorScheme.tertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLow
                  ? colorScheme.error.withOpacity(0.3)
                  : colorScheme.tertiary.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Level ${slot.level}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$remaining',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isLow ? colorScheme.error : colorScheme.tertiary,
                ),
              ),
              Text(
                '/ ${slot.total}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}