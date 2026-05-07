import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';

enum ClassSpellcastingFilter { any, spellcaster, nonSpellcaster }

class GuidedClassPicker extends StatefulWidget {
  final CharacterEditorController controller;
  final CharacterClassLevel entry;
  final int index;

  const GuidedClassPicker({
    super.key,
    required this.controller,
    required this.entry,
    required this.index,
  });

  @override
  State<GuidedClassPicker> createState() => _GuidedClassPickerState();
}

class _GuidedClassPickerState extends State<GuidedClassPicker> {
  final TextEditingController _searchController = TextEditingController();

  late String _rulesetScope = widget.controller.character!.primaryRulesetId;
  ClassSpellcastingFilter _spellcastingFilter = ClassSpellcastingFilter.any;
  late Future<List<ClassPickerOption>> _futureOptions = _loadOptions();

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

  Future<List<ClassPickerOption>> _loadOptions() async {
    final service = widget.controller.compendium;
    final results = await service.searchEntities(
      rulesetIds: _activeRulesetIds,
      entityTypes: const ['class'],
      limit: 300,
    );
    final options = <ClassPickerOption>[];
    for (final result in results) {
      final resolved = await service.loadResolvedEntity(result.ref);
      if (resolved == null) {
        continue;
      }
      options.add(
        ClassPickerOption(
          ref: result.ref,
          rulesetName: result.rulesetName,
          detail: resolved.detail,
        ),
      );
    }
    options.sort(
      (left, right) => left.displayName.compareTo(right.displayName),
    );
    return options;
  }

  List<ClassPickerOption> _filteredOptions(List<ClassPickerOption> options) {
    final query = _searchController.text.trim().toLowerCase();
    return options
        .where((option) {
          if (query.isNotEmpty &&
              !option.displayName.toLowerCase().contains(query)) {
            return false;
          }
          return switch (_spellcastingFilter) {
            ClassSpellcastingFilter.any => true,
            ClassSpellcastingFilter.spellcaster => option.isSpellcaster,
            ClassSpellcastingFilter.nonSpellcaster => !option.isSpellcaster,
          };
        })
        .toList(growable: false);
  }

  Future<void> _selectClass(ClassPickerOption option) async {
    await widget.controller.setClassEntry(
      widget.index,
      classRef: option.ref,
      clearSubclass: true,
      level: widget.entry.level.clamp(1, 20).toInt(),
    );
  }

  Future<void> _openDetail(ClassPickerOption option) async {
    await showGuidedClassDetailSheet(
      context,
      option: option,
      service: widget.controller.compendium,
      selected: _isSelected(option),
      onChoose: () => _selectClass(option),
    );
  }

  bool _isSelected(ClassPickerOption option) {
    final current = widget.entry.classRef;
    return current?.rulesetId == option.ref.rulesetId &&
        current?.entityType == option.ref.entityType &&
        current?.entityId == option.ref.entityId;
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
              'Choose a Class',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Class features, hit points, saving throws, proficiencies, and some spellcasting choices come from your class.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _ClassPickerFilters(
              searchController: _searchController,
              installedRulesets: widget.controller.installedRulesets,
              primaryRulesetId: widget.controller.character!.primaryRulesetId,
              rulesetScope: _rulesetScope,
              spellcastingFilter: _spellcastingFilter,
              onRulesetScopeChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _rulesetScope = value;
                  _futureOptions = _loadOptions();
                });
              },
              onSpellcastingFilterChanged: (filter) {
                setState(() {
                  _spellcastingFilter = filter;
                });
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<ClassPickerOption>>(
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
                      'Class choices could not be loaded.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final options = _filteredOptions(snapshot.data ?? const []);
                if (options.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No classes match those filters.'),
                  );
                }

                return _ClassCardGrid(
                  options: options,
                  isSelected: _isSelected,
                  onChoose: _selectClass,
                  onOpenDetail: _openDetail,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ClassPickerOption {
  final CharacterEntityRef ref;
  final String? rulesetName;
  final CompendiumEntityDetail detail;

  ClassPickerOption({
    required this.ref,
    required this.rulesetName,
    required this.detail,
  });

  String get displayName => ref.displayName;
  Map<String, dynamic> get data => detail.entity.data;

  String? get hitDie {
    final hd = data['hd'];
    if (hd is Map && hd['faces'] != null) {
      return 'd${hd['faces']}';
    }
    return null;
  }

  List<String> get primaryAbilities => _abilityLabels(data['primaryAbility']);

  String? get spellcastingAbility {
    final ability = data['spellcastingAbility']?.toString();
    if (ability == null || ability.trim().isEmpty) {
      return null;
    }
    return _abilityLabel(ability);
  }

  String? get spellcastingType {
    final progression = data['casterProgression']?.toString().trim();
    if (progression != null && progression.isNotEmpty) {
      return _humanizeProgression(progression);
    }
    return spellcastingAbility == null ? null : 'Spellcaster';
  }

  bool get isSpellcaster =>
      spellcastingAbility != null ||
      data['casterProgression']?.toString().trim().isNotEmpty == true;

  List<String> get savingThrows =>
      (data['proficiency'] as List<dynamic>? ?? const [])
          .map((entry) => _abilityLabel(entry.toString()))
          .where((entry) => entry.trim().isNotEmpty)
          .toList(growable: false);

  List<String> get armorProficiencies =>
      _stringListFromStartingProficiencies('armor');

  List<String> get weaponProficiencies =>
      _stringListFromStartingProficiencies('weapons');

  List<String> get toolProficiencies =>
      _stringListFromStartingProficiencies('tools');

  String? get skillChoiceSummary {
    final starting = data['startingProficiencies'];
    if (starting is! Map) {
      return null;
    }
    final skills = starting['skills'];
    if (skills is! List || skills.isEmpty) {
      return null;
    }

    final pieces = <String>[];
    for (final skill in skills) {
      if (skill is String && skill.trim().isNotEmpty) {
        pieces.add(_titleCase(skill));
        continue;
      }
      if (skill is Map && skill['choose'] is Map) {
        final choose = skill['choose'] as Map;
        final count = (choose['count'] as num?)?.toInt() ?? 1;
        final from = (choose['from'] as List<dynamic>? ?? const [])
            .map((entry) => _titleCase(entry.toString()))
            .where((entry) => entry.trim().isNotEmpty)
            .toList(growable: false);
        if (from.isNotEmpty) {
          pieces.add('Choose $count from ${from.join(', ')}');
        } else {
          pieces.add('Choose $count skills');
        }
      }
    }
    return pieces.isEmpty ? null : pieces.join('; ');
  }

  List<ClassFeaturePreview> get levelOneFeatures => _classFeatures(level: 1);

  String get summary {
    final pieces = <String>[
      if (hitDie != null) '$hitDie Hit Die',
      if (primaryAbilities.isNotEmpty)
        '${primaryAbilities.join(' or ')} as a primary ability',
      if (spellcastingType != null) spellcastingType!,
      if (savingThrows.isNotEmpty)
        '${savingThrows.join(' and ')} saving throws',
    ];
    if (pieces.isEmpty) {
      return 'Class details are available in the rules entry.';
    }
    return pieces.join(', ');
  }

  List<String> _stringListFromStartingProficiencies(String key) {
    final starting = data['startingProficiencies'];
    if (starting is! Map) {
      return const <String>[];
    }
    return (starting[key] as List<dynamic>? ?? const [])
        .map((entry) => _titleCase(entry.toString()))
        .where((entry) => entry.trim().isNotEmpty)
        .toList(growable: false);
  }

  List<ClassFeaturePreview> _classFeatures({required int level}) {
    final raw = data['classFeatures'];
    if (raw is! List) {
      return const <ClassFeaturePreview>[];
    }

    final features = <ClassFeaturePreview>[];
    final seen = <String>{};
    for (final item in raw) {
      final rawReference = item is String
          ? item
          : item is Map && item['classFeature'] != null
          ? item['classFeature'].toString()
          : null;
      if (rawReference == null) {
        continue;
      }

      final parts = rawReference
          .split('|')
          .map((part) => part.trim())
          .toList(growable: false);
      if (parts.isEmpty) {
        continue;
      }
      final featureLevel = parts.length >= 4 ? int.tryParse(parts[3]) : null;
      if (featureLevel != level) {
        continue;
      }
      final candidate = CompendiumLinkParser.tryParsePlainReference(
        rawReference,
        hintedFieldKey: 'classFeatures',
      );
      if (candidate == null || !seen.add(rawReference)) {
        continue;
      }
      features.add(
        ClassFeaturePreview(
          label: parts.first,
          level: level,
          candidate: candidate,
        ),
      );
    }
    return features;
  }
}

class ClassFeaturePreview {
  final String label;
  final int level;
  final CompendiumLinkCandidate candidate;

  const ClassFeaturePreview({
    required this.label,
    required this.level,
    required this.candidate,
  });
}

class _ClassPickerFilters extends StatelessWidget {
  final TextEditingController searchController;
  final List<RulesetSummary> installedRulesets;
  final String primaryRulesetId;
  final String rulesetScope;
  final ClassSpellcastingFilter spellcastingFilter;
  final ValueChanged<String?> onRulesetScopeChanged;
  final ValueChanged<ClassSpellcastingFilter> onSpellcastingFilterChanged;

  const _ClassPickerFilters({
    required this.searchController,
    required this.installedRulesets,
    required this.primaryRulesetId,
    required this.rulesetScope,
    required this.spellcastingFilter,
    required this.onRulesetScopeChanged,
    required this.onSpellcastingFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final showRulesetFilter = installedRulesets.length > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('guided-class-search'),
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search class names',
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
            SegmentedButton<ClassSpellcastingFilter>(
              key: const Key('guided-class-spellcasting-filter'),
              segments: const [
                ButtonSegment(
                  value: ClassSpellcastingFilter.any,
                  label: Text('Any'),
                ),
                ButtonSegment(
                  value: ClassSpellcastingFilter.spellcaster,
                  label: Text('Spellcaster'),
                ),
                ButtonSegment(
                  value: ClassSpellcastingFilter.nonSpellcaster,
                  label: Text('Non-spellcaster'),
                ),
              ],
              selected: {spellcastingFilter},
              onSelectionChanged: (selection) =>
                  onSpellcastingFilterChanged(selection.first),
            ),
            if (showRulesetFilter)
              SizedBox(
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
                  onChanged: onRulesetScopeChanged,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ClassCardGrid extends StatelessWidget {
  final List<ClassPickerOption> options;
  final bool Function(ClassPickerOption option) isSelected;
  final Future<void> Function(ClassPickerOption option) onChoose;
  final Future<void> Function(ClassPickerOption option) onOpenDetail;

  const _ClassCardGrid({
    required this.options,
    required this.isSelected,
    required this.onChoose,
    required this.onOpenDetail,
  });

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
              .map((option) {
                final selected = isSelected(option);
                return SizedBox(
                  width: cardWidth,
                  child: _ClassChoiceCard(
                    option: option,
                    selected: selected,
                    onChoose: () => onChoose(option),
                    onOpenDetail: () => onOpenDetail(option),
                  ),
                );
              })
              .toList(growable: false),
        );
      },
    );
  }
}

class _ClassChoiceCard extends StatelessWidget {
  final ClassPickerOption option;
  final bool selected;
  final Future<void> Function() onChoose;
  final Future<void> Function() onOpenDetail;

  const _ClassChoiceCard({
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
            Row(
              children: [
                Expanded(
                  child: CompendiumReferenceAnchor(
                    rulesetId: option.ref.rulesetId,
                    entityType: option.ref.entityType,
                    entityId: option.ref.entityId,
                    entityName: option.displayName,
                    onTap: onOpenDetail,
                    child: Text(
                      option.displayName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (option.rulesetName?.trim().isNotEmpty == true)
                  Chip(label: Text(option.rulesetName!.trim())),
                if (option.hitDie != null)
                  _TermChip(term: 'Hit Die', value: option.hitDie!),
                if (option.primaryAbilities.isNotEmpty)
                  Chip(
                    label: Text(
                      'Primary: ${option.primaryAbilities.join(' / ')}',
                    ),
                  ),
                if (option.spellcastingAbility != null)
                  _TermChip(
                    term: 'Spellcasting',
                    value: option.spellcastingAbility!,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(option.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            _ClassFactLines(option: option, compact: true),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  key: Key('choose-class:${option.ref.entityId}'),
                  onPressed: selected ? null : onChoose,
                  icon: Icon(selected ? Icons.check : Icons.add),
                  label: Text(selected ? 'Selected' : 'Choose Class'),
                ),
                OutlinedButton.icon(
                  key: Key('class-detail:${option.ref.entityId}'),
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

class _ClassFactLines extends StatelessWidget {
  final ClassPickerOption option;
  final bool compact;

  const _ClassFactLines({required this.option, required this.compact});

  @override
  Widget build(BuildContext context) {
    final lines = <Widget>[
      if (option.savingThrows.isNotEmpty)
        _FactLine(term: 'Saving throws', value: option.savingThrows.join(', ')),
      if (option.armorProficiencies.isNotEmpty)
        _FactLine(
          term: 'Armor Proficiency',
          label: 'Armor training',
          value: option.armorProficiencies.join(', '),
        ),
      if (option.weaponProficiencies.isNotEmpty)
        _FactLine(
          term: 'Weapon Proficiency',
          label: 'Weapon training',
          value: option.weaponProficiencies.join(', '),
        ),
      if (option.skillChoiceSummary != null)
        _FactLine(
          term: 'Proficiency',
          label: 'Skills',
          value: option.skillChoiceSummary!,
        ),
      if (option.spellcastingType != null)
        _FactLine(term: 'Spellcasting', value: option.spellcastingType!),
    ];

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
    final lineLabel = label ?? term;
    return Tooltip(
      message: _tooltipForTerm(term),
      child: Text(
        '$lineLabel: $value',
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

Future<void> showGuidedClassDetailSheet(
  BuildContext context, {
  required ClassPickerOption option,
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
        child: _GuidedClassDetailSheet(
          option: option,
          service: service,
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

class _GuidedClassDetailSheet extends StatelessWidget {
  final ClassPickerOption option;
  final CharacterCompendiumService service;
  final bool selected;
  final Future<void> Function() onChoose;
  final Future<void> Function() onOpenFullEntry;

  const _GuidedClassDetailSheet({
    required this.option,
    required this.service,
    required this.selected,
    required this.onChoose,
    required this.onOpenFullEntry,
  });

  @override
  Widget build(BuildContext context) {
    final levelOneFeatures = option.levelOneFeatures;
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
                    if (option.hitDie != null)
                      _TermChip(term: 'Hit Die', value: option.hitDie!),
                    if (option.primaryAbilities.isNotEmpty)
                      Chip(
                        label: Text(
                          'Primary: ${option.primaryAbilities.join(' / ')}',
                        ),
                      ),
                    if (option.spellcastingAbility != null)
                      _TermChip(
                        term: 'Spellcasting',
                        value: option.spellcastingAbility!,
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                _ClassDetailSection(
                  title: 'Proficiencies',
                  child: _ClassFactLines(option: option, compact: false),
                ),
                if (levelOneFeatures.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _ClassDetailSection(
                    title: 'Level 1 Class Features',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final feature in levelOneFeatures)
                          ActionChip(
                            avatar: const Icon(
                              Icons.visibility_outlined,
                              size: 18,
                            ),
                            label: Text(feature.label),
                            onPressed: () => openCompendiumLinkPreview(
                              context,
                              browseRepository: service.browseRepository,
                              candidate: feature.candidate,
                              preferredRulesetId: option.ref.rulesetId,
                              currentRulesetId: option.ref.rulesetId,
                              currentEntityType: option.ref.entityType,
                              currentEntityId: option.ref.entityId,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _ClassDetailSection(
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
                key: Key('class-detail-choose:${option.ref.entityId}'),
                onPressed: selected ? null : onChoose,
                icon: Icon(selected ? Icons.check : Icons.add),
                label: Text(selected ? 'Selected' : 'Choose Class'),
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

class _ClassDetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _ClassDetailSection({required this.title, required this.child});

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
    'Hit Die' => 'The die your class uses for hit points at each level.',
    'Saving throws' || 'Saving Throw' =>
      'Rolls used to resist danger, usually tied to an ability.',
    'Proficiency' =>
      'Training that lets you add your proficiency bonus when the rules apply.',
    'Spellcasting' => 'The class rules that let this character cast spells.',
    'Armor Proficiency' =>
      'Armor training your class provides at character creation.',
    'Weapon Proficiency' =>
      'Weapon training your class provides at character creation.',
    _ => term,
  };
}

List<String> _abilityLabels(dynamic value) {
  if (value is! List || value.isEmpty) {
    return const <String>[];
  }
  final labels = <String>[];
  for (final item in value) {
    if (item is String) {
      final label = _abilityLabel(item);
      if (label.isNotEmpty) {
        labels.add(label);
      }
      continue;
    }
    if (item is Map) {
      for (final entry in item.entries) {
        if (entry.value == true || entry.value is num) {
          final label = _abilityLabel(entry.key.toString());
          if (label.isNotEmpty) {
            labels.add(label);
          }
        }
      }
    }
  }
  return labels;
}

String _abilityLabel(String value) {
  return switch (value.trim().toLowerCase()) {
    'str' || 'strength' => 'Strength',
    'dex' || 'dexterity' => 'Dexterity',
    'con' || 'constitution' => 'Constitution',
    'int' || 'intelligence' => 'Intelligence',
    'wis' || 'wisdom' => 'Wisdom',
    'cha' || 'charisma' => 'Charisma',
    _ => _titleCase(value),
  };
}

String _humanizeProgression(String value) {
  return switch (value.trim().toLowerCase()) {
    'full' => 'Full spellcaster',
    'half' => 'Half spellcaster',
    'third' || '1/3' => 'Partial spellcaster',
    'pact' => 'Pact spellcaster',
    'artificer' => 'Artificer spellcasting',
    'none' => 'No spellcasting',
    _ => _titleCase(value),
  };
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
