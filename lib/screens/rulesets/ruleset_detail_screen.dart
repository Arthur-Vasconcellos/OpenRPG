import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/compendium/models/ruleset.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/ruleset_collection_screen.dart';

class RulesetDetailScreen extends StatefulWidget {
  final String rulesetId;

  const RulesetDetailScreen({super.key, required this.rulesetId});

  @override
  State<RulesetDetailScreen> createState() => _RulesetDetailScreenState();
}

class _RulesetDetailScreenState extends State<RulesetDetailScreen> {
  final CompendiumRepository _repository = CompendiumRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<Ruleset> _futureRuleset;

  @override
  void initState() {
    super.initState();
    _futureRuleset = _repository.loadRuleset(widget.rulesetId);
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _futureRuleset = _repository.loadRuleset(widget.rulesetId);
    });
    await _futureRuleset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruleset Browser')),
      body: FutureBuilder<Ruleset>(
        future: _futureRuleset,
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

          final ruleset = snapshot.data!;
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
                        ruleset.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      if (ruleset.description.trim().isNotEmpty)
                        Text(ruleset.description),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Chip(label: Text('Mode: ${ruleset.mode.name}')),
                          Chip(
                            label: Text(
                              'Entities: ${ruleset.totalEntityCount}',
                            ),
                          ),
                          Chip(label: Text('Schema: ${ruleset.schemaVersion}')),
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
                ...ruleset.collectionViews
                    .where((view) => view.entities.isNotEmpty)
                    .map(
                      (view) => Card(
                        child: ListTile(
                          title: Text(view.definition.label),
                          subtitle: Text('${view.entities.length} records'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RulesetCollectionScreen(
                                  rulesetId: ruleset.id,
                                  entityType: view.definition.entityType,
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
                  future: _repository.searchEntities(
                    CompendiumSearchQuery(
                      text: query,
                      rulesetIds: [ruleset.id],
                      limit: 150,
                    ),
                  ),
                  builder: (context, searchSnapshot) {
                    if (!searchSnapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final results = searchSnapshot.data!;
                    if (results.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text('No matches in this ruleset.'),
                        ),
                      );
                    }

                    return Column(
                      children: results.map((result) {
                        final descriptor = descriptorForType(
                          result.entity.entityType,
                        );
                        return Card(
                          child: ListTile(
                            title: Text(result.entity.displayName),
                            subtitle: Text(
                              '${descriptor?.collection.label ?? result.entity.entityType}'
                              '${result.entity.source.isNotEmpty ? ' • ${result.entity.source}' : ''}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CompendiumEntityDetailScreen(
                                    rulesetId: result.rulesetId,
                                    entityType: result.entity.entityType,
                                    entityId: result.entity.id,
                                  ),
                                ),
                              );
                              await _reload();
                            },
                          ),
                        );
                      }).toList(),
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
