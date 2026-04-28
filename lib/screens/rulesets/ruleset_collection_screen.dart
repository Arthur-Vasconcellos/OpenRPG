import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_relationship_validator.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/compendium/models/ruleset.dart';
import 'package:openrpg/screens/characters/character_creation_flow.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';
import 'package:openrpg/screens/rulesets/ruleset_object_editor_screen.dart';

class RulesetCollectionScreen extends StatefulWidget {
  final String rulesetId;
  final String entityType;

  const RulesetCollectionScreen({
    super.key,
    required this.rulesetId,
    required this.entityType,
  });

  @override
  State<RulesetCollectionScreen> createState() =>
      _RulesetCollectionScreenState();
}

class _RulesetCollectionScreenState extends State<RulesetCollectionScreen> {
  final CompendiumBrowseRepository _browseRepository =
      CompendiumBrowseRepository();
  final CompendiumRepository _repository = CompendiumRepository();
  final TextEditingController _searchController = TextEditingController();

  RulesetSummary? _summary;
  final List<CompendiumEntityPreview> _items = [];
  CompendiumEntityPreview? _selectedPreview;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _page = 0;
  Timer? _searchDebounce;
  final Set<String> _selectedEntityKeys = <String>{};
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    unawaited(_reload());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) {
        return;
      }
      unawaited(_reload());
    });
  }

  Future<void> _reload() async {
    setState(() {
      _isInitialLoading = true;
      _page = 0;
    });

    final summary = await _browseRepository.loadRulesetSummary(
      widget.rulesetId,
    );
    final page = await _browseRepository.loadCollectionPage(
      rulesetId: widget.rulesetId,
      entityType: widget.entityType,
      query: _searchController.text,
      page: 0,
      pageSize: 100,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _summary = summary;
      _items
        ..clear()
        ..addAll(page.items);
      _hasMore = page.hasMore;
      _selectedPreview = _items.isEmpty ? null : _items.first;
      _selectedEntityKeys.removeWhere(
        (key) => !_items.any((item) => _entitySelectionKey(item) == key),
      );
      if (_selectionMode && _selectedEntityKeys.isEmpty) {
        _selectionMode = false;
      }
      _isInitialLoading = false;
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _page + 1;
    final page = await _browseRepository.loadCollectionPage(
      rulesetId: widget.rulesetId,
      entityType: widget.entityType,
      query: _searchController.text,
      page: nextPage,
      pageSize: 100,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _page = nextPage;
      _items.addAll(page.items);
      _hasMore = page.hasMore;
      _isLoadingMore = false;
      _selectedPreview ??= _items.isEmpty ? null : _items.first;
    });
  }

  Future<void> _editEntity([CompendiumEntity? entity]) async {
    final updated = await Navigator.of(context).push<CompendiumEntity>(
      MaterialPageRoute(
        builder: (_) => RulesetObjectEditorScreen(
          rulesetId: widget.rulesetId,
          entityType: widget.entityType,
          initialEntity: entity,
          browseRepository: _browseRepository,
        ),
      ),
    );
    if (updated == null) {
      return;
    }

    await _repository.saveEntity(rulesetId: widget.rulesetId, entity: updated);
    await _reload();
  }

  Future<void> _deleteEntity(CompendiumEntityPreview entity) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entity'),
        content: Text('Delete ${entity.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    await _repository.deleteEntity(
      rulesetId: widget.rulesetId,
      entityType: entity.entityType,
      entityId: entity.entityId,
    );
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final descriptor = descriptorForType(widget.entityType);
    final canEdit = _summary?.mode != RulesetMode.bundled.name;
    final wide = MediaQuery.sizeOf(context).width >= 1040;

    return Scaffold(
      appBar: AppBar(
        title: Text(descriptor?.collection.label ?? widget.entityType),
      ),
      floatingActionButton: !canEdit
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _editEntity(),
              icon: const Icon(Icons.add),
              label: const Text('Add Entity'),
            ),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              CompendiumTypeBadge(
                                entityType: widget.entityType,
                                label: descriptor?.collection.label,
                              ),
                              if (_summary?.mode == RulesetMode.bundled.name)
                                const Chip(label: Text('Read-only starter')),
                              if (_summary?.mode != RulesetMode.bundled.name)
                                const Chip(label: Text('Editable')),
                              ActionChip(
                                label: const Text('Use Ruleset For Character'),
                                avatar: const Icon(Icons.auto_awesome_outlined),
                                onPressed: () => createCharacterFromRulesetFlow(
                                  context,
                                  preselectedRulesetId: widget.rulesetId,
                                ),
                              ),
                              ActionChip(
                                label: Text(
                                  _selectionMode
                                      ? 'Done Selecting'
                                      : 'Select Entries',
                                ),
                                avatar: Icon(
                                  _selectionMode
                                      ? Icons.check_circle_outline
                                      : Icons.checklist_rtl_outlined,
                                ),
                                onPressed: _toggleSelectionMode,
                              ),
                              ActionChip(
                                label: Text(
                                  _selectedEntityKeys.isEmpty
                                      ? 'Validate Visible Links'
                                      : 'Validate Selected Links',
                                ),
                                avatar: const Icon(Icons.rule_folder_outlined),
                                onPressed: _items.isEmpty
                                    ? null
                                    : () => _validateEntries(
                                        selectedOnly:
                                            _selectedEntityKeys.isNotEmpty,
                                      ),
                              ),
                              if (_selectedEntityKeys.isNotEmpty)
                                Chip(
                                  label: Text(
                                    '${_selectedEntityKeys.length} selected',
                                  ),
                                ),
                              if (wide)
                                const Chip(label: Text('Split preview active')),
                            ],
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search this collection',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: _items.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              canEdit
                                  ? 'No entities matched this collection yet. Use Add Entity to start authoring.'
                                  : 'No entities matched this collection.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : wide
                      ? Row(
                          children: [
                            Expanded(
                              child: _buildListContent(
                                context,
                                canEdit: canEdit,
                                wide: true,
                              ),
                            ),
                            SizedBox(
                              width: 420,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  16,
                                  16,
                                ),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: _selectedPreview == null
                                      ? const Center(
                                          child: Text(
                                            'Select an entry to keep a pinned preview visible while you browse.',
                                          ),
                                        )
                                      : CompendiumEntityPreviewPanel(
                                          key: ValueKey(
                                            _selectedPreview!.entityId,
                                          ),
                                          rulesetId:
                                              _selectedPreview!.rulesetId,
                                          entityType:
                                              _selectedPreview!.entityType,
                                          entityId: _selectedPreview!.entityId,
                                          browseRepository: _browseRepository,
                                          compact: false,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _buildListContent(
                          context,
                          canEdit: canEdit,
                          wide: false,
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildListContent(
    BuildContext context, {
    required bool canEdit,
    required bool wide,
  }) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return Center(
            child: FilledButton.tonal(
              onPressed: _isLoadingMore ? null : _loadMore,
              child: Text(_isLoadingMore ? 'Loading...' : 'Load more'),
            ),
          );
        }

        final entity = _items[index];
        final selected =
            _selectedPreview?.entityType == entity.entityType &&
            _selectedPreview?.entityId == entity.entityId;
        return Card(
          color: selected
              ? Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.55)
              : null,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              if (_selectionMode) {
                _toggleEntitySelection(entity);
                return;
              }
              if (wide) {
                _selectPreview(entity);
                return;
              }
              _openEntity(entity);
            },
            onLongPress: () => _activateSelectionMode(entity),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectionMode) ...[
                        Checkbox(
                          value: _selectedEntityKeys.contains(
                            _entitySelectionKey(entity),
                          ),
                          onChanged: (_) => _toggleEntitySelection(entity),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: CompendiumReferenceAnchor(
                          rulesetId: widget.rulesetId,
                          entityType: entity.entityType,
                          entityId: entity.entityId,
                          entityName: entity.displayName,
                          onTap: () {
                            showCompendiumEntityPreviewSurface(
                              context,
                              rulesetId: widget.rulesetId,
                              entityType: entity.entityType,
                              entityId: entity.entityId,
                              entityName: entity.displayName,
                              browseRepository: _browseRepository,
                            );
                          },
                          child: Text(
                            entity.displayName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: wide ? 'Pin in preview pane' : 'Preview',
                        icon: Icon(
                          wide
                              ? Icons.view_sidebar_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => wide
                            ? _selectPreview(entity)
                            : showCompendiumEntityPreviewSurface(
                                context,
                                rulesetId: widget.rulesetId,
                                entityType: entity.entityType,
                                entityId: entity.entityId,
                                entityName: entity.displayName,
                                browseRepository: _browseRepository,
                              ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          switch (value) {
                            case 'open':
                              await _openEntity(entity);
                              break;
                            case 'copy':
                              await Clipboard.setData(
                                ClipboardData(
                                  text:
                                      '${entity.entityType}|${entity.displayName}|${entity.entityId}',
                                ),
                              );
                              if (!mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied link target.'),
                                ),
                              );
                              break;
                            case 'edit':
                              final detail = await _browseRepository
                                  .loadEntityDetail(
                                    rulesetId: widget.rulesetId,
                                    entityType: entity.entityType,
                                    entityId: entity.entityId,
                                  );
                              await _editEntity(detail.entity);
                              break;
                            case 'delete':
                              await _deleteEntity(entity);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'open',
                            child: Text('Open full entry'),
                          ),
                          const PopupMenuItem(
                            value: 'copy',
                            child: Text('Copy link target'),
                          ),
                          if (canEdit)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                          if (canEdit)
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      CompendiumReferenceAnchor(
                        rulesetId: widget.rulesetId,
                        entityType: entity.entityType,
                        entityId: entity.entityId,
                        entityName: entity.displayName,
                        onTap: () {
                          showCompendiumEntityPreviewSurface(
                            context,
                            rulesetId: widget.rulesetId,
                            entityType: entity.entityType,
                            entityId: entity.entityId,
                            entityName: entity.displayName,
                            browseRepository: _browseRepository,
                          );
                        },
                        child: IgnorePointer(
                          child: CompendiumTypeBadge(
                            entityType: entity.entityType,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(
                          '${entity.inboundReferenceCount} inbound refs',
                        ),
                      ),
                      Chip(
                        label: Text(
                          '${entity.characterUsageCount} character uses',
                        ),
                      ),
                    ],
                  ),
                  if (entity.snippet.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      entity.snippet,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  if (entity.entityId.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      entity.entityId,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectPreview(CompendiumEntityPreview entity) {
    setState(() {
      _selectedPreview = entity;
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) {
        _selectedEntityKeys.clear();
      }
    });
  }

  void _activateSelectionMode(CompendiumEntityPreview entity) {
    setState(() {
      _selectionMode = true;
      _selectedEntityKeys.add(_entitySelectionKey(entity));
    });
  }

  void _toggleEntitySelection(CompendiumEntityPreview entity) {
    final key = _entitySelectionKey(entity);
    setState(() {
      _selectionMode = true;
      if (_selectedEntityKeys.contains(key)) {
        _selectedEntityKeys.remove(key);
      } else {
        _selectedEntityKeys.add(key);
      }
      if (_selectedEntityKeys.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  String _entitySelectionKey(CompendiumEntityPreview entity) =>
      '${entity.entityType}:${entity.entityId}';

  Future<void> _validateEntries({required bool selectedOnly}) async {
    final candidates = selectedOnly
        ? _items
              .where(
                (item) =>
                    _selectedEntityKeys.contains(_entitySelectionKey(item)),
              )
              .toList(growable: false)
        : List<CompendiumEntityPreview>.from(_items);

    if (candidates.isEmpty) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text('Validating references for this collection...'),
            ),
          ],
        ),
      ),
    );

    final reports = await Future.wait(
      candidates.map((entity) async {
        final detail = await _browseRepository.loadEntityDetail(
          rulesetId: entity.rulesetId,
          entityType: entity.entityType,
          entityId: entity.entityId,
        );
        return validateCompendiumEntityData(
          browseRepository: _browseRepository,
          rulesetId: entity.rulesetId,
          entityType: entity.entityType,
          entityId: entity.entityId,
          displayName: entity.displayName,
          data: detail.entity.data,
        );
      }),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();

    await showDialog<void>(
      context: context,
      builder: (context) => _CollectionValidationDialog(
        summary: _CollectionValidationSummary(
          entityType: widget.entityType,
          validatedEntries: candidates.length,
          reports: reports,
          selectedOnly: selectedOnly,
        ),
      ),
    );
  }

  Future<void> _openEntity(CompendiumEntityPreview entity) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompendiumEntityDetailScreen(
          rulesetId: widget.rulesetId,
          entityType: entity.entityType,
          entityId: entity.entityId,
          browseRepository: _browseRepository,
          repository: _repository,
        ),
      ),
    );
    await _reload();
  }
}

class _CollectionValidationSummary {
  final String entityType;
  final int validatedEntries;
  final List<CompendiumEntityValidationReport> reports;
  final bool selectedOnly;

  const _CollectionValidationSummary({
    required this.entityType,
    required this.validatedEntries,
    required this.reports,
    required this.selectedOnly,
  });

  int get totalIssues =>
      reports.fold<int>(0, (sum, report) => sum + report.issues.length);

  int get unresolvedReferences => reports.fold<int>(
    0,
    (sum, report) => sum + report.unresolvedReferenceCount,
  );

  int get malformedTokens =>
      reports.fold<int>(0, (sum, report) => sum + report.malformedTokenCount);

  List<CompendiumEntityValidationReport> get flaggedReports =>
      reports.where((report) => report.hasIssues).toList(growable: false);
}

class _CollectionValidationDialog extends StatelessWidget {
  final _CollectionValidationSummary summary;

  const _CollectionValidationDialog({required this.summary});

  @override
  Widget build(BuildContext context) {
    final flaggedReports = summary.flaggedReports;
    return AlertDialog(
      title: Text(
        summary.selectedOnly
            ? 'Selected Entry Validation'
            : 'Visible Collection Validation',
      ),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                flaggedReports.isEmpty
                    ? 'Validated ${summary.validatedEntries} ${summary.entityType} entr${summary.validatedEntries == 1 ? 'y' : 'ies'} and found no broken references.'
                    : 'Validated ${summary.validatedEntries} ${summary.entityType} entr${summary.validatedEntries == 1 ? 'y' : 'ies'} and flagged ${flaggedReports.length} with issues.',
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Chip(
                    label: Text('${summary.validatedEntries} entries checked'),
                  ),
                  Chip(label: Text('${summary.totalIssues} issues')),
                  Chip(
                    label: Text(
                      '${summary.unresolvedReferences} unresolved refs',
                    ),
                  ),
                  Chip(
                    label: Text('${summary.malformedTokens} malformed tokens'),
                  ),
                ],
              ),
              if (flaggedReports.isNotEmpty) ...[
                const SizedBox(height: 18),
                ...flaggedReports.map(
                  (report) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.displayName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            ...report.issues.map(
                              (issue) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(issue.message),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
