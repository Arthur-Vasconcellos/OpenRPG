import 'package:flutter/material.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';

class CompendiumTypeStyle {
  static const List<Color> _palette = <Color>[
    Color(0xFF136F63),
    Color(0xFF355C7D),
    Color(0xFFB56576),
    Color(0xFF8C5E34),
    Color(0xFF4D6C2F),
    Color(0xFF7B4EA3),
    Color(0xFFB04A2F),
    Color(0xFF287271),
    Color(0xFF6D597A),
    Color(0xFF9C6644),
  ];

  static String labelFor(String entityType) {
    return descriptorForType(entityType)?.collection.label ?? entityType;
  }

  static Color colorFor(String entityType) {
    final hash = entityType.codeUnits.fold<int>(
      0,
      (value, unit) => (value * 31 + unit) & 0x7fffffff,
    );
    return _palette[hash % _palette.length];
  }
}

class CompendiumTypeBadge extends StatelessWidget {
  final String entityType;
  final String? label;

  const CompendiumTypeBadge({super.key, required this.entityType, this.label});

  @override
  Widget build(BuildContext context) {
    final color = CompendiumTypeStyle.colorFor(entityType);
    final text = label ?? CompendiumTypeStyle.labelFor(entityType);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
