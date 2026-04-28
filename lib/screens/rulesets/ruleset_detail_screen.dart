import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/characters/character_creation_flow.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';
import 'package:openrpg/screens/rulesets/ruleset_collection_screen.dart';

enum _RulesetDetailMode { browse, search, builder }

class RulesetDetailScreen extends StatefulWidget {
  final String rulesetId;

  const RulesetDetailScreen({super.key, required this.rulesetId});

  @override
  State<RulesetDetailScreen> createState() => _RulesetDetailScreenState();
}

class _RulesetDetailScreenState extends State<RulesetDetailScreen> {
  final CompendiumBrowseRepository _browseRepository =
      CompendiumBrowseRepository();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _collectionFilterController =
      TextEditingController();

  late Future<_RulesetDetailState> _futureState;
  Future<List<CompendiumSearchResult>>? _futureSearchResults;
  Timer? _searchDebounce;
  String? _selectedEntityType;
  CompendiumEntityPreview? _selectedSearchPreview;
  int _searchRequestToken = 0;
  _RulesetDetailMode _mode = _RulesetDetailMode.browse;

  @override
  void initState() {
    super.initState();
    _futureState = _loadState();
    _searchController.addListener(_onSearchChanged);
    _collectionFilterController.addListener(_onCollectionFilterChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _collectionFilterController
      ..removeListener(_onCollectionFilterChanged)
      ..dispose();
    super.dispose();
  }

  Future<_RulesetDetailState> _loadState() async {
    final summary = await _browseRepository.loadRulesetSummary(
      widget.rulesetId,
    );
    final collections = await _browseRepository.loadCollectionSummaries(
      widget.rulesetId,
    );
    return _RulesetDetailState(summary: summary, collections: collections);
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _futureSearchResults = null;
        _selectedSearchPreview = null;
      });
      return;
    }

    if (_mode == _RulesetDetailMode.browse) {
      setState(() {
        _mode = _RulesetDetailMode.search;
      });
    }

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) {
        return;
      }
      _runSearch();
    });
  }

  void _onCollectionFilterChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _runSearch() {
    final requestToken = ++_searchRequestToken;
    final future = _browseRepository.searchEntityPreviews(
      CompendiumSearchQuery(
        text: _searchController.text.trim(),
        rulesetIds: [widget.rulesetId],
        entityTypes: _selectedEntityType == null
            ? const []
            : <String>[_selectedEntityType!],
        limit: 150,
      ),
    );

    setState(() {
      _futureSearchResults = future;
    });

    unawaited(() async {
      final results = await future;
      if (!mounted || requestToken != _searchRequestToken) {
        return;
      }

      final nextSelection = _resolvedSelectedSearchPreview(results);
      if (_samePreview(_selectedSearchPreview, nextSelection)) {
        return;
      }

      setState(() {
        _selectedSearchPreview = nextSelection;
      });
    }());
  }

  Future<void> _reload() async {
    setState(() {
      _futureState = _loadState();
    });
    await _futureState;

    if (_searchController.text.trim().isNotEmpty && mounted) {
      _runSearch();
    }
  }

  CompendiumEntityPreview? _resolvedSelectedSearchPreview(
    List<CompendiumSearchResult> results,
  ) {
    if (results.isEmpty) {
      return null;
    }

    final current = _selectedSearchPreview;
    if (current != null) {
      for (final result in results) {
        if (_samePreview(current, result.preview)) {
          return result.preview;
        }
      }
    }

    return results.first.preview;
  }

  bool _samePreview(
    CompendiumEntityPreview? left,
    CompendiumEntityPreview? right,
  ) {
    if (left == null || right == null) {
      return left == right;
    }

    return left.rulesetId == right.rulesetId &&
        left.entityType == right.entityType &&
        left.entityId == right.entityId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<_RulesetDetailState>(
          future: _futureState,
          builder: (context, snapshot) {
            final title = snapshot.data?.summary.name;
            return Text(
              title == null || title.trim().isEmpty ? 'Ruleset Browser' : title,
            );
          },
        ),
      ),
      body: FutureBuilder<_RulesetDetailState>(
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
                  'Failed to load ruleset.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final state = snapshot.data!;
          final filteredCollections = _filterCollections(state.collections);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _RulesetHeaderCard(
                summary: state.summary,
                searchController: _searchController,
                mode: _mode,
                onModeChanged: (mode) {
                  setState(() {
                    _mode = mode;
                  });
                  if (mode == _RulesetDetailMode.search &&
                      _searchController.text.trim().isNotEmpty) {
                    _runSearch();
                  }
                },
                onCreateCharacter: () => createCharacterFromRulesetFlow(
                  context,
                  preselectedRulesetId: state.summary.id,
                ),
              ),
              const SizedBox(height: 18),
              switch (_mode) {
                _RulesetDetailMode.browse => _buildBrowseMode(
                  context,
                  state,
                  filteredCollections,
                ),
                _RulesetDetailMode.search => _buildSearchMode(context, state),
                _RulesetDetailMode.builder => _buildBuilderMode(context, state),
              },
            ],
          );
        },
      ),
    );
  }

  Widget _buildBrowseMode(
    BuildContext context,
    _RulesetDetailState state,
    List<RulesetCollectionSummary> filteredCollections,
  ) {
    return Column(
      children: [
        TextField(
          controller: _collectionFilterController,
          decoration: const InputDecoration(
            hintText: 'Filter collection types',
            prefixIcon: Icon(Icons.tune),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        if (filteredCollections.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text('No collection types matched that filter.'),
            ),
          )
        else
          ...filteredCollections.map(
            (view) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _RulesetCollectionCard(
                summary: state.summary,
                collection: view,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RulesetCollectionScreen(
                        rulesetId: state.summary.id,
                        entityType: view.entityType,
                      ),
                    ),
                  );
                  await _reload();
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchMode(BuildContext context, _RulesetDetailState state) {
    final wide = MediaQuery.sizeOf(context).width >= 1120;
    return Column(
      children: [
        _RulesetSearchFiltersCard(
          collections: state.collections,
          selectedEntityType: _selectedEntityType,
          onEntityTypeChanged: (value) {
            setState(() {
              _selectedEntityType = value;
            });
            _runSearch();
          },
        ),
        const SizedBox(height: 18),
        FutureBuilder<List<CompendiumSearchResult>>(
          future: _futureSearchResults,
          builder: (context, searchSnapshot) {
            if (_searchController.text.trim().isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Start typing to search this ruleset. Result rows support direct preview from the title and type badge.',
                  ),
                ),
              );
            }
            if (_futureSearchResults == null ||
                searchSnapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (searchSnapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Search failed.\n${searchSnapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final results = searchSnapshot.data ?? const [];
            if (results.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('No matches in this ruleset.')),
              );
            }

            final selectedPreview = _resolvedSelectedSearchPreview(results);

            Widget listContent = Column(
              children: results
                  .map(
                    (result) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _SearchResultCard(
                        result: result,
                        wide: wide,
                        selected: _samePreview(selectedPreview, result.preview),
                        onSelectPreview: () {
                          setState(() {
                            _selectedSearchPreview = result.preview;
                          });
                        },
                        onOpen: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CompendiumEntityDetailScreen(
                                rulesetId: result.preview.rulesetId,
                                entityType: result.preview.entityType,
                                entityId: result.preview.entityId,
                                browseRepository: _browseRepository,
                              ),
                            ),
                          );
                          await _reload();
                        },
                      ),
                    ),
                  )
                  .toList(growable: false),
            );

            if (!wide) {
              return listContent;
            }

            return SizedBox(
              height: 760,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SingleChildScrollView(child: listContent)),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 420,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: selectedPreview == null
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'Select a result to keep a pinned preview visible while you browse search matches.',
                                ),
                              ),
                            )
                          : CompendiumEntityPreviewPanel(
                              key: ValueKey(
                                '${selectedPreview.entityType}:${selectedPreview.entityId}',
                              ),
                              rulesetId: selectedPreview.rulesetId,
                              entityType: selectedPreview.entityType,
                              entityId: selectedPreview.entityId,
                              browseRepository: _browseRepository,
                              compact: false,
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBuilderMode(BuildContext context, _RulesetDetailState state) {
    final relevantCollections = state.collections
        .where(
          (collection) => const {
            'class',
            'subclass',
            'race',
            'background',
            'spell',
            'item',
          }.contains(collection.entityType),
        )
        .toList(growable: false);

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use This Ruleset In Character Builder',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Start a saved character with this ruleset already pinned as the primary build source. The picks below are the collections most commonly used while building.',
                ),
                const SizedBox(height: 14),
                FilledButton.tonalIcon(
                  onPressed: () => createCharacterFromRulesetFlow(
                    context,
                    preselectedRulesetId: state.summary.id,
                  ),
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('Start Character From This Ruleset'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...relevantCollections.map(
          (collection) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _BuilderShortcutCard(
              collection: collection,
              onOpen: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RulesetCollectionScreen(
                      rulesetId: widget.rulesetId,
                      entityType: collection.entityType,
                    ),
                  ),
                );
                await _reload();
              },
            ),
          ),
        ),
      ],
    );
  }

  List<RulesetCollectionSummary> _filterCollections(
    List<RulesetCollectionSummary> collections,
  ) {
    final query = _collectionFilterController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return collections;
    }

    return collections
        .where((collection) {
          return collection.label.toLowerCase().contains(query) ||
              collection.entityType.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }
}

class _RulesetDetailState {
  final RulesetSummary summary;
  final List<RulesetCollectionSummary> collections;

  const _RulesetDetailState({required this.summary, required this.collections});
}

class _RulesetHeaderCard extends StatelessWidget {
  final RulesetSummary summary;
  final TextEditingController searchController;
  final _RulesetDetailMode mode;
  final ValueChanged<_RulesetDetailMode> onModeChanged;
  final Future<void> Function() onCreateCharacter;

  const _RulesetHeaderCard({
    required this.summary,
    required this.searchController,
    required this.mode,
    required this.onModeChanged,
    required this.onCreateCharacter,
  });

  @override
  Widget build(BuildContext context) {
    final modeMessage = switch (summary.mode) {
      'bundled' =>
        'Bundled starter content is read-only. Duplicate it from the library to turn it into editable homebrew.',
      'editable' =>
        'This ruleset is editable inside the app, including empty collections that are ready for authoring.',
      _ =>
        'Imported rulesets stay editable and can be re-exported as portable JSON.',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (summary.description.trim().isNotEmpty)
              Text(summary.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Chip(label: Text('Mode: ${summary.mode}')),
                Chip(label: Text('Entities: ${summary.entityCount}')),
                Chip(label: Text('Schema: ${summary.schemaVersion}')),
                if (summary.version.trim().isNotEmpty)
                  Chip(label: Text('Version: ${summary.version}')),
              ],
            ),
            const SizedBox(height: 12),
            Text(modeMessage),
            const SizedBox(height: 16),
            SegmentedButton<_RulesetDetailMode>(
              segments: const [
                ButtonSegment<_RulesetDetailMode>(
                  value: _RulesetDetailMode.browse,
                  icon: Icon(Icons.view_module_outlined),
                  label: Text('Browse'),
                ),
                ButtonSegment<_RulesetDetailMode>(
                  value: _RulesetDetailMode.search,
                  icon: Icon(Icons.search),
                  label: Text('Search'),
                ),
                ButtonSegment<_RulesetDetailMode>(
                  value: _RulesetDetailMode.builder,
                  icon: Icon(Icons.auto_awesome_outlined),
                  label: Text('Use In Character Builder'),
                ),
              ],
              selected: {_RulesetDetailMode.values[mode.index]},
              onSelectionChanged: (selection) => onModeChanged(selection.first),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onCreateCharacter,
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('Start Character From This Ruleset'),
                ),
                OutlinedButton.icon(
                  onPressed: () => searchController.clear(),
                  icon: const Icon(Icons.clear_all_outlined),
                  label: const Text('Clear Search'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search this ruleset',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RulesetCollectionCard extends StatelessWidget {
  final RulesetSummary summary;
  final RulesetCollectionSummary collection;
  final Future<void> Function() onTap;

  const _RulesetCollectionCard({
    required this.summary,
    required this.collection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusLabel = collection.entityCount == 0
        ? summary.mode == 'bundled'
              ? 'No starter entries'
              : 'Ready for authoring'
        : '${collection.entityCount} entries';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      collection.label,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CompendiumTypeBadge(entityType: collection.entityType),
                  Chip(label: Text(statusLabel)),
                  if (summary.mode == 'bundled')
                    const Chip(label: Text('Read-only starter')),
                ],
              ),
              if (collection.representativeEntries.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'Representative entries',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: collection.representativeEntries
                      .map(
                        (entry) => CompendiumReferenceAnchor(
                          rulesetId: entry.rulesetId,
                          entityType: entry.entityType,
                          entityId: entry.entityId,
                          entityName: entry.displayName,
                          child: IgnorePointer(
                            child: ActionChip(
                              avatar: const Icon(
                                Icons.visibility_outlined,
                                size: 18,
                              ),
                              label: Text(entry.displayName),
                              onPressed: () {},
                            ),
                          ),
                          onTap: () {
                            showCompendiumEntityPreviewSurface(
                              context,
                              rulesetId: entry.rulesetId,
                              entityType: entry.entityType,
                              entityId: entry.entityId,
                              entityName: entry.displayName,
                            );
                          },
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BuilderShortcutCard extends StatelessWidget {
  final RulesetCollectionSummary collection;
  final Future<void> Function() onOpen;

  const _BuilderShortcutCard({required this.collection, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onOpen,
        title: Text(collection.label),
        subtitle: collection.representativeEntries.isEmpty
            ? Text(
                collection.entityCount == 0
                    ? 'No entries available yet.'
                    : '${collection.entityCount} entries available.',
              )
            : Text(
                collection.representativeEntries
                    .map((entry) => entry.displayName)
                    .join(' • '),
              ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _RulesetSearchFiltersCard extends StatelessWidget {
  final List<RulesetCollectionSummary> collections;
  final String? selectedEntityType;
  final ValueChanged<String?> onEntityTypeChanged;

  const _RulesetSearchFiltersCard({
    required this.collections,
    required this.selectedEntityType,
    required this.onEntityTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Filters',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: selectedEntityType,
              decoration: const InputDecoration(
                labelText: 'Entity type',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All Types'),
                ),
                ...collections.map(
                  (collection) => DropdownMenuItem<String?>(
                    value: collection.entityType,
                    child: Text(collection.label),
                  ),
                ),
              ],
              onChanged: onEntityTypeChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final CompendiumSearchResult result;
  final bool wide;
  final bool selected;
  final VoidCallback onSelectPreview;
  final Future<void> Function() onOpen;

  const _SearchResultCard({
    required this.result,
    required this.wide,
    required this.selected,
    required this.onSelectPreview,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final preview = result.preview;
    final snippet = result.snippet.trim().isEmpty
        ? 'Preview this entry from the title or type badge, or open the full detail page to inspect nested links and structured attributes.'
        : result.snippet.trim();
    return Card(
      color: selected
          ? Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.55)
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: wide ? onSelectPreview : onOpen,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CompendiumReferenceAnchor(
                      rulesetId: preview.rulesetId,
                      entityType: preview.entityType,
                      entityId: preview.entityId,
                      entityName: preview.displayName,
                      onTap: () {
                        showCompendiumEntityPreviewSurface(
                          context,
                          rulesetId: preview.rulesetId,
                          entityType: preview.entityType,
                          entityId: preview.entityId,
                          entityName: preview.displayName,
                        );
                      },
                      child: Text(
                        preview.displayName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: wide ? 'Pin in preview pane' : 'Open full entry',
                    icon: Icon(
                      wide
                          ? Icons.view_sidebar_outlined
                          : Icons.open_in_new_outlined,
                    ),
                    onPressed: wide ? onSelectPreview : onOpen,
                  ),
                  if (wide)
                    IconButton(
                      tooltip: 'Open full entry',
                      icon: const Icon(Icons.open_in_new_outlined),
                      onPressed: onOpen,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CompendiumReferenceAnchor(
                    rulesetId: preview.rulesetId,
                    entityType: preview.entityType,
                    entityId: preview.entityId,
                    entityName: preview.displayName,
                    onTap: () {
                      showCompendiumEntityPreviewSurface(
                        context,
                        rulesetId: preview.rulesetId,
                        entityType: preview.entityType,
                        entityId: preview.entityId,
                        entityName: preview.displayName,
                      );
                    },
                    child: IgnorePointer(
                      child: CompendiumTypeBadge(
                        entityType: preview.entityType,
                      ),
                    ),
                  ),
                  if (preview.inboundReferenceCount > 0)
                    Chip(
                      label: Text(
                        '${preview.inboundReferenceCount} inbound refs',
                      ),
                    ),
                  if (preview.characterUsageCount > 0)
                    Chip(
                      label: Text(
                        '${preview.characterUsageCount} character uses',
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(snippet, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
