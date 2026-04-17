import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
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
    final browseRepository = CompendiumBrowseRepository();
    final sections = <_FeatureSection>[
      _FeatureSection(
        title: 'Class Features',
        icon: Icons.class_outlined,
        features: resolved.classFeatures,
      ),
      _FeatureSection(
        title: 'Subclass Features',
        icon: Icons.account_tree_outlined,
        features: resolved.subclassFeatures,
      ),
      _FeatureSection(
        title: 'Race Traits',
        icon: Icons.people_outline,
        features: character.racialTraits,
      ),
      _FeatureSection(
        title: 'Background Traits',
        icon: Icons.work_outline,
        features: character.backgroundTraits,
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
                  'Open a feature directly, or expand it and follow any linked entries inside the narrative.',
                  style: Theme.of(context).textTheme.bodyMedium,
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
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (section.features.isEmpty)
                      Text(
                        'No entries yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else
                      ...section.features.map(
                        (feature) => FeatureItem(
                          feature: feature,
                          onOpenReference: feature.reference == null
                              ? null
                              : () {
                                  final ref = feature.reference!;
                                  showCompendiumEntityPreviewSurface(
                                    context,
                                    rulesetId: ref.rulesetId,
                                    entityType: ref.entityType,
                                    entityId: ref.entityId,
                                  );
                                },
                          onLinkTap: (candidate) => openCompendiumLinkPreview(
                            context,
                            browseRepository: browseRepository,
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

  const _FeatureSection({
    required this.title,
    required this.icon,
    required this.features,
  });
}
