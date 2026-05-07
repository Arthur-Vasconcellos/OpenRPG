import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/characters/creation/species_race_terms.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';

enum SpeciesSenseFilter { any, darkvision, noDarkvision }

class GuidedSpeciesRacePicker extends StatefulWidget {
  final CharacterEditorController controller;
  final SpeciesRaceTerminology terminology;

  const GuidedSpeciesRacePicker({
    super.key,
    required this.controller,
    required this.terminology,
  });

  @override
  State<GuidedSpeciesRacePicker> createState() =>
      _GuidedSpeciesRacePickerState();
}

class _GuidedSpeciesRacePickerState extends State<GuidedSpeciesRacePicker> {
  final TextEditingController _searchController = TextEditingController();

  late String _rulesetScope = widget.controller.character!.primaryRulesetId;
  SpeciesSenseFilter _senseFilter = SpeciesSenseFilter.any;
  late Future<List<SpeciesRacePickerOption>> _futureOptions = _loadOptions();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<String> get _activeRulesetIds {
    if (_rulesetScope == '__all__') {
      return widget.controller.installedRulesets
          .map((ruleset) => ruleset.id)
          .toList(growable: false);
    }
    return <String>[_rulesetScope];
  }

  Future<List<SpeciesRacePickerOption>> _loadOptions() async {
    final service = widget.controller.compendium;
    final results = await service.searchEntities(
      rulesetIds: _activeRulesetIds,
      entityTypes: const ['race'],
      limit: 300,
    );
    final options = <SpeciesRacePickerOption>[];
    for (final result in results) {
      final loadedEntity = await service.loadResolvedEntity(result.ref);
      if (loadedEntity == null) {
        continue;
      }
      options.add(
        SpeciesRacePickerOption(
          ref: result.ref,
          rulesetName: result.rulesetName,
          detail: loadedEntity.detail,
        ),
      );
    }
    options.sort(
      (left, right) => left.displayName.compareTo(right.displayName),
    );
    return options;
  }

  List<SpeciesRacePickerOption> _filteredOptions(
    List<SpeciesRacePickerOption> options,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return options
        .where((option) {
          if (query.isNotEmpty &&
              !option.displayName.toLowerCase().contains(query)) {
            return false;
          }
          return switch (_senseFilter) {
            SpeciesSenseFilter.any => true,
            SpeciesSenseFilter.darkvision => option.hasDarkvision,
            SpeciesSenseFilter.noDarkvision => !option.hasDarkvision,
          };
        })
        .toList(growable: false);
  }

  Future<void> _selectOption(SpeciesRacePickerOption option) {
    return widget.controller.setRace(option.ref);
  }

  Future<void> _openDetail(SpeciesRacePickerOption option) {
    return showGuidedSpeciesRaceDetailSheet(
      context,
      option: option,
      service: widget.controller.compendium,
      terminology: widget.terminology,
      selected: _isSelected(option),
      onChoose: () => _selectOption(option),
    );
  }

  bool _isSelected(SpeciesRacePickerOption option) {
    final current = widget.controller.character!.raceRef;
    return current?.rulesetId == option.ref.rulesetId &&
        current?.entityType == option.ref.entityType &&
        current?.entityId == option.ref.entityId;
  }

  @override
  Widget build(BuildContext context) {
    final terminology = widget.terminology;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose ${terminology.displayLabel}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Traits, movement, senses, languages, and some proficiencies can come ${terminology.choiceSourceLabel}.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _SpeciesRaceFilters(
              searchController: _searchController,
              installedRulesets: widget.controller.installedRulesets,
              primaryRulesetId: widget.controller.character!.primaryRulesetId,
              rulesetScope: _rulesetScope,
              senseFilter: _senseFilter,
              onRulesetScopeChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _rulesetScope = value;
                  _futureOptions = _loadOptions();
                });
              },
              onSenseFilterChanged: (filter) {
                setState(() {
                  _senseFilter = filter;
                });
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<SpeciesRacePickerOption>>(
              future: _futureOptions,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${terminology.displayLabel} choices could not be loaded.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final options = _filteredOptions(snapshot.data ?? const []);
                if (options.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No ${terminology.lowerLabel} choices match those filters.',
                    ),
                  );
                }

                return _OptionCardWrap<SpeciesRacePickerOption>(
                  options: options,
                  itemBuilder: (option) {
                    final selected = _isSelected(option);
                    return _SpeciesRaceChoiceCard(
                      option: option,
                      terminology: terminology,
                      selected: selected,
                      onChoose: () => _selectOption(option),
                      onOpenDetail: () => _openDetail(option),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GuidedBackgroundPicker extends StatefulWidget {
  final CharacterEditorController controller;

  const GuidedBackgroundPicker({super.key, required this.controller});

  @override
  State<GuidedBackgroundPicker> createState() => _GuidedBackgroundPickerState();
}

class _GuidedBackgroundPickerState extends State<GuidedBackgroundPicker> {
  final TextEditingController _searchController = TextEditingController();

  late String _rulesetScope = widget.controller.character!.primaryRulesetId;
  String _skillFilter = '__any__';
  late Future<List<BackgroundPickerOption>> _futureOptions = _loadOptions();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<String> get _activeRulesetIds {
    if (_rulesetScope == '__all__') {
      return widget.controller.installedRulesets
          .map((ruleset) => ruleset.id)
          .toList(growable: false);
    }
    return <String>[_rulesetScope];
  }

  Future<List<BackgroundPickerOption>> _loadOptions() async {
    final service = widget.controller.compendium;
    final results = await service.searchEntities(
      rulesetIds: _activeRulesetIds,
      entityTypes: const ['background'],
      limit: 300,
    );
    final options = <BackgroundPickerOption>[];
    for (final result in results) {
      final loadedEntity = await service.loadResolvedEntity(result.ref);
      if (loadedEntity == null) {
        continue;
      }
      options.add(
        BackgroundPickerOption(
          ref: result.ref,
          rulesetName: result.rulesetName,
          detail: loadedEntity.detail,
        ),
      );
    }
    options.sort(
      (left, right) => left.displayName.compareTo(right.displayName),
    );
    return options;
  }

  List<BackgroundPickerOption> _filteredOptions(
    List<BackgroundPickerOption> options,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return options
        .where((option) {
          if (query.isNotEmpty &&
              !option.displayName.toLowerCase().contains(query)) {
            return false;
          }
          if (_skillFilter != '__any__' &&
              !option.filterableSkillNames.contains(_skillFilter)) {
            return false;
          }
          return true;
        })
        .toList(growable: false);
  }

  Future<void> _selectOption(BackgroundPickerOption option) {
    return widget.controller.setBackground(option.ref);
  }

  Future<void> _openDetail(BackgroundPickerOption option) {
    return showGuidedBackgroundDetailSheet(
      context,
      option: option,
      service: widget.controller.compendium,
      selected: _isSelected(option),
      onChoose: () => _selectOption(option),
    );
  }

  bool _isSelected(BackgroundPickerOption option) {
    final current = widget.controller.character!.backgroundRef;
    return current?.rulesetId == option.ref.rulesetId &&
        current?.entityType == option.ref.entityType &&
        current?.entityId == option.ref.entityId;
  }

  List<String> _availableSkills(List<BackgroundPickerOption> options) {
    final skills = <String>{};
    for (final option in options) {
      skills.addAll(option.filterableSkillNames);
    }
    return skills.toList(growable: false)..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Background',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Skills, tools, languages, equipment, story hooks, and sometimes ability scores come from your background.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _BackgroundBaseFilters(
              searchController: _searchController,
              installedRulesets: widget.controller.installedRulesets,
              primaryRulesetId: widget.controller.character!.primaryRulesetId,
              rulesetScope: _rulesetScope,
              onRulesetScopeChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _rulesetScope = value;
                  _skillFilter = '__any__';
                  _futureOptions = _loadOptions();
                });
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<BackgroundPickerOption>>(
              future: _futureOptions,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Background choices could not be loaded.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final allOptions = snapshot.data ?? const [];
                final skillOptions = _availableSkills(allOptions);
                final options = _filteredOptions(allOptions);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (skillOptions.isNotEmpty) ...[
                      SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          key: const Key('guided-background-skill-filter'),
                          initialValue: _skillFilter,
                          decoration: const InputDecoration(
                            labelText: 'Skill',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: '__any__',
                              child: Text('Any skill'),
                            ),
                            ...skillOptions.map(
                              (skill) => DropdownMenuItem<String>(
                                value: skill,
                                child: Text(skill),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _skillFilter = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (options.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No backgrounds match those filters.'),
                      )
                    else
                      _OptionCardWrap<BackgroundPickerOption>(
                        options: options,
                        itemBuilder: (option) {
                          final selected = _isSelected(option);
                          return _BackgroundChoiceCard(
                            option: option,
                            selected: selected,
                            onChoose: () => _selectOption(option),
                            onOpenDetail: () => _openDetail(option),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SpeciesRaceImpactSummary extends StatelessWidget {
  final CharacterEditorController controller;
  final SpeciesRaceTerminology terminology;

  const SpeciesRaceImpactSummary({
    super.key,
    required this.controller,
    required this.terminology,
  });

  @override
  Widget build(BuildContext context) {
    final ref = controller.character!.raceRef;
    if (ref == null) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<CharacterResolvedEntity?>(
      future: controller.compendium.loadResolvedEntity(ref),
      builder: (context, snapshot) {
        final option = snapshot.data == null
            ? null
            : SpeciesRacePickerOption(
                ref: ref,
                rulesetName: snapshot.data!.rulesetName,
                detail: snapshot.data!.detail,
              );
        final chips = <String>[
          if (option?.speedSummary != null) 'Movement: ${option!.speedSummary}',
          if (option?.sizeSummary != null) 'Size: ${option!.sizeSummary}',
          if (option?.traitNames.isNotEmpty == true)
            'Traits: ${option!.traitNames.take(3).join(', ')}',
          if (option?.senses.isNotEmpty == true)
            'Senses: ${option!.senses.join(', ')}',
          if (option?.resistances.isNotEmpty == true)
            'Resistances: ${option!.resistances.join(', ')}',
          if (option?.languageSummary != null)
            'Languages: ${option!.languageSummary}',
          if (option?.abilitySummary != null)
            'Ability scores: ${option!.abilitySummary}',
        ];
        return _ImpactSummaryCard(
          title: 'What This ${terminology.displayLabel} Affects',
          description:
              'This is a play summary. The review step will call out anything that needs attention.',
          chips: chips.isEmpty
              ? const [
                  'Traits and movement appear when the selected rules list them.',
                ]
              : chips,
        );
      },
    );
  }
}

class BackgroundImpactSummary extends StatelessWidget {
  final CharacterEditorController controller;

  const BackgroundImpactSummary({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ref = controller.character!.backgroundRef;
    if (ref == null) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<CharacterResolvedEntity?>(
      future: controller.compendium.loadResolvedEntity(ref),
      builder: (context, snapshot) {
        final option = snapshot.data == null
            ? null
            : BackgroundPickerOption(
                ref: ref,
                rulesetName: snapshot.data!.rulesetName,
                detail: snapshot.data!.detail,
              );
        final chips = <String>[
          if (option?.skillSummary != null) 'Skills: ${option!.skillSummary}',
          if (option?.toolSummary != null) 'Tools: ${option!.toolSummary}',
          if (option?.languageSummary != null)
            'Languages: ${option!.languageSummary}',
          if (option?.abilitySummary != null)
            'Ability scores: ${option!.abilitySummary}',
          if (option?.featSummary != null)
            'Starting feat: ${option!.featSummary}',
          if (option?.equipmentSummary != null)
            'Equipment: ${option!.equipmentSummary}',
          if (option?.featureNames.isNotEmpty == true)
            'Story hooks: ${option!.featureNames.take(2).join(', ')}',
        ];
        return _ImpactSummaryCard(
          title: 'What This Background Affects',
          description:
              'This is a play summary. The review step will call out anything that needs attention.',
          chips: chips.isEmpty
              ? const [
                  'Skills, tools, languages, and story hooks appear when the selected rules list them.',
                ]
              : chips,
        );
      },
    );
  }
}

class SpeciesRacePickerOption {
  final CharacterEntityRef ref;
  final String? rulesetName;
  final CompendiumEntityDetail detail;

  SpeciesRacePickerOption({
    required this.ref,
    required this.rulesetName,
    required this.detail,
  });

  String get displayName => ref.displayName;
  Map<String, dynamic> get data => detail.entity.data;

  String? get sizeSummary => _sizeSummary(data['size'], data['sizeEntry']);
  String? get speedSummary => _speedSummary(data['speed']);
  String? get abilitySummary => _abilitySummary(data['ability']);
  String? get languageSummary =>
      _summaryFromChoiceList(
        data['languageProficiencies'],
        kind: 'languages',
      ) ??
      _summaryFromChoiceList(data['languages'], kind: 'languages');
  List<String> get senses => _senseSummaries(data);
  bool get hasDarkvision =>
      senses.any((sense) => sense.toLowerCase().contains('darkvision'));
  List<String> get resistances =>
      _choiceList(data['resist'], kind: 'resistances');
  List<String> get proficiencies => [
    ..._choiceList(data['skillProficiencies'], kind: 'skills'),
    ..._choiceList(data['toolProficiencies'], kind: 'tools'),
    ..._choiceList(data['weaponProficiencies'], kind: 'weapons'),
    ..._choiceList(data['armorProficiencies'], kind: 'armor'),
  ];
  List<String> get traitNames => _entryNames(data['entries']);

  String get summary {
    final pieces = <String>[
      if (sizeSummary != null) sizeSummary!,
      if (speedSummary != null) '$speedSummary movement',
      if (senses.isNotEmpty) senses.first,
      if (resistances.isNotEmpty) '${resistances.first} resistance',
      if (traitNames.isNotEmpty) traitNames.take(2).join(', '),
    ];
    if (pieces.isEmpty) {
      return 'Details are available in the rules entry.';
    }
    return pieces.join(', ');
  }
}

class BackgroundPickerOption {
  final CharacterEntityRef ref;
  final String? rulesetName;
  final CompendiumEntityDetail detail;

  BackgroundPickerOption({
    required this.ref,
    required this.rulesetName,
    required this.detail,
  });

  String get displayName => ref.displayName;
  Map<String, dynamic> get data => detail.entity.data;

  String? get abilitySummary => _abilitySummary(data['ability']);
  String? get skillSummary =>
      _summaryFromChoiceList(data['skillProficiencies'], kind: 'skills');
  String? get toolSummary =>
      _summaryFromChoiceList(data['toolProficiencies'], kind: 'tools');
  String? get languageSummary =>
      _summaryFromChoiceList(data['languageProficiencies'], kind: 'languages');
  String? get featSummary => _summaryFromFeatList(data['feats']);
  String? get equipmentSummary =>
      _startingEquipmentSummary(data['startingEquipment']);
  List<String> get featureNames => _backgroundFeatureNames(data['entries']);
  Set<String> get filterableSkillNames =>
      _filterableChoiceNames(data['skillProficiencies']);

  String get summary {
    final pieces = <String>[
      if (abilitySummary != null) 'Ability scores: $abilitySummary',
      if (skillSummary != null) 'Skills: $skillSummary',
      if (featSummary != null) 'Feat: $featSummary',
      if (featureNames.isNotEmpty) featureNames.take(2).join(', '),
    ];
    if (pieces.isEmpty) {
      return 'Details are available in the rules entry.';
    }
    return pieces.join(', ');
  }
}

class _SpeciesRaceFilters extends StatelessWidget {
  final TextEditingController searchController;
  final List<RulesetSummary> installedRulesets;
  final String primaryRulesetId;
  final String rulesetScope;
  final SpeciesSenseFilter senseFilter;
  final ValueChanged<String?> onRulesetScopeChanged;
  final ValueChanged<SpeciesSenseFilter> onSenseFilterChanged;

  const _SpeciesRaceFilters({
    required this.searchController,
    required this.installedRulesets,
    required this.primaryRulesetId,
    required this.rulesetScope,
    required this.senseFilter,
    required this.onRulesetScopeChanged,
    required this.onSenseFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final showRulesetFilter = installedRulesets.length > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('guided-species-race-search'),
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search names',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SegmentedButton<SpeciesSenseFilter>(
              key: const Key('guided-species-race-sense-filter'),
              segments: const [
                ButtonSegment(
                  value: SpeciesSenseFilter.any,
                  label: Text('Any'),
                ),
                ButtonSegment(
                  value: SpeciesSenseFilter.darkvision,
                  label: Text('Darkvision'),
                ),
                ButtonSegment(
                  value: SpeciesSenseFilter.noDarkvision,
                  label: Text('No darkvision'),
                ),
              ],
              selected: {senseFilter},
              onSelectionChanged: (selection) =>
                  onSenseFilterChanged(selection.first),
            ),
            if (showRulesetFilter)
              _RulesetScopeDropdown(
                installedRulesets: installedRulesets,
                primaryRulesetId: primaryRulesetId,
                rulesetScope: rulesetScope,
                onChanged: onRulesetScopeChanged,
              ),
          ],
        ),
      ],
    );
  }
}

class _BackgroundBaseFilters extends StatelessWidget {
  final TextEditingController searchController;
  final List<RulesetSummary> installedRulesets;
  final String primaryRulesetId;
  final String rulesetScope;
  final ValueChanged<String?> onRulesetScopeChanged;

  const _BackgroundBaseFilters({
    required this.searchController,
    required this.installedRulesets,
    required this.primaryRulesetId,
    required this.rulesetScope,
    required this.onRulesetScopeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final showRulesetFilter = installedRulesets.length > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('guided-background-search'),
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search background names',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        if (showRulesetFilter) ...[
          const SizedBox(height: 12),
          _RulesetScopeDropdown(
            installedRulesets: installedRulesets,
            primaryRulesetId: primaryRulesetId,
            rulesetScope: rulesetScope,
            onChanged: onRulesetScopeChanged,
          ),
        ],
      ],
    );
  }
}

class _RulesetScopeDropdown extends StatelessWidget {
  final List<RulesetSummary> installedRulesets;
  final String primaryRulesetId;
  final String rulesetScope;
  final ValueChanged<String?> onChanged;

  const _RulesetScopeDropdown({
    required this.installedRulesets,
    required this.primaryRulesetId,
    required this.rulesetScope,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: DropdownButtonFormField<String>(
        initialValue: rulesetScope,
        decoration: const InputDecoration(
          labelText: 'Ruleset',
          border: OutlineInputBorder(),
        ),
        items: [
          DropdownMenuItem<String>(
            value: primaryRulesetId,
            child: const Text('Primary ruleset'),
          ),
          const DropdownMenuItem<String>(
            value: '__all__',
            child: Text('All installed rulesets'),
          ),
          ...installedRulesets
              .where((ruleset) => ruleset.id != primaryRulesetId)
              .map(
                (ruleset) => DropdownMenuItem<String>(
                  value: ruleset.id,
                  child: Text(ruleset.name),
                ),
              ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _OptionCardWrap<T> extends StatelessWidget {
  final List<T> options;
  final Widget Function(T option) itemBuilder;

  const _OptionCardWrap({required this.options, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width < 760
            ? 1
            : width < 1180
            ? 2
            : 3;
        const spacing = 12.0;
        final cardWidth = columns == 1
            ? width
            : (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: options
              .map(
                (option) =>
                    SizedBox(width: cardWidth, child: itemBuilder(option)),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _SpeciesRaceChoiceCard extends StatelessWidget {
  final SpeciesRacePickerOption option;
  final SpeciesRaceTerminology terminology;
  final bool selected;
  final Future<void> Function() onChoose;
  final Future<void> Function() onOpenDetail;

  const _SpeciesRaceChoiceCard({
    required this.option,
    required this.terminology,
    required this.selected,
    required this.onChoose,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: selected ? colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OptionTitleRow(
              ref: option.ref,
              title: option.displayName,
              selected: selected,
              onOpenDetail: onOpenDetail,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (option.rulesetName?.trim().isNotEmpty == true)
                  Chip(label: Text(option.rulesetName!.trim())),
                if (option.sizeSummary != null)
                  _TermChip(term: 'Size', value: option.sizeSummary!),
                if (option.speedSummary != null)
                  _TermChip(term: 'Speed', value: option.speedSummary!),
                if (option.senses.isNotEmpty)
                  _TermChip(term: 'Darkvision', value: option.senses.first),
              ],
            ),
            const SizedBox(height: 10),
            Text(option.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            _SpeciesRaceFactLines(option: option, compact: true),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  key: Key('choose-species-race:${option.ref.entityId}'),
                  onPressed: selected ? null : onChoose,
                  icon: Icon(selected ? Icons.check : Icons.add),
                  label: Text(
                    selected ? 'Selected' : terminology.chooseActionLabel,
                  ),
                ),
                OutlinedButton.icon(
                  key: Key('species-race-detail:${option.ref.entityId}'),
                  onPressed: onOpenDetail,
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundChoiceCard extends StatelessWidget {
  final BackgroundPickerOption option;
  final bool selected;
  final Future<void> Function() onChoose;
  final Future<void> Function() onOpenDetail;

  const _BackgroundChoiceCard({
    required this.option,
    required this.selected,
    required this.onChoose,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: selected ? colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OptionTitleRow(
              ref: option.ref,
              title: option.displayName,
              selected: selected,
              onOpenDetail: onOpenDetail,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (option.rulesetName?.trim().isNotEmpty == true)
                  Chip(label: Text(option.rulesetName!.trim())),
                if (option.abilitySummary != null)
                  Chip(label: Text('Abilities: ${option.abilitySummary}')),
                if (option.featSummary != null)
                  _TermChip(term: 'Feat', value: option.featSummary!),
              ],
            ),
            const SizedBox(height: 10),
            Text(option.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            _BackgroundFactLines(option: option, compact: true),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  key: Key('choose-background:${option.ref.entityId}'),
                  onPressed: selected ? null : onChoose,
                  icon: Icon(selected ? Icons.check : Icons.add),
                  label: Text(selected ? 'Selected' : 'Choose Background'),
                ),
                OutlinedButton.icon(
                  key: Key('background-detail:${option.ref.entityId}'),
                  onPressed: onOpenDetail,
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTitleRow extends StatelessWidget {
  final CharacterEntityRef ref;
  final String title;
  final bool selected;
  final Future<void> Function() onOpenDetail;

  const _OptionTitleRow({
    required this.ref,
    required this.title,
    required this.selected,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: CompendiumReferenceAnchor(
            rulesetId: ref.rulesetId,
            entityType: ref.entityType,
            entityId: ref.entityId,
            entityName: title,
            onTap: onOpenDetail,
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        if (selected)
          Chip(
            avatar: const Icon(Icons.check_circle, size: 18),
            label: const Text('Selected'),
            backgroundColor: colorScheme.primary,
            labelStyle: TextStyle(color: colorScheme.onPrimary),
          ),
      ],
    );
  }
}

class _SpeciesRaceFactLines extends StatelessWidget {
  final SpeciesRacePickerOption option;
  final bool compact;

  const _SpeciesRaceFactLines({required this.option, required this.compact});

  @override
  Widget build(BuildContext context) {
    final lines = <Widget>[
      if (option.abilitySummary != null)
        _FactLine(term: 'Ability Score', value: option.abilitySummary!),
      if (option.languageSummary != null)
        _FactLine(term: 'Language', value: option.languageSummary!),
      if (option.senses.length > 1)
        _FactLine(
          term: 'Darkvision',
          label: 'Senses',
          value: option.senses.join(', '),
        ),
      if (option.resistances.isNotEmpty)
        _FactLine(term: 'Resistance', value: option.resistances.join(', ')),
      if (option.proficiencies.isNotEmpty)
        _FactLine(term: 'Proficiency', value: option.proficiencies.join(', ')),
      if (option.traitNames.isNotEmpty)
        _FactLine(term: 'Trait', value: option.traitNames.take(4).join(', ')),
    ];

    return _FactLineColumn(lines: lines, compact: compact);
  }
}

class _BackgroundFactLines extends StatelessWidget {
  final BackgroundPickerOption option;
  final bool compact;

  const _BackgroundFactLines({required this.option, required this.compact});

  @override
  Widget build(BuildContext context) {
    final lines = <Widget>[
      if (option.skillSummary != null)
        _FactLine(term: 'Skill', value: option.skillSummary!),
      if (option.toolSummary != null)
        _FactLine(
          term: 'Tool Proficiency',
          label: 'Tools',
          value: option.toolSummary!,
        ),
      if (option.languageSummary != null)
        _FactLine(term: 'Language', value: option.languageSummary!),
      if (option.equipmentSummary != null)
        _FactLine(term: 'Equipment', value: option.equipmentSummary!),
      if (option.featureNames.isNotEmpty)
        _FactLine(
          term: 'Trait',
          label: 'Hooks',
          value: option.featureNames.take(3).join(', '),
        ),
    ];

    return _FactLineColumn(lines: lines, compact: compact);
  }
}

class _FactLineColumn extends StatelessWidget {
  final List<Widget> lines;
  final bool compact;

  const _FactLineColumn({required this.lines, required this.compact});

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return const SizedBox.shrink();
    }
    final visibleLines = compact
        ? lines.take(4).toList(growable: false)
        : lines;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in visibleLines)
          Padding(padding: const EdgeInsets.only(bottom: 4), child: line),
      ],
    );
  }
}

class _FactLine extends StatelessWidget {
  final String term;
  final String? label;
  final String value;

  const _FactLine({required this.term, this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _tooltipForTerm(term),
      child: Text(
        '${label ?? term}: $value',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _TermChip extends StatelessWidget {
  final String term;
  final String value;

  const _TermChip({required this.term, required this.value});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _tooltipForTerm(term),
      child: Chip(label: Text('$term: $value')),
    );
  }
}

class _ImpactSummaryCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> chips;

  const _ImpactSummaryCard({
    required this.title,
    required this.description,
    required this.chips,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final chip in chips) Chip(label: Text(chip))],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showGuidedSpeciesRaceDetailSheet(
  BuildContext context, {
  required SpeciesRacePickerOption option,
  required CharacterCompendiumService service,
  required SpeciesRaceTerminology terminology,
  required bool selected,
  required Future<void> Function() onChoose,
}) {
  Future<void> openFullEntry(BuildContext sheetContext) async {
    Navigator.of(sheetContext).pop();
    await Future<void>.delayed(Duration.zero);
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CompendiumEntityDetailScreen(
          rulesetId: option.ref.rulesetId,
          entityType: option.ref.entityType,
          entityId: option.ref.entityId,
          browseRepository: service.browseRepository,
        ),
      ),
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return FractionallySizedBox(
        heightFactor: 0.92,
        child: _SpeciesRaceDetailSheet(
          option: option,
          terminology: terminology,
          selected: selected,
          onChoose: () async {
            await onChoose();
            if (sheetContext.mounted) {
              Navigator.of(sheetContext).pop();
            }
          },
          onOpenFullEntry: () => openFullEntry(sheetContext),
        ),
      );
    },
  );
}

Future<void> showGuidedBackgroundDetailSheet(
  BuildContext context, {
  required BackgroundPickerOption option,
  required CharacterCompendiumService service,
  required bool selected,
  required Future<void> Function() onChoose,
}) {
  Future<void> openFullEntry(BuildContext sheetContext) async {
    Navigator.of(sheetContext).pop();
    await Future<void>.delayed(Duration.zero);
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CompendiumEntityDetailScreen(
          rulesetId: option.ref.rulesetId,
          entityType: option.ref.entityType,
          entityId: option.ref.entityId,
          browseRepository: service.browseRepository,
        ),
      ),
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return FractionallySizedBox(
        heightFactor: 0.92,
        child: _BackgroundDetailSheet(
          option: option,
          selected: selected,
          onChoose: () async {
            await onChoose();
            if (sheetContext.mounted) {
              Navigator.of(sheetContext).pop();
            }
          },
          onOpenFullEntry: () => openFullEntry(sheetContext),
        ),
      );
    },
  );
}

class _SpeciesRaceDetailSheet extends StatelessWidget {
  final SpeciesRacePickerOption option;
  final SpeciesRaceTerminology terminology;
  final bool selected;
  final Future<void> Function() onChoose;
  final Future<void> Function() onOpenFullEntry;

  const _SpeciesRaceDetailSheet({
    required this.option,
    required this.terminology,
    required this.selected,
    required this.onChoose,
    required this.onOpenFullEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  '${option.displayName} Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(option.summary),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (option.rulesetName?.trim().isNotEmpty == true)
                      Chip(label: Text(option.rulesetName!.trim())),
                    if (option.sizeSummary != null)
                      _TermChip(term: 'Size', value: option.sizeSummary!),
                    if (option.speedSummary != null)
                      _TermChip(term: 'Speed', value: option.speedSummary!),
                    for (final sense in option.senses)
                      _TermChip(term: 'Darkvision', value: sense),
                  ],
                ),
                const SizedBox(height: 18),
                _DetailSection(
                  title: 'Traits',
                  child: option.traitNames.isEmpty
                      ? const Text('Traits are listed in the full rules entry.')
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final trait in option.traitNames)
                              Chip(label: Text(trait)),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                _DetailSection(
                  title: 'Rules Benefits',
                  child: _SpeciesRaceFactLines(option: option, compact: false),
                ),
                const SizedBox(height: 16),
                _DetailSection(
                  title: 'Source',
                  child: Text(
                    option.rulesetName?.trim().isNotEmpty == true
                        ? option.rulesetName!.trim()
                        : option.ref.rulesetId,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                key: Key('species-race-detail-choose:${option.ref.entityId}'),
                onPressed: selected ? null : onChoose,
                icon: Icon(selected ? Icons.check : Icons.add),
                label: Text(
                  selected ? 'Selected' : terminology.chooseActionLabel,
                ),
              ),
              OutlinedButton.icon(
                onPressed: onOpenFullEntry,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open Full Rules Entry'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackgroundDetailSheet extends StatelessWidget {
  final BackgroundPickerOption option;
  final bool selected;
  final Future<void> Function() onChoose;
  final Future<void> Function() onOpenFullEntry;

  const _BackgroundDetailSheet({
    required this.option,
    required this.selected,
    required this.onChoose,
    required this.onOpenFullEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  '${option.displayName} Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(option.summary),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (option.rulesetName?.trim().isNotEmpty == true)
                      Chip(label: Text(option.rulesetName!.trim())),
                    if (option.abilitySummary != null)
                      Chip(label: Text('Abilities: ${option.abilitySummary}')),
                    if (option.featSummary != null)
                      _TermChip(term: 'Feat', value: option.featSummary!),
                  ],
                ),
                const SizedBox(height: 18),
                _DetailSection(
                  title: 'Mechanical Benefits',
                  child: _BackgroundFactLines(option: option, compact: false),
                ),
                if (option.featureNames.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _DetailSection(
                    title: 'Story Hooks',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final feature in option.featureNames)
                          Chip(label: Text(feature)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _DetailSection(
                  title: 'Source',
                  child: Text(
                    option.rulesetName?.trim().isNotEmpty == true
                        ? option.rulesetName!.trim()
                        : option.ref.rulesetId,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                key: Key('background-detail-choose:${option.ref.entityId}'),
                onPressed: selected ? null : onChoose,
                icon: Icon(selected ? Icons.check : Icons.add),
                label: Text(selected ? 'Selected' : 'Choose Background'),
              ),
              OutlinedButton.icon(
                onPressed: onOpenFullEntry,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open Full Rules Entry'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

String _tooltipForTerm(String term) {
  return switch (term) {
    'Darkvision' =>
      'A sense that lets you see in darkness within the listed range.',
    'Resistance' => 'A rule that reduces damage of the listed type.',
    'Proficiency' =>
      'Training that lets you add your proficiency bonus when the rules apply.',
    'Language' => 'A language your character can speak, read, or sign.',
    'Speed' => 'How far your character can move on a turn.',
    'Size' => 'The physical size category used by the rules.',
    'Feat' => 'A special talent or rule benefit your character gains.',
    'Skill' => 'A trained area that uses an ability check.',
    'Tool Proficiency' =>
      'Training with a tool that can add your proficiency bonus.',
    'Ability Score' => 'A rule that affects one or more ability scores.',
    'Trait' => 'A feature or story hook from this choice.',
    'Equipment' => 'Starting gear or gold from your background.',
    _ => term,
  };
}

String? _sizeSummary(dynamic rawSize, dynamic rawSizeEntry) {
  final sizes = <String>[];
  if (rawSize is String) {
    sizes.add(_sizeLabel(rawSize));
  } else if (rawSize is List) {
    for (final value in rawSize) {
      final label = _sizeLabel(value.toString());
      if (label.isNotEmpty) {
        sizes.add(label);
      }
    }
  }
  if (sizes.isNotEmpty) {
    return _joinOr(sizes);
  }
  final entryText = _plainText(rawSizeEntry);
  return entryText.isEmpty ? null : entryText;
}

String _sizeLabel(String value) {
  return switch (value.trim().toUpperCase()) {
    'T' => 'Tiny',
    'S' => 'Small',
    'M' => 'Medium',
    'L' => 'Large',
    'H' => 'Huge',
    'G' => 'Gargantuan',
    _ => _titleCase(value),
  };
}

String? _speedSummary(dynamic rawSpeed) {
  if (rawSpeed is num) {
    return '${rawSpeed.toInt()} ft';
  }
  if (rawSpeed is String && rawSpeed.trim().isNotEmpty) {
    return rawSpeed.trim();
  }
  if (rawSpeed is Map) {
    final pieces = <String>[];
    for (final entry in rawSpeed.entries) {
      final value = entry.value;
      if (value is num) {
        pieces.add('${_titleCase(entry.key.toString())} ${value.toInt()} ft');
      } else if (value is String && value.trim().isNotEmpty) {
        pieces.add('${_titleCase(entry.key.toString())} ${value.trim()}');
      }
    }
    return pieces.isEmpty ? null : pieces.join(', ');
  }
  return null;
}

String? _abilitySummary(dynamic raw) {
  if (raw == null) {
    return null;
  }

  final direct = <String>[];
  void collectDirect(dynamic value) {
    if (value is List) {
      for (final item in value) {
        collectDirect(item);
      }
      return;
    }
    if (value is Map) {
      for (final entry in value.entries) {
        final ability = _abilityLabelOrNull(entry.key.toString());
        if (ability != null && entry.value is num) {
          final bonus = (entry.value as num).toInt();
          direct.add('$ability ${bonus >= 0 ? '+' : ''}$bonus');
        }
      }
    }
  }

  collectDirect(raw);
  if (direct.isNotEmpty) {
    return _unique(direct).join(', ');
  }

  final abilities = <String>{};
  void collectAbilities(dynamic value) {
    if (value is String) {
      final label = _abilityLabelOrNull(value);
      if (label != null) {
        abilities.add(label);
      }
      return;
    }
    if (value is List) {
      for (final item in value) {
        collectAbilities(item);
      }
      return;
    }
    if (value is Map) {
      for (final entry in value.entries) {
        collectAbilities(entry.key);
        collectAbilities(entry.value);
      }
    }
  }

  collectAbilities(raw);
  if (abilities.isEmpty) {
    return null;
  }
  return 'Choose from ${_joinOr(abilities.toList(growable: false))}';
}

String? _summaryFromChoiceList(dynamic raw, {required String kind}) {
  final values = _choiceList(raw, kind: kind);
  return values.isEmpty ? null : values.join(', ');
}

List<String> _choiceList(dynamic raw, {required String kind}) {
  if (raw == null) {
    return const <String>[];
  }
  final values = <String>[];

  void visit(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is String) {
      final cleaned = _cleanReferenceName(value);
      if (cleaned.isNotEmpty) {
        values.add(cleaned);
      }
      return;
    }
    if (value is List) {
      for (final item in value) {
        visit(item);
      }
      return;
    }
    if (value is Map) {
      if (value['choose'] is Map) {
        final choose = value['choose'] as Map;
        final count =
            (choose['count'] as num?)?.toInt() ??
            (choose['amount'] as num?)?.toInt() ??
            1;
        final from = _choiceNamesFromValue(
          choose['from'] ?? choose['weighted']?['from'],
        );
        if (from.isEmpty) {
          values.add('Choose $count $kind');
        } else {
          values.add('Choose $count from ${from.join(', ')}');
        }
        return;
      }
      if (value['any'] is num) {
        values.add('Choose ${(value['any'] as num).toInt()} $kind');
        return;
      }
      for (final entry in value.entries) {
        if (entry.value == true || entry.value is num) {
          final label = _cleanReferenceName(entry.key.toString());
          if (label.isNotEmpty) {
            values.add(label);
          }
        }
      }
    }
  }

  visit(raw);
  return _unique(values);
}

Set<String> _filterableChoiceNames(dynamic raw) {
  final names = <String>{};
  for (final value in _choiceList(raw, kind: 'choices')) {
    if (!value.toLowerCase().startsWith('choose ')) {
      names.add(value);
    }
  }
  return names;
}

List<String> _choiceNamesFromValue(dynamic value) {
  final names = <String>[];
  if (value is List) {
    for (final item in value) {
      final name = _cleanReferenceName(item.toString());
      if (name.isNotEmpty) {
        names.add(name);
      }
    }
  }
  return names;
}

String? _summaryFromFeatList(dynamic raw) {
  final feats = <String>[];

  void visit(dynamic value) {
    if (value == null) {
      return;
    }
    if (value is String) {
      feats.add(_cleanReferenceName(value));
      return;
    }
    if (value is List) {
      for (final item in value) {
        visit(item);
      }
      return;
    }
    if (value is Map) {
      if (value['anyFromCategory'] is Map) {
        final category = value['anyFromCategory'] as Map;
        final count = (category['count'] as num?)?.toInt() ?? 1;
        final categories = (category['category'] as List<dynamic>? ?? const [])
            .map((item) => item.toString().toUpperCase())
            .toList(growable: false);
        final label = categories.contains('O') ? 'Origin feat' : 'feat';
        feats.add('Choose $count $label');
        return;
      }
      for (final entry in value.entries) {
        if (entry.value == true || entry.value is num) {
          feats.add(_cleanReferenceName(entry.key.toString()));
        }
      }
    }
  }

  visit(raw);
  final clean = _unique(feats).where((entry) => entry.isNotEmpty).toList();
  return clean.isEmpty ? null : clean.join(', ');
}

String? _startingEquipmentSummary(dynamic raw) {
  if (raw is! List || raw.isEmpty) {
    return null;
  }

  final optionSummaries = <String>[];
  for (final item in raw) {
    if (item is! Map) {
      continue;
    }
    for (final entry in item.entries) {
      final optionLabel = entry.key.toString();
      final values = entry.value;
      if (values is! List) {
        continue;
      }
      final pieces = <String>[];
      for (final value in values) {
        if (value is! Map) {
          continue;
        }
        if (value['value'] is num) {
          pieces.add(_coinValue((value['value'] as num).toInt()));
          continue;
        }
        final displayName = value['displayName']?.toString();
        final itemRef = value['item']?.toString();
        final name = displayName?.trim().isNotEmpty == true
            ? displayName!.trim()
            : itemRef == null
            ? ''
            : _cleanReferenceName(itemRef);
        if (name.isNotEmpty) {
          final quantity = (value['quantity'] as num?)?.toInt();
          pieces.add(
            quantity == null || quantity == 1 ? name : '$name x$quantity',
          );
        }
      }
      if (pieces.isEmpty) {
        continue;
      }
      final visible = pieces.take(3).toList(growable: false);
      final overflow = pieces.length - visible.length;
      optionSummaries.add(
        '$optionLabel: ${visible.join(', ')}${overflow > 0 ? ', +$overflow more' : ''}',
      );
    }
  }

  return optionSummaries.isEmpty ? null : optionSummaries.join('; ');
}

String _coinValue(int copperValue) {
  if (copperValue >= 100 && copperValue % 100 == 0) {
    return '${copperValue ~/ 100} GP';
  }
  return '$copperValue CP';
}

List<String> _senseSummaries(Map<String, dynamic> data) {
  final senses = <String>[];
  void addRange(String label, dynamic value) {
    if (value is num) {
      senses.add('$label ${value.toInt()} ft');
    } else if (value is String && value.trim().isNotEmpty) {
      senses.add('$label ${value.trim()}');
    }
  }

  addRange('Darkvision', data['darkvision']);
  addRange('Blindsight', data['blindsight']);
  addRange('Tremorsense', data['tremorsense']);
  addRange('Truesight', data['truesight']);
  final rawSenses = data['senses'];
  if (rawSenses is List) {
    for (final sense in rawSenses) {
      final label = _cleanReferenceName(sense.toString());
      if (label.isNotEmpty) {
        senses.add(label);
      }
    }
  }
  return _unique(senses);
}

List<String> _entryNames(dynamic rawEntries) {
  if (rawEntries is! List) {
    return const <String>[];
  }
  final names = <String>[];
  for (final entry in rawEntries) {
    if (entry is Map) {
      final name = entry['name']?.toString().trim();
      if (name != null && name.isNotEmpty) {
        names.add(_cleanEntryLabel(name));
      }
    }
  }
  return _unique(names);
}

List<String> _backgroundFeatureNames(dynamic rawEntries) {
  final names = _entryNames(rawEntries)
      .where((name) => !_isMechanicalBackgroundLabel(name))
      .toList(growable: false);
  if (names.isNotEmpty) {
    return names;
  }
  if (rawEntries is List) {
    final itemNames = <String>[];
    for (final entry in rawEntries.whereType<Map>()) {
      final items = entry['items'];
      if (items is! List) {
        continue;
      }
      for (final item in items.whereType<Map>()) {
        final name = item['name']?.toString().trim();
        if (name != null &&
            name.isNotEmpty &&
            !_isMechanicalBackgroundLabel(name)) {
          itemNames.add(_cleanEntryLabel(name));
        }
      }
    }
    return _unique(itemNames);
  }
  return const <String>[];
}

bool _isMechanicalBackgroundLabel(String value) {
  final normalized = value.toLowerCase().replaceAll(':', '').trim();
  return normalized == 'ability scores' ||
      normalized == 'feat' ||
      normalized == 'skill proficiencies' ||
      normalized == 'tool proficiency' ||
      normalized == 'tool proficiencies' ||
      normalized == 'languages' ||
      normalized == 'equipment';
}

String _plainText(dynamic content) {
  if (content == null) {
    return '';
  }
  if (content is String) {
    return CompendiumLinkParser.renderInlineLabel(content);
  }
  if (content is List) {
    return content
        .map(_plainText)
        .where((entry) => entry.trim().isNotEmpty)
        .join(' ');
  }
  if (content is Map) {
    final pieces = <String>[];
    final name = content['name']?.toString();
    if (name != null && name.trim().isNotEmpty) {
      pieces.add(_cleanEntryLabel(name));
    }
    if (content['entry'] != null) {
      pieces.add(_plainText(content['entry']));
    }
    if (content['entries'] != null) {
      pieces.add(_plainText(content['entries']));
    }
    return pieces.where((entry) => entry.trim().isNotEmpty).join(' ');
  }
  return content.toString();
}

String? _abilityLabelOrNull(String value) {
  return switch (value.trim().toLowerCase()) {
    'str' || 'strength' => 'Strength',
    'dex' || 'dexterity' => 'Dexterity',
    'con' || 'constitution' => 'Constitution',
    'int' || 'intelligence' => 'Intelligence',
    'wis' || 'wisdom' => 'Wisdom',
    'cha' || 'charisma' => 'Charisma',
    _ => null,
  };
}

String _cleanReferenceName(String value) {
  final rendered = CompendiumLinkParser.renderInlineLabel(value).trim();
  final beforePipe = rendered.split('|').first.trim();
  if (beforePipe.contains(';')) {
    final parts = beforePipe
        .split(';')
        .map((part) => _titleCase(part))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.length >= 2) {
      return '${parts.first} (${parts.skip(1).join(' ')})';
    }
  }
  return _titleCase(beforePipe);
}

String _cleanEntryLabel(String value) {
  return value.replaceAll(':', '').trim();
}

String _joinOr(List<String> values) {
  final clean = _unique(values).where((entry) => entry.isNotEmpty).toList();
  if (clean.length <= 1) {
    return clean.join();
  }
  if (clean.length == 2) {
    return '${clean.first} or ${clean.last}';
  }
  return '${clean.take(clean.length - 1).join(', ')}, or ${clean.last}';
}

List<String> _unique(Iterable<String> values) {
  final seen = <String>{};
  final results = <String>[];
  for (final value in values) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      continue;
    }
    final key = trimmed.toLowerCase();
    if (seen.add(key)) {
      results.add(trimmed);
    }
  }
  return results;
}

String _titleCase(String value) {
  final words = value
      .trim()
      .replaceAll(RegExp(r'[_\\-]+'), ' ')
      .split(RegExp(r'\\s+'))
      .where((word) => word.isNotEmpty)
      .toList(growable: false);
  if (words.isEmpty) {
    return '';
  }
  return words
      .map(
        (word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');
}
