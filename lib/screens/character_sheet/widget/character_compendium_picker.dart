import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';
import 'package:openrpg/screens/rulesets/compendium_type_badge.dart';

Future<CharacterCompendiumSearchResult?> showCharacterCompendiumPicker(
  BuildContext context, {
  required CharacterCompendiumService service,
  required List<RulesetSummary> installedRulesets,
  required String primaryRulesetId,
  required List<String> entityTypes,
  required String title,
  String? classNameForSubclasses,
}) {
  final width = MediaQuery.sizeOf(context).width;
  final compact = width < 720;

  final picker = _CharacterCompendiumPicker(
    service: service,
    installedRulesets: installedRulesets,
    primaryRulesetId: primaryRulesetId,
    entityTypes: entityTypes,
    title: title,
    classNameForSubclasses: classNameForSubclasses,
  );

  if (compact) {
    return showModalBottomSheet<CharacterCompendiumSearchResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: picker,
      ),
    );
  }

  return showDialog<CharacterCompendiumSearchResult>(
    context: context,
    builder: (_) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 760),
        child: picker,
      ),
    ),
  );
}

class _CharacterCompendiumPicker extends StatefulWidget {
  final CharacterCompendiumService service;
  final List<RulesetSummary> installedRulesets;
  final String primaryRulesetId;
  final List<String> entityTypes;
  final String title;
  final String? classNameForSubclasses;

  const _CharacterCompendiumPicker({
    required this.service,
    required this.installedRulesets,
    required this.primaryRulesetId,
    required this.entityTypes,
    required this.title,
    required this.classNameForSubclasses,
  });

  @override
  State<_CharacterCompendiumPicker> createState() =>
      _CharacterCompendiumPickerState();
}

class _CharacterCompendiumPickerState
    extends State<_CharacterCompendiumPicker> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  late String _scopeValue = widget.primaryRulesetId;
  late Future<List<CharacterCompendiumSearchResult>> _futureResults =
      _loadResults();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  List<String> get _activeRulesetIds {
    if (_scopeValue == '__all__') {
      return widget.installedRulesets.map((ruleset) => ruleset.id).toList();
    }
    return <String>[_scopeValue];
  }

  void _handleSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _futureResults = _loadResults();
      });
    });
  }

  Future<List<CharacterCompendiumSearchResult>> _loadResults() {
    if (widget.classNameForSubclasses != null &&
        widget.entityTypes.length == 1 &&
        widget.entityTypes.first == 'subclass') {
      return widget.service.loadSubclassesForClass(
        rulesetIds: _activeRulesetIds,
        className: widget.classNameForSubclasses!,
        query: _searchController.text,
      );
    }

    return widget.service.searchEntities(
      rulesetIds: _activeRulesetIds,
      entityTypes: widget.entityTypes,
      query: _searchController.text,
      limit: 150,
    );
  }

  void _preview(CharacterCompendiumSearchResult result) {
    final ref = result.ref;
    showCompendiumEntityPreviewSurface(
      context,
      rulesetId: ref.rulesetId,
      entityType: ref.entityType,
      entityId: ref.entityId,
      browseRepository: widget.service.browseRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 720;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _scopeValue,
            decoration: const InputDecoration(
              labelText: 'Ruleset scope',
              border: OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem<String>(
                value: widget.primaryRulesetId,
                child: const Text('Primary ruleset'),
              ),
              const DropdownMenuItem<String>(
                value: '__all__',
                child: Text('All installed rulesets'),
              ),
              ...widget.installedRulesets
                  .where((ruleset) => ruleset.id != widget.primaryRulesetId)
                  .map(
                    (ruleset) => DropdownMenuItem<String>(
                      value: ruleset.id,
                      child: Text(ruleset.name),
                    ),
                  ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _scopeValue = value;
                _futureResults = _loadResults();
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search entries',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            compact
                ? 'Tap a row to select it. Long-press the result content or use the preview button to inspect it first.'
                : 'Hover a result name to preview it, click a row to select it, or use the preview button to pin the rules reference.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<CharacterCompendiumSearchResult>>(
              future: _futureResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load results.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final results = snapshot.data ?? const [];
                if (results.isEmpty) {
                  return const Center(child: Text('No matching entries.'));
                }

                return ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final result = results[index];
                    final ref = result.ref;
                    final snippet = result.snippet.trim();
                    return Card(
                      child: ListTile(
                        title: CompendiumReferenceAnchor(
                          rulesetId: ref.rulesetId,
                          entityType: ref.entityType,
                          entityId: ref.entityId,
                          entityName: ref.displayName,
                          browseRepository: widget.service.browseRepository,
                          previewOnLongPress: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ref.displayName),
                              if (snippet.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  snippet,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  CompendiumTypeBadge(
                                    entityType: ref.entityType,
                                  ),
                                  if (result.rulesetName != null)
                                    Tooltip(
                                      message:
                                          'Selection comes from the installed ruleset "${result.rulesetName!}".',
                                      child: Text(result.rulesetName!),
                                    ),
                                  if (result.inboundReferenceCount > 0)
                                    Tooltip(
                                      message:
                                          'Referenced by ${result.inboundReferenceCount} other compendium entr${result.inboundReferenceCount == 1 ? 'y' : 'ies'}.',
                                      child: Text(
                                        '${result.inboundReferenceCount} inbound ref${result.inboundReferenceCount == 1 ? '' : 's'}',
                                      ),
                                    ),
                                  if (result.characterUsageCount > 0)
                                    Tooltip(
                                      message:
                                          'Currently used by ${result.characterUsageCount} saved character${result.characterUsageCount == 1 ? '' : 's'}.',
                                      child: Text(
                                        '${result.characterUsageCount} character use${result.characterUsageCount == 1 ? '' : 's'}',
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: 'Preview and pin',
                          icon: const Icon(Icons.visibility_outlined),
                          onPressed: () => _preview(result),
                        ),
                        onLongPress: () => _preview(result),
                        onTap: () => Navigator.of(context).pop(result),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
