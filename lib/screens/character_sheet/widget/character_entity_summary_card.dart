import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_summary_sections.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';

class CharacterEntitySummaryCard extends StatefulWidget {
  final String title;
  final CharacterEntityRef? reference;
  final CharacterCompendiumService service;
  final bool compact;
  final bool embedded;
  final bool showTitle;

  const CharacterEntitySummaryCard({
    super.key,
    required this.title,
    required this.reference,
    required this.service,
    this.compact = true,
    this.embedded = false,
    this.showTitle = true,
  });

  @override
  State<CharacterEntitySummaryCard> createState() =>
      _CharacterEntitySummaryCardState();
}

class _CharacterEntitySummaryCardState
    extends State<CharacterEntitySummaryCard> {
  Future<CharacterResolvedEntity?>? _futureEntity;

  @override
  void initState() {
    super.initState();
    _futureEntity = _load();
  }

  @override
  void didUpdateWidget(covariant CharacterEntitySummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reference != widget.reference) {
      _futureEntity = _load();
    }
  }

  Future<CharacterResolvedEntity?> _load() {
    final reference = widget.reference;
    if (reference == null) {
      return Future<CharacterResolvedEntity?>.value(null);
    }
    return widget.service.loadResolvedEntity(reference);
  }

  @override
  Widget build(BuildContext context) {
    final reference = widget.reference;
    if (reference == null) {
      final empty = widget.embedded
          ? Text(
              'Nothing selected yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          : Card(
              child: ListTile(
                title: Text(widget.title),
                subtitle: const Text('Nothing selected yet.'),
              ),
            );
      return empty;
    }

    return FutureBuilder<CharacterResolvedEntity?>(
      future: _futureEntity,
      builder: (context, snapshot) {
        final resolved = snapshot.data;
        final displayName =
            resolved?.detail.entity.displayName ?? reference.displayName;
        final entityType =
            resolved?.detail.entity.entityType ?? reference.entityType;
        final rulesetName = resolved?.rulesetName;
        final canPreview = reference.isResolved;
        void preview() {
          if (!canPreview) {
            return;
          }
          showCompendiumEntityPreviewSurface(
            context,
            rulesetId: reference.rulesetId,
            entityType: reference.entityType,
            entityId: reference.entityId,
            entityName: displayName,
            browseRepository: widget.service.browseRepository,
          );
        }

        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.showTitle) ...[
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 6),
                      ],
                      CompendiumReferenceAnchor(
                        rulesetId: reference.rulesetId,
                        entityType: reference.entityType,
                        entityId: reference.entityId,
                        entityName: displayName,
                        browseRepository: widget.service.browseRepository,
                        onTap: canPreview ? preview : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            displayName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Preview',
                  icon: const Icon(Icons.visibility_outlined),
                  onPressed: canPreview ? preview : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CompendiumReferenceAnchor(
                  rulesetId: reference.rulesetId,
                  entityType: reference.entityType,
                  entityId: reference.entityId,
                  entityName: displayName,
                  browseRepository: widget.service.browseRepository,
                  onTap: canPreview ? preview : null,
                  child: IgnorePointer(
                    child: CompendiumTypeBadge(entityType: entityType),
                  ),
                ),
                if (rulesetName != null && rulesetName.trim().isNotEmpty)
                  ActionChip(
                    label: Text(rulesetName),
                    onPressed: canPreview ? preview : null,
                  ),
              ],
            ),
            if (!reference.isResolved || resolved == null) ...[
              const SizedBox(height: 12),
              Text(
                'This saved rules reference needs attention. Choose a replacement to restore previews and character details.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            if (resolved != null) ...[
              const SizedBox(height: 12),
              CompendiumEntitySummarySections(
                entityType: resolved.detail.entity.entityType,
                data: resolved.detail.entity.data,
                compact: widget.compact,
                onLinkTap: (candidate) => openCompendiumLinkPreview(
                  context,
                  browseRepository: widget.service.browseRepository,
                  candidate: candidate,
                  preferredRulesetId: resolved.ref.rulesetId,
                  currentRulesetId: resolved.ref.rulesetId,
                  currentEntityType: resolved.ref.entityType,
                  currentEntityId: resolved.ref.entityId,
                ),
              ),
            ],
          ],
        );

        if (widget.embedded) {
          return content;
        }

        return Card(
          child: Padding(padding: const EdgeInsets.all(16), child: content),
        );
      },
    );
  }
}
