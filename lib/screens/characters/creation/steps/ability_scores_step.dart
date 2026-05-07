import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/ability_score_grid.dart';
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
    final method = abilityScoreGenerationMethodFromCreation(creation);
    final assignments = standardArrayAssignmentsFromCreation(creation);
    final pointBuyRules = PointBuyRules.fromRulesetExtra(
      widget.controller.primaryRulesetExtraData,
    );
    final validation = validateAbilityScoreGeneration(
      character: character,
      abilities: abilities,
      creation: creation,
      pointBuyRules: pointBuyRules,
    );
    final classRelevance = _classRelevance();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
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
                  'Choose how this character gets their six ability scores.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                SegmentedButton<AbilityScoreGenerationMethod>(
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
                    _changeMethod(
                      selection.first,
                      pointBuyRules: pointBuyRules,
                      abilities: abilities,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _AbilityScoreSummaryCard(
          controller: widget.controller,
          abilities: abilities,
          method: method,
          validation: validation,
        ),
        const SizedBox(height: 16),
        if (method == AbilityScoreGenerationMethod.pointBuy) ...[
          _PointBuyBudgetCard(evaluation: _pointBuyEvaluation(pointBuyRules)),
          const SizedBox(height: 16),
          _PointBuyGrid(
            controller: widget.controller,
            abilities: abilities,
            evaluation: _pointBuyEvaluation(pointBuyRules),
            classRelevance: classRelevance,
            skillSummaryFor: _skillSummaryFor,
            onAdjust: (ability, delta) =>
                _adjustPointBuyScore(ability, delta, pointBuyRules),
          ),
        ] else if (method == AbilityScoreGenerationMethod.standardArray)
          _StandardArrayAssignmentCard(
            controller: widget.controller,
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
            onAssign: (ability) => _assignStandardScore(ability, assignments),
          )
        else
          _ManualAbilityScoreCard(
            controller: widget.controller,
            abilities: abilities,
          ),
      ],
    );
  }

  PointBuyEvaluation _pointBuyEvaluation(PointBuyRules rules) {
    final abilities = widget.controller.sheetSchema.abilities;
    return PointBuyEvaluation.fromVisibleScores(
      abilityIds: abilities.map((ability) => ability.id),
      scores: {
        for (final ability in abilities)
          ability.id: widget.controller.abilityScoreFor(ability.id),
      },
      rules: rules,
    );
  }

  Future<void> _changeMethod(
    AbilityScoreGenerationMethod method, {
    required PointBuyRules pointBuyRules,
    required List<CharacterAbilityDescriptor> abilities,
  }) async {
    await widget.controller.setCreationExtraValue(
      kAbilityScoreMethodExtraKey,
      method.storageValue,
    );
    if (method == AbilityScoreGenerationMethod.pointBuy) {
      for (final ability in abilities) {
        await widget.controller.setAbilityScore(
          ability.id,
          pointBuyRules.startingScore,
        );
      }
    }
  }

  Future<void> _adjustPointBuyScore(
    CharacterAbilityDescriptor ability,
    int delta,
    PointBuyRules rules,
  ) async {
    final evaluation = _pointBuyEvaluation(rules);
    if (delta > 0 && !evaluation.canIncrement(ability.id)) {
      return;
    }
    if (delta < 0 && !evaluation.canDecrement(ability.id)) {
      return;
    }
    await widget.controller.setAbilityScore(
      ability.id,
      (evaluation.scoreFor(ability.id) + delta)
          .clamp(rules.minimumScore, rules.maximumScore)
          .toInt(),
    );
  }

  Future<void> _assignStandardScore(
    CharacterAbilityDescriptor ability,
    Map<String, int> assignments,
  ) async {
    final score = _selectedStandardScore;
    if (score == null) {
      return;
    }
    final nextAssignments = Map<String, int>.from(assignments)
      ..removeWhere((_, assignedScore) => assignedScore == score);
    nextAssignments[ability.id] = score;
    await widget.controller.setAbilityScore(ability.id, score);
    await widget.controller.setCreationExtraValue(
      kStandardArrayAssignmentsExtraKey,
      nextAssignments,
    );
    if (!mounted) {
      return;
    }
    final remaining = kDefaultStandardArray
        .where((value) => !nextAssignments.values.contains(value))
        .toList(growable: false);
    setState(() {
      _selectedStandardScore = remaining.isEmpty ? score : remaining.first;
    });
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

class _AbilityScoreSummaryCard extends StatelessWidget {
  final CharacterEditorController controller;
  final List<CharacterAbilityDescriptor> abilities;
  final AbilityScoreGenerationMethod method;
  final AbilityScoreValidationResult validation;

  const _AbilityScoreSummaryCard({
    required this.controller,
    required this.abilities,
    required this.method,
    required this.validation,
  });

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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(label: Text(method.label)),
                Chip(
                  backgroundColor: statusColor,
                  label: Text(
                    validation.statusLabel,
                    style: TextStyle(color: statusTextColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: abilities
                  .map((ability) {
                    final score = controller.abilityScoreFor(ability.id);
                    final modifier = controller.abilityModifierFor(ability.id);
                    return Chip(
                      label: Text(
                        '${ability.abbreviation} $score (${_formatModifier(modifier)})',
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
            if (validation.message.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(validation.message),
            ],
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
              'Points spent: ${evaluation.spent} / ${evaluation.rules.pointBudget}',
            ),
            Text('Points remaining: ${evaluation.remaining}'),
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

class _PointBuyGrid extends StatelessWidget {
  final CharacterEditorController controller;
  final List<CharacterAbilityDescriptor> abilities;
  final PointBuyEvaluation evaluation;
  final Map<String, _ClassAbilityRelevance> classRelevance;
  final String Function(CharacterAbilityDescriptor ability) skillSummaryFor;
  final void Function(CharacterAbilityDescriptor ability, int delta) onAdjust;

  const _PointBuyGrid({
    required this.controller,
    required this.abilities,
    required this.evaluation,
    required this.classRelevance,
    required this.skillSummaryFor,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.sizeOf(context).width < 620 ? 1 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: crossAxisCount == 1 ? 1.35 : 1.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: abilities.length,
      itemBuilder: (context, index) {
        final ability = abilities[index];
        return _PointBuyAbilityTile(
          ability: ability,
          score: evaluation.scoreFor(ability.id),
          modifier: controller.abilityModifierFor(ability.id),
          cost: evaluation.costForAbility(ability.id),
          relevance: classRelevance[ability.id],
          skillSummary: skillSummaryFor(ability),
          canIncrement: evaluation.canIncrement(ability.id),
          canDecrement: evaluation.canDecrement(ability.id),
          onIncrement: () => onAdjust(ability, 1),
          onDecrement: () => onAdjust(ability, -1),
        );
      },
    );
  }
}

class _PointBuyAbilityTile extends StatelessWidget {
  final CharacterAbilityDescriptor ability;
  final int score;
  final int modifier;
  final int cost;
  final _ClassAbilityRelevance? relevance;
  final String skillSummary;
  final bool canIncrement;
  final bool canDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _PointBuyAbilityTile({
    required this.ability,
    required this.score,
    required this.modifier,
    required this.cost,
    required this.relevance,
    required this.skillSummary,
    required this.canIncrement,
    required this.canDecrement,
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
                Text('Cost $cost'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              skillSummary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
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
                  tooltip: 'Increase ${ability.label}',
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
  final CharacterEditorController controller;
  final List<CharacterAbilityDescriptor> abilities;

  const _ManualAbilityScoreCard({
    required this.controller,
    required this.abilities,
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
              'Advanced / Manual Entry',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Use this for rolled stats, table-specific rules, imports, or DM-approved overrides.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            AbilityScoreGrid(controller: controller, abilities: abilities),
          ],
        ),
      ),
    );
  }
}

class _StandardArrayAssignmentCard extends StatelessWidget {
  final CharacterEditorController controller;
  final List<CharacterAbilityDescriptor> abilities;
  final Map<String, int> assignments;
  final int? selectedScore;
  final List<int> standardArray;
  final Map<String, _ClassAbilityRelevance> classRelevance;
  final ValueChanged<int> onScoreSelected;
  final ValueChanged<CharacterAbilityDescriptor> onAssign;

  const _StandardArrayAssignmentCard({
    required this.controller,
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
              'Assign these six scores to your abilities.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: standardArray
                  .map((score) {
                    return FilterChip(
                      selected: selectedScore == score,
                      label: Text(
                        usedScores.contains(score)
                            ? '$score assigned'
                            : '$score',
                      ),
                      onSelected: (_) => onScoreSelected(score),
                    );
                  })
                  .toList(growable: false),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.sizeOf(context).width < 520 ? 2 : 3,
                childAspectRatio: 1.02,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: abilities.length,
              itemBuilder: (context, index) {
                final ability = abilities[index];
                return _StandardArrayAbilityTile(
                  ability: ability,
                  score: controller.abilityScoreFor(ability.id),
                  modifier: controller.abilityModifierFor(ability.id),
                  assignedScore: assignments[ability.id],
                  relevance: classRelevance[ability.id],
                  onTap: () => onAssign(ability),
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
  final _ClassAbilityRelevance? relevance;
  final VoidCallback onTap;

  const _StandardArrayAbilityTile({
    required this.ability,
    required this.score,
    required this.modifier,
    required this.assignedScore,
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
                  'Array $assignedScore',
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
