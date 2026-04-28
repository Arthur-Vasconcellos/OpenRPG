import 'package:openrpg/compendium/models/compendium_entity.dart';

class CharacterEntityRef {
  final String entityType;
  final String entityId;
  final String rulesetId;
  final String name;

  const CharacterEntityRef({
    required this.entityType,
    required this.entityId,
    required this.rulesetId,
    required this.name,
  });

  String get displayName => name.trim().isEmpty ? entityId : name.trim();
  bool get isResolved =>
      entityType.trim().isNotEmpty &&
      entityId.trim().isNotEmpty &&
      rulesetId.trim().isNotEmpty;

  factory CharacterEntityRef.fromJson(Map<String, dynamic> json) {
    return CharacterEntityRef(
      entityType: json['entityType']?.toString() ?? '',
      entityId: json['entityId']?.toString() ?? '',
      rulesetId: json['rulesetId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entityType': entityType,
      'entityId': entityId,
      'rulesetId': rulesetId,
      'name': name,
    };
  }

  CharacterEntityRef copyWith({
    String? entityType,
    String? entityId,
    String? rulesetId,
    String? name,
  }) {
    return CharacterEntityRef(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      rulesetId: rulesetId ?? this.rulesetId,
      name: name ?? this.name,
    );
  }
}

class Character {
  static const String jsonSchemaVersion = '3.0.0';

  final String id;
  final String name;
  final String playerName;
  final String primaryRulesetId;
  final List<CharacterClassLevel> classes;
  final CharacterEntityRef? raceRef;
  final CharacterEntityRef? backgroundRef;
  final String alignment;
  final int experiencePoints;
  final int inspiration;

  final AbilityScores abilityScores;
  final CalculatedModifiers modifiers;

  final ProficiencySet proficiencies;

  final CombatStats combatStats;
  final Health health;

  final Equipment equipment;
  final Wealth wealth;

  final SpellcastingInfo? spellcasting;

  final Traits traits;
  final List<Feature> features;
  final List<Feature> racialTraits;
  final List<Feature> backgroundTraits;

  final PhysicalDescription physicalDescription;
  final Notes notes;
  final Map<String, dynamic> extraData;

  final DateTime createdAt;
  final DateTime updatedAt;

  int get totalLevel => classes.fold(0, (sum, cls) => sum + cls.level);

  bool get hasBuildSelections =>
      raceRef != null ||
      backgroundRef != null ||
      classes.any(
        (entry) => entry.classRef != null || entry.subclassRef != null,
      ) ||
      (spellcasting?.allSpells.isNotEmpty ?? false);

  Character({
    required this.id,
    required this.name,
    this.playerName = '',
    this.primaryRulesetId = '',
    required this.classes,
    this.raceRef,
    this.backgroundRef,
    this.alignment = '',
    this.experiencePoints = 0,
    this.inspiration = 0,
    required this.abilityScores,
    required this.modifiers,
    required this.proficiencies,
    required this.combatStats,
    required this.health,
    required this.equipment,
    required this.wealth,
    this.spellcasting,
    required this.traits,
    this.features = const [],
    this.racialTraits = const [],
    this.backgroundTraits = const [],
    required this.physicalDescription,
    required this.notes,
    this.extraData = const <String, dynamic>{},
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc(),
       updatedAt = updatedAt ?? DateTime.now().toUtc();

  factory Character.createBlank({
    required String id,
    required String name,
    required String primaryRulesetId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = (updatedAt ?? DateTime.now().toUtc()).toUtc();
    return Character(
      id: id,
      name: name,
      primaryRulesetId: primaryRulesetId,
      classes: const [],
      alignment: '',
      abilityScores: const AbilityScores(values: <String, int>{}),
      modifiers: const CalculatedModifiers(values: <String, int>{}),
      proficiencies: const ProficiencySet(
        proficiencyBonus: 2,
        skills: SkillProficiencies(proficiencies: {}),
        savingThrows: SavingThrowProficiencies(proficientAbilityIds: {}),
      ),
      combatStats: const CombatStats(
        armorClass: 10,
        initiative: 0,
        speed: 30,
        proficiencyBonus: 2,
      ),
      health: Health(
        maxHitPoints: 1,
        currentHitPoints: 1,
        hitDice: const [],
        deathSaves: const DeathSaves(),
      ),
      equipment: const Equipment(),
      wealth: const Wealth(),
      traits: const Traits(),
      physicalDescription: const PhysicalDescription(),
      notes: const Notes(),
      createdAt: createdAt ?? now,
      updatedAt: now,
    ).copyWithCalculatedValues();
  }

  static String importedName({String? decodedName, String? fileName}) {
    final trimmedName = decodedName?.trim() ?? '';
    if (trimmedName.isNotEmpty) {
      return trimmedName;
    }

    final rawFileName = fileName?.trim() ?? '';
    if (rawFileName.isEmpty) {
      return 'Imported Character';
    }

    return rawFileName
        .replaceAll(RegExp(r'\.character\.json$', caseSensitive: false), '')
        .replaceAll(RegExp(r'\.json$', caseSensitive: false), '')
        .replaceAll('_', ' ')
        .trim();
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    final normalizedJson = _normalizeCharacterJson(json);
    _assertSupportedCharacterJson(normalizedJson);
    final primaryRulesetId =
        normalizedJson['primaryRulesetId']?.toString().trim() ?? '';
    final parsedRaceRef = _refFromDynamic(normalizedJson['raceRef']);
    final parsedBackgroundRef = _refFromDynamic(
      normalizedJson['backgroundRef'],
    );

    final List<CharacterClassLevel> classes;
    if (normalizedJson['classes'] is List) {
      classes = (normalizedJson['classes'] as List)
          .whereType<Map>()
          .map(
            (entry) =>
                CharacterClassLevel.fromJson(entry.cast<String, dynamic>()),
          )
          .toList(growable: false);
    } else {
      classes = const [];
    }

    return Character(
      id:
          normalizedJson['id']?.toString() ??
          'character:${DateTime.now().microsecondsSinceEpoch}',
      name: normalizedJson['name']?.toString() ?? 'Unnamed Character',
      playerName: normalizedJson['playerName']?.toString() ?? '',
      primaryRulesetId: primaryRulesetId,
      classes: classes,
      raceRef: parsedRaceRef,
      backgroundRef: parsedBackgroundRef,
      alignment: normalizedJson['alignment']?.toString() ?? '',
      experiencePoints: _jsonInt(
        normalizedJson['experiencePoints'],
        defaultValue: 0,
      ),
      inspiration: _jsonInt(normalizedJson['inspiration'], defaultValue: 0),
      abilityScores: AbilityScores.fromJson(
        (normalizedJson['abilityScores'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{'values': <String, int>{}},
      ),
      modifiers: CalculatedModifiers.fromJson(
        (normalizedJson['modifiers'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{'values': <String, int>{}},
      ),
      proficiencies: ProficiencySet.fromJson(
        (normalizedJson['proficiencies'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{
              'proficiencyBonus': 2,
              'skills': <String, dynamic>{'proficiencies': <String, dynamic>{}},
              'savingThrows': <String, dynamic>{
                'proficientAbilityIds': <String>[],
              },
            },
      ),
      combatStats: CombatStats.fromJson(
        (normalizedJson['combatStats'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{
              'armorClass': 10,
              'initiative': 0,
              'speed': 30,
              'proficiencyBonus': 2,
            },
      ),
      health: Health.fromJson(
        (normalizedJson['health'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{
              'maxHitPoints': 1,
              'currentHitPoints': 1,
              'hitDice': <dynamic>[],
              'deathSaves': <String, dynamic>{'successes': 0, 'failures': 0},
            },
      ),
      equipment: Equipment.fromJson(
        (normalizedJson['equipment'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      wealth: Wealth.fromJson(
        (normalizedJson['wealth'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      spellcasting: normalizedJson['spellcasting'] is Map<String, dynamic>
          ? SpellcastingInfo.fromJson(
              normalizedJson['spellcasting'] as Map<String, dynamic>,
            )
          : normalizedJson['spellcasting'] is Map
          ? SpellcastingInfo.fromJson(
              (normalizedJson['spellcasting'] as Map).cast<String, dynamic>(),
            )
          : null,
      traits: Traits.fromJson(
        (normalizedJson['traits'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      features: _featureListFromDynamic(normalizedJson['features']),
      racialTraits: _featureListFromDynamic(normalizedJson['racialTraits']),
      backgroundTraits: _featureListFromDynamic(
        normalizedJson['backgroundTraits'],
      ),
      physicalDescription: PhysicalDescription.fromJson(
        (normalizedJson['physicalDescription'] as Map?)
                ?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      notes: Notes.fromJson(
        (normalizedJson['notes'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      extraData: _jsonMap(normalizedJson['extraData']),
      createdAt:
          _dateTimeFromDynamic(
            normalizedJson['createdAt'],
            field: 'createdAt',
          ) ??
          DateTime.now().toUtc(),
      updatedAt:
          _dateTimeFromDynamic(
            normalizedJson['updatedAt'],
            field: 'updatedAt',
          ) ??
          DateTime.now().toUtc(),
    ).copyWithCalculatedValues();
  }

  Character copyWithPartial({
    CombatStats? combatStats,
    Health? health,
    Equipment? equipment,
    ProficiencySet? proficiencies,
  }) {
    return Character(
      id: id,
      name: name,
      playerName: playerName,
      primaryRulesetId: primaryRulesetId,
      classes: classes,
      raceRef: raceRef,
      backgroundRef: backgroundRef,
      alignment: alignment,
      experiencePoints: experiencePoints,
      inspiration: inspiration,
      abilityScores: abilityScores,
      modifiers: modifiers,
      proficiencies: proficiencies ?? this.proficiencies,
      combatStats: combatStats ?? this.combatStats,
      health: health ?? this.health,
      equipment: equipment ?? this.equipment,
      wealth: wealth,
      spellcasting: spellcasting,
      traits: traits,
      features: features,
      racialTraits: racialTraits,
      backgroundTraits: backgroundTraits,
      physicalDescription: physicalDescription,
      notes: notes,
      extraData: CompendiumJsonUtils.deepCopyMap(extraData),
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': jsonSchemaVersion,
      'id': id,
      'name': name,
      'playerName': playerName,
      'primaryRulesetId': primaryRulesetId,
      'classes': classes.map((e) => e.toJson()).toList(growable: false),
      if (raceRef != null) 'raceRef': raceRef!.toJson(),
      if (backgroundRef != null) 'backgroundRef': backgroundRef!.toJson(),
      if (alignment.trim().isNotEmpty) 'alignment': alignment.trim(),
      'experiencePoints': experiencePoints,
      'inspiration': inspiration,
      'abilityScores': abilityScores.toJson(),
      'modifiers': modifiers.toJson(),
      'proficiencies': proficiencies.toJson(),
      'combatStats': combatStats.toJson(),
      'health': health.toJson(),
      'equipment': equipment.toJson(),
      'wealth': wealth.toJson(),
      if (spellcasting != null) 'spellcasting': spellcasting!.toJson(),
      'traits': traits.toJson(),
      'features': features
          .map((entry) => entry.toJson())
          .toList(growable: false),
      'racialTraits': racialTraits
          .map((entry) => entry.toJson())
          .toList(growable: false),
      'backgroundTraits': backgroundTraits
          .map((entry) => entry.toJson())
          .toList(growable: false),
      'physicalDescription': physicalDescription.toJson(),
      'notes': notes.toJson(),
      if (extraData.isNotEmpty)
        'extraData': CompendiumJsonUtils.deepCopyMap(extraData),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Character copyWith({
    String? id,
    String? name,
    String? playerName,
    String? primaryRulesetId,
    List<CharacterClassLevel>? classes,
    CharacterEntityRef? raceRef,
    bool clearRaceRef = false,
    CharacterEntityRef? backgroundRef,
    bool clearBackgroundRef = false,
    String? alignment,
    int? experiencePoints,
    int? inspiration,
    AbilityScores? abilityScores,
    CalculatedModifiers? modifiers,
    ProficiencySet? proficiencies,
    CombatStats? combatStats,
    Health? health,
    Equipment? equipment,
    Wealth? wealth,
    SpellcastingInfo? spellcasting,
    bool clearSpellcasting = false,
    Traits? traits,
    List<Feature>? features,
    List<Feature>? racialTraits,
    List<Feature>? backgroundTraits,
    PhysicalDescription? physicalDescription,
    Notes? notes,
    Map<String, dynamic>? extraData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      playerName: playerName ?? this.playerName,
      primaryRulesetId: primaryRulesetId ?? this.primaryRulesetId,
      classes: classes ?? List.from(this.classes),
      raceRef: clearRaceRef ? null : raceRef ?? this.raceRef,
      backgroundRef: clearBackgroundRef
          ? null
          : backgroundRef ?? this.backgroundRef,
      alignment: alignment ?? this.alignment,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      inspiration: inspiration ?? this.inspiration,
      abilityScores: abilityScores ?? this.abilityScores,
      modifiers: modifiers ?? this.modifiers,
      proficiencies: proficiencies ?? this.proficiencies,
      combatStats: combatStats ?? this.combatStats,
      health: health ?? this.health,
      equipment: equipment ?? this.equipment,
      wealth: wealth ?? this.wealth,
      spellcasting: clearSpellcasting
          ? null
          : spellcasting ?? this.spellcasting,
      traits: traits ?? this.traits,
      features: features ?? List.from(this.features),
      racialTraits: racialTraits ?? List.from(this.racialTraits),
      backgroundTraits: backgroundTraits ?? List.from(this.backgroundTraits),
      physicalDescription: physicalDescription ?? this.physicalDescription,
      notes: notes ?? this.notes,
      extraData: extraData ?? CompendiumJsonUtils.deepCopyMap(this.extraData),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    ).copyWithCalculatedValues();
  }

  Character copyWithCalculatedValues() {
    final totalLevel = this.totalLevel;
    final calculatedModifiers = _calculateModifiers(abilityScores);
    final proficiencyBonus = _calculateProficiencyBonus(totalLevel);
    final updatedCombatStats = combatStats.copyWith(
      proficiencyBonus: proficiencyBonus,
      initiative: calculatedModifiers.modifierFor('dex'),
    );

    return Character(
      id: id,
      name: name,
      playerName: playerName,
      primaryRulesetId: primaryRulesetId,
      classes: classes,
      raceRef: raceRef,
      backgroundRef: backgroundRef,
      alignment: alignment,
      experiencePoints: experiencePoints,
      inspiration: inspiration,
      abilityScores: abilityScores,
      modifiers: calculatedModifiers,
      proficiencies: proficiencies.copyWith(proficiencyBonus: proficiencyBonus),
      combatStats: updatedCombatStats,
      health: health,
      equipment: equipment,
      wealth: wealth,
      spellcasting: spellcasting?.copyWith(
        spellSaveDC:
            8 +
            proficiencyBonus +
            (spellcasting?.spellcastingAbility?.getModifier(
                  calculatedModifiers,
                ) ??
                0),
        spellAttackBonus:
            proficiencyBonus +
            (spellcasting?.spellcastingAbility?.getModifier(
                  calculatedModifiers,
                ) ??
                0),
      ),
      traits: traits,
      features: features,
      racialTraits: racialTraits,
      backgroundTraits: backgroundTraits,
      physicalDescription: physicalDescription,
      notes: notes,
      extraData: CompendiumJsonUtils.deepCopyMap(extraData),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Character ensureSheetFields({
    required Iterable<String> abilityIds,
    required Iterable<String> skillIds,
  }) {
    return copyWith(
      abilityScores: abilityScores.ensureAbilityIds(abilityIds),
      proficiencies: proficiencies.copyWith(
        skills: proficiencies.skills.onlyFor(skillIds),
        savingThrows: proficiencies.savingThrows.onlyFor(abilityIds),
      ),
    );
  }

  CalculatedModifiers _calculateModifiers(AbilityScores scores) {
    return CalculatedModifiers.fromAbilityScores(scores);
  }

  int _calculateProficiencyBonus(int level) {
    if (level <= 0) {
      return 2;
    }
    return 2 + ((level - 1) / 4).ceil();
  }
}

class CharacterClassLevel {
  final CharacterEntityRef? classRef;
  final CharacterEntityRef? subclassRef;
  final int level;

  String get className => classRef?.displayName ?? 'Unassigned class';
  String? get subclassName => subclassRef?.displayName;

  CharacterClassLevel({this.classRef, this.subclassRef, required this.level});

  factory CharacterClassLevel.fromJson(Map<String, dynamic> json) {
    final parsedClassRef = _refFromDynamic(json['classRef']);
    final parsedSubclassRef = _refFromDynamic(json['subclassRef']);
    return CharacterClassLevel(
      classRef: parsedClassRef,
      subclassRef: parsedSubclassRef,
      level: _jsonInt(json['level'], defaultValue: 1, field: 'classes.level'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (classRef != null) 'classRef': classRef!.toJson(),
      if (subclassRef != null) 'subclassRef': subclassRef!.toJson(),
      'level': level,
    };
  }

  CharacterClassLevel copyWith({
    CharacterEntityRef? classRef,
    bool clearClassRef = false,
    CharacterEntityRef? subclassRef,
    bool clearSubclassRef = false,
    int? level,
  }) {
    return CharacterClassLevel(
      classRef: clearClassRef ? null : classRef ?? this.classRef,
      subclassRef: clearSubclassRef ? null : subclassRef ?? this.subclassRef,
      level: level ?? this.level,
    );
  }
}

typedef CharacterClassEntry = CharacterClassLevel;

CharacterEntityRef? _refFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return CharacterEntityRef.fromJson(value);
  }
  if (value is Map) {
    return CharacterEntityRef.fromJson(value.cast<String, dynamic>());
  }
  return null;
}

List<Feature> _featureListFromDynamic(dynamic value) {
  if (value is! List) {
    return const <Feature>[];
  }

  return value
      .whereType<Map>()
      .map((entry) => Feature.fromJson(entry.cast<String, dynamic>()))
      .toList(growable: false);
}

const Set<String> _removedCharacterPayloadKeys = <String>{
  'race',
  'background',
  'characterClass',
  'subclass',
  'level',
  'equippedCombatStats',
  'inventory',
  'weapons',
  'armor',
};

Map<String, dynamic> _normalizeCharacterJson(Map<String, dynamic> json) {
  final normalized = CompendiumJsonUtils.jsonMap(json);
  final extraData = _jsonMap(normalized['extraData']);
  if (extraData.isEmpty) {
    normalized.remove('extraData');
  } else {
    normalized['extraData'] = extraData;
  }
  return normalized;
}

Map<String, dynamic> _jsonMap(dynamic value) {
  return CompendiumJsonUtils.jsonMap(value);
}

List<Map<String, dynamic>> _jsonListOfMaps(dynamic value) {
  return CompendiumJsonUtils.listOfMaps(value);
}

int _jsonInt(dynamic value, {required int defaultValue, String? field}) {
  if (value == null) {
    return defaultValue;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  throw FormatException('Invalid integer for ${field ?? 'value'}: $value');
}

double _jsonDouble(
  dynamic value, {
  required double defaultValue,
  String? field,
}) {
  if (value == null) {
    return defaultValue;
  }
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  throw FormatException('Invalid number for ${field ?? 'value'}: $value');
}

bool _jsonBool(dynamic value, {required bool defaultValue, String? field}) {
  if (value == null) {
    return defaultValue;
  }
  if (value is bool) {
    return value;
  }
  throw FormatException('Invalid boolean for ${field ?? 'value'}: $value');
}

List<String> _stringListFromDynamic(dynamic value) {
  if (value is! List) {
    return const <String>[];
  }

  return value
      .map((entry) => entry?.toString().trim() ?? '')
      .where((entry) => entry.isNotEmpty)
      .toList(growable: false);
}

DateTime? _dateTimeFromDynamic(dynamic value, {String? field}) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value.toUtc();
  }

  final parsed = DateTime.tryParse(value.toString());
  if (parsed != null) {
    return parsed.toUtc();
  }

  throw FormatException('Invalid date for ${field ?? 'value'}: $value');
}

void _assertSupportedCharacterJson(Map<String, dynamic> json) {
  final rawSchemaVersion = json['schemaVersion']?.toString().trim() ?? '';
  final hasRemovedKeys = _removedCharacterPayloadKeys.any(json.containsKey);
  if (hasRemovedKeys) {
    throw StateError(
      'This character file uses a removed character schema and can no longer be loaded.',
    );
  }
  if (rawSchemaVersion != Character.jsonSchemaVersion) {
    throw StateError(
      'Unsupported character schema version "$rawSchemaVersion".',
    );
  }
}

const Set<String> _canonicalAbilityIds = <String>{
  'str',
  'dex',
  'con',
  'int',
  'wis',
  'cha',
};

String canonicalAbilityId(String? value) {
  final normalized = value?.trim().toLowerCase() ?? '';
  return _canonicalAbilityIds.contains(normalized) ? normalized : '';
}

String _normalizeLookupId(String? value) {
  return value?.trim().toLowerCase() ?? '';
}

class AbilityScores {
  final Map<String, int> values;

  const AbilityScores({required this.values});

  factory AbilityScores.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const AbilityScores(values: <String, int>{});
    }
    final rawValues = json['values'];
    if (rawValues is! Map) {
      throw StateError(
        'Current character schema requires abilityScores.values to be a map.',
      );
    }
    final source = rawValues.cast<String, dynamic>();
    final values = <String, int>{};
    for (final entry in source.entries) {
      final abilityId = canonicalAbilityId(entry.key);
      if (abilityId.isEmpty) {
        continue;
      }
      values[abilityId] = _jsonInt(
        entry.value,
        defaultValue: 10,
        field: 'abilityScores.values.$abilityId',
      );
    }
    return AbilityScores(values: values);
  }

  List<String> get ids => values.keys.toList(growable: false);

  int scoreFor(String abilityId, {int defaultValue = 10}) {
    return values[canonicalAbilityId(abilityId)] ?? defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {'values': Map<String, int>.from(values)};
  }

  AbilityScores copyWith({Map<String, int>? values}) {
    return AbilityScores(values: values ?? Map<String, int>.from(this.values));
  }

  AbilityScores copyWithValue(String abilityId, int score) {
    final normalizedAbilityId = canonicalAbilityId(abilityId);
    final next = Map<String, int>.from(values);
    next[normalizedAbilityId] = score;
    return AbilityScores(values: next);
  }

  AbilityScores ensureAbilityIds(Iterable<String> abilityIds) {
    final allowed = {
      for (final abilityId in abilityIds)
        if (canonicalAbilityId(abilityId).isNotEmpty)
          canonicalAbilityId(abilityId),
    };
    final next = <String, int>{};
    for (final abilityId in allowed) {
      next[abilityId] = values[abilityId] ?? 10;
    }
    return AbilityScores(values: next);
  }
}

class CalculatedModifiers {
  final Map<String, int> values;

  const CalculatedModifiers({required this.values});

  factory CalculatedModifiers.fromAbilityScores(AbilityScores scores) {
    final values = <String, int>{};
    for (final entry in scores.values.entries) {
      values[entry.key] = ((entry.value - 10) / 2).floor();
    }
    return CalculatedModifiers(values: values);
  }

  factory CalculatedModifiers.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const CalculatedModifiers(values: <String, int>{});
    }
    final rawValues = json['values'];
    if (rawValues is! Map) {
      throw StateError(
        'Current character schema requires modifiers.values to be a map.',
      );
    }
    final source = rawValues.cast<String, dynamic>();
    final values = <String, int>{};
    for (final entry in source.entries) {
      final abilityId = canonicalAbilityId(entry.key);
      if (abilityId.isEmpty) {
        continue;
      }
      values[abilityId] = _jsonInt(
        entry.value,
        defaultValue: 0,
        field: 'modifiers.values.$abilityId',
      );
    }
    return CalculatedModifiers(values: values);
  }

  int modifierFor(String abilityId) {
    return values[canonicalAbilityId(abilityId)] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {'values': Map<String, int>.from(values)};
  }

  CalculatedModifiers copyWith({Map<String, int>? values}) {
    return CalculatedModifiers(
      values: values ?? Map<String, int>.from(this.values),
    );
  }
}

abstract final class SkillTrainingLevel {
  static const String none = 'none';
  static const String proficient = 'proficient';
  static const String expertise = 'expertise';
  static const String half = 'half';

  static const Set<String> supported = <String>{
    none,
    proficient,
    expertise,
    half,
  };

  static String normalize(String value) {
    final normalized = value.trim().toLowerCase();
    return supported.contains(normalized) ? normalized : none;
  }

  static String parse(String value, {required String field}) {
    final normalized = value.trim().toLowerCase();
    if (supported.contains(normalized)) {
      return normalized;
    }
    throw StateError(
      'Unsupported skill training "$value" for "$field". '
      'Expected one of: ${supported.join(', ')}.',
    );
  }

  static int bonus(String level, int proficiencyBonus) {
    return switch (normalize(level)) {
      proficient => proficiencyBonus,
      expertise => proficiencyBonus * 2,
      half => proficiencyBonus ~/ 2,
      _ => 0,
    };
  }

  static String shortLabel(String level) {
    return switch (normalize(level)) {
      proficient => 'Prof.',
      expertise => 'Expert',
      half => 'Half',
      _ => 'None',
    };
  }
}

class ProficiencySet {
  final int proficiencyBonus;
  final SkillProficiencies skills;
  final SavingThrowProficiencies savingThrows;
  final List<String> languages;
  final List<String> tools;
  final List<String> weapons;
  final List<String> armor;
  final List<String> other;

  const ProficiencySet({
    required this.proficiencyBonus,
    required this.skills,
    required this.savingThrows,
    this.languages = const [],
    this.tools = const [],
    this.weapons = const [],
    this.armor = const [],
    this.other = const [],
  });

  factory ProficiencySet.fromJson(Map<String, dynamic> json) {
    return ProficiencySet(
      proficiencyBonus: _jsonInt(
        json['proficiencyBonus'],
        defaultValue: 2,
        field: 'proficiencies.proficiencyBonus',
      ),
      skills: SkillProficiencies.fromJson(_jsonMap(json['skills'])),
      savingThrows: SavingThrowProficiencies.fromJson(
        _jsonMap(json['savingThrows']),
      ),
      languages: _stringListFromDynamic(json['languages']),
      tools: _stringListFromDynamic(json['tools']),
      weapons: _stringListFromDynamic(json['weapons']),
      armor: _stringListFromDynamic(json['armor']),
      other: _stringListFromDynamic(json['other']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proficiencyBonus': proficiencyBonus,
      'skills': skills.toJson(),
      'savingThrows': savingThrows.toJson(),
      'languages': languages,
      'tools': tools,
      'weapons': weapons,
      'armor': armor,
      'other': other,
    };
  }

  ProficiencySet copyWith({
    int? proficiencyBonus,
    SkillProficiencies? skills,
    SavingThrowProficiencies? savingThrows,
    List<String>? languages,
    List<String>? tools,
    List<String>? weapons,
    List<String>? armor,
    List<String>? other,
  }) {
    return ProficiencySet(
      proficiencyBonus: proficiencyBonus ?? this.proficiencyBonus,
      skills: skills ?? this.skills,
      savingThrows: savingThrows ?? this.savingThrows,
      languages: languages ?? List.from(this.languages),
      tools: tools ?? List.from(this.tools),
      weapons: weapons ?? List.from(this.weapons),
      armor: armor ?? List.from(this.armor),
      other: other ?? List.from(this.other),
    );
  }
}

class SkillProficiencies {
  final Map<String, String> proficiencies;

  const SkillProficiencies({required this.proficiencies});

  int getModifier(
    String skillId, {
    required String abilityId,
    required CalculatedModifiers modifiers,
    int proficiencyBonus = 0,
  }) {
    return modifiers.modifierFor(abilityId) +
        SkillTrainingLevel.bonus(proficiencyFor(skillId), proficiencyBonus);
  }

  String proficiencyFor(String skillId) {
    return SkillTrainingLevel.normalize(
      proficiencies[_normalizeLookupId(skillId)] ?? SkillTrainingLevel.none,
    );
  }

  factory SkillProficiencies.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const SkillProficiencies(proficiencies: <String, String>{});
    }
    final map = <String, String>{};
    final rawProficiencies = json['proficiencies'];
    if (rawProficiencies is! Map) {
      throw StateError(
        'Current character schema requires proficiencies.skills.proficiencies to be a map.',
      );
    }
    final source = rawProficiencies.cast<String, dynamic>();

    for (final entry in source.entries) {
      final skillId = _normalizeLookupId(entry.key);
      if (skillId.isEmpty) {
        continue;
      }
      map[skillId] = SkillTrainingLevel.parse(
        entry.value.toString(),
        field: 'proficiencies.skills.proficiencies.$skillId',
      );
    }

    return SkillProficiencies(proficiencies: map);
  }

  Map<String, dynamic> toJson() {
    final map = <String, String>{};
    for (final entry in proficiencies.entries) {
      map[entry.key] = SkillTrainingLevel.normalize(entry.value);
    }
    return {'proficiencies': map};
  }

  SkillProficiencies copyWith({Map<String, String>? proficiencies}) {
    return SkillProficiencies(
      proficiencies:
          proficiencies ?? Map<String, String>.from(this.proficiencies),
    );
  }

  SkillProficiencies onlyFor(Iterable<String> skillIds) {
    final allowed = {
      for (final skillId in skillIds)
        if (_normalizeLookupId(skillId).isNotEmpty) _normalizeLookupId(skillId),
    };
    final next = <String, String>{};
    for (final skillId in allowed) {
      final level = proficiencies[skillId];
      if (level == null) {
        continue;
      }
      next[skillId] = SkillTrainingLevel.normalize(level);
    }
    return SkillProficiencies(proficiencies: next);
  }
}

class SavingThrowProficiencies {
  final Set<String> proficientAbilityIds;

  const SavingThrowProficiencies({required this.proficientAbilityIds});

  int getModifier(
    String ability,
    CalculatedModifiers modifiers,
    int proficiencyBonus,
  ) {
    final normalizedAbility = canonicalAbilityId(ability);
    return modifiers.modifierFor(normalizedAbility) +
        (isProficient(normalizedAbility) ? proficiencyBonus : 0);
  }

  bool isProficient(String abilityId) {
    return proficientAbilityIds.contains(canonicalAbilityId(abilityId));
  }

  factory SavingThrowProficiencies.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const SavingThrowProficiencies(proficientAbilityIds: <String>{});
    }
    final rawList = json['proficientAbilityIds'];
    if (rawList is! List) {
      throw StateError(
        'Current character schema requires proficiencies.savingThrows.proficientAbilityIds to be a list.',
      );
    }
    return SavingThrowProficiencies(
      proficientAbilityIds: rawList
          .map((entry) => canonicalAbilityId(entry.toString()))
          .where((entry) => entry.isNotEmpty)
          .toSet(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proficientAbilityIds': proficientAbilityIds.toList(growable: false),
    };
  }

  SavingThrowProficiencies copyWith({Set<String>? proficientAbilityIds}) {
    return SavingThrowProficiencies(
      proficientAbilityIds:
          proficientAbilityIds ?? Set<String>.from(this.proficientAbilityIds),
    );
  }

  SavingThrowProficiencies onlyFor(Iterable<String> abilityIds) {
    final allowed = {
      for (final abilityId in abilityIds)
        if (canonicalAbilityId(abilityId).isNotEmpty)
          canonicalAbilityId(abilityId),
    };
    return SavingThrowProficiencies(
      proficientAbilityIds: proficientAbilityIds
          .where(allowed.contains)
          .toSet(),
    );
  }
}

class CombatStats {
  final int armorClass;
  final int initiative;
  final int speed;
  final int proficiencyBonus;

  const CombatStats({
    required this.armorClass,
    required this.initiative,
    required this.speed,
    required this.proficiencyBonus,
  });

  CombatStats copyWith({
    int? armorClass,
    int? initiative,
    int? speed,
    int? proficiencyBonus,
  }) {
    return CombatStats(
      armorClass: armorClass ?? this.armorClass,
      initiative: initiative ?? this.initiative,
      speed: speed ?? this.speed,
      proficiencyBonus: proficiencyBonus ?? this.proficiencyBonus,
    );
  }

  factory CombatStats.fromJson(Map<String, dynamic> json) {
    return CombatStats(
      armorClass: _jsonInt(
        json['armorClass'],
        defaultValue: 10,
        field: 'combatStats.armorClass',
      ),
      initiative: _jsonInt(
        json['initiative'],
        defaultValue: 0,
        field: 'combatStats.initiative',
      ),
      speed: _jsonInt(
        json['speed'],
        defaultValue: 30,
        field: 'combatStats.speed',
      ),
      proficiencyBonus: _jsonInt(
        json['proficiencyBonus'],
        defaultValue: 2,
        field: 'combatStats.proficiencyBonus',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'armorClass': armorClass,
      'initiative': initiative,
      'speed': speed,
      'proficiencyBonus': proficiencyBonus,
    };
  }
}

class Health {
  final int maxHitPoints;
  final int currentHitPoints;
  final int temporaryHitPoints;
  final List<HitDie> hitDice;
  final DeathSaves deathSaves;
  final int exhaustionLevel;

  const Health({
    required this.maxHitPoints,
    required this.currentHitPoints,
    this.temporaryHitPoints = 0,
    required this.hitDice,
    required this.deathSaves,
    this.exhaustionLevel = 0,
  });

  Health copyWith({
    int? maxHitPoints,
    int? currentHitPoints,
    int? temporaryHitPoints,
    List<HitDie>? hitDice,
    DeathSaves? deathSaves,
    int? exhaustionLevel,
  }) {
    return Health(
      maxHitPoints: maxHitPoints ?? this.maxHitPoints,
      currentHitPoints: currentHitPoints ?? this.currentHitPoints,
      temporaryHitPoints: temporaryHitPoints ?? this.temporaryHitPoints,
      hitDice: hitDice ?? List.from(this.hitDice),
      deathSaves: deathSaves ?? this.deathSaves,
      exhaustionLevel: exhaustionLevel ?? this.exhaustionLevel,
    );
  }

  factory Health.fromJson(Map<String, dynamic> json) {
    return Health(
      maxHitPoints: _jsonInt(
        json['maxHitPoints'],
        defaultValue: 1,
        field: 'health.maxHitPoints',
      ),
      currentHitPoints: _jsonInt(
        json['currentHitPoints'],
        defaultValue: 1,
        field: 'health.currentHitPoints',
      ),
      temporaryHitPoints: _jsonInt(
        json['temporaryHitPoints'],
        defaultValue: 0,
        field: 'health.temporaryHitPoints',
      ),
      hitDice: _jsonListOfMaps(
        json['hitDice'],
      ).map(HitDie.fromJson).toList(growable: false),
      deathSaves: DeathSaves.fromJson(_jsonMap(json['deathSaves'])),
      exhaustionLevel: _jsonInt(
        json['exhaustionLevel'],
        defaultValue: 0,
        field: 'health.exhaustionLevel',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxHitPoints': maxHitPoints,
      'currentHitPoints': currentHitPoints,
      'temporaryHitPoints': temporaryHitPoints,
      'hitDice': hitDice.map((e) => e.toJson()).toList(),
      'deathSaves': deathSaves.toJson(),
      'exhaustionLevel': exhaustionLevel,
    };
  }
}

class HitDie {
  final int sides;
  final int count;
  final int used;

  const HitDie({required this.sides, required this.count, this.used = 0});

  int get remaining => count - used;

  factory HitDie.fromJson(Map<String, dynamic> json) {
    return HitDie(
      sides: _jsonInt(json['sides'], defaultValue: 0, field: 'hitDice.sides'),
      count: _jsonInt(json['count'], defaultValue: 0, field: 'hitDice.count'),
      used: _jsonInt(json['used'], defaultValue: 0, field: 'hitDice.used'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'sides': sides, 'count': count, 'used': used};
  }
}

class DeathSaves {
  final int successes;
  final int failures;

  const DeathSaves({this.successes = 0, this.failures = 0});

  factory DeathSaves.fromJson(Map<String, dynamic> json) {
    return DeathSaves(
      successes: _jsonInt(
        json['successes'],
        defaultValue: 0,
        field: 'deathSaves.successes',
      ),
      failures: _jsonInt(
        json['failures'],
        defaultValue: 0,
        field: 'deathSaves.failures',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'successes': successes, 'failures': failures};
  }
}

enum CharacterInventoryKind { other, weapon, armor }

class CharacterInventoryEntryOverrides {
  final String? label;
  final String? damageDice;
  final String? damageType;
  final String? attackAbility;
  final int? enhancementBonus;
  final bool? finesse;
  final String? weaponCategory;
  final int? armorClass;
  final String? armorCategory;
  final bool? usesDexterity;
  final int? maxDexterityBonus;

  const CharacterInventoryEntryOverrides({
    this.label,
    this.damageDice,
    this.damageType,
    this.attackAbility,
    this.enhancementBonus,
    this.finesse,
    this.weaponCategory,
    this.armorClass,
    this.armorCategory,
    this.usesDexterity,
    this.maxDexterityBonus,
  });

  bool get isEmpty =>
      label == null &&
      damageDice == null &&
      damageType == null &&
      attackAbility == null &&
      enhancementBonus == null &&
      finesse == null &&
      weaponCategory == null &&
      armorClass == null &&
      armorCategory == null &&
      usesDexterity == null &&
      maxDexterityBonus == null;

  factory CharacterInventoryEntryOverrides.fromJson(Map<String, dynamic> json) {
    return CharacterInventoryEntryOverrides(
      label: json['label']?.toString(),
      damageDice: json['damageDice']?.toString(),
      damageType: json['damageType']?.toString(),
      attackAbility: json['attackAbility']?.toString(),
      enhancementBonus: json['enhancementBonus'] == null
          ? null
          : _jsonInt(
              json['enhancementBonus'],
              defaultValue: 0,
              field: 'equipment.overrides.enhancementBonus',
            ),
      finesse: json['finesse'] == null
          ? null
          : _jsonBool(
              json['finesse'],
              defaultValue: false,
              field: 'equipment.overrides.finesse',
            ),
      weaponCategory: json['weaponCategory']?.toString(),
      armorClass: json['armorClass'] == null
          ? null
          : _jsonInt(
              json['armorClass'],
              defaultValue: 0,
              field: 'equipment.overrides.armorClass',
            ),
      armorCategory: json['armorCategory']?.toString(),
      usesDexterity: json['usesDexterity'] == null
          ? null
          : _jsonBool(
              json['usesDexterity'],
              defaultValue: false,
              field: 'equipment.overrides.usesDexterity',
            ),
      maxDexterityBonus: json['maxDexterityBonus'] == null
          ? null
          : _jsonInt(
              json['maxDexterityBonus'],
              defaultValue: 0,
              field: 'equipment.overrides.maxDexterityBonus',
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (label != null) 'label': label,
      if (damageDice != null) 'damageDice': damageDice,
      if (damageType != null) 'damageType': damageType,
      if (attackAbility != null) 'attackAbility': attackAbility,
      if (enhancementBonus != null) 'enhancementBonus': enhancementBonus,
      if (finesse != null) 'finesse': finesse,
      if (weaponCategory != null) 'weaponCategory': weaponCategory,
      if (armorClass != null) 'armorClass': armorClass,
      if (armorCategory != null) 'armorCategory': armorCategory,
      if (usesDexterity != null) 'usesDexterity': usesDexterity,
      if (maxDexterityBonus != null) 'maxDexterityBonus': maxDexterityBonus,
    };
  }

  CharacterInventoryEntryOverrides copyWith({
    String? label,
    String? damageDice,
    String? damageType,
    String? attackAbility,
    int? enhancementBonus,
    bool? finesse,
    String? weaponCategory,
    int? armorClass,
    String? armorCategory,
    bool? usesDexterity,
    int? maxDexterityBonus,
  }) {
    return CharacterInventoryEntryOverrides(
      label: label ?? this.label,
      damageDice: damageDice ?? this.damageDice,
      damageType: damageType ?? this.damageType,
      attackAbility: attackAbility ?? this.attackAbility,
      enhancementBonus: enhancementBonus ?? this.enhancementBonus,
      finesse: finesse ?? this.finesse,
      weaponCategory: weaponCategory ?? this.weaponCategory,
      armorClass: armorClass ?? this.armorClass,
      armorCategory: armorCategory ?? this.armorCategory,
      usesDexterity: usesDexterity ?? this.usesDexterity,
      maxDexterityBonus: maxDexterityBonus ?? this.maxDexterityBonus,
    );
  }
}

class CharacterInventoryEntry {
  final String id;
  final CharacterEntityRef? reference;
  final String name;
  final String description;
  final int quantity;
  final double weight;
  final bool equipped;
  final bool attuned;
  final String notes;
  final CharacterInventoryKind kind;
  final CharacterInventoryEntryOverrides overrides;

  const CharacterInventoryEntry({
    required this.id,
    this.reference,
    required this.name,
    this.description = '',
    this.quantity = 1,
    this.weight = 0,
    this.equipped = false,
    this.attuned = false,
    this.notes = '',
    this.kind = CharacterInventoryKind.other,
    this.overrides = const CharacterInventoryEntryOverrides(),
  });

  String get displayName => overrides.label?.trim().isNotEmpty == true
      ? overrides.label!.trim()
      : name;

  factory CharacterInventoryEntry.fromJson(Map<String, dynamic> json) {
    final kindName =
        json['kind']?.toString() ?? CharacterInventoryKind.other.name;
    CharacterInventoryKind? kind;
    for (final candidate in CharacterInventoryKind.values) {
      if (candidate.name.toLowerCase() == kindName.toLowerCase()) {
        kind = candidate;
        break;
      }
    }
    if (kind == null) {
      throw StateError(
        'Unsupported equipment kind "$kindName" for "equipment.entries.kind".',
      );
    }
    return CharacterInventoryEntry(
      id: json['id']?.toString() ?? '',
      reference: _refFromDynamic(json['reference']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      quantity: _jsonInt(
        json['quantity'],
        defaultValue: 1,
        field: 'equipment.entries.quantity',
      ),
      weight: _jsonDouble(
        json['weight'],
        defaultValue: 0,
        field: 'equipment.entries.weight',
      ),
      equipped: _jsonBool(
        json['equipped'],
        defaultValue: false,
        field: 'equipment.entries.equipped',
      ),
      attuned: _jsonBool(
        json['attuned'],
        defaultValue: false,
        field: 'equipment.entries.attuned',
      ),
      notes: json['notes']?.toString() ?? '',
      kind: kind,
      overrides: CharacterInventoryEntryOverrides.fromJson(
        _jsonMap(json['overrides']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (reference != null) 'reference': reference!.toJson(),
      'name': name,
      'description': description,
      'quantity': quantity,
      'weight': weight,
      'equipped': equipped,
      'attuned': attuned,
      'notes': notes,
      'kind': kind.name,
      if (!overrides.isEmpty) 'overrides': overrides.toJson(),
    };
  }

  CharacterInventoryEntry copyWith({
    String? id,
    CharacterEntityRef? reference,
    bool clearReference = false,
    String? name,
    String? description,
    int? quantity,
    double? weight,
    bool? equipped,
    bool? attuned,
    String? notes,
    CharacterInventoryKind? kind,
    CharacterInventoryEntryOverrides? overrides,
  }) {
    return CharacterInventoryEntry(
      id: id ?? this.id,
      reference: clearReference ? null : reference ?? this.reference,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      equipped: equipped ?? this.equipped,
      attuned: attuned ?? this.attuned,
      notes: notes ?? this.notes,
      kind: kind ?? this.kind,
      overrides: overrides ?? this.overrides,
    );
  }
}

class EquipmentLoadout {
  final String? armorEntryId;
  final String? meleeEntryId;
  final String? rangedEntryId;

  const EquipmentLoadout({
    this.armorEntryId,
    this.meleeEntryId,
    this.rangedEntryId,
  });

  factory EquipmentLoadout.fromJson(Map<String, dynamic> json) {
    return EquipmentLoadout(
      armorEntryId: json['armorEntryId']?.toString(),
      meleeEntryId: json['meleeEntryId']?.toString(),
      rangedEntryId: json['rangedEntryId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (armorEntryId != null) 'armorEntryId': armorEntryId,
      if (meleeEntryId != null) 'meleeEntryId': meleeEntryId,
      if (rangedEntryId != null) 'rangedEntryId': rangedEntryId,
    };
  }

  EquipmentLoadout copyWith({
    String? armorEntryId,
    bool clearArmorEntry = false,
    String? meleeEntryId,
    bool clearMeleeEntry = false,
    String? rangedEntryId,
    bool clearRangedEntry = false,
  }) {
    return EquipmentLoadout(
      armorEntryId: clearArmorEntry ? null : armorEntryId ?? this.armorEntryId,
      meleeEntryId: clearMeleeEntry ? null : meleeEntryId ?? this.meleeEntryId,
      rangedEntryId: clearRangedEntry
          ? null
          : rangedEntryId ?? this.rangedEntryId,
    );
  }
}

class Equipment {
  final List<CharacterInventoryEntry> entries;
  final EquipmentLoadout loadout;
  final double totalWeight;

  const Equipment({
    this.entries = const [],
    this.loadout = const EquipmentLoadout(),
    this.totalWeight = 0,
  });

  double get effectiveTotalWeight => totalWeight > 0
      ? totalWeight
      : entries.fold<double>(
          0,
          (sum, entry) => sum + (entry.weight * entry.quantity),
        );

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      entries: _jsonListOfMaps(
        json['entries'],
      ).map(CharacterInventoryEntry.fromJson).toList(growable: false),
      loadout: EquipmentLoadout.fromJson(_jsonMap(json['loadout'])),
      totalWeight: _jsonDouble(
        json['totalWeight'],
        defaultValue: 0,
        field: 'equipment.totalWeight',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entries': entries.map((entry) => entry.toJson()).toList(growable: false),
      'loadout': loadout.toJson(),
      'totalWeight': effectiveTotalWeight,
    };
  }

  Equipment copyWith({
    List<CharacterInventoryEntry>? entries,
    EquipmentLoadout? loadout,
    double? totalWeight,
  }) {
    return Equipment(
      entries: entries ?? List<CharacterInventoryEntry>.from(this.entries),
      loadout: loadout ?? this.loadout,
      totalWeight: totalWeight ?? this.totalWeight,
    );
  }
}

class Wealth {
  final int copper;
  final int silver;
  final int electrum;
  final int gold;
  final int platinum;

  const Wealth({
    this.copper = 0,
    this.silver = 0,
    this.electrum = 0,
    this.gold = 0,
    this.platinum = 0,
  });

  factory Wealth.fromJson(Map<String, dynamic> json) {
    return Wealth(
      copper: _jsonInt(json['copper'], defaultValue: 0, field: 'wealth.copper'),
      silver: _jsonInt(json['silver'], defaultValue: 0, field: 'wealth.silver'),
      electrum: _jsonInt(
        json['electrum'],
        defaultValue: 0,
        field: 'wealth.electrum',
      ),
      gold: _jsonInt(json['gold'], defaultValue: 0, field: 'wealth.gold'),
      platinum: _jsonInt(
        json['platinum'],
        defaultValue: 0,
        field: 'wealth.platinum',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'copper': copper,
      'silver': silver,
      'electrum': electrum,
      'gold': gold,
      'platinum': platinum,
    };
  }
}

class SpellcastingInfo {
  final String? spellcastingAbility;
  final int spellSaveDC;
  final int spellAttackBonus;
  final List<SpellSlot> spellSlots;
  final List<Spell> preparedSpells;
  final List<Spell> knownSpells;

  const SpellcastingInfo({
    this.spellcastingAbility,
    required this.spellSaveDC,
    required this.spellAttackBonus,
    this.spellSlots = const [],
    this.preparedSpells = const [],
    this.knownSpells = const [],
  });

  Iterable<Spell> get allSpells sync* {
    yield* preparedSpells;
    yield* knownSpells.where(
      (spell) => !preparedSpells.any((prepared) => prepared.id == spell.id),
    );
  }

  SpellcastingInfo copyWith({
    String? spellcastingAbility,
    int? spellSaveDC,
    int? spellAttackBonus,
    List<SpellSlot>? spellSlots,
    List<Spell>? preparedSpells,
    List<Spell>? knownSpells,
  }) {
    return SpellcastingInfo(
      spellcastingAbility: spellcastingAbility ?? this.spellcastingAbility,
      spellSaveDC: spellSaveDC ?? this.spellSaveDC,
      spellAttackBonus: spellAttackBonus ?? this.spellAttackBonus,
      spellSlots: spellSlots ?? List.from(this.spellSlots),
      preparedSpells: preparedSpells ?? List.from(this.preparedSpells),
      knownSpells: knownSpells ?? List.from(this.knownSpells),
    );
  }

  factory SpellcastingInfo.fromJson(Map<String, dynamic> json) {
    return SpellcastingInfo(
      spellcastingAbility: json['spellcastingAbility'] as String?,
      spellSaveDC: _jsonInt(
        json['spellSaveDC'],
        defaultValue: 8,
        field: 'spellcasting.spellSaveDC',
      ),
      spellAttackBonus: _jsonInt(
        json['spellAttackBonus'],
        defaultValue: 0,
        field: 'spellcasting.spellAttackBonus',
      ),
      spellSlots: _jsonListOfMaps(
        json['spellSlots'],
      ).map(SpellSlot.fromJson).toList(growable: false),
      preparedSpells: _jsonListOfMaps(
        json['preparedSpells'],
      ).map(Spell.fromJson).toList(growable: false),
      knownSpells: _jsonListOfMaps(
        json['knownSpells'],
      ).map(Spell.fromJson).toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (spellcastingAbility != null)
        'spellcastingAbility': spellcastingAbility,
      'spellSaveDC': spellSaveDC,
      'spellAttackBonus': spellAttackBonus,
      'spellSlots': spellSlots.map((e) => e.toJson()).toList(),
      'preparedSpells': preparedSpells.map((e) => e.toJson()).toList(),
      'knownSpells': knownSpells.map((e) => e.toJson()).toList(),
    };
  }
}

class SpellSlot {
  final int level;
  final int total;
  final int used;

  const SpellSlot({required this.level, required this.total, this.used = 0});

  int get remaining => total - used;

  factory SpellSlot.fromJson(Map<String, dynamic> json) {
    return SpellSlot(
      level: _jsonInt(
        json['level'],
        defaultValue: 0,
        field: 'spellcasting.spellSlots.level',
      ),
      total: _jsonInt(
        json['total'],
        defaultValue: 0,
        field: 'spellcasting.spellSlots.total',
      ),
      used: _jsonInt(
        json['used'],
        defaultValue: 0,
        field: 'spellcasting.spellSlots.used',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'level': level, 'total': total, 'used': used};
  }
}

class Spell {
  final String id;
  final String name;
  final int level;
  final String school;
  final bool isPrepared;
  final bool isRitual;
  final bool isConcentration;
  final CharacterEntityRef? reference;

  const Spell({
    required this.id,
    required this.name,
    required this.level,
    this.school = '',
    this.isPrepared = false,
    this.isRitual = false,
    this.isConcentration = false,
    this.reference,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      level: _jsonInt(json['level'], defaultValue: 0, field: 'spell.level'),
      school: json['school'] as String? ?? '',
      isPrepared: _jsonBool(
        json['isPrepared'],
        defaultValue: false,
        field: 'spell.isPrepared',
      ),
      isRitual: _jsonBool(
        json['isRitual'],
        defaultValue: false,
        field: 'spell.isRitual',
      ),
      isConcentration: _jsonBool(
        json['isConcentration'],
        defaultValue: false,
        field: 'spell.isConcentration',
      ),
      reference: _refFromDynamic(json['reference']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'school': school,
      'isPrepared': isPrepared,
      'isRitual': isRitual,
      'isConcentration': isConcentration,
      if (reference != null) 'reference': reference!.toJson(),
    };
  }

  Spell copyWith({
    String? id,
    String? name,
    int? level,
    String? school,
    bool? isPrepared,
    bool? isRitual,
    bool? isConcentration,
    CharacterEntityRef? reference,
    bool clearReference = false,
  }) {
    return Spell(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      school: school ?? this.school,
      isPrepared: isPrepared ?? this.isPrepared,
      isRitual: isRitual ?? this.isRitual,
      isConcentration: isConcentration ?? this.isConcentration,
      reference: clearReference ? null : reference ?? this.reference,
    );
  }
}

class Traits {
  final String personalityTraits;
  final String ideals;
  final String bonds;
  final String flaws;
  final List<String> alliesAndOrganizations;

  const Traits({
    this.personalityTraits = '',
    this.ideals = '',
    this.bonds = '',
    this.flaws = '',
    this.alliesAndOrganizations = const [],
  });

  factory Traits.fromJson(Map<String, dynamic> json) {
    return Traits(
      personalityTraits: json['personalityTraits'] as String? ?? '',
      ideals: json['ideals'] as String? ?? '',
      bonds: json['bonds'] as String? ?? '',
      flaws: json['flaws'] as String? ?? '',
      alliesAndOrganizations: _stringListFromDynamic(
        json['alliesAndOrganizations'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalityTraits': personalityTraits,
      'ideals': ideals,
      'bonds': bonds,
      'flaws': flaws,
      'alliesAndOrganizations': alliesAndOrganizations,
    };
  }
}

class Feature {
  final String id;
  final String name;
  final String description;
  final int levelObtained;
  final String source;
  final CharacterEntityRef? reference;
  final dynamic content;

  const Feature({
    required this.id,
    required this.name,
    required this.description,
    this.levelObtained = 1,
    this.source = 'class',
    this.reference,
    this.content,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description'] as String? ?? '',
      levelObtained: _jsonInt(
        json['levelObtained'],
        defaultValue: 1,
        field: 'feature.levelObtained',
      ),
      source: json['source'] as String? ?? 'class',
      reference: _refFromDynamic(json['reference']),
      content: json.containsKey('content')
          ? CompendiumJsonUtils.deepCopy(json['content'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'levelObtained': levelObtained,
      'source': source,
      if (reference != null) 'reference': reference!.toJson(),
      if (content != null) 'content': CompendiumJsonUtils.deepCopy(content),
    };
  }

  Feature copyWith({
    String? id,
    String? name,
    String? description,
    int? levelObtained,
    String? source,
    CharacterEntityRef? reference,
    bool clearReference = false,
    dynamic content,
    bool clearContent = false,
  }) {
    return Feature(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      levelObtained: levelObtained ?? this.levelObtained,
      source: source ?? this.source,
      reference: clearReference ? null : reference ?? this.reference,
      content: clearContent ? null : content ?? this.content,
    );
  }
}

class PhysicalDescription {
  final int age;
  final String height;
  final String weight;
  final String eyes;
  final String skin;
  final String hair;
  final String deity;
  final CharacterEntityRef? deityRef;

  const PhysicalDescription({
    this.age = 0,
    this.height = '',
    this.weight = '',
    this.eyes = '',
    this.skin = '',
    this.hair = '',
    this.deity = '',
    this.deityRef,
  });

  factory PhysicalDescription.fromJson(Map<String, dynamic> json) {
    return PhysicalDescription(
      age: _jsonInt(
        json['age'],
        defaultValue: 0,
        field: 'physicalDescription.age',
      ),
      height: json['height'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      eyes: json['eyes'] as String? ?? '',
      skin: json['skin'] as String? ?? '',
      hair: json['hair'] as String? ?? '',
      deity: json['deity'] as String? ?? '',
      deityRef: _refFromDynamic(json['deityRef']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'height': height,
      'weight': weight,
      'eyes': eyes,
      'skin': skin,
      'hair': hair,
      'deity': deity,
      if (deityRef != null) 'deityRef': deityRef!.toJson(),
    };
  }

  PhysicalDescription copyWith({
    int? age,
    String? height,
    String? weight,
    String? eyes,
    String? skin,
    String? hair,
    String? deity,
    CharacterEntityRef? deityRef,
    bool clearDeityRef = false,
  }) {
    return PhysicalDescription(
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      eyes: eyes ?? this.eyes,
      skin: skin ?? this.skin,
      hair: hair ?? this.hair,
      deity: deity ?? this.deity,
      deityRef: clearDeityRef ? null : deityRef ?? this.deityRef,
    );
  }
}

class Notes {
  final String backstory;
  final String appearance;
  final String inventoryNotes;
  final String languagesNotes;
  final String otherNotes;

  const Notes({
    this.backstory = '',
    this.appearance = '',
    this.inventoryNotes = '',
    this.languagesNotes = '',
    this.otherNotes = '',
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      backstory: json['backstory'] as String? ?? '',
      appearance: json['appearance'] as String? ?? '',
      inventoryNotes: json['inventoryNotes'] as String? ?? '',
      languagesNotes: json['languagesNotes'] as String? ?? '',
      otherNotes: json['otherNotes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backstory': backstory,
      'appearance': appearance,
      'inventoryNotes': inventoryNotes,
      'languagesNotes': languagesNotes,
      'otherNotes': otherNotes,
    };
  }
}

extension SpellcastingAbilityExtension on String {
  int getModifier(CalculatedModifiers modifiers) {
    return modifiers.modifierFor(this);
  }
}
