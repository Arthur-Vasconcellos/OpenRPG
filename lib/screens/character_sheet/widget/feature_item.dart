import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/rulesets/compendium_rich_content_renderer.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';

class FeatureItem extends StatelessWidget {
  final Feature feature;
  final VoidCallback? onOpenReference;
  final CompendiumLinkTap? onLinkTap;
  final CompendiumBrowseRepository? browseRepository;

  const FeatureItem({
    super.key,
    required this.feature,
    this.onOpenReference,
    this.onLinkTap,
    this.browseRepository,
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
        title: Row(
          children: [
            Expanded(
              child: hasPreview && browseRepository != null
                  ? CompendiumReferenceAnchor(
                      rulesetId: feature.reference!.rulesetId,
                      entityType: feature.reference!.entityType,
                      entityId: feature.reference!.entityId,
                      entityName: feature.reference!.displayName,
                      browseRepository: browseRepository!,
                      onTap: onOpenReference,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          feature.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        feature.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
            ),
            if (hasPreview)
              IconButton(
                tooltip: 'Preview feature source',
                onPressed: onOpenReference,
                icon: const Icon(Icons.visibility_outlined),
              ),
          ],
        ),
        subtitle: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Level ${feature.levelObtained}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (feature.source.trim().isNotEmpty)
              Chip(
                label: Text(feature.source),
                visualDensity: VisualDensity.compact,
              ),
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
