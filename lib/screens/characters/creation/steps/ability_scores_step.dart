import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/attribute_card.dart';
import 'package:openrpg/screens/characters/creation/ability_score_generation.dart';

class AbilityScoresStep extends StatefulWidget {
  final CharacterEditorController controller;

  const AbilityScoresStep({super.key, required this.controller});

  @override
  State<AbilityScoresStep> createState() => _AbilityScoresStepState();
}

class _AbilityScoresStepState extends State<AbilityScoresStep> {
  int? _selectedStandardScore = 15;

  @override
  Widget build(BuildContext context) {
    final character = widget.controller.character!;
    final abilities = widget.controller.sheetSchema.abilities;
    final creation = characterCreationData(character.extraData);
    final pointBuyRules = PointBuyRules.fromRulesetExtra(
      widget.controller.primaryRulesetExtraData,
    );
    final abilityState = CharacterCreationAbilityScores.fromCharacter(
      character,
      pointBuyRules: pointBuyRules,
    );
    final backgroundOptions = backgroundAbilityBonusOptionsForResolvedEntity(
      widget.controller.resolvedBuild.background,
    );
    final resolution = abilityState.resolve(
      backgroundAbilityOptions: backgroundOptions,
      backgroundSourceKey: backgroundAbilitySourceKeyForRef(
        character.backgroundRef,
      ),
    );
    final method = abilityState.method;
    final assignments = abilityState.standardArray.assignments;
    final pointBuyEvaluation = _pointBuyEvaluation(abilityState, pointBuyRules);
    final validation = validateAbilityScoreGeneration(
      character: character,
      abilities: abilities,
      creation: creation,
      pointBuyRules: pointBuyRules,
      creationAbilityScores: abilityState,
      backgroundAbilityOptions: backgroundOptions,
    );
    final classRelevance = _classRelevance();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _AbilityScoresHeaderCard(),
        const SizedBox(height: 16),
        _AbilityScoreMethodSelectorCard(
          method: method,
          onChanged: (nextMethod) =>
              _changeMethod(nextMethod, abilityState: abilityState),
        ),
        const SizedBox(height: 16),
        _ClassRecommendationStrip(
          abilities: abilities,
          classRelevance: classRelevance,
        ),
        const SizedBox(height: 16),
        if (method == AbilityScoreGenerationMethod.pointBuy) ...[
          _PointBuyBudgetCard(evaluation: pointBuyEvaluation),
          const SizedBox(height: 16),
          _PointBuyGrid(
            abilities: abilities,
            evaluation: pointBuyEvaluation,
            classRelevance: classRelevance,
            skillSummaryFor: _skillSummaryFor,
            onAdjust: (ability, delta) => _adjustPointBuyScore(
              ability,
              delta,
              pointBuyRules,
              abilityState,
            ),
          ),
        ] else if (method == AbilityScoreGenerationMethod.standardArray)
          _StandardArrayAssignmentCard(
            abilities: abilities,
            assignments: assignments,
            selectedScore: _selectedStandardScore,
            standardArray: kDefaultStandardArray,
            classRelevance: classRelevance,
            onScoreSelected: (score) {
              setState(() {
                _selectedStandardScore = score;
              });
            },
            onAssign: (ability) => _assignStandardScore(ability, abilityState),
          )
        else
          _ManualAbilityScoreCard(
            abilities: abilities,
            scores: abilityState.manual.completeScores(),
            onAdjust: (ability, delta) =>
                _adjustManualScore(ability, delta, abilityState),
          ),
        if (backgroundOptions.hasOptions) ...[
          const SizedBox(height: 16),
          _BackgroundAbilityIncreaseCard(
            options: backgroundOptions,
            selection: abilityState.backgroundAbilityBonus,
            onModeSelected: (mode) => _selectBackgroundAbilityBonusMode(
              abilityState,
              backgroundOptions,
              mode,
            ),
            onAbilitySelected: (mode, slotIndex, abilityId) =>
                _assignBackgroundAbilityBonus(
                  abilityState,
                  backgroundOptions,
                  mode,
                  slotIndex,
                  abilityId,
                ),
          ),
        ],
        const SizedBox(height: 16),
        _FinalScoreBreakdownCard(abilities: abilities, resolution: resolution),
        const SizedBox(height: 16),
        _AbilityScoreValidationCard(validation: validation),
      ],
    );
  }

  PointBuyEvaluation _pointBuyEvaluation(
    CharacterCreationAbilityScores abilityState,
    PointBuyRules rules,
  ) {
    final abilities = widget.controller.sheetSchema.abilities;
    return PointBuyEvaluation.fromVisibleScores(
      abilityIds: abilities.map((ability) => ability.id),
      scores: abilityState.pointBuy.completeScores(),
      rules: rules,
    );
  }

  Future<void> _changeMethod(
    AbilityScoreGenerationMethod method, {
    required CharacterCreationAbilityScores abilityState,
  }) async {
    await widget.controller.setCreationAbilityScores(
      abilityState.withMethod(method),
    );
  }

  Future<void> _adjustPointBuyScore(
    CharacterAbilityDescriptor ability,
    int delta,
    PointBuyRules rules,
    CharacterCreationAbilityScores abilityState,
  ) async {
    final evaluation = _pointBuyEvaluation(abilityState, rules);
    if (delta > 0 && !evaluation.canIncrement(ability.id)) {
      return;
    }
    if (delta < 0 && !evaluation.canDecrement(ability.id)) {
      return;
    }
    await widget.controller.setCreationAbilityScores(
      abilityState.withPointBuyScore(
        ability.id,
        evaluation.scoreFor(ability.id) + delta,
        rules: rules,
      ),
    );
  }

  Future<void> _adjustManualScore(
    CharacterAbilityDescriptor ability,
    int delta,
    CharacterCreationAbilityScores abilityState,
  ) async {
    await widget.controller.setCreationAbilityScores(
      abilityState.withManualScore(
        ability.id,
        abilityState.manual.scoreFor(ability.id) + delta,
      ),
    );
  }

  Future<void> _assignStandardScore(
    CharacterAbilityDescriptor ability,
    CharacterCreationAbilityScores abilityState,
  ) async {
    final score = _selectedStandardScore;
    if (score == null) {
      return;
    }
    final nextState = abilityState.withStandardArrayAssignment(
      ability.id,
      score,
    );
    await widget.controller.setCreationAbilityScores(nextState);
    if (!mounted) {
      return;
    }
    final remaining = kDefaultStandardArray
        .where(
          (value) =>
              !nextState.standardArray.assignments.values.contains(value),
        )
        .toList(growable: false);
    setState(() {
      _selectedStandardScore = remaining.isEmpty ? score : remaining.first;
    });
  }

  Future<void> _selectBackgroundAbilityBonusMode(
    CharacterCreationAbilityScores abilityState,
    DndBackgroundAbilityBonusOptions options,
    DndBackgroundAbilityBonusMode mode,
  ) async {
    await widget.controller.setCreationAbilityScores(
      abilityState.withBackgroundAbilityBonusMode(options, mode),
    );
  }

  Future<void> _assignBackgroundAbilityBonus(
    CharacterCreationAbilityScores abilityState,
    DndBackgroundAbilityBonusOptions options,
    DndBackgroundAbilityBonusMode mode,
    int slotIndex,
    String abilityId,
  ) async {
    await widget.controller.setCreationAbilityScores(
      abilityState.withBackgroundAbilityBonusAssignment(
        options,
        mode,
        slotIndex,
        abilityId,
      ),
    );
  }

  String _skillSummaryFor(CharacterAbilityDescriptor ability) {
    final skills = widget.controller.sheetSchema.skills
        .where((skill) => skill.abilityId == ability.id)
        .map((skill) => skill.label)
        .toList(growable: false);
    final shownSkills = skills.take(3).join(', ');
    final moreCount = skills.length - 3;
    final skillText = shownSkills.isEmpty
        ? 'Saving throws'
        : moreCount > 0
        ? '$shownSkills + $moreCount more'
        : shownSkills;
    return '$skillText; ${ability.abbreviation} saves';
  }

  Map<String, _ClassAbilityRelevance> _classRelevance() {
    final result = <String, _ClassAbilityRelevance>{};
    for (final entity in widget.controller.resolvedBuild.entityByKey.values) {
      if (entity.ref.entityType != 'class') {
        continue;
      }
      final data = entity.detail.entity.data;
      for (final abilityId in _primaryAbilityIds(data['primaryAbility'])) {
        result[abilityId] = _ClassAbilityRelevance.important;
      }
      final spellcastingAbility = canonicalAbilityId(
        data['spellcastingAbility']?.toString(),
      );
      if (spellcastingAbility.isNotEmpty) {
        result.putIfAbsent(
          spellcastingAbility,
          () => _ClassAbilityRelevance.secondary,
        );
      }
    }

    for (final abilityId
        in widget
            .controller
            .resolvedBuild
            .savingThrowDefaults
            .proficientAbilityIds) {
      result.putIfAbsent(abilityId, () => _ClassAbilityRelevance.secondary);
    }

    // TODO: Use richer class ability guidance when a ruleset exposes it.
    return result;
  }

  Iterable<String> _primaryAbilityIds(dynamic raw) sync* {
    if (raw is! List) {
      return;
    }
    for (final entry in raw) {
      if (entry is String) {
        final abilityId = canonicalAbilityId(entry);
        if (abilityId.isNotEmpty) {
          yield abilityId;
        }
        continue;
      }
      if (entry is Map) {
        for (final key in entry.keys) {
          final abilityId = canonicalAbilityId(key.toString());
          if (abilityId.isNotEmpty) {
            yield abilityId;
          }
        }
      }
    }
  }
}

enum _ClassAbilityRelevance {
  important('Important for your class'),
  secondary('Useful secondary ability');

  final String label;

  const _ClassAbilityRelevance(this.label);
}

class _AbilityScoresHeaderCard extends StatelessWidget {
  const _AbilityScoresHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ability Scores',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Set the six D&D abilities used for attacks, saving throws, skills, spellcasting, hit points, and class features. Your background ability increases are applied after the base scores.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _AbilityScoreMethodSelectorCard extends StatelessWidget {
  final AbilityScoreGenerationMethod method;
  final ValueChanged<AbilityScoreGenerationMethod> onChanged;

  const _AbilityScoreMethodSelectorCard({
    required this.method,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score Method',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Switching methods keeps the other D&D allocations saved for this character.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final showSelectedIcon = constraints.maxWidth >= 380;
                return SegmentedButton<AbilityScoreGenerationMethod>(
                  showSelectedIcon: showSelectedIcon,
                  segments: const [
                    ButtonSegment(
                      value: AbilityScoreGenerationMethod.manualRolled,
                      icon: Icon(Icons.tune_outlined),
                      label: Text('Manual / Rolled'),
                    ),
                    ButtonSegment(
                      value: AbilityScoreGenerationMethod.standardArray,
                      icon: Icon(Icons.format_list_numbered_outlined),
                      label: Text('Standard Array'),
                    ),
                    ButtonSegment(
                      value: AbilityScoreGenerationMethod.pointBuy,
                      icon: Icon(Icons.calculate_outlined),
                      label: Text('Point Buy'),
                    ),
                  ],
                  selected: {method},
                  onSelectionChanged: (selection) {
                    onChanged(selection.first);
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

class _ClassRecommendationStrip extends StatelessWidget {
  final List<CharacterAbilityDescriptor> abilities;
  final Map<String, _ClassAbilityRelevance> classRelevance;

  const _ClassRecommendationStrip({
    required this.abilities,
    required this.classRelevance,
  });

  @override
  Widget build(BuildContext context) {
    final recommendations = abilities
        .where((ability) => classRelevance.containsKey(ability.id))
        .toList(growable: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class Ability Priorities',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (recommendations.isEmpty)
              Text(
                'Choose a D&D class to see the ability scores that matter most for its attacks, saves, and spellcasting.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final ability in recommendations)
                    Chip(
                      avatar: Icon(
                        classRelevance[ability.id] ==
                                _ClassAbilityRelevance.important
                            ? Icons.star_outline
                            : Icons.shield_outlined,
                        size: 18,
                      ),
                      label: Text(
                        '${ability.abbreviation}: ${classRelevance[ability.id]!.label}',
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _FinalScoreBreakdownCard extends StatelessWidget {
  final List<CharacterAbilityDescriptor> abilities;
  final CharacterCreationAbilityScoreResolution resolution;

  const _FinalScoreBreakdownCard({
    required this.abilities,
    required this.resolution,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Final Score Breakdown',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'D&D background increases are added to the selected base scores here.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 520
                    ? 1
                    : constraints.maxWidth < 820
                    ? 2
                    : 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 142,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: abilities.length,
                  itemBuilder: (context, index) {
                    final ability = abilities[index];
                    final baseScore = resolution.baseScores[ability.id] ?? 10;
                    final bonus = resolution.backgroundBonuses[ability.id] ?? 0;
                    final finalScore =
                        resolution.finalScores[ability.id] ?? baseScore;
                    final modifier = abilityModifierForScore(finalScore);
                    return _FinalScoreBreakdownTile(
                      ability: ability,
                      baseScore: baseScore,
                      backgroundBonus: bonus,
                      finalScore: finalScore,
                      modifier: modifier,
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

class _FinalScoreBreakdownTile extends StatelessWidget {
  final CharacterAbilityDescriptor ability;
  final int baseScore;
  final int backgroundBonus;
  final int finalScore;
  final int modifier;

  const _FinalScoreBreakdownTile({
    required this.ability,
    required this.baseScore,
    required this.backgroundBonus,
    required this.finalScore,
    required this.modifier,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ability.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                ability.abbreviation,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _BreakdownValue(label: 'Base', value: '$baseScore'),
              _BreakdownValue(
                label: 'Background',
                value: _formatSignedBonus(backgroundBonus),
              ),
              _BreakdownValue(label: 'Final', value: '$finalScore'),
              _BreakdownValue(
                label: 'Modifier',
                value: _formatModifier(modifier),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownValue extends StatelessWidget {
  final String label;
  final String value;

  const _BreakdownValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _AbilityScoreValidationCard extends StatelessWidget {
  final AbilityScoreValidationResult validation;

  const _AbilityScoreValidationCard({required this.validation});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = switch (validation.status) {
      AbilityScoreValidationStatus.ready => colorScheme.primaryContainer,
      AbilityScoreValidationStatus.needsAttention =>
        colorScheme.tertiaryContainer,
      AbilityScoreValidationStatus.invalid => colorScheme.errorContainer,
    };
    final statusTextColor = switch (validation.status) {
      AbilityScoreValidationStatus.ready => colorScheme.onPrimaryContainer,
      AbilityScoreValidationStatus.needsAttention =>
        colorScheme.onTertiaryContainer,
      AbilityScoreValidationStatus.invalid => colorScheme.onErrorContainer,
    };
    final icon = switch (validation.status) {
      AbilityScoreValidationStatus.ready => Icons.check_circle_outline,
      AbilityScoreValidationStatus.needsAttention => Icons.info_outline,
      AbilityScoreValidationStatus.invalid => Icons.error_outline,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Validation & Issues',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  avatar: Icon(icon, size: 18, color: statusTextColor),
                  backgroundColor: statusColor,
                  label: Text(
                    validation.statusLabel,
                    style: TextStyle(color: statusTextColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              validation.title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              validation.message.trim().isEmpty
                  ? 'Ability scores are ready for D&D play.'
                  : validation.message,
            ),
          ],
        ),
      ),
    );
  }
}

class _PointBuyBudgetCard extends StatelessWidget {
  final PointBuyEvaluation evaluation;

  const _PointBuyBudgetCard({required this.evaluation});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isInvalid = !evaluation.isValid;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Point Buy Budget',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'D&D point buy starts every ability at ${evaluation.rules.startingScore} and spends up to ${evaluation.rules.pointBudget} points before background increases.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 520;
                final metrics = [
                  _BudgetMetric(
                    label: 'Points spent',
                    value: '${evaluation.spent}',
                    helper: 'Budget ${evaluation.rules.pointBudget}',
                  ),
                  _BudgetMetric(
                    label: 'Points remaining',
                    value: '${evaluation.remaining}',
                    helper: evaluation.remaining < 0
                        ? 'Over budget'
                        : 'Available now',
                  ),
                ];
                if (compact) {
                  return Column(
                    children: [
                      for (final metric in metrics) ...[
                        metric,
                        if (metric != metrics.last) const SizedBox(height: 8),
                      ],
                    ],
                  );
                }
                return Row(
                  children: [
                    for (final metric in metrics) ...[
                      Expanded(child: metric),
                      if (metric != metrics.last) const SizedBox(width: 12),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: evaluation.rules.pointBudget == 0
                  ? 0
                  : (evaluation.spent / evaluation.rules.pointBudget)
                        .clamp(0, 1)
                        .toDouble(),
            ),
            if (isInvalid) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  evaluation.isOverBudget
                      ? 'Spend ${evaluation.rules.pointBudget} points or fewer before continuing.'
                      : 'Keep every score between ${evaluation.rules.minimumScore} and ${evaluation.rules.maximumScore}.',
                  style: TextStyle(color: colorScheme.onErrorContainer),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BudgetMetric extends StatelessWidget {
  final String label;
  final String value;
  final String helper;

  const _BudgetMetric({
    required this.label,
    required this.value,
    required this.helper,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 2),
          Text(helper, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _BackgroundAbilityIncreaseCard extends StatelessWidget {
  final DndBackgroundAbilityBonusOptions options;
  final BackgroundAbilityBonusSelection? selection;
  final ValueChanged<DndBackgroundAbilityBonusMode> onModeSelected;
  final void Function(
    DndBackgroundAbilityBonusMode mode,
    int slotIndex,
    String abilityId,
  )
  onAbilitySelected;

  const _BackgroundAbilityIncreaseCard({
    required this.options,
    required this.selection,
    required this.onModeSelected,
    required this.onAbilitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentMode =
        options.modeById(selection?.modeId) ?? options.preferredMode;
    final selectedModeId = currentMode.id;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Background Ability Increase',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${options.sourceName} grants D&D 2024 background ability increases. Choose one mode, then assign each increase to a different listed ability.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currentMode.abilityIds
                  .map(
                    (abilityId) => Chip(label: Text(_abilityLabel(abilityId))),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: options.modes
                  .map(
                    (mode) => ButtonSegment<String>(
                      value: mode.id,
                      label: Text(mode.label),
                    ),
                  )
                  .toList(growable: false),
              selected: {selectedModeId},
              onSelectionChanged: (selected) {
                final mode = options.modeById(selected.first);
                if (mode != null) {
                  onModeSelected(mode);
                }
              },
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 620 ? 1 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: crossAxisCount == 1 ? 3.5 : 2.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: currentMode.slotCount,
                  itemBuilder: (context, index) {
                    return DropdownButtonFormField<String>(
                      initialValue:
                          selection?.matchesSourceAndMode(
                                options.sourceKey,
                                currentMode.id,
                              ) ==
                              true
                          ? selection?.abilityForSlot(index)
                          : null,
                      decoration: InputDecoration(
                        labelText: '+${currentMode.weights[index]} ability',
                        border: const OutlineInputBorder(),
                      ),
                      items: currentMode.abilityIds
                          .map(
                            (abilityId) => DropdownMenuItem<String>(
                              value: abilityId,
                              child: Text(_abilityLabel(abilityId)),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (abilityId) {
                        if (abilityId == null) {
                          return;
                        }
                        onAbilitySelected(currentMode, index, abilityId);
                      },
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

class _PointBuyGrid extends StatelessWidget {
  final List<CharacterAbilityDescriptor> abilities;
  final PointBuyEvaluation evaluation;
  final Map<String, _ClassAbilityRelevance> classRelevance;
  final String Function(CharacterAbilityDescriptor ability) skillSummaryFor;
  final void Function(CharacterAbilityDescriptor ability, int delta) onAdjust;

  const _PointBuyGrid({
    required this.abilities,
    required this.evaluation,
    required this.classRelevance,
    required this.skillSummaryFor,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 620 ? 1 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 224,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: abilities.length,
          itemBuilder: (context, index) {
            final ability = abilities[index];
            return _PointBuyAbilityTile(
              ability: ability,
              score: evaluation.scoreFor(ability.id),
              modifier: evaluation.modifierFor(ability.id),
              cost: evaluation.costForAbility(ability.id),
              nextCost: evaluation.rules.costFor(
                evaluation.scoreFor(ability.id) + 1,
              ),
              relevance: classRelevance[ability.id],
              skillSummary: skillSummaryFor(ability),
              canIncrement: evaluation.canIncrement(ability.id),
              canDecrement: evaluation.canDecrement(ability.id),
              incrementBlockReason: _incrementBlockReason(
                evaluation,
                ability.id,
              ),
              onIncrement: () => onAdjust(ability, 1),
              onDecrement: () => onAdjust(ability, -1),
            );
          },
        );
      },
    );
  }
}

String? _incrementBlockReason(PointBuyEvaluation evaluation, String abilityId) {
  if (evaluation.canIncrement(abilityId)) {
    return null;
  }
  final score = evaluation.scoreFor(abilityId);
  if (score >= evaluation.rules.maximumScore) {
    return 'At D&D point-buy maximum ${evaluation.rules.maximumScore}.';
  }
  final currentCost = evaluation.rules.costFor(score);
  final nextCost = evaluation.rules.costFor(score + 1);
  if (currentCost == null || nextCost == null) {
    return 'No D&D point-buy cost for the next score.';
  }
  final needed = nextCost - currentCost;
  if (evaluation.remaining < needed) {
    return 'Needs $needed points; ${evaluation.remaining} remaining.';
  }
  return 'Cannot increase this D&D point-buy score.';
}

class _PointBuyAbilityTile extends StatelessWidget {
  final CharacterAbilityDescriptor ability;
  final int score;
  final int modifier;
  final int cost;
  final int? nextCost;
  final _ClassAbilityRelevance? relevance;
  final String skillSummary;
  final bool canIncrement;
  final bool canDecrement;
  final String? incrementBlockReason;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _PointBuyAbilityTile({
    required this.ability,
    required this.score,
    required this.modifier,
    required this.cost,
    required this.nextCost,
    required this.relevance,
    required this.skillSummary,
    required this.canIncrement,
    required this.canDecrement,
    required this.incrementBlockReason,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ability.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  ability.abbreviation,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            if (relevance != null) ...[
              const SizedBox(height: 8),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text(relevance!.label),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$score',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    _formatModifier(modifier),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Point-buy cost $cost'),
                    if (nextCost != null && canIncrement)
                      Text(
                        'Next costs $nextCost',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              skillSummary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (incrementBlockReason != null) ...[
              const SizedBox(height: 6),
              Text(
                incrementBlockReason!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.filledTonal(
                  tooltip: 'Decrease ${ability.label}',
                  onPressed: canDecrement ? onDecrement : null,
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: canIncrement
                      ? 'Increase ${ability.label}'
                      : incrementBlockReason ?? 'Cannot increase',
                  onPressed: canIncrement ? onIncrement : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualAbilityScoreCard extends StatelessWidget {
  final List<CharacterAbilityDescriptor> abilities;
  final Map<String, int> scores;
  final void Function(CharacterAbilityDescriptor ability, int delta) onAdjust;

  const _ManualAbilityScoreCard({
    required this.abilities,
    required this.scores,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    final warnings = _manualWarnings(abilities, scores);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced / Manual Entry',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Advanced mode for rolled stats, table-specific D&D rules, imports, or DM-approved overrides.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              _ManualScoreWarning(warnings: warnings),
            ],
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 520 ? 2 : 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 184,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: abilities.length,
                  itemBuilder: (context, index) {
                    final ability = abilities[index];
                    final score = scores[ability.id] ?? 10;
                    return AttributeCard(
                      abbreviation: ability.abbreviation,
                      name: ability.label,
                      value: score,
                      modifier: abilityModifierForScore(score),
                      onDecrement: () => onAdjust(ability, -1),
                      onIncrement: () => onAdjust(ability, 1),
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

class _ManualScoreWarning extends StatelessWidget {
  final List<String> warnings;

  const _ManualScoreWarning({required this.warnings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: colorScheme.onTertiaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manual score warning',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                for (final warning in warnings)
                  Text(
                    warning,
                    style: TextStyle(color: colorScheme.onTertiaryContainer),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<String> _manualWarnings(
  List<CharacterAbilityDescriptor> abilities,
  Map<String, int> scores,
) {
  final high = <String>[];
  final low = <String>[];
  for (final ability in abilities) {
    final score = scores[ability.id] ?? 10;
    if (score > 18) {
      high.add('${ability.abbreviation} $score');
    } else if (score < 3) {
      low.add('${ability.abbreviation} $score');
    }
  }
  return [
    if (high.isNotEmpty)
      'D&D rolled scores usually do not exceed 18 before background increases: ${high.join(', ')}.',
    if (low.isNotEmpty)
      'D&D rolled scores usually start at 3 or higher: ${low.join(', ')}.',
  ];
}

class _StandardArrayAssignmentCard extends StatelessWidget {
  final List<CharacterAbilityDescriptor> abilities;
  final Map<String, int> assignments;
  final int? selectedScore;
  final List<int> standardArray;
  final Map<String, _ClassAbilityRelevance> classRelevance;
  final ValueChanged<int> onScoreSelected;
  final ValueChanged<CharacterAbilityDescriptor> onAssign;

  const _StandardArrayAssignmentCard({
    required this.abilities,
    required this.assignments,
    required this.selectedScore,
    required this.standardArray,
    required this.classRelevance,
    required this.onScoreSelected,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    final usedScores = assignments.values.toSet();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Standard Array Assignment',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select one D&D Standard Array score, then tap an ability tile to place or move it.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Available scores',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: standardArray
                  .map((score) {
                    final isUsed = usedScores.contains(score);
                    final isSelected = selectedScore == score;
                    return FilterChip(
                      selected: isSelected,
                      avatar: Icon(
                        isUsed
                            ? Icons.check_circle_outline
                            : Icons.radio_button_unchecked,
                        size: 18,
                      ),
                      label: Text(
                        isSelected
                            ? '$score selected'
                            : isUsed
                            ? '$score used'
                            : '$score open',
                      ),
                      onSelected: (_) => onScoreSelected(score),
                    );
                  })
                  .toList(growable: false),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 520 ? 2 : 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 168,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: abilities.length,
                  itemBuilder: (context, index) {
                    final ability = abilities[index];
                    final score = assignments[ability.id] ?? 10;
                    return _StandardArrayAbilityTile(
                      ability: ability,
                      score: score,
                      modifier: abilityModifierForScore(score),
                      assignedScore: assignments[ability.id],
                      selectedScore: selectedScore,
                      relevance: classRelevance[ability.id],
                      onTap: () => onAssign(ability),
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

class _StandardArrayAbilityTile extends StatelessWidget {
  final CharacterAbilityDescriptor ability;
  final int score;
  final int modifier;
  final int? assignedScore;
  final int? selectedScore;
  final _ClassAbilityRelevance? relevance;
  final VoidCallback onTap;

  const _StandardArrayAbilityTile({
    required this.ability,
    required this.score,
    required this.modifier,
    required this.assignedScore,
    required this.selectedScore,
    required this.relevance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ability.abbreviation,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  if (assignedScore != null)
                    Icon(Icons.check_circle, color: colorScheme.primary),
                ],
              ),
              const SizedBox(height: 6),
              Text('$score', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                _formatModifier(modifier),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (assignedScore != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Assigned $assignedScore',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ] else if (selectedScore != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Tap to assign $selectedScore',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
              if (relevance != null) ...[
                const SizedBox(height: 6),
                Text(
                  relevance!.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _formatModifier(int modifier) =>
    modifier >= 0 ? '+$modifier' : '$modifier';

String _formatSignedBonus(int bonus) => bonus >= 0 ? '+$bonus' : '$bonus';

String _abilityLabel(String abilityId) {
  return switch (canonicalAbilityId(abilityId)) {
    'str' => 'Strength',
    'dex' => 'Dexterity',
    'con' => 'Constitution',
    'int' => 'Intelligence',
    'wis' => 'Wisdom',
    'cha' => 'Charisma',
    _ => abilityId,
  };
}
