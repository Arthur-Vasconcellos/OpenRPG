import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_summary_sections.dart';
import 'package:openrpg/screens/rulesets/compendium_rich_content_renderer.dart';
import 'package:openrpg/screens/rulesets/compendium_structured_attributes.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';
import 'package:openrpg/screens/rulesets/ruleset_object_editor_screen.dart';

class CompendiumEntityDetailScreen extends StatefulWidget {
  final String rulesetId;
  final String entityType;
  final String entityId;
  final CompendiumBrowseRepository? browseRepository;
  final CompendiumRepository? repository;

  const CompendiumEntityDetailScreen({
    super.key,
    required this.rulesetId,
    required this.entityType,
    required this.entityId,
    this.browseRepository,
    this.repository,
  });

  @override
  State<CompendiumEntityDetailScreen> createState() =>
      _CompendiumEntityDetailScreenState();
}

class _CompendiumEntityDetailScreenState
    extends State<CompendiumEntityDetailScreen> {
  late final CompendiumBrowseRepository _fallbackBrowseRepository =
      CompendiumBrowseRepository();
  late final CompendiumRepository _fallbackRepository = CompendiumRepository();
  late Future<_EntityDetailState> _futureState;

  CompendiumBrowseRepository get _browseRepository =>
      widget.browseRepository ?? _fallbackBrowseRepository;

  CompendiumRepository get _repository =>
      widget.repository ?? _fallbackRepository;

  @override
  void initState() {
    super.initState();
    _futureState = _loadState();
  }

  Future<_EntityDetailState> _loadState() async {
    final ruleset = await _browseRepository.loadRulesetSummary(
      widget.rulesetId,
    );
    final detail = await _browseRepository.loadEntityDetail(
      rulesetId: widget.rulesetId,
      entityType: widget.entityType,
      entityId: widget.entityId,
    );
    return _EntityDetailState(ruleset: ruleset, detail: detail);
  }

  Future<void> _reload() async {
    setState(() {
      _futureState = _loadState();
    });
    await _futureState;
  }

  Future<void> _editEntity(_EntityDetailState state) async {
    final updated = await Navigator.of(context).push<CompendiumEntity>(
      MaterialPageRoute(
        builder: (_) => RulesetObjectEditorScreen(
          entityType: state.detail.entity.entityType,
          initialEntity: state.detail.entity,
        ),
      ),
    );
    if (updated == null) {
      return;
    }

    await _repository.saveEntity(rulesetId: state.ruleset.id, entity: updated);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<_EntityDetailState>(
        future: _futureState,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Failed to load entity.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final state = snapshot.data!;
          final entity = state.detail.entity;
          final data = entity.data;
          final accent = CompendiumTypeStyle.colorFor(entity.entityType);
          final narrativeContent =
              data['entries'] ??
              data['entry'] ??
              data['items'] ??
              data['description'];
          final summaryHiddenKeys = compendiumSummaryHiddenKeysFor(
            entity.entityType,
          );

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 200,
                actions: [
                  if (state.ruleset.mode != 'bundled')
                    IconButton(
                      onPressed: () => _editEntity(state),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  title: Text(
                    entity.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent.withValues(alpha: 0.18),
                          Theme.of(context).colorScheme.secondaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [CompendiumTypeBadge(entityType: entity.entityType)],
                    ),
                    const SizedBox(height: 20),
                    CompendiumEntitySummarySections(
                      entityType: entity.entityType,
                      data: data,
                      compact: false,
                      onLinkTap: (candidate) => openCompendiumLinkPreview(
                        context,
                        browseRepository: _browseRepository,
                        candidate: candidate,
                        preferredRulesetId: widget.rulesetId,
                        currentRulesetId: widget.rulesetId,
                        currentEntityType: widget.entityType,
                        currentEntityId: widget.entityId,
                      ),
                    ),
                    if (narrativeContent != null)
                      CompendiumRichContentRenderer(
                        content: narrativeContent,
                        onLinkTap: (candidate) => openCompendiumLinkPreview(
                          context,
                          browseRepository: _browseRepository,
                          candidate: candidate,
                          preferredRulesetId: widget.rulesetId,
                          currentRulesetId: widget.rulesetId,
                          currentEntityType: widget.entityType,
                          currentEntityId: widget.entityId,
                        ),
                      ),
                    ExpansionTile(
                      title: const Text('Attributes'),
                      initiallyExpanded: narrativeContent == null,
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        CompendiumStructuredAttributesView(
                          entityType: entity.entityType,
                          data: data,
                          onLinkTap: (candidate) => openCompendiumLinkPreview(
                            context,
                            browseRepository: _browseRepository,
                            candidate: candidate,
                            preferredRulesetId: widget.rulesetId,
                            currentRulesetId: widget.rulesetId,
                            currentEntityType: widget.entityType,
                            currentEntityId: widget.entityId,
                          ),
                          hiddenKeys: const {
                            'name',
                            'entries',
                            'entry',
                            'items',
                            'description',
                          }.union(summaryHiddenKeys),
                          emptyText: 'No additional attributes.',
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EntityDetailState {
  final RulesetSummary ruleset;
  final CompendiumEntityDetail detail;

  const _EntityDetailState({required this.ruleset, required this.detail});
}
