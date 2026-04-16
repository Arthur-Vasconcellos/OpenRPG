import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/compendium_rich_content_renderer.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';

Future<void> showCompendiumEntityPreviewSheet(
  BuildContext context, {
  required String rulesetId,
  required String entityType,
  required String entityId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => CompendiumEntityPreviewSheet(
      rulesetId: rulesetId,
      entityType: entityType,
      entityId: entityId,
    ),
  );
}

class CompendiumEntityPreviewSheet extends StatefulWidget {
  final String rulesetId;
  final String entityType;
  final String entityId;

  const CompendiumEntityPreviewSheet({
    super.key,
    required this.rulesetId,
    required this.entityType,
    required this.entityId,
  });

  @override
  State<CompendiumEntityPreviewSheet> createState() =>
      _CompendiumEntityPreviewSheetState();
}

class _CompendiumEntityPreviewSheetState
    extends State<CompendiumEntityPreviewSheet> {
  final CompendiumBrowseRepository _browseRepository =
      CompendiumBrowseRepository();
  late Future<_PreviewSheetState> _futureState;

  @override
  void initState() {
    super.initState();
    _futureState = _loadState();
  }

  Future<_PreviewSheetState> _loadState() async {
    final ruleset = await _browseRepository.loadRulesetSummary(
      widget.rulesetId,
    );
    final detail = await _browseRepository.loadEntityDetail(
      rulesetId: widget.rulesetId,
      entityType: widget.entityType,
      entityId: widget.entityId,
    );
    return _PreviewSheetState(ruleset: ruleset, detail: detail);
  }

  Future<void> _openNestedPreview(CompendiumSearchResult? result) async {
    if (result == null || !mounted) {
      return;
    }

    await showCompendiumEntityPreviewSheet(
      context,
      rulesetId: result.preview.rulesetId,
      entityType: result.preview.entityType,
      entityId: result.preview.entityId,
    );
  }

  Future<void> _openFullEntry(CompendiumEntityDetail detail) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompendiumEntityDetailScreen(
          rulesetId: widget.rulesetId,
          entityType: detail.entity.entityType,
          entityId: detail.entity.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.88;
    return SizedBox(
      height: maxHeight,
      child: FutureBuilder<_PreviewSheetState>(
        future: _futureState,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Failed to load preview.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final state = snapshot.data!;
          final entity = state.detail.entity;
          final data = entity.data;
          final narrativeContent =
              data['entries'] ??
              data['entry'] ??
              data['items'] ??
              data['description'];
          final accent = CompendiumTypeStyle.colorFor(entity.entityType);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.18),
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entity.displayName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        CompendiumTypeBadge(entityType: entity.entityType),
                        if (entity.source.trim().isNotEmpty)
                          Chip(label: Text('Source: ${entity.source}')),
                        if (entity.edition?.trim().isNotEmpty == true)
                          Chip(label: Text('Edition: ${entity.edition}')),
                        if (state.ruleset.name.trim().isNotEmpty)
                          Chip(label: Text(state.ruleset.name)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (narrativeContent != null)
                        CompendiumRichContentRenderer(
                          content: narrativeContent,
                          onLinkTap: (candidate) async {
                            final resolved = await _browseRepository
                                .resolveLink(
                                  candidate,
                                  preferredRulesetId: widget.rulesetId,
                                );
                            await _openNestedPreview(resolved);
                          },
                        )
                      else
                        const Text('No narrative preview is available.'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _openFullEntry(state.detail),
                    child: const Text('Open Full Entry'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PreviewSheetState {
  final RulesetSummary ruleset;
  final CompendiumEntityDetail detail;

  const _PreviewSheetState({required this.ruleset, required this.detail});
}
