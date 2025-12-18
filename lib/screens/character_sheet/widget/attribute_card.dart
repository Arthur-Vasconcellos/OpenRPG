import 'package:flutter/material.dart';

class AttributeCard extends StatelessWidget {
  final String abbreviation;
  final String name;
  final int value;
  final int modifier;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const AttributeCard({
    super.key,
    required this.abbreviation,
    required this.name,
    required this.value,
    required this.modifier,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPositive = modifier >= 0;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            abbreviation,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isPositive
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPositive ? '+$modifier' : '$modifier',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isPositive ? colorScheme.primary : colorScheme.error,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: colorScheme.error,
                  size: 20,
                ),
                onPressed: onDecrement,
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}