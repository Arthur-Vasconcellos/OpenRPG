import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/models/character.dart';

const String kAbilityScoreMethodExtraKey = 'abilityScoreMethod';
const String kStandardArrayAssignmentsExtraKey = 'standardArrayAssignments';
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
    return ((scoreFor(abilityId) - 10) / 2).floor();
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

Map<String, dynamic> characterCreationData(Map<String, dynamic> extraData) {
  final creation = extraData['creation'];
  if (creation is Map<String, dynamic>) {
    return Map<String, dynamic>.from(creation);
  }
  if (creation is Map) {
    return Map<String, dynamic>.from(creation.cast<String, dynamic>());
  }
  return const <String, dynamic>{};
}

AbilityScoreGenerationMethod abilityScoreGenerationMethodFromCreation(
  Map<String, dynamic> creation,
) {
  final raw = creation[kAbilityScoreMethodExtraKey]?.toString().trim();
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

Map<String, int> standardArrayAssignmentsFromCreation(
  Map<String, dynamic> creation,
) {
  final raw = creation[kStandardArrayAssignmentsExtraKey];
  if (raw is! Map) {
    return <String, int>{};
  }
  return raw.map((key, value) {
    final parsedValue = value is num ? value.toInt() : int.tryParse('$value');
    return MapEntry(canonicalAbilityId(key.toString()), parsedValue ?? 0);
  })..removeWhere((key, value) => key.isEmpty || value == 0);
}

AbilityScoreValidationResult validateAbilityScoreGeneration({
  required Character character,
  required List<CharacterAbilityDescriptor> abilities,
  required Map<String, dynamic> creation,
  required PointBuyRules pointBuyRules,
}) {
  final abilityIds = abilities.map((ability) => ability.id).toList();
  final missing = abilities
      .where(
        (ability) => !character.abilityScores.values.containsKey(ability.id),
      )
      .map((ability) => ability.label)
      .toList(growable: false);
  final method = abilityScoreGenerationMethodFromCreation(creation);

  if (missing.isNotEmpty) {
    return AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Ability scores missing',
      message: 'Set scores for ${missing.join(', ')}.',
    );
  }

  return switch (method) {
    AbilityScoreGenerationMethod.pointBuy => _validatePointBuy(
      character: character,
      abilityIds: abilityIds,
      rules: pointBuyRules,
    ),
    AbilityScoreGenerationMethod.standardArray => _validateStandardArray(
      character: character,
      abilities: abilities,
      creation: creation,
    ),
    AbilityScoreGenerationMethod.manualRolled => _validateManualRolled(
      character: character,
      abilities: abilities,
    ),
  };
}

AbilityScoreValidationResult _validatePointBuy({
  required Character character,
  required Iterable<String> abilityIds,
  required PointBuyRules rules,
}) {
  final evaluation = PointBuyEvaluation.fromAbilityScores(
    abilityIds: abilityIds,
    abilityScores: character.abilityScores,
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
  required Character character,
  required List<CharacterAbilityDescriptor> abilities,
  required Map<String, dynamic> creation,
}) {
  final assignments = standardArrayAssignmentsFromCreation(creation);
  final abilityIds = abilities.map((ability) => ability.id).toSet();
  final missingAssignments = abilityIds
      .where((abilityId) => !assignments.containsKey(abilityId))
      .toList(growable: false);
  if (missingAssignments.isNotEmpty) {
    return const AbilityScoreValidationResult(
      status: AbilityScoreValidationStatus.invalid,
      title: 'Standard Array needs attention',
      message: 'Assign these six scores to your abilities before continuing.',
    );
  }

  final assignedScores = assignments.values.toList(growable: false);
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

  for (final ability in abilities) {
    if (character.abilityScores.scoreFor(ability.id) !=
        assignments[ability.id]) {
      return const AbilityScoreValidationResult(
        status: AbilityScoreValidationStatus.invalid,
        title: 'Standard Array needs attention',
        message: 'Tap each ability to finish its assigned score.',
      );
    }
  }

  return const AbilityScoreValidationResult(
    status: AbilityScoreValidationStatus.ready,
    title: 'Standard Array ready',
    message: 'Ability scores are ready.',
  );
}

AbilityScoreValidationResult _validateManualRolled({
  required Character character,
  required List<CharacterAbilityDescriptor> abilities,
}) {
  if (abilities.isNotEmpty &&
      abilities.every(
        (ability) => character.abilityScores.scoreFor(ability.id) == 10,
      )) {
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

List<String> _normalizedAbilityIds(Iterable<String> abilityIds) {
  return abilityIds
      .map(canonicalAbilityId)
      .where((abilityId) => abilityId.isNotEmpty)
      .toList(growable: false);
}
