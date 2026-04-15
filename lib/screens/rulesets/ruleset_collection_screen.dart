import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/compendium/models/ruleset.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
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
  List<String> _availableSources = const [];
  List<String> _availableEditions = const [];
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  String? _selectedSource;
  String? _selectedEdition;
  int _page = 0;
  Timer? _searchDebounce;

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
      source: _selectedSource,
      edition: _selectedEdition,
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
      _availableSources = page.availableSources;
      _availableEditions = page.availableEditions;
      _hasMore = page.hasMore;
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
      source: _selectedSource,
      edition: _selectedEdition,
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
    });
  }

  Future<void> _editEntity([CompendiumEntity? entity]) async {
    final updated = await Navigator.of(context).push<CompendiumEntity>(
      MaterialPageRoute(
        builder: (_) => RulesetObjectEditorScreen(
          entityType: widget.entityType,
          initialEntity: entity,
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
                if (_availableSources.isNotEmpty ||
                    _availableEditions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if (_availableSources.isNotEmpty)
                          DropdownButtonFormField<String?>(
                            initialValue: _selectedSource,
                            decoration: const InputDecoration(
                              labelText: 'Source',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All Sources'),
                              ),
                              ..._availableSources.map(
                                (source) => DropdownMenuItem<String?>(
                                  value: source,
                                  child: Text(source),
                                ),
                              ),
                            ],
                            onChanged: (value) async {
                              setState(() {
                                _selectedSource = value;
                              });
                              await _reload();
                            },
                          ),
                        if (_availableSources.isNotEmpty &&
                            _availableEditions.isNotEmpty)
                          const SizedBox(height: 12),
                        if (_availableEditions.isNotEmpty)
                          DropdownButtonFormField<String?>(
                            initialValue: _selectedEdition,
                            decoration: const InputDecoration(
                              labelText: 'Edition',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All Editions'),
                              ),
                              ..._availableEditions.map(
                                (edition) => DropdownMenuItem<String?>(
                                  value: edition,
                                  child: Text(edition),
                                ),
                              ),
                            ],
                            onChanged: (value) async {
                              setState(() {
                                _selectedEdition = value;
                              });
                              await _reload();
                            },
                          ),
                      ],
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
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _items.length + (_hasMore ? 1 : 0),
                          separatorBuilder: (_, separatorIndex) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index == _items.length) {
                              return Center(
                                child: FilledButton.tonal(
                                  onPressed: _isLoadingMore ? null : _loadMore,
                                  child: Text(
                                    _isLoadingMore ? 'Loading...' : 'Load more',
                                  ),
                                ),
                              );
                            }

                            final entity = _items[index];
                            return Card(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () => _openEntity(entity),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              entity.displayName,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleLarge,
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            onSelected: (value) async {
                                              switch (value) {
                                                case 'open':
                                                  await _openEntity(entity);
                                                  break;
                                                case 'edit':
                                                  final detail =
                                                      await _browseRepository
                                                          .loadEntityDetail(
                                                            rulesetId: widget
                                                                .rulesetId,
                                                            entityType: entity
                                                                .entityType,
                                                            entityId:
                                                                entity.entityId,
                                                          );
                                                  await _editEntity(
                                                    detail.entity,
                                                  );
                                                  break;
                                                case 'delete':
                                                  await _deleteEntity(entity);
                                                  break;
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'open',
                                                child: Text('Open'),
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
                                          CompendiumTypeBadge(
                                            entityType: entity.entityType,
                                          ),
                                          if (entity.source.trim().isNotEmpty)
                                            Chip(
                                              label: Text(
                                                'Source: ${entity.source}',
                                              ),
                                            ),
                                          if (entity.edition
                                                  ?.trim()
                                                  .isNotEmpty ==
                                              true)
                                            Chip(
                                              label: Text(
                                                'Edition: ${entity.edition}',
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (entity.entityId
                                          .trim()
                                          .isNotEmpty) ...[
                                        const SizedBox(height: 10),
                                        Text(
                                          entity.entityId,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
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
        ),
      ),
    );
    await _reload();
  }
}
