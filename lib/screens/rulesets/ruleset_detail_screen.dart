import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
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

  late Future<_RulesetDetailState> _futureState;
  Future<List<CompendiumSearchResult>>? _futureSearchResults;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _futureState = _loadState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController
      ..removeListener(_onSearchChanged)
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
      });
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _futureSearchResults = _browseRepository.searchEntityPreviews(
          CompendiumSearchQuery(
            text: query,
            rulesetIds: [widget.rulesetId],
            limit: 150,
          ),
        );
      });
    });
  }

  Future<void> _reload() async {
    setState(() {
      _futureState = _loadState();
      if (_searchController.text.trim().isNotEmpty) {
        _futureSearchResults = _browseRepository.searchEntityPreviews(
          CompendiumSearchQuery(
            text: _searchController.text.trim(),
            rulesetIds: [widget.rulesetId],
            limit: 150,
          ),
        );
      }
    });
    await _futureState;
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

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.summary.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      if (state.summary.description.trim().isNotEmpty)
                        Text(state.summary.description),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Chip(label: Text('Mode: ${state.summary.mode}')),
                          Chip(
                            label: Text(
                              'Entities: ${state.summary.entityCount}',
                            ),
                          ),
                          Chip(
                            label: Text(
                              'Schema: ${state.summary.schemaVersion}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search this ruleset',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              if (query.isEmpty)
                ...state.collections
                    .where((view) => view.entityCount > 0)
                    .map(
                      (view) => Card(
                        child: ListTile(
                          title: Text(view.label),
                          subtitle: Text('${view.entityCount} records'),
                          trailing: const Icon(Icons.chevron_right),
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
                    )
              else
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
                          .map((result) {
                            final preview = result.preview;
                            final descriptor = descriptorForType(
                              preview.entityType,
                            );
                            return Card(
                              child: ListTile(
                                title: Text(preview.displayName),
                                subtitle: Text(
                                  '${descriptor?.collection.label ?? preview.entityType}'
                                  '${preview.source.isNotEmpty ? ' - ${preview.source}' : ''}',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CompendiumEntityDetailScreen(
                                            rulesetId: preview.rulesetId,
                                            entityType: preview.entityType,
                                            entityId: preview.entityId,
                                          ),
                                    ),
                                  );
                                  await _reload();
                                },
                              ),
                            );
                          })
                          .toList(growable: false),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RulesetDetailState {
  final RulesetSummary summary;
  final List<RulesetCollectionSummary> collections;

  const _RulesetDetailState({required this.summary, required this.collections});
}
