import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
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
  final List<CompendiumPreviewRequest>? navigationTrail;

  const CompendiumEntityDetailScreen({
    super.key,
    required this.rulesetId,
    required this.entityType,
    required this.entityId,
    this.browseRepository,
    this.repository,
    this.navigationTrail,
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
  late List<CompendiumPreviewRequest> _navigationTrail;

  CompendiumBrowseRepository get _browseRepository =>
      widget.browseRepository ?? _fallbackBrowseRepository;

  CompendiumRepository get _repository =>
      widget.repository ?? _fallbackRepository;

  @override
  void initState() {
    super.initState();
    _navigationTrail =
        widget.navigationTrail == null || widget.navigationTrail!.isEmpty
        ? <CompendiumPreviewRequest>[
            CompendiumPreviewRequest(
              rulesetId: widget.rulesetId,
              entityType: widget.entityType,
              entityId: widget.entityId,
              browseRepository: widget.browseRepository,
            ),
          ]
        : List<CompendiumPreviewRequest>.from(widget.navigationTrail!);
    _futureState = _loadState();
  }

  CompendiumPreviewRequest get _currentRequest => _navigationTrail.last;

  Future<_EntityDetailState> _loadState() async {
    final ruleset = await _browseRepository.loadRulesetSummary(
      _currentRequest.rulesetId,
    );
    final detail = await _browseRepository.loadEntityDetail(
      rulesetId: _currentRequest.rulesetId,
      entityType: _currentRequest.entityType,
      entityId: _currentRequest.entityId,
    );
    final impact = await _browseRepository.loadEntityImpact(
      rulesetId: _currentRequest.rulesetId,
      entityType: _currentRequest.entityType,
      entityId: _currentRequest.entityId,
      entityName: detail.entity.displayName,
    );
    return _EntityDetailState(ruleset: ruleset, detail: detail, impact: impact);
  }

  Future<void> _reload() async {
    setState(() {
      _futureState = _loadState();
    });
    await _futureState;
  }

  void _syncCurrentRequestLabel(String label) {
    if ((_currentRequest.entityName ?? '').trim() == label.trim()) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          (_currentRequest.entityName ?? '').trim() == label.trim()) {
        return;
      }

      final updatedTrail = List<CompendiumPreviewRequest>.from(
        _navigationTrail,
      );
      final current = updatedTrail.removeLast();
      updatedTrail.add(
        CompendiumPreviewRequest(
          rulesetId: current.rulesetId,
          entityType: current.entityType,
          entityId: current.entityId,
          entityName: label,
          browseRepository: current.browseRepository ?? _browseRepository,
        ),
      );
      setState(() {
        _navigationTrail = updatedTrail;
      });
    });
  }

  void _focusTrailIndex(int index) {
    if (index < 0 || index >= _navigationTrail.length) {
      return;
    }

    setState(() {
      _navigationTrail = _navigationTrail
          .take(index + 1)
          .toList(growable: false);
      _futureState = _loadState();
    });
  }

  void _pushOrFocusTrail(CompendiumPreviewRequest request) {
    if (_currentRequest.key == request.key) {
      return;
    }

    final existingIndex = _navigationTrail.indexWhere(
      (candidate) => candidate.key == request.key,
    );

    setState(() {
      if (existingIndex >= 0) {
        _navigationTrail = _navigationTrail
            .take(existingIndex + 1)
            .toList(growable: false);
      } else {
        _navigationTrail = <CompendiumPreviewRequest>[
          ..._navigationTrail,
          request,
        ];
      }
      _futureState = _loadState();
    });
  }

  Future<void> _followLinkCandidate(CompendiumLinkCandidate candidate) async {
    final resolved = await _browseRepository.resolveLink(
      candidate,
      preferredRulesetId: _currentRequest.rulesetId,
    );
    if (!mounted) {
      return;
    }

    if (resolved == null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('This reference could not be resolved.')),
      );
      return;
    }

    _pushOrFocusTrail(
      CompendiumPreviewRequest(
        rulesetId: resolved.preview.rulesetId,
        entityType: resolved.preview.entityType,
        entityId: resolved.preview.entityId,
        entityName: resolved.preview.displayName,
        browseRepository: _browseRepository,
      ),
    );
  }

  Future<void> _editEntity(_EntityDetailState state) async {
    final updated = await Navigator.of(context).push<CompendiumEntity>(
      MaterialPageRoute(
        builder: (_) => RulesetObjectEditorScreen(
          rulesetId: state.ruleset.id,
          entityType: state.detail.entity.entityType,
          initialEntity: state.detail.entity,
          browseRepository: _browseRepository,
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
      appBar: AppBar(
        leading: _navigationTrail.length > 1
            ? IconButton(
                onPressed: () => _focusTrailIndex(_navigationTrail.length - 2),
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back in reference trail',
              )
            : null,
        actions: [
          FutureBuilder<_EntityDetailState>(
            future: _futureState,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state == null || state.ruleset.mode == 'bundled') {
                return const SizedBox.shrink();
              }
              return IconButton(
                onPressed: () => _editEntity(state),
                icon: const Icon(Icons.edit_outlined),
              );
            },
          ),
        ],
      ),
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
          _syncCurrentRequestLabel(entity.displayName);
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_navigationTrail.length > 1) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (
                        var index = 0;
                        index < _navigationTrail.length;
                        index += 1
                      )
                        ActionChip(
                          label: Text(_navigationTrail[index].label),
                          avatar: Icon(
                            index == _navigationTrail.length - 1
                                ? Icons.location_on_outlined
                                : Icons.chevron_right,
                            size: 18,
                          ),
                          onPressed: () => _focusTrailIndex(index),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: 0.18),
                        Theme.of(context).colorScheme.secondaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity.displayName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          CompendiumTypeBadge(entityType: entity.entityType),
                          Chip(
                            label: Text(
                              'Referenced by ${state.impact.inboundReferenceCount} entr${state.impact.inboundReferenceCount == 1 ? 'y' : 'ies'}',
                            ),
                          ),
                          Chip(
                            label: Text(
                              'Used by ${state.impact.characterUsageCount} character${state.impact.characterUsageCount == 1 ? '' : 's'}',
                            ),
                          ),
                          Chip(label: Text(state.ruleset.name)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (narrativeContent != null) ...[
                  CompendiumRichContentRenderer(
                    content: narrativeContent,
                    onLinkTap: (candidate) => openCompendiumLinkPreview(
                      context,
                      browseRepository: _browseRepository,
                      candidate: candidate,
                      preferredRulesetId: _currentRequest.rulesetId,
                      currentRulesetId: _currentRequest.rulesetId,
                      currentEntityType: _currentRequest.entityType,
                      currentEntityId: _currentRequest.entityId,
                      navigationTrail: List<CompendiumPreviewRequest>.from(
                        _navigationTrail,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                ExpansionTile(
                  title: const Text('Attributes'),
                  initiallyExpanded: true,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    CompendiumStructuredAttributesView(
                      entityType: entity.entityType,
                      data: data,
                      onLinkTap: (candidate) => openCompendiumLinkPreview(
                        context,
                        browseRepository: _browseRepository,
                        candidate: candidate,
                        preferredRulesetId: _currentRequest.rulesetId,
                        currentRulesetId: _currentRequest.rulesetId,
                        currentEntityType: _currentRequest.entityType,
                        currentEntityId: _currentRequest.entityId,
                        navigationTrail: List<CompendiumPreviewRequest>.from(
                          _navigationTrail,
                        ),
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
                const SizedBox(height: 16),
                CompendiumEntitySummarySections(
                  entityType: entity.entityType,
                  data: data,
                  compact: false,
                  onLinkTap: (candidate) => openCompendiumLinkPreview(
                    context,
                    browseRepository: _browseRepository,
                    candidate: candidate,
                    preferredRulesetId: _currentRequest.rulesetId,
                    currentRulesetId: _currentRequest.rulesetId,
                    currentEntityType: _currentRequest.entityType,
                    currentEntityId: _currentRequest.entityId,
                    navigationTrail: List<CompendiumPreviewRequest>.from(
                      _navigationTrail,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (state.detail.outgoingLinks.isNotEmpty) ...[
                  ExpansionTile(
                    title: const Text('Linked References'),
                    subtitle: Text(
                      '${state.detail.outgoingLinks.length} previewable reference${state.detail.outgoingLinks.length == 1 ? '' : 's'}',
                    ),
                    initiallyExpanded: true,
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: state.detail.outgoingLinks
                        .map(
                          (candidate) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(candidate.displayText),
                            subtitle: Text(candidate.tag),
                            leading: const Icon(Icons.link_outlined),
                            trailing: Wrap(
                              spacing: 4,
                              children: [
                                IconButton(
                                  tooltip: 'Preview',
                                  onPressed: () => openCompendiumLinkPreview(
                                    context,
                                    browseRepository: _browseRepository,
                                    candidate: candidate,
                                    preferredRulesetId:
                                        _currentRequest.rulesetId,
                                    currentRulesetId: _currentRequest.rulesetId,
                                    currentEntityType:
                                        _currentRequest.entityType,
                                    currentEntityId: _currentRequest.entityId,
                                    navigationTrail:
                                        List<CompendiumPreviewRequest>.from(
                                          _navigationTrail,
                                        ),
                                  ),
                                  icon: const Icon(Icons.visibility_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Open in this detail page',
                                  onPressed: () =>
                                      _followLinkCandidate(candidate),
                                  icon: const Icon(
                                    Icons.open_in_browser_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 16),
                ],
                ExpansionTile(
                  title: const Text('Impact'),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.link_outlined),
                      title: Text(
                        'Referenced by ${state.impact.inboundReferenceCount} compendium entr${state.impact.inboundReferenceCount == 1 ? 'y' : 'ies'}',
                      ),
                      subtitle: const Text(
                        'Inbound references are calculated from the locally indexed ruleset data.',
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: Text(
                        'Used by ${state.impact.characterUsageCount} saved character${state.impact.characterUsageCount == 1 ? '' : 's'}',
                      ),
                      subtitle: const Text(
                        'Character usage is counted from local saved character selections.',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EntityDetailState {
  final RulesetSummary ruleset;
  final CompendiumEntityDetail detail;
  final CompendiumEntityImpact impact;

  const _EntityDetailState({
    required this.ruleset,
    required this.detail,
    required this.impact,
  });
}
