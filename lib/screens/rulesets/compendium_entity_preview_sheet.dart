import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/compendium_rich_content_renderer.dart';
import 'package:openrpg/screens/rulesets/compendium_structured_attributes.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';

const double _compendiumPreviewCompactBreakpoint = 720;

Future<void> showCompendiumEntityPreviewSurface(
  BuildContext context, {
  required String rulesetId,
  required String entityType,
  required String entityId,
  CompendiumBrowseRepository? browseRepository,
}) {
  final width = MediaQuery.sizeOf(context).width;
  final compact = width < _compendiumPreviewCompactBreakpoint;

  if (compact) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => KeyedSubtree(
        key: const Key('compendium-preview-sheet'),
        child: CompendiumEntityPreviewPanel(
          rulesetId: rulesetId,
          entityType: entityType,
          entityId: entityId,
          browseRepository: browseRepository,
          compact: true,
        ),
      ),
    );
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Dialog(
        key: const Key('compendium-preview-dialog'),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 760,
            maxHeight: MediaQuery.sizeOf(context).height * 0.88,
          ),
          child: CompendiumEntityPreviewPanel(
            rulesetId: rulesetId,
            entityType: entityType,
            entityId: entityId,
            browseRepository: browseRepository,
            compact: false,
          ),
        ),
      );
    },
  );
}

Future<void> showCompendiumEntityPreviewSheet(
  BuildContext context, {
  required String rulesetId,
  required String entityType,
  required String entityId,
  CompendiumBrowseRepository? browseRepository,
}) {
  return showCompendiumEntityPreviewSurface(
    context,
    rulesetId: rulesetId,
    entityType: entityType,
    entityId: entityId,
    browseRepository: browseRepository,
  );
}

Future<void> openCompendiumLinkPreview(
  BuildContext context, {
  required CompendiumBrowseRepository browseRepository,
  required CompendiumLinkCandidate candidate,
  required String preferredRulesetId,
  String? currentRulesetId,
  String? currentEntityType,
  String? currentEntityId,
}) async {
  final resolved = await browseRepository.resolveLink(
    candidate,
    preferredRulesetId: preferredRulesetId,
  );

  if (!context.mounted) {
    return;
  }

  if (resolved == null) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(content: Text('Preview unavailable for this reference.')),
    );
    return;
  }

  if (resolved.preview.rulesetId == currentRulesetId &&
      resolved.preview.entityType == currentEntityType &&
      resolved.preview.entityId == currentEntityId) {
    return;
  }

  await showCompendiumEntityPreviewSurface(
    context,
    rulesetId: resolved.preview.rulesetId,
    entityType: resolved.preview.entityType,
    entityId: resolved.preview.entityId,
    browseRepository: browseRepository,
  );
}

class CompendiumEntityPreviewPanel extends StatefulWidget {
  final String rulesetId;
  final String entityType;
  final String entityId;
  final CompendiumBrowseRepository? browseRepository;
  final bool compact;

  const CompendiumEntityPreviewPanel({
    super.key,
    required this.rulesetId,
    required this.entityType,
    required this.entityId,
    this.browseRepository,
    required this.compact,
  });

  @override
  State<CompendiumEntityPreviewPanel> createState() =>
      _CompendiumEntityPreviewPanelState();
}

class _CompendiumEntityPreviewPanelState
    extends State<CompendiumEntityPreviewPanel> {
  late final CompendiumBrowseRepository _fallbackBrowseRepository =
      CompendiumBrowseRepository();
  late Future<_PreviewPanelState> _futureState;

  CompendiumBrowseRepository get _browseRepository =>
      widget.browseRepository ?? _fallbackBrowseRepository;

  @override
  void initState() {
    super.initState();
    _futureState = _loadState();
  }

  Future<_PreviewPanelState> _loadState() async {
    final ruleset = await _browseRepository.loadRulesetSummary(
      widget.rulesetId,
    );
    final detail = await _browseRepository.loadEntityDetail(
      rulesetId: widget.rulesetId,
      entityType: widget.entityType,
      entityId: widget.entityId,
    );
    return _PreviewPanelState(ruleset: ruleset, detail: detail);
  }

  Future<void> _handleLinkTap(CompendiumLinkCandidate candidate) async {
    await openCompendiumLinkPreview(
      context,
      browseRepository: _browseRepository,
      candidate: candidate,
      preferredRulesetId: widget.rulesetId,
      currentRulesetId: widget.rulesetId,
      currentEntityType: widget.entityType,
      currentEntityId: widget.entityId,
    );
  }

  Future<void> _openFullEntry(CompendiumEntityDetail detail) async {
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    final localNavigator = Navigator.of(context);
    if (localNavigator.canPop()) {
      localNavigator.pop();
    }

    await rootNavigator.push(
      MaterialPageRoute(
        builder: (_) => CompendiumEntityDetailScreen(
          rulesetId: widget.rulesetId,
          entityType: detail.entity.entityType,
          entityId: detail.entity.id,
          browseRepository: _browseRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_PreviewPanelState>(
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
        final bodyPadding = widget.compact ? 20.0 : 24.0;

        return Column(
          key: const Key('compendium-preview-panel'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(bodyPadding, 16, bodyPadding, 20),
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
                padding: EdgeInsets.all(bodyPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (narrativeContent != null)
                      CompendiumRichContentRenderer(
                        content: narrativeContent,
                        onLinkTap: _handleLinkTap,
                      )
                    else ...[
                      Text(
                        'Narrative text is unavailable for this entry. Showing structured attributes instead.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      CompendiumStructuredAttributesView(
                        entityType: entity.entityType,
                        data: data,
                        onLinkTap: _handleLinkTap,
                        compact: widget.compact,
                        hiddenKeys: const {
                          'name',
                          'source',
                          'edition',
                          'entries',
                          'entry',
                          'items',
                          'description',
                        },
                        emptyText: 'No structured attributes are available.',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(bodyPadding, 0, bodyPadding, 20),
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
    );
  }
}

class _PreviewPanelState {
  final RulesetSummary ruleset;
  final CompendiumEntityDetail detail;

  const _PreviewPanelState({required this.ruleset, required this.detail});
}
