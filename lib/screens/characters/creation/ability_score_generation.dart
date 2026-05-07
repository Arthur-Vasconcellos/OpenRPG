import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/models/character.dart';

const String kCreationAbilityScoresExtraKey = 'abilityScores';
const String kAbilityScoreMethodExtraKey = 'abilityScoreMethod';
const String kStandardArrayAssignmentsExtraKey = 'standardArrayAssignments';
const List<String> kDndAbilityIds = <String>[
  'str',
  'dex',
  'con',
  'int',
  'wis',
  'cha',
];
const List<int> kDefaultStandardArray = <int>[15, 14, 13, 12, 10, 8];

enum AbilityScoreGenerationMethod {
  manualRolled,
  standardArray,
  pointBuy;

  String get storageValue {
    return switch (this) {
      AbilityScoreGenerationMethod.manualRolled => 'manual',
      AbilityScoreGenerationMethod.standardArray => 'standardArray',
      AbilityScoreGenerationMethod.pointBuy => 'pointBuy',
    };
  }

  String get label {
    return switch (this) {
      AbilityScoreGenerationMethod.manualRolled => 'Manual / Rolled',
      AbilityScoreGenerationMethod.standardArray => 'Standard Array',
      AbilityScoreGenerationMethod.pointBuy => 'Point Buy',
    };
  }

  static AbilityScoreGenerationMethod fromStorageValue(String? value) {
    final raw = value?.trim();
    return switch (raw) {
      'standardArray' => AbilityScoreGenerationMethod.standardArray,
      'pointBuy' => AbilityScoreGenerationMethod.pointBuy,
      'manualRolled' ||
      'manual' ||
      null ||
      '' => AbilityScoreGenerationMethod.manualRolled,
      _ => AbilityScoreGenerationMethod.manualRolled,
    };
  }
}

enum AbilityScoreValidationStatus { ready, needsAttention, invalid }

class AbilityScoreValidationResult {
  final AbilityScoreValidationStatus status;
  final String title;
  final String message;

  const AbilityScoreValidationResult({
    required this.status,
    required this.title,
    required this.message,
  });

  bool get blocksProgress => status == AbilityScoreValidationStatus.invalid;

  String get statusLabel {
    return switch (status) {
      AbilityScoreValidationStatus.ready => 'Ready',
      AbilityScoreValidationStatus.needsAttention => 'Needs attention',
      AbilityScoreValidationStatus.invalid => 'Invalid',
    };
  }
}

class PointBuyRules {
  final int startingScore;
  final int minimumScore;
  final int maximumScore;
  final int pointBudget;
  final Map<int, int> costs;

  const PointBuyRules({
    required this.startingScore,
    required this.minimumScore,
    required this.maximumScore,
    required this.pointBudget,
    required this.costs,
  });

  static const PointBuyRules defaults = PointBuyRules(
    startingScore: 8,
    minimumScore: 8,
    maximumScore: 15,
    pointBudget: 27,
    costs: <int, int>{8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9},
  );

  factory PointBuyRules.fromRulesetExtra(Map<String, dynamic> extra) {
    final raw = _findPointBuySettings(extra);
    if (raw == null) {
      return defaults;
    }
    return defaults.copyWith(
      startingScore: _intValue(
        raw['startingScore'] ?? raw['start'] ?? raw['baseScore'],
      ),
      minimumScore: _intValue(
        raw['minimumScore'] ?? raw['minScore'] ?? raw['minimum'],
      ),
      maximumScore: _intValue(
        raw['maximumScore'] ??
            raw['maxScore'] ??
            raw['maximum'] ??
            raw['maximumBeforeBonuses'] ??
            raw['maxBeforeBonuses'],
      ),
      pointBudget: _intValue(
        raw['pointBudget'] ?? raw['budget'] ?? raw['points'],
      ),
      costs: _costTable(
        raw['costs'] ?? raw['scoreCosts'] ?? raw['costTable'] ?? raw['table'],
      ),
    );
  }

  PointBuyRules copyWith({
    int? startingScore,
    int? minimumScore,
    int? maximumScore,
    int? pointBudget,
    Map<int, int>? costs,
  }) {
    return PointBuyRules(
      startingScore: startingScore ?? this.startingScore,
      minimumScore: minimumScore ?? this.minimumScore,
      maximumScore: maximumScore ?? this.maximumScore,
      pointBudget: pointBudget ?? this.pointBudget,
      costs: costs == null
          ? Map<int, int>.from(this.costs)
          : <int, int>{...this.costs, ...costs},
    );
  }

  int? costFor(int score) => costs[score];
}

class PointBuyEvaluation {
  final PointBuyRules rules;
  final List<String> abilityIds;
  final Map<String, int> scores;

  const PointBuyEvaluation({
    required this.rules,
    required this.abilityIds,
    required this.scores,
  });

  factory PointBuyEvaluation.starting({
    required Iterable<String> abilityIds,
    PointBuyRules rules = PointBuyRules.defaults,
  }) {
    final ids = _normalizedAbilityIds(abilityIds);
    return PointBuyEvaluation(
      rules: rules,
      abilityIds: ids,
      scores: {for (final abilityId in ids) abilityId: rules.startingScore},
    );
  }

  factory PointBuyEvaluation.fromAbilityScores({
    required Iterable<String> abilityIds,
    required AbilityScores abilityScores,
    PointBuyRules rules = PointBuyRules.defaults,
  }) {
    final ids = _normalizedAbilityIds(abilityIds);
    return PointBuyEvaluation(
      rules: rules,
      abilityIds: ids,
      scores: {
        for (final abilityId in ids)
          if (abilityScores.values.containsKey(abilityId))
            abilityId: abilityScores.scoreFor(abilityId),
      },
    );
  }

  factory PointBuyEvaluation.fromVisibleScores({
    required Iterable<String> abilityIds,
    required Map<String, int> scores,
    PointBuyRules rules = PointBuyRules.defaults,
  }) {
    final ids = _normalizedAbilityIds(abilityIds);
    return PointBuyEvaluation(
      rules: rules,
      abilityIds: ids,
      scores: {
        for (final abilityId in ids)
          abilityId: scores[abilityId] ?? rules.startingScore,
      },
    );
  }

  Set<String> get missingAbilityIds =>
      abilityIds.where((abilityId) => !scores.containsKey(abilityId)).toSet();

  Set<String> get outOfRangeAbilityIds => abilityIds.where((abilityId) {
    final score = scores[abilityId];
    return score != null &&
        (score < rules.minimumScore || score > rules.maximumScore);
  }).toSet();

  Set<String> get unknownCostAbilityIds => abilityIds.where((abilityId) {
    final score = scores[abilityId];
    return score != null &&
        score >= rules.minimumScore &&
        score <= rules.maximumScore &&
        rules.costFor(score) == null;
  }).toSet();

  int get spent {
    var total = 0;
    for (final abilityId in abilityIds) {
      final score = scores[abilityId];
      if (score == null) {
        continue;
      }
      total += rules.costFor(score) ?? 0;
    }
    return total;
  }

  int get remaining => rules.pointBudget - spent;

  bool get isOverBudget => spent > rules.pointBudget;

  bool get isValid =>
      missingAbilityIds.isEmpty &&
      outOfRangeAbilityIds.isEmpty &&
      unknownCostAbilityIds.isEmpty &&
      !isOverBudget;

  int scoreFor(String abilityId) {
    return scores[canonicalAbilityId(abilityId)] ?? rules.startingScore;
  }

  int modifierFor(String abilityId) {
    return abilityModifierForScore(scoreFor(abilityId));
  }

  int costForAbility(String abilityId) {
    return rules.costFor(scoreFor(abilityId)) ?? 0;
  }

  bool canIncrement(String abilityId) {
    final normalized = canonicalAbilityId(abilityId);
    final current = scoreFor(normalized);
    if (current >= rules.maximumScore) {
      return false;
    }
    final currentCost = rules.costFor(current);
    final nextCost = rules.costFor(current + 1);
    if (currentCost == null || nextCost == null) {
      return false;
    }
    return spent - currentCost + nextCost <= rules.pointBudget;
  }

  bool canDecrement(String abilityId) {
    return scoreFor(abilityId) > rules.minimumScore;
  }
}

class CharacterCreationAbilityScores {
  final AbilityScoreGenerationMethod method;
  final ManualCreationAbilityScores manual;
  final StandardArrayCreationAbilityScores standardArray;
  final PointBuyCreationAbilityScores pointBuy;
  final BackgroundAbilityBonusSelection? backgroundAbilityBonus;

  const CharacterCreationAbilityScores({
    required this.method,
    required this.manual,
    required this.standardArray,
    required this.pointBuy,
    this.backgroundAbilityBonus,
  });

  factory CharacterCreationAbilityScores.defaults({
    AbilityScores? currentScores,
    PointBuyRules pointBuyRules = PointBuyRules.defaults,
  }) {
    return CharacterCreationAbilityScores(
      method: AbilityScoreGenerationMethod.manualRolled,
      manual: ManualCreationAbilityScores.fromScores(
        currentScores?.values,
        defaultScore: 10,
      ),
      standardArray: const StandardArrayCreationAbilityScores(),
      pointBuy: PointBuyCreationAbilityScores.defaults(rules: pointBuyRules),
    );
  }

  factory CharacterCreationAbilityScores.fromCharacter(
    Character character, {
    PointBuyRules pointBuyRules = PointBuyRules.defaults,
  }) {
    return CharacterCreationAbilityScores.fromCreation(
      characterCreationData(character.extraData),
      currentScores: character.abilityScores,
      pointBuyRules: pointBuyRules,
    );
  }

  factory CharacterCreationAbilityScores.fromCreation(
    Map<String, dynamic> creation, {
    AbilityScores? currentScores,
    PointBuyRules pointBuyRules = PointBuyRules.defaults,
  }) {
    final rawAbilityScores = _mapValue(
      creation[kCreationAbilityScoresExtraKey],
    );
    final method = AbilityScoreGenerationMethod.fromStorageValue(
      rawAbilityScores?['method']?.toString() ??
          creation[kAbilityScoreMethodExtraKey]?.toString(),
    );
    final legacyAssignments = _standardArrayAssignmentsFromDynamic(
      creation[kStandardArrayAssignmentsExtraKey],
    );
    final fallbackPointBuyScores =
        rawAbilityScores == null &&
            method == AbilityScoreGenerationMethod.pointBuy
        ? currentScores?.values
        : null;

    return CharacterCreationAbilityScores(
      method: method,
      manual: ManualCreationAbilityScores.fromJson(
        rawAbilityScores?['manual'],
        fallbackScores: currentScores?.values,
      ),
      standardArray: StandardArrayCreationAbilityScores.fromJson(
        rawAbilityScores?['standardArray'],
        fallbackAssignments: legacyAssignments,
      ),
      pointBuy: PointBuyCreationAbilityScores.fromJson(
        rawAbilityScores?['pointBuy'],
        fallbackScores: fallbackPointBuyScores,
        rules: pointBuyRules,
      ),
      backgroundAbilityBonus: BackgroundAbilityBonusSelection.fromJson(
        rawAbilityScores?['backgroundAbilityBonus'] ??
            rawAbilityScores?['backgroundBonuses'],
      ),
    );
  }

  CharacterCreationAbilityScoreResolution resolve({
    DndBackgroundAbilityBonusOptions? backgroundAbilityOptions,
    String? backgroundSourceKey,
  }) {
    final baseScores = switch (method) {
      AbilityScoreGenerationMethod.manualRolled => manual.completeScores(),
      AbilityScoreGenerationMethod.standardArray => standardArray.baseScores(),
      AbilityScoreGenerationMethod.pointBuy => pointBuy.completeScores(),
    };
    final backgroundBonuses =
        backgroundAbilityBonus?.bonusesFor(
          options: backgroundAbilityOptions,
          currentSourceKey:
              backgroundSourceKey ?? backgroundAbilityOptions?.sourceKey,
        ) ??
        const <String, int>{};
    return CharacterCreationAbilityScoreResolution(
      baseScores: baseScores,
      backgroundBonuses: backgroundBonuses,
    );
  }

  Map<String, int> get baseScores => resolve().baseScores;

  Map<String, dynamic> toJson() {
    final resolution = resolve();
    return {
      'method': method.storageValue,
      'manual': manual.toJson(),
      'standardArray': standardArray.toJson(),
      'pointBuy': pointBuy.toJson(),
      'baseScores': resolution.baseScores,
      if (backgroundAbilityBonus != null)
        'backgroundAbilityBonus': backgroundAbilityBonus!.toJson(),
    };
  }

  CharacterCreationAbilityScores copyWith({
    AbilityScoreGenerationMethod? method,
    ManualCreationAbilityScores? manual,
    StandardArrayCreationAbilityScores? standardArray,
    PointBuyCreationAbilityScores? pointBuy,
    BackgroundAbilityBonusSelection? backgroundAbilityBonus,
    bool clearBackgroundAbilityBonus = false,
  }) {
    return CharacterCreationAbilityScores(
      method: method ?? this.method,
      manual: manual ?? this.manual,
      standardArray: standardArray ?? this.standardArray,
      pointBuy: pointBuy ?? this.pointBuy,
      backgroundAbilityBonus: clearBackgroundAbilityBonus
          ? null
          : backgroundAbilityBonus ?? this.backgroundAbilityBonus,
    );
  }

  CharacterCreationAbilityScores withMethod(
    AbilityScoreGenerationMethod method,
  ) {
    return copyWith(method: method);
  }

  CharacterCreationAbilityScores withManualScore(String abilityId, int score) {
    return copyWith(manual: manual.withScore(abilityId, score));
  }

  CharacterCreationAbilityScores withPointBuyScore(
    String abilityId,
    int score, {
    PointBuyRules rules = PointBuyRules.defaults,
  }) {
    return copyWith(pointBuy: pointBuy.withScore(abilityId, score, rules));
  }

  CharacterCreationAbilityScores withStandardArrayAssignment(
    String abilityId,
    int score,
  ) {
    final normalizedAbilityId = canonicalAbilityId(abilityId);
    if (normalizedAbilityId.isEmpty) {
      return this;
    }
    final nextAssignments = Map<String, int>.from(standardArray.assignments)
      ..removeWhere((_, assignedScore) => assignedScore == score);
    nextAssignments[normalizedAbilityId] = score;
    return copyWith(
      standardArray: standardArray.copyWith(assignments: nextAssignments),
    );
  }

  CharacterCreationAbilityScores withBackgroundAbilityBonusMode(
    DndBackgroundAbilityBonusOptions options,
    DndBackgroundAbilityBonusMode mode,
  ) {
    return copyWith(
      backgroundAbilityBonus: BackgroundAbilityBonusSelection.emptyForMode(
        sourceKey: options.sourceKey,
        sourceName: options.sourceName,
        mode: mode,
      ),
    );
  }

  CharacterCreationAbilityScores withBackgroundAbilityBonusAssignment(
    DndBackgroundAbilityBonusOptions options,
    DndBackgroundAbilityBonusMode mode,
    int slotIndex,
    String abilityId,
  ) {
    final current =
        backgroundAbilityBonus?.matchesSourceAndMode(
              options.sourceKey,
              mode.id,
            ) ==
            true
        ? backgroundAbilityBonus!
        : BackgroundAbilityBonusSelection.emptyForMode(
            sourceKey: options.sourceKey,
            sourceName: options.sourceName,
            mode: mode,
          );
    return copyWith(
      backgroundAbilityBonus: current.withAssignment(
        slotIndex: slotIndex,
        bonus: mode.weights[slotIndex],
        abilityId: abilityId,
      ),
    );
  }
}

class ManualCreationAbilityScores {
  final Map<String, int> scores;

  const ManualCreationAbilityScores({this.scores = const <String, int>{}});

  factory ManualCreationAbilityScores.fromJson(
    dynamic json, {
    Map<String, int>? fallbackScores,
  }) {
    final raw = _mapValue(json);
    return ManualCreationAbilityScores.fromScores(
      _mapValue(raw?['scores']) ?? fallbackScores,
      defaultScore: 10,
    );
  }

  factory ManualCreationAbilityScores.fromScores(
    dynamic scores, {
    required int defaultScore,
  }) {
    return ManualCreationAbilityScores(
      scores: _normalizedScoreMap(
        scores,
        defaultScore: defaultScore,
        minimumScore: 1,
        maximumScore: 30,
      ),
    );
  }

  int scoreFor(String abilityId) {
    return completeScores()[canonicalAbilityId(abilityId)] ?? 10;
  }

  Map<String, int> completeScores() {
    return _completeScoreMap(scores, defaultScore: 10);
  }

  ManualCreationAbilityScores withScore(String abilityId, int score) {
    final normalizedAbilityId = canonicalAbilityId(abilityId);
    if (normalizedAbilityId.isEmpty) {
      return this;
    }
    final next = completeScores();
    next[normalizedAbilityId] = score.clamp(1, 30).toInt();
    return ManualCreationAbilityScores(scores: next);
  }

  Map<String, dynamic> toJson() {
    return {'scores': completeScores()};
  }
}

class StandardArrayCreationAbilityScores {
  final Map<String, int> assignments;

  const StandardArrayCreationAbilityScores({
    this.assignments = const <String, int>{},
  });

  factory StandardArrayCreationAbilityScores.fromJson(
    dynamic json, {
    Map<String, int>? fallbackAssignments,
  }) {
    final raw = _mapValue(json);
    return StandardArrayCreationAbilityScores(
      assignments: _standardArrayAssignmentsFromDynamic(
        _mapValue(raw?['assignments']) ?? fallbackAssignments,
      ),
    );
  }

  int? assignedScoreFor(String abilityId) {
    return assignments[canonicalAbilityId(abilityId)];
  }

  Map<String, int> baseScores() {
    final scores = _completeScoreMap(const <String, int>{}, defaultScore: 10);
    for (final entry in assignments.entries) {
      if (kDndAbilityIds.contains(entry.key)) {
        scores[entry.key] = entry.value;
      }
    }
    return scores;
  }

  StandardArrayCreationAbilityScores copyWith({Map<String, int>? assignments}) {
    return StandardArrayCreationAbilityScores(
      assignments: assignments == null
          ? Map<String, int>.from(this.assignments)
          : _standardArrayAssignmentsFromDynamic(assignments),
    );
  }

  Map<String, dynamic> toJson() {
    return {'assignments': Map<String, int>.from(assignments)};
  }
}

class PointBuyCreationAbilityScores {
  final Map<String, int> scores;

  const PointBuyCreationAbilityScores({this.scores = const <String, int>{}});

  factory PointBuyCreationAbilityScores.defaults({
    PointBuyRules rules = PointBuyRules.defaults,
  }) {
    return PointBuyCreationAbilityScores(
      scores: _completeScoreMap(
        const <String, int>{},
        defaultScore: rules.startingScore,
      ),
    );
  }

  factory PointBuyCreationAbilityScores.fromJson(
    dynamic json, {
    Map<String, int>? fallbackScores,
    PointBuyRules rules = PointBuyRules.defaults,
  }) {
    final raw = _mapValue(json);
    return PointBuyCreationAbilityScores(
      scores: _normalizedScoreMap(
        _mapValue(raw?['scores']) ?? fallbackScores,
        defaultScore: rules.startingScore,
        minimumScore: rules.minimumScore,
        maximumScore: rules.maximumScore,
      ),
    );
  }

  int scoreFor(String abilityId) {
    return completeScores()[canonicalAbilityId(abilityId)] ??
        PointBuyRules.defaults.startingScore;
  }

  Map<String, int> completeScores() {
    return _completeScoreMap(
      scores,
      defaultScore: PointBuyRules.defaults.startingScore,
    );
  }

  PointBuyCreationAbilityScores withScore(
    String abilityId,
    int score,
    PointBuyRules rules,
  ) {
    final normalizedAbilityId = canonicalAbilityId(abilityId);
    if (normalizedAbilityId.isEmpty) {
      return this;
    }
    final next = completeScores();
    next[normalizedAbilityId] = score
        .clamp(rules.minimumScore, rules.maximumScore)
        .toInt();
    return PointBuyCreationAbilityScores(scores: next);
  }

  Map<String, dynamic> toJson() {
    return {'scores': completeScores()};
  }
}

class CharacterCreationAbilityScoreResolution {
  final Map<String, int> baseScores;
  final Map<String, int> backgroundBonuses;

  const CharacterCreationAbilityScoreResolution({
    required this.baseScores,
    required this.backgroundBonuses,
  });

  Map<String, int> get finalScores {
    final scores = Map<String, int>.from(baseScores);
    for (final entry in backgroundBonuses.entries) {
      scores[entry.key] = (scores[entry.key] ?? 10) + entry.value;
    }
    return scores;
  }
}

class DndBackgroundAbilityBonusOptions {
  final String sourceKey;
  final String sourceName;
  final List<DndBackgroundAbilityBonusMode> modes;

  const DndBackgroundAbilityBonusOptions({
    required this.sourceKey,
    required this.sourceName,
    required this.modes,
  });

  const DndBackgroundAbilityBonusOptions.none()
    : sourceKey = '',
      sourceName = '',
      modes = const <DndBackgroundAbilityBonusMode>[];

  bool get hasBackground => sourceKey.trim().isNotEmpty;
  bool get hasOptions => modes.isNotEmpty;

  DndBackgroundAbilityBonusMode? modeById(String? modeId) {
    for (final mode in modes) {
      if (mode.id == modeId) {
        return mode;
      }
    }
    return null;
  }

  DndBackgroundAbilityBonusMode get preferredMode => modes.first;
}

class DndBackgroundAbilityBonusMode {
  final String id;
  final String label;
  final List<String> abilityIds;
  final List<int> weights;

  const DndBackgroundAbilityBonusMode({
    required this.id,
    required this.label,
    required this.abilityIds,
    required this.weights,
  });

  int get slotCount => weights.length;
}

class BackgroundAbilityBonusSelection {
  final String sourceKey;
  final String sourceName;
  final String modeId;
  final List<BackgroundAbilityBonusAssignment> assignments;

  const BackgroundAbilityBonusSelection({
    required this.sourceKey,
    required this.sourceName,
    required this.modeId,
    required this.assignments,
  });

  factory BackgroundAbilityBonusSelection.emptyForMode({
    required String sourceKey,
    required String sourceName,
    required DndBackgroundAbilityBonusMode mode,
  }) {
    return BackgroundAbilityBonusSelection(
      sourceKey: sourceKey,
      sourceName: sourceName,
      modeId: mode.id,
      assignments: [
        for (var index = 0; index < mode.weights.length; index++)
          BackgroundAbilityBonusAssignment(
            slotIndex: index,
            bonus: mode.weights[index],
            abilityId: '',
          ),
      ],
    );
  }

  static BackgroundAbilityBonusSelection? fromJson(dynamic json) {
    final raw = _mapValue(json);
    if (raw == null) {
      return null;
    }
    final assignments = <BackgroundAbilityBonusAssignment>[];
    final rawAssignments = raw['assignments'];
    if (rawAssignments is List) {
      for (final entry in rawAssignments) {
        final assignment = BackgroundAbilityBonusAssignment.fromJson(entry);
        if (assignment != null) {
          assignments.add(assignment);
        }
      }
    }
    assignments.sort(
      (left, right) => left.slotIndex.compareTo(right.slotIndex),
    );

    return BackgroundAbilityBonusSelection(
      sourceKey: raw['sourceKey']?.toString() ?? '',
      sourceName: raw['sourceName']?.toString() ?? '',
      modeId: raw['modeId']?.toString() ?? '',
      assignments: assignments,
    );
  }

  bool matchesSourceAndMode(String sourceKey, String modeId) {
    return this.sourceKey == sourceKey && this.modeId == modeId;
  }

  String? abilityForSlot(int slotIndex) {
    for (final assignment in assignments) {
      if (assignment.slotIndex == slotIndex) {
        return assignment.abilityId.trim().isEmpty
            ? null
            : assignment.abilityId;
      }
    }
    return null;
  }

  BackgroundAbilityBonusSelection withAssignment({
    required int slotIndex,
    required int bonus,
    required String abilityId,
  }) {
    final normalizedAbilityId = canonicalAbilityId(abilityId);
    final next = <BackgroundAbilityBonusAssignment>[];
    var replaced = false;
    for (final assignment in assignments) {
      if (assignment.slotIndex == slotIndex) {
        next.add(
          BackgroundAbilityBonusAssignment(
            slotIndex: slotIndex,
            bonus: bonus,
            abilityId: normalizedAbilityId,
          ),
        );
        replaced = true;
      } else {
        next.add(assignment);
      }
    }
    if (!replaced) {
      next.add(
        BackgroundAbilityBonusAssignment(
          slotIndex: slotIndex,
          bonus: bonus,
          abilityId: normalizedAbilityId,
        ),
      );
    }
    next.sort((left, right) => left.slotIndex.compareTo(right.slotIndex));
    return BackgroundAbilityBonusSelection(
      sourceKey: sourceKey,
      sourceName: sourceName,
      modeId: modeId,
      assignments: next,
    );
  }

  Map<String, int> bonusesFor({
    DndBackgroundAbilityBonusOptions? options,
    String? currentSourceKey,
  }) {
    if (currentSourceKey != null &&
        currentSourceKey.trim().isNotEmpty &&
        sourceKey != currentSourceKey) {
      return const <String, int>{};
    }
    final validation = validateBackgroundAbilityBonusSelection(
      options: options,
      currentSourceKey: currentSourceKey,
      selection: this,
    );
    if (validation.status == AbilityScoreValidationStatus.invalid) {
      return const <String, int>{};
    }

    final bonuses = <String, int>{};
    for (final assignment in assignments) {
      final abilityId = canonicalAbilityId(assignment.abilityId);
      if (abilityId.isEmpty) {
        continue;
      }
      bonuses.update(
        abilityId,
        (current) => current + assignment.bonus,
        ifAbsent: () => assignment.bonus,
      );
    }
    return bonuses;
  }

  Map<String, dynamic> toJson() {
    return {
      'sourceKey': sourceKey,
      'sourceName': sourceName,
      'modeId': modeId,
      'assignments': assignments
          .map((assignment) => assignment.toJson())
          .toList(growable: false),
    };
  }
}

class BackgroundAbilityBonusAssignment {
  final int slotIndex;
  final int bonus;
  final String abilityId;

  const BackgroundAbilityBonusAssignment({
    required this.slotIndex,
    required this.bonus,
    required this.abilityId,
  });

  static BackgroundAbilityBonusAssignment? fromJson(dynamic json) {
    final raw = _mapValue(json);
    if (raw == null) {
      return null;
    }
    final slotIndex = _intValue(raw['slotIndex'] ?? raw['slot']);
    final bonus = _intValue(raw['bonus']);
    if (slotIndex == null || bonus == null) {
      return null;
    }
    return BackgroundAbilityBonusAssignment(
      slotIndex: slotIndex,
      bonus: bonus,
      abilityId: canonicalAbilityId(raw['abilityId']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slotIndex': slotIndex,
      'bonus': bonus,
      if (abilityId.trim().isNotEmpty) 'abilityId': abilityId,
    };
  }
}

Character applyCreationAbilityScoresToCharacter(
  Character character,
  CharacterCreationAbilityScores abilityScores, {
  DndBackgroundAbilityBonusOptions? backgroundAbilityOptions,
}) {
  final extraData = Map<String, dynamic>.from(character.extraData);
  final creation = characterCreationData(extraData);
  creation[kCreationAbilityScoresExtraKey] = abilityScores.toJson();
  creation.remove(kAbilityScoreMethodExtraKey);
  creation.remove(kStandardArrayAssignmentsExtraKey);
  extraData['creation'] = creation;

  final resolution = abilityScores.resolve(
    backgroundAbilityOptions: backgroundAbilityOptions,
    backgroundSourceKey:
        backgroundAbilityOptions?.sourceKey ??
        backgroundAbilitySourceKeyForRef(character.backgroundRef),
  );
  return character.copyWith(
    abilityScores: AbilityScores(values: resolution.finalScores),
    extraData: extraData,
  );
}

Map<String, dynamic> characterCreationData(Map<String, dynamic> extraData) {
  final creation = extraData['creation'];
  if (creation is Map<String, dynamic>) {
    return Map<String, dynamic>.from(creation);
  }
  if (creation is Map) {
    return Map<String, dynamic>.from(creation.cast<String, dynamic>());
  }
  return <String, dynamic>{};
}

AbilityScoreGenerationMethod abilityScoreGenerationMethodFromCreation(
  Map<String, dynamic> creation,
) {
  return CharacterCreationAbilityScores.fromCreation(creation).method;
}

Map<String, int> standardArrayAssignmentsFromCreation(
  Map<String, dynamic> creation,
) {
  return CharacterCreationAbilityScores.fromCreation(
    creation,
  ).standardArray.assignments;
}

DndBackgroundAbilityBonusOptions backgroundAbilityBonusOptionsForResolvedEntity(
  CharacterResolvedEntity? background,
) {
  if (background == null) {
    return const DndBackgroundAbilityBonusOptions.none();
  }
  return backgroundAbilityBonusOptionsFromData(
    sourceKey: backgroundAbilitySourceKeyForRef(background.ref),
    sourceName: background.detail.entity.displayName,
    data: background.detail.entity.data,
  );
}

DndBackgroundAbilityBonusOptions backgroundAbilityBonusOptionsFromData({
  required String sourceKey,
  required String sourceName,
  required Map<String, dynamic> data,
}) {
  final modesById = <String, DndBackgroundAbilityBonusMode>{};
  final rawAbility = data['ability'];
  if (rawAbility is List) {
    for (final entry in rawAbility) {
      final mode = _backgroundAbilityBonusModeFromEntry(entry);
      if (mode != null) {
        modesById.putIfAbsent(mode.id, () => mode);
      }
    }
  }
  return DndBackgroundAbilityBonusOptions(
    sourceKey: sourceKey,
    sourceName: sourceName,
    modes: modesById.values.toList(growable: false),
  );
}

String backgroundAbilitySourceKeyForRef(CharacterEntityRef? ref) {
  if (ref == null || !ref.isResolved) {
    return '';
  }
  return '${ref.rulesetId}:${ref.entityType}:${ref.entityId}';
}

AbilityScoreValidationResult validateAbilityScoreGeneration({
  required Character character,
  required List<CharacterAbilityDescriptor> abilities,
  required Map<String, dynamic> creation,
  required PointBuyRules pointBuyRules,
  CharacterCreationAbilityScores? creationAbilityScores,
  DndBackgroundAbilityBonusOptions? backgroundAbilityOptions,
}) {
  final abilityIds = _abilityIdsFromDescriptors(abilities);
  final state =
      creationAbilityScores ??
      CharacterCreationAbilityScores.fromCreation(
        creation,
        currentScores: character.abilityScores,
        pointBuyRules: pointBuyRules,
      );

  final baseValidation = switch (state.method) {
    AbilityScoreGenerationMethod.pointBuy => _validatePointBuy(
      state: state,
      abilityIds: abilityIds,
      rules: pointBuyRules,
    ),
    AbilityScoreGenerationMethod.standardArray => _validateStandardArray(
      state: state,
      abilityIds: abilityIds,
    ),
    AbilityScoreGenerationMethod.manualRolled => _validateManualRolled(
      state: state,
      abilities: abilities,
    ),
  };
  if (baseValidation.status == AbilityScoreValidationStatus.invalid) {
    return baseValidation;
  }

  final backgroundValidation = validateBackgroundAbilityBonusSelection(
    options: backgroundAbilityOptions,
    currentSourceKey:
        backgroundAbilityOptions?.sourceKey ??
        backgroundAbilitySourceKeyForRef(character.backgroundRef),
    selection: state.backgroundAbilityBonus,
  );
  if (backgroundValidation.status == AbilityScoreValidationStatus.invalid) {
    return backgroundValidation;
  }
  if (baseValidation.status == AbilityScoreValidationStatus.needsAttention) {
    return baseValidation;
  }
  if (backgroundValidation.status ==
      AbilityScoreValidationStatus.needsAttention) {
    return backgroundValidation;
  }
  return baseValidation;
}

AbilityScoreValidationResult validateBackgroundAbilityBonusSelection({
  required DndBackgroundAbilityBonusOptions? options,
  required String? currentSourceKey,
  required BackgroundAbilityBonusSelection? selection,
}) {
  if (options == null || !options.hasBackground) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.ready,
      title: 'Background ability increases ready',
      message: '',
    );
  }
  if (!options.hasOptions) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.needsAttention,
      title: 'No background ability increases found',
      message:
          'This background does not expose ability score choices the builder can apply automatically.',
    );
  }
  if (selection == null || selection.modeId.trim().isEmpty) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Background ability increase needed',
      message: 'Choose the ability score increases granted by your background.',
    );
  }
  final sourceKey = currentSourceKey ?? options.sourceKey;
  if (selection.sourceKey != sourceKey ||
      selection.sourceKey != options.sourceKey) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Background ability increase needs review',
      message:
          'The saved ability increase came from a different background. Choose the increases for the current background.',
    );
  }
  final mode = options.modeById(selection.modeId);
  if (mode == null) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Background ability increase needs review',
      message: 'Choose a supported background ability increase option.',
    );
  }
  final selected = <String>[];
  for (var index = 0; index < mode.slotCount; index++) {
    final abilityId = selection.abilityForSlot(index);
    if (abilityId == null || !mode.abilityIds.contains(abilityId)) {
      return const AbilityScoreValidationResult(
        status: AbilityScoreValidationStatus.invalid,
        title: 'Background ability increase needed',
        message:
            'Assign every background ability increase to an available ability.',
      );
    }
    selected.add(abilityId);
  }
  if (selected.toSet().length != selected.length) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Background ability increase needs review',
      message: 'Choose a different ability for each background increase.',
    );
  }
  return const AbilityScoreValidationResult(
    status: AbilityScoreValidationStatus.ready,
    title: 'Background ability increases ready',
    message: 'Background ability increases are ready.',
  );
}

AbilityScoreValidationResult _validatePointBuy({
  required CharacterCreationAbilityScores state,
  required Iterable<String> abilityIds,
  required PointBuyRules rules,
}) {
  final evaluation = PointBuyEvaluation.fromVisibleScores(
    abilityIds: abilityIds,
    scores: state.pointBuy.completeScores(),
    rules: rules,
  );
  if (evaluation.missingAbilityIds.isNotEmpty) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Point Buy needs attention',
      message: 'Set all six ability scores before continuing.',
    );
  }
  if (evaluation.outOfRangeAbilityIds.isNotEmpty) {
    return AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Point Buy score outside the allowed range',
      message:
          'Keep Point Buy scores between ${rules.minimumScore} and ${rules.maximumScore}.',
    );
  }
  if (evaluation.unknownCostAbilityIds.isNotEmpty) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Point Buy table needs attention',
      message: 'The selected rules do not include costs for every score.',
    );
  }
  if (evaluation.isOverBudget) {
    return AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Point Buy is over budget',
      message:
          'Spend ${rules.pointBudget} points or fewer. Current total: ${evaluation.spent}.',
    );
  }
  return const AbilityScoreValidationResult(
    status: AbilityScoreValidationStatus.ready,
    title: 'Point Buy ready',
    message: 'Ability scores are ready.',
  );
}

AbilityScoreValidationResult _validateStandardArray({
  required CharacterCreationAbilityScores state,
  required Iterable<String> abilityIds,
}) {
  final ids = _normalizedAbilityIds(abilityIds);
  final assignments = state.standardArray.assignments;
  final missingAssignments = ids
      .where((abilityId) => !assignments.containsKey(abilityId))
      .toList(growable: false);
  if (missingAssignments.isNotEmpty) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Standard Array needs attention',
      message: 'Assign these six scores to your abilities before continuing.',
    );
  }

  final assignedScores = ids
      .map((abilityId) => assignments[abilityId])
      .whereType<int>()
      .toList(growable: false);
  final expectedScores = kDefaultStandardArray.toSet();
  if (assignedScores.length != kDefaultStandardArray.length ||
      assignedScores.toSet().length != assignedScores.length ||
      !assignedScores.toSet().containsAll(expectedScores)) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Standard Array needs attention',
      message: 'Use each Standard Array score once.',
    );
  }

  return const AbilityScoreValidationResult(
    status: AbilityScoreValidationStatus.ready,
    title: 'Standard Array ready',
    message: 'Ability scores are ready.',
  );
}

AbilityScoreValidationResult _validateManualRolled({
  required CharacterCreationAbilityScores state,
  required List<CharacterAbilityDescriptor> abilities,
}) {
  final scores = state.manual.completeScores();
  if (abilities.isNotEmpty &&
      _abilityIdsFromDescriptors(
        abilities,
      ).every((abilityId) => scores[abilityId] == 10)) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.needsAttention,
      title: 'All abilities are 10',
      message:
          'That can be right for table-specific rules, but most characters use varied scores.',
    );
  }
  return const AbilityScoreValidationResult(
    status: AbilityScoreValidationStatus.ready,
    title: 'Manual scores ready',
    message: 'Ability scores are ready.',
  );
}

int abilityModifierForScore(int score) {
  return ((score - 10) / 2).floor();
}

Map<String, dynamic>? _findPointBuySettings(dynamic value, [int depth = 0]) {
  if (depth > 4 || value is! Map) {
    return null;
  }
  final map = value.cast<String, dynamic>();
  for (final key in const <String>[
    'pointBuy',
    'pointBuyRules',
    'pointBuyDefaults',
    'abilityPointBuy',
  ]) {
    final candidate = map[key];
    if (candidate is Map) {
      return candidate.cast<String, dynamic>();
    }
  }
  if (_looksLikePointBuySettings(map)) {
    return map;
  }
  for (final key in const <String>[
    'abilityScores',
    'abilityScoreGeneration',
    'scoreGeneration',
    'characterCreation',
    'characterGeneration',
    'generation',
    'rules',
    'characterOptions',
    'options',
  ]) {
    final nested = _findPointBuySettings(map[key], depth + 1);
    if (nested != null) {
      return nested;
    }
  }
  return null;
}

bool _looksLikePointBuySettings(Map<String, dynamic> map) {
  return map.containsKey('budget') ||
      map.containsKey('pointBudget') ||
      map.containsKey('costs') ||
      map.containsKey('scoreCosts') ||
      map.containsKey('costTable');
}

int? _intValue(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '');
}

Map<int, int>? _costTable(dynamic raw) {
  if (raw is Map) {
    final costs = <int, int>{};
    for (final entry in raw.entries) {
      final score = _intValue(entry.key);
      final cost = entry.value is Map
          ? _intValue((entry.value as Map)['cost'])
          : _intValue(entry.value);
      if (score != null && cost != null) {
        costs[score] = cost;
      }
    }
    return costs.isEmpty ? null : costs;
  }
  if (raw is List) {
    final costs = <int, int>{};
    for (final entry in raw) {
      if (entry is! Map) {
        continue;
      }
      final score = _intValue(entry['score'] ?? entry['value']);
      final cost = _intValue(entry['cost'] ?? entry['points']);
      if (score != null && cost != null) {
        costs[score] = cost;
      }
    }
    return costs.isEmpty ? null : costs;
  }
  return null;
}

DndBackgroundAbilityBonusMode? _backgroundAbilityBonusModeFromEntry(
  dynamic entry,
) {
  final map = _mapValue(entry);
  final choose = _mapValue(map?['choose']);
  final weighted = _mapValue(choose?['weighted']);
  if (weighted == null) {
    return null;
  }
  final from = weighted['from'];
  final weights = weighted['weights'];
  if (from is! List || weights is! List) {
    return null;
  }
  final abilityIds = from
      .map((value) => canonicalAbilityId(value.toString()))
      .where((abilityId) => abilityId.isNotEmpty)
      .toSet()
      .toList(growable: false);
  final parsedWeights = weights
      .map(_intValue)
      .whereType<int>()
      .toList(growable: false);
  if (abilityIds.isEmpty || parsedWeights.length != weights.length) {
    return null;
  }
  final supported =
      _listEquals(parsedWeights, const <int>[2, 1]) ||
      _listEquals(parsedWeights, const <int>[1, 1, 1]);
  if (!supported || abilityIds.length < parsedWeights.length) {
    return null;
  }
  final id = parsedWeights.join(',');
  return DndBackgroundAbilityBonusMode(
    id: id,
    label: parsedWeights.map((weight) => '+$weight').join('/'),
    abilityIds: abilityIds,
    weights: parsedWeights,
  );
}

bool _listEquals(List<int> left, List<int> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}

Map<String, dynamic>? _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) {
    return Map<String, dynamic>.from(value);
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value.cast<String, dynamic>());
  }
  return null;
}

Map<String, int> _normalizedScoreMap(
  dynamic raw, {
  required int defaultScore,
  required int minimumScore,
  required int maximumScore,
  bool fillMissing = true,
}) {
  final scores = fillMissing
      ? _completeScoreMap(const <String, int>{}, defaultScore: defaultScore)
      : <String, int>{};
  final map = _mapValue(raw);
  if (map == null) {
    return scores;
  }
  for (final entry in map.entries) {
    final abilityId = canonicalAbilityId(entry.key);
    final score = _intValue(entry.value);
    if (abilityId.isEmpty || score == null) {
      continue;
    }
    scores[abilityId] = score.clamp(minimumScore, maximumScore).toInt();
  }
  return scores;
}

Map<String, int> _completeScoreMap(
  Map<String, int> scores, {
  required int defaultScore,
}) {
  return {
    for (final abilityId in kDndAbilityIds)
      abilityId: scores[abilityId] ?? defaultScore,
  };
}

Map<String, int> _standardArrayAssignmentsFromDynamic(dynamic raw) {
  final map = _mapValue(raw);
  if (map == null) {
    return <String, int>{};
  }
  final assignments = <String, int>{};
  for (final entry in map.entries) {
    final abilityId = canonicalAbilityId(entry.key);
    final score = _intValue(entry.value);
    if (abilityId.isEmpty || score == null) {
      continue;
    }
    assignments[abilityId] = score;
  }
  return assignments;
}

List<String> _abilityIdsFromDescriptors(
  List<CharacterAbilityDescriptor> abilities,
) {
  final ids = _normalizedAbilityIds(abilities.map((ability) => ability.id));
  return ids.isEmpty ? List<String>.from(kDndAbilityIds) : ids;
}

List<String> _normalizedAbilityIds(Iterable<String> abilityIds) {
  return abilityIds
      .map(canonicalAbilityId)
      .where((abilityId) => abilityId.isNotEmpty)
      .toList(growable: false);
}
