import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/rulesets/compendium_rich_content_renderer.dart';

class FeatureItem extends StatelessWidget {
  final Feature feature;
  final VoidCallback? onOpenReference;
  final CompendiumLinkTap? onLinkTap;

  const FeatureItem({
    super.key,
    required this.feature,
    this.onOpenReference,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasStructuredContent = feature.content != null;
    final hasPreview = onOpenReference != null && feature.reference != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          feature.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          'Level ${feature.levelObtained}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasPreview)
              IconButton(
                tooltip: 'Preview entry',
                icon: const Icon(Icons.visibility_outlined),
                onPressed: onOpenReference,
              ),
            const Icon(Icons.expand_more),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          if (feature.description.trim().isNotEmpty && !hasStructuredContent)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                feature.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.45),
              ),
            ),
          if (hasStructuredContent)
            CompendiumRichContentRenderer(
              content: feature.content,
              onLinkTap: onLinkTap,
            ),
          if (feature.description.trim().isNotEmpty &&
              hasStructuredContent) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                feature.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
