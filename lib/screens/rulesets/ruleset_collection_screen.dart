import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/compendium/models/ruleset.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
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
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  String? _selectedSource;
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
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search this collection',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                if (_availableSources.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton<String?>(
                        value: _selectedSource,
                        hint: const Text('Filter by source'),
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
                    ),
                  ),
                const SizedBox(height: 6),
                Expanded(
                  child: _items.isEmpty
                      ? const Center(
                          child: Text('No entities matched this collection.'),
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
                              child: ListTile(
                                title: Text(entity.displayName),
                                subtitle: Text(
                                  entity.source.isEmpty
                                      ? entity.entityId
                                      : '${entity.source}\n${entity.entityId}',
                                ),
                                isThreeLine: entity.source.isNotEmpty,
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    switch (value) {
                                      case 'open':
                                        await _openEntity(entity);
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
                                onTap: () => _openEntity(entity),
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
