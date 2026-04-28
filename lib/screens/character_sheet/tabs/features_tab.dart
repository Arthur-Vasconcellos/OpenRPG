import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/feature_item.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';

class FeaturesTab extends StatelessWidget {
  final CharacterEditorController controller;

  const FeaturesTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final resolved = controller.resolvedBuild;
    final sections = <_FeatureSection>[
      _FeatureSection(
        title: 'Class Features',
        icon: Icons.class_outlined,
        features: resolved.classFeatures,
        description:
            'Level-gated features sourced from the selected class entries.',
      ),
      _FeatureSection(
        title: 'Subclass Features',
        icon: Icons.account_tree_outlined,
        features: resolved.subclassFeatures,
        description:
            'Subclass additions layered onto the active class progression.',
      ),
      _FeatureSection(
        title: 'Race Traits',
        icon: Icons.people_outline,
        features: resolved.raceTraits,
        description:
            'Always-on ancestry traits and referenceable racial entries.',
      ),
      _FeatureSection(
        title: 'Background Traits',
        icon: Icons.work_outline,
        features: resolved.backgroundFeatures,
        description:
            'Roleplay-facing hooks and benefits coming from the chosen background.',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Every previewable feature, trait, and nested reference should be reachable from here.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Features are grouped by provenance first, then by the level where they come online, so build progression and source context stay visible together.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        '${resolved.allFeatures.length} resolved feature${resolved.allFeatures.length == 1 ? '' : 's'}',
                      ),
                    ),
                    if (resolved.classFeatures.isNotEmpty)
                      Chip(
                        label: Text(
                          '${resolved.classFeatures.length} class feature${resolved.classFeatures.length == 1 ? '' : 's'}',
                        ),
                      ),
                    if (resolved.subclassFeatures.isNotEmpty)
                      Chip(
                        label: Text(
                          '${resolved.subclassFeatures.length} subclass feature${resolved.subclassFeatures.length == 1 ? '' : 's'}',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...sections.map((section) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(section.icon),
                        const SizedBox(width: 8),
                        Text(
                          section.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(
                            '${section.features.length} entr${section.features.length == 1 ? 'y' : 'ies'}',
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      section.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    if (section.features.isEmpty)
                      Text(
                        'No entries yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else
                      ..._groupByLevel(section.features).entries.map(
                        (levelGroup) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (levelGroup.key >= 0) ...[
                              const SizedBox(height: 4),
                              Text(
                                levelGroup.key == 0
                                    ? 'Always Available'
                                    : 'Level ${levelGroup.key}',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 8),
                            ],
                            ...levelGroup.value.map(
                              (feature) => FeatureItem(
                                feature: feature,
                                browseRepository:
                                    controller.compendium.browseRepository,
                                onOpenReference: feature.reference == null
                                    ? null
                                    : () {
                                        final ref = feature.reference!;
                                        showCompendiumEntityPreviewSurface(
                                          context,
                                          rulesetId: ref.rulesetId,
                                          entityType: ref.entityType,
                                          entityId: ref.entityId,
                                          browseRepository: controller
                                              .compendium
                                              .browseRepository,
                                        );
                                      },
                                onLinkTap: (candidate) =>
                                    openCompendiumLinkPreview(
                                      context,
                                      browseRepository: controller
                                          .compendium
                                          .browseRepository,
                                      candidate: candidate,
                                      preferredRulesetId:
                                          feature.reference?.rulesetId ??
                                          character.primaryRulesetId,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _FeatureSection {
  final String title;
  final IconData icon;
  final List<Feature> features;
  final String description;

  const _FeatureSection({
    required this.title,
    required this.icon,
    required this.features,
    required this.description,
  });
}

Map<int, List<Feature>> _groupByLevel(List<Feature> features) {
  final grouped = <int, List<Feature>>{};
  final sorted = List<Feature>.from(features)
    ..sort((left, right) {
      final levelOrder = left.levelObtained.compareTo(right.levelObtained);
      if (levelOrder != 0) {
        return levelOrder;
      }
      return left.name.compareTo(right.name);
    });
  for (final feature in sorted) {
    grouped.putIfAbsent(feature.levelObtained, () => <Feature>[]).add(feature);
  }
  return grouped;
}
