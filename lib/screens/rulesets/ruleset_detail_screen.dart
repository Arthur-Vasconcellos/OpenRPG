import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';
import 'package:openrpg/screens/rulesets/ruleset_collection_screen.dart';

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
    return _RulesetDetailState(
      summary: summary,
      collections: collections,
    );
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _futureSearchResults = null;
      });
      return;
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
    setState(() {
      _futureSearchResults = _browseRepository.searchEntityPreviews(
        CompendiumSearchQuery(
          text: _searchController.text.trim(),
          rulesetIds: [widget.rulesetId],
          entityTypes: _selectedEntityType == null
              ? const []
              : <String>[_selectedEntityType!],
          limit: 150,
        ),
      );
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruleset Browser')),
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
          final query = _searchController.text.trim();
          final filteredCollections = _filterCollections(state.collections);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _RulesetHeaderCard(
                summary: state.summary,
                searchController: _searchController,
              ),
              const SizedBox(height: 18),
              if (query.isEmpty) ...[
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
              ] else ...[
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
                    if (_futureSearchResults == null ||
                        searchSnapshot.connectionState !=
                            ConnectionState.done) {
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
                        child: Center(
                          child: Text('No matches in this ruleset.'),
                        ),
                      );
                    }

                    return Column(
                      children: results
                          .map(
                            (result) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _SearchResultCard(
                                result: result,
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CompendiumEntityDetailScreen(
                                            rulesetId: result.preview.rulesetId,
                                            entityType:
                                                result.preview.entityType,
                                            entityId: result.preview.entityId,
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
                  },
                ),
              ],
            ],
          );
        },
      ),
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

  const _RulesetDetailState({
    required this.summary,
    required this.collections,
  });
}

class _RulesetHeaderCard extends StatelessWidget {
  final RulesetSummary summary;
  final TextEditingController searchController;

  const _RulesetHeaderCard({
    required this.summary,
    required this.searchController,
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
            ],
          ),
        ),
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
  final Future<void> Function() onTap;

  const _SearchResultCard({required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final preview = result.preview;
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
                      preview.displayName,
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
                children: [CompendiumTypeBadge(entityType: preview.entityType)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
