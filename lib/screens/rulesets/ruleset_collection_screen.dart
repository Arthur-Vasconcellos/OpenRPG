import 'package:flutter/material.dart';
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
  final CompendiumRepository _repository = CompendiumRepository();
  final TextEditingController _searchController = TextEditingController();
  late Future<_CollectionState> _futureState;
  String? _selectedSource;

  @override
  void initState() {
    super.initState();
    _futureState = _loadState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<_CollectionState> _loadState() async {
    final ruleset = await _repository.loadRuleset(widget.rulesetId);
    final page = await _repository.getCollectionPage(
      rulesetId: widget.rulesetId,
      entityType: widget.entityType,
      query: _searchController.text,
      source: _selectedSource,
    );
    return _CollectionState(ruleset: ruleset, page: page);
  }

  Future<void> _reload() async {
    setState(() {
      _futureState = _loadState();
    });
    await _futureState;
  }

  Future<void> _editEntity(
    _CollectionState state, [
    CompendiumEntity? entity,
  ]) async {
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

  Future<void> _deleteEntity(
    _CollectionState state,
    CompendiumEntity entity,
  ) async {
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
      entityId: entity.id,
    );
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final descriptor = descriptorForType(widget.entityType);
    return Scaffold(
      appBar: AppBar(
        title: Text(descriptor?.collection.label ?? widget.entityType),
      ),
      floatingActionButton: FutureBuilder<_CollectionState>(
        future: _futureState,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data!.ruleset.mode == RulesetMode.bundled) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton.extended(
            onPressed: () => _editEntity(snapshot.data!),
            icon: const Icon(Icons.add),
            label: const Text('Add Entity'),
          );
        },
      ),
      body: FutureBuilder<_CollectionState>(
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
                  'Failed to load collection.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final state = snapshot.data!;
          final canEdit = state.ruleset.mode != RulesetMode.bundled;

          return Column(
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
                  onSubmitted: (_) => _reload(),
                ),
              ),
              if (state.page.availableSources.isNotEmpty)
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
                        ...state.page.availableSources.map(
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
                child: state.page.items.isEmpty
                    ? const Center(
                        child: Text('No entities matched this collection.'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.page.items.length,
                        separatorBuilder: (_, separatorIndex) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final entity = state.page.items[index];
                          return Card(
                            child: ListTile(
                              title: Text(entity.displayName),
                              subtitle: Text(
                                entity.source.isEmpty
                                    ? entity.id
                                    : '${entity.source}\n${entity.id}',
                              ),
                              isThreeLine: entity.source.isNotEmpty,
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  switch (value) {
                                    case 'open':
                                      await _openEntity(entity);
                                      break;
                                    case 'edit':
                                      await _editEntity(state, entity);
                                      break;
                                    case 'delete':
                                      await _deleteEntity(state, entity);
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
          );
        },
      ),
    );
  }

  Future<void> _openEntity(CompendiumEntity entity) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompendiumEntityDetailScreen(
          rulesetId: widget.rulesetId,
          entityType: entity.entityType,
          entityId: entity.id,
        ),
      ),
    );
    await _reload();
  }
}

class _CollectionState {
  final Ruleset ruleset;
  final CompendiumCollectionPage page;

  const _CollectionState({required this.ruleset, required this.page});
}
