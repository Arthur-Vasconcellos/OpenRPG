import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class FeatureItem extends StatelessWidget {
  final Feature feature;

  const FeatureItem({
    super.key,
    required this.feature,
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          feature.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          'Level ${feature.levelObtained}',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              feature.description,
              style: TextStyle(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}