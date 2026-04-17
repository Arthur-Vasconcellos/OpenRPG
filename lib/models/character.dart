import 'package:openrpg/compendium/models/compendium_entity.dart';

import 'enums.dart';

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
  static const String jsonSchemaVersion = '2.0.0';

  final String id;
  final String name;
  final String playerName;
  final String primaryRulesetId;
  final List<CharacterClassLevel> classes;
  final CharacterEntityRef? raceRef;
  final CharacterEntityRef? backgroundRef;
  final Race _legacyRace;
  final Background _legacyBackground;
  final MoralAlignment moralAlignment;
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

  final DateTime createdAt;
  final DateTime updatedAt;

  final EquippedCombatStats equippedCombatStats;

  int get totalLevel => classes.fold(0, (sum, cls) => sum + cls.level);
  Race get race => _legacyRace;
  Background get background => _legacyBackground;

  CharacterClass get primaryClass =>
      classes.isNotEmpty ? classes.first.characterClass : CharacterClass.custom;

  Subclass get primarySubclass =>
      classes.isNotEmpty ? classes.first.subclass : Subclass.none;

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
    CharacterEntityRef? raceRef,
    Race race = Race.custom,
    CharacterEntityRef? backgroundRef,
    Background background = Background.custom,
    required this.moralAlignment,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.equippedCombatStats,
  }) : raceRef = raceRef ?? _legacyRaceRef(race, primaryRulesetId),
       backgroundRef =
           backgroundRef ?? _legacyBackgroundRef(background, primaryRulesetId),
       _legacyRace = _resolveLegacyRace(raceRef, race),
       _legacyBackground = _resolveLegacyBackground(backgroundRef, background),
       createdAt = createdAt ?? DateTime.now().toUtc(),
       updatedAt = updatedAt ?? DateTime.now().toUtc();

  factory Character.createBlank({
    required String id,
    required String name,
    required String primaryRulesetId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final abilityScores = const AbilityScores(
      strength: 10,
      dexterity: 10,
      constitution: 10,
      intelligence: 10,
      wisdom: 10,
      charisma: 10,
    );
    final now = (updatedAt ?? DateTime.now().toUtc()).toUtc();
    return Character(
      id: id,
      name: name,
      primaryRulesetId: primaryRulesetId,
      classes: const [],
      moralAlignment: MoralAlignment.neutral,
      abilityScores: abilityScores,
      modifiers: const CalculatedModifiers(
        strength: 0,
        dexterity: 0,
        constitution: 0,
        intelligence: 0,
        wisdom: 0,
        charisma: 0,
      ),
      proficiencies: const ProficiencySet(
        proficiencyBonus: 2,
        skills: SkillProficiencies(proficiencies: {}),
        savingThrows: SavingThrowProficiencies(),
      ),
      combatStats: const CombatStats(
        armorClass: 10,
        initiative: 0,
        speed: 30,
        proficiencyBonus: 2,
        passivePerception: 10,
        passiveInsight: 10,
        passiveInvestigation: 10,
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
      equippedCombatStats: const EquippedCombatStats(
        equippedArmor: EquippedArmor(
          armorType: 'cloth',
          baseAC: 10,
          manualBonus: 0,
          usesDexterity: true,
          maxDexBonus: 999,
        ),
      ),
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
    final primaryRulesetId =
        json['primaryRulesetId']?.toString() ??
        _detectPrimaryRulesetIdFromLegacyPayload(json);
    final parsedRaceRef =
        _refFromDynamic(json['raceRef']) ??
        _legacyRaceRef(
          json['race'] == null
              ? Race.custom
              : EnumParser.race(json['race'] as String),
          primaryRulesetId,
        );
    final parsedBackgroundRef =
        _refFromDynamic(json['backgroundRef']) ??
        _legacyBackgroundRef(
          json['background'] == null
              ? Background.custom
              : EnumParser.background(json['background'] as String),
          primaryRulesetId,
        );

    final List<CharacterClassLevel> classes;
    if (json['classes'] is List) {
      classes = (json['classes'] as List)
          .whereType<Map>()
          .map(
            (entry) => CharacterClassLevel.fromJson(
              entry.cast<String, dynamic>(),
              fallbackRulesetId: primaryRulesetId,
            ),
          )
          .toList(growable: false);
    } else if (json['characterClass'] != null) {
      classes = [
        CharacterClassLevel.fromJson(<String, dynamic>{
          'characterClass': json['characterClass'],
          'subclass': json['subclass'],
          'level': json['level'],
        }, fallbackRulesetId: primaryRulesetId),
      ];
    } else {
      classes = const [];
    }

    return Character(
      id:
          json['id']?.toString() ??
          'character:${DateTime.now().microsecondsSinceEpoch}',
      name: json['name']?.toString() ?? 'Unnamed Character',
      playerName: json['playerName']?.toString() ?? '',
      primaryRulesetId: primaryRulesetId,
      classes: classes,
      raceRef: parsedRaceRef,
      race: json['race'] == null
          ? _resolveLegacyRace(parsedRaceRef, Race.custom)
          : EnumParser.race(json['race'] as String),
      backgroundRef: parsedBackgroundRef,
      background: json['background'] == null
          ? _resolveLegacyBackground(parsedBackgroundRef, Background.custom)
          : EnumParser.background(json['background'] as String),
      moralAlignment: EnumParser.moralAlignment(
        json['moralAlignment']?.toString() ?? MoralAlignment.neutral.value,
      ),
      experiencePoints: json['experiencePoints'] as int? ?? 0,
      inspiration: json['inspiration'] as int? ?? 0,
      abilityScores: AbilityScores.fromJson(
        (json['abilityScores'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{
              'strength': 10,
              'dexterity': 10,
              'constitution': 10,
              'intelligence': 10,
              'wisdom': 10,
              'charisma': 10,
            },
      ),
      modifiers: CalculatedModifiers.fromJson(
        (json['modifiers'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{
              'strength': 0,
              'dexterity': 0,
              'constitution': 0,
              'intelligence': 0,
              'wisdom': 0,
              'charisma': 0,
            },
      ),
      proficiencies: ProficiencySet.fromJson(
        (json['proficiencies'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{
              'proficiencyBonus': 2,
              'skills': <String, dynamic>{},
              'savingThrows': <String, dynamic>{},
            },
      ),
      combatStats: CombatStats.fromJson(
        (json['combatStats'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{
              'armorClass': 10,
              'initiative': 0,
              'speed': 30,
              'proficiencyBonus': 2,
              'passivePerception': 10,
              'passiveInsight': 10,
              'passiveInvestigation': 10,
            },
      ),
      health: Health.fromJson(
        (json['health'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{
              'maxHitPoints': 1,
              'currentHitPoints': 1,
              'hitDice': <dynamic>[],
              'deathSaves': <String, dynamic>{'successes': 0, 'failures': 0},
            },
      ),
      equipment: Equipment.fromJson(
        (json['equipment'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      wealth: Wealth.fromJson(
        (json['wealth'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      spellcasting: json['spellcasting'] is Map<String, dynamic>
          ? SpellcastingInfo.fromJson(
              json['spellcasting'] as Map<String, dynamic>,
            )
          : json['spellcasting'] is Map
          ? SpellcastingInfo.fromJson(
              (json['spellcasting'] as Map).cast<String, dynamic>(),
            )
          : null,
      traits: Traits.fromJson(
        (json['traits'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      features: _featureListFromDynamic(json['features']),
      racialTraits: _featureListFromDynamic(json['racialTraits']),
      backgroundTraits: _featureListFromDynamic(json['backgroundTraits']),
      physicalDescription: PhysicalDescription.fromJson(
        (json['physicalDescription'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      notes: Notes.fromJson(
        (json['notes'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      createdAt: json['createdAt'] == null
          ? DateTime.now().toUtc()
          : DateTime.parse(json['createdAt'] as String).toUtc(),
      updatedAt: json['updatedAt'] == null
          ? DateTime.now().toUtc()
          : DateTime.parse(json['updatedAt'] as String).toUtc(),
      equippedCombatStats: EquippedCombatStats.fromJson(
        (json['equippedCombatStats'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{
              'equippedArmor': <String, dynamic>{
                'armorType': 'cloth',
                'baseAC': 10,
                'manualBonus': 0,
                'usesDexterity': true,
                'maxDexBonus': 999,
              },
            },
      ),
    ).copyWithCalculatedValues();
  }

  Character copyWithPartial({
    CombatStats? combatStats,
    Health? health,
    Equipment? equipment,
    ProficiencySet? proficiencies,
    EquippedCombatStats? equippedCombatStats,
  }) {
    return Character(
      id: id,
      name: name,
      playerName: playerName,
      primaryRulesetId: primaryRulesetId,
      classes: classes,
      raceRef: raceRef,
      race: race,
      backgroundRef: backgroundRef,
      background: background,
      moralAlignment: moralAlignment,
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
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
      equippedCombatStats: equippedCombatStats ?? this.equippedCombatStats,
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
      'moralAlignment': moralAlignment.value,
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
      'features': features.map((e) => e.toJson()).toList(growable: false),
      'racialTraits': racialTraits
          .map((e) => e.toJson())
          .toList(growable: false),
      'backgroundTraits': backgroundTraits
          .map((e) => e.toJson())
          .toList(growable: false),
      'physicalDescription': physicalDescription.toJson(),
      'notes': notes.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'equippedCombatStats': equippedCombatStats.toJson(),
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
    Race? race,
    CharacterEntityRef? backgroundRef,
    bool clearBackgroundRef = false,
    Background? background,
    MoralAlignment? moralAlignment,
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
    EquippedCombatStats? equippedCombatStats,
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
      race: race ?? this.race,
      backgroundRef: clearBackgroundRef
          ? null
          : backgroundRef ?? this.backgroundRef,
      background: background ?? this.background,
      moralAlignment: moralAlignment ?? this.moralAlignment,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
      equippedCombatStats: equippedCombatStats ?? this.equippedCombatStats,
    ).copyWithCalculatedValues();
  }

  Character copyWithCalculatedValues() {
    final totalLevel = this.totalLevel;
    final calculatedModifiers = _calculateModifiers(abilityScores);
    final proficiencyBonus = _calculateProficiencyBonus(totalLevel);
    final updatedCombatStats = combatStats.copyWith(
      proficiencyBonus: proficiencyBonus,
      initiative: calculatedModifiers.dexterity,
      passivePerception:
          10 +
          proficiencies.skills.getModifier(
            Skill.perception,
            calculatedModifiers,
            proficiencyBonus,
          ),
      passiveInsight:
          10 +
          proficiencies.skills.getModifier(
            Skill.insight,
            calculatedModifiers,
            proficiencyBonus,
          ),
      passiveInvestigation:
          10 +
          proficiencies.skills.getModifier(
            Skill.investigation,
            calculatedModifiers,
            proficiencyBonus,
          ),
    );

    return Character(
      id: id,
      name: name,
      playerName: playerName,
      primaryRulesetId: primaryRulesetId,
      classes: classes,
      raceRef: raceRef,
      race: race,
      backgroundRef: backgroundRef,
      background: background,
      moralAlignment: moralAlignment,
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
      createdAt: createdAt,
      updatedAt: updatedAt,
      equippedCombatStats: equippedCombatStats,
    );
  }

  CalculatedModifiers _calculateModifiers(AbilityScores scores) {
    return CalculatedModifiers(
      strength: ((scores.strength - 10) / 2).floor(),
      dexterity: ((scores.dexterity - 10) / 2).floor(),
      constitution: ((scores.constitution - 10) / 2).floor(),
      intelligence: ((scores.intelligence - 10) / 2).floor(),
      wisdom: ((scores.wisdom - 10) / 2).floor(),
      charisma: ((scores.charisma - 10) / 2).floor(),
    );
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
  final CharacterClass _legacyCharacterClass;
  final Subclass _legacySubclass;
  final int level;

  CharacterClass get characterClass => _legacyCharacterClass;
  Subclass get subclass => _legacySubclass;
  String get className => classRef?.displayName ?? characterClass.displayName;
  String? get subclassName =>
      subclassRef?.displayName ??
      (subclass == Subclass.none ? null : subclass.displayName);

  CharacterClassLevel({
    this.classRef,
    this.subclassRef,
    CharacterClass? characterClass,
    Subclass? subclass,
    required this.level,
    String rulesetId = '',
  }) : _legacyCharacterClass = _resolveLegacyCharacterClass(
         classRef,
         characterClass ?? CharacterClass.custom,
       ),
       _legacySubclass = _resolveLegacySubclass(
         subclassRef,
         subclass ?? Subclass.none,
       );

  factory CharacterClassLevel.fromJson(
    Map<String, dynamic> json, {
    String fallbackRulesetId = '',
  }) {
    final parsedClassRef =
        _refFromDynamic(json['classRef']) ??
        _legacyClassRef(
          json['characterClass'] == null
              ? CharacterClass.custom
              : EnumParser.characterClass(json['characterClass'] as String),
          fallbackRulesetId,
        );
    final parsedSubclassRef = _refFromDynamic(json['subclassRef']);
    return CharacterClassLevel(
      classRef: parsedClassRef,
      subclassRef: parsedSubclassRef,
      characterClass: json['characterClass'] == null
          ? _resolveLegacyCharacterClass(parsedClassRef, CharacterClass.custom)
          : EnumParser.characterClass(json['characterClass'] as String),
      subclass: json['subclass'] == null
          ? _resolveLegacySubclass(parsedSubclassRef, Subclass.none)
          : EnumParser.subclass(json['subclass'] as String),
      level: json['level'] as int? ?? 1,
      rulesetId: fallbackRulesetId,
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
    CharacterClass? characterClass,
    Subclass? subclass,
    int? level,
    String rulesetId = '',
  }) {
    return CharacterClassLevel(
      classRef: clearClassRef ? null : classRef ?? this.classRef,
      subclassRef: clearSubclassRef ? null : subclassRef ?? this.subclassRef,
      characterClass: characterClass ?? this.characterClass,
      subclass: subclass ?? this.subclass,
      level: level ?? this.level,
      rulesetId: rulesetId,
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

String _detectPrimaryRulesetIdFromLegacyPayload(Map<String, dynamic> json) {
  final classes = json['classes'];
  if (classes is List) {
    for (final entry in classes.whereType<Map>()) {
      final classRef = _refFromDynamic(entry['classRef']);
      if (classRef != null && classRef.rulesetId.trim().isNotEmpty) {
        return classRef.rulesetId;
      }
    }
  }

  for (final key in ['raceRef', 'backgroundRef']) {
    final ref = _refFromDynamic(json[key]);
    if (ref != null && ref.rulesetId.trim().isNotEmpty) {
      return ref.rulesetId;
    }
  }

  return '';
}

CharacterEntityRef? _legacyRaceRef(Race race, String rulesetId) {
  if (race == Race.custom) {
    return null;
  }

  final name = race.displayName;
  return CharacterEntityRef(
    entityType: 'race',
    entityId: CompendiumJsonUtils.stableEntityId(
      entityType: 'race',
      payload: <String, dynamic>{
        'name': name,
        'data': <String, dynamic>{'name': name},
      },
    ),
    rulesetId: rulesetId,
    name: name,
  );
}

CharacterEntityRef? _legacyBackgroundRef(
  Background background,
  String rulesetId,
) {
  if (background == Background.custom) {
    return null;
  }

  final name = background.displayName;
  return CharacterEntityRef(
    entityType: 'background',
    entityId: CompendiumJsonUtils.stableEntityId(
      entityType: 'background',
      payload: <String, dynamic>{
        'name': name,
        'data': <String, dynamic>{'name': name},
      },
    ),
    rulesetId: rulesetId,
    name: name,
  );
}

CharacterEntityRef? _legacyClassRef(
  CharacterClass characterClass,
  String rulesetId,
) {
  if (characterClass == CharacterClass.custom) {
    return null;
  }

  final name = characterClass.displayName;
  return CharacterEntityRef(
    entityType: 'class',
    entityId: CompendiumJsonUtils.stableEntityId(
      entityType: 'class',
      payload: <String, dynamic>{
        'name': name,
        'data': <String, dynamic>{'name': name},
      },
    ),
    rulesetId: rulesetId,
    name: name,
  );
}

Race _resolveLegacyRace(CharacterEntityRef? ref, Race fallback) {
  final matched = _matchEnumByName<Race>(
    Race.values,
    ref?.displayName ?? '',
    (value) => value.displayName,
    (value) => value.value,
  );
  return matched ?? fallback;
}

Background _resolveLegacyBackground(
  CharacterEntityRef? ref,
  Background fallback,
) {
  final matched = _matchEnumByName<Background>(
    Background.values,
    ref?.displayName ?? '',
    (value) => value.displayName,
    (value) => value.value,
  );
  return matched ?? fallback;
}

CharacterClass _resolveLegacyCharacterClass(
  CharacterEntityRef? ref,
  CharacterClass fallback,
) {
  final matched = _matchEnumByName<CharacterClass>(
    CharacterClass.values,
    ref?.displayName ?? '',
    (value) => value.displayName,
    (value) => value.value,
  );
  return matched ?? fallback;
}

Subclass _resolveLegacySubclass(CharacterEntityRef? ref, Subclass fallback) {
  final matched = _matchEnumByName<Subclass>(
    Subclass.values,
    ref?.displayName ?? '',
    (value) => value.displayName,
    (value) => value.value,
  );
  return matched ?? fallback;
}

T? _matchEnumByName<T>(
  List<T> values,
  String raw,
  String Function(T value) displayName,
  String Function(T value) rawValue,
) {
  final normalized = _normalizeLookupValue(raw);
  if (normalized.isEmpty) {
    return null;
  }

  for (final value in values) {
    final display = _normalizeLookupValue(displayName(value));
    final canonical = _normalizeLookupValue(rawValue(value));
    if (display == normalized || canonical == normalized) {
      return value;
    }
  }
  return null;
}

String _normalizeLookupValue(String value) {
  return CompendiumJsonUtils.slugify(
    value
        .replaceAll('&', 'and')
        .replaceAll("'", '')
        .replaceAll('-', ' ')
        .replaceAll('/', ' '),
  );
}

class AbilityScores {
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  const AbilityScores({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });

  factory AbilityScores.fromJson(Map<String, dynamic> json) {
    return AbilityScores(
      strength: json['strength'] as int,
      dexterity: json['dexterity'] as int,
      constitution: json['constitution'] as int,
      intelligence: json['intelligence'] as int,
      wisdom: json['wisdom'] as int,
      charisma: json['charisma'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strength': strength,
      'dexterity': dexterity,
      'constitution': constitution,
      'intelligence': intelligence,
      'wisdom': wisdom,
      'charisma': charisma,
    };
  }

  AbilityScores copyWith({
    int? strength,
    int? dexterity,
    int? constitution,
    int? intelligence,
    int? wisdom,
    int? charisma,
  }) {
    return AbilityScores(
      strength: strength ?? this.strength,
      dexterity: dexterity ?? this.dexterity,
      constitution: constitution ?? this.constitution,
      intelligence: intelligence ?? this.intelligence,
      wisdom: wisdom ?? this.wisdom,
      charisma: charisma ?? this.charisma,
    );
  }
}

class CalculatedModifiers {
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  const CalculatedModifiers({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });

  factory CalculatedModifiers.fromJson(Map<String, dynamic> json) {
    return CalculatedModifiers(
      strength: json['strength'] as int,
      dexterity: json['dexterity'] as int,
      constitution: json['constitution'] as int,
      intelligence: json['intelligence'] as int,
      wisdom: json['wisdom'] as int,
      charisma: json['charisma'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strength': strength,
      'dexterity': dexterity,
      'constitution': constitution,
      'intelligence': intelligence,
      'wisdom': wisdom,
      'charisma': charisma,
    };
  }

  CalculatedModifiers copyWith({
    int? strength,
    int? dexterity,
    int? constitution,
    int? intelligence,
    int? wisdom,
    int? charisma,
  }) {
    return CalculatedModifiers(
      strength: strength ?? this.strength,
      dexterity: dexterity ?? this.dexterity,
      constitution: constitution ?? this.constitution,
      intelligence: intelligence ?? this.intelligence,
      wisdom: wisdom ?? this.wisdom,
      charisma: charisma ?? this.charisma,
    );
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
      proficiencyBonus: json['proficiencyBonus'] as int,
      skills: SkillProficiencies.fromJson(
        json['skills'] as Map<String, dynamic>,
      ),
      savingThrows: SavingThrowProficiencies.fromJson(
        json['savingThrows'] as Map<String, dynamic>,
      ),
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : [],
      tools: json['tools'] != null ? List<String>.from(json['tools']) : [],
      weapons: json['weapons'] != null
          ? List<String>.from(json['weapons'])
          : [],
      armor: json['armor'] != null ? List<String>.from(json['armor']) : [],
      other: json['other'] != null ? List<String>.from(json['other']) : [],
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
  final Map<Skill, ProficiencyLevel> proficiencies;

  const SkillProficiencies({required this.proficiencies});

  int getModifier(
    Skill skill,
    CalculatedModifiers modifiers,
    int proficiencyBonus,
  ) {
    final abilityModifier = _getAbilityModifierForSkill(skill, modifiers);
    final proficiency = proficiencies[skill] ?? ProficiencyLevel.none;

    switch (proficiency) {
      case ProficiencyLevel.none:
        return abilityModifier;
      case ProficiencyLevel.proficient:
        return abilityModifier + proficiencyBonus;
      case ProficiencyLevel.expert:
        return abilityModifier + (proficiencyBonus * 2);
      case ProficiencyLevel.jackOfAllTrades:
        return abilityModifier + (proficiencyBonus ~/ 2);
    }
  }

  int _getAbilityModifierForSkill(Skill skill, CalculatedModifiers modifiers) {
    switch (skill) {
      case Skill.acrobatics:
      case Skill.sleightOfHand:
      case Skill.stealth:
        return modifiers.dexterity;
      case Skill.animalHandling:
      case Skill.insight:
      case Skill.medicine:
      case Skill.perception:
      case Skill.survival:
        return modifiers.wisdom;
      case Skill.arcana:
      case Skill.history:
      case Skill.investigation:
      case Skill.nature:
      case Skill.religion:
        return modifiers.intelligence;
      case Skill.deception:
      case Skill.intimidation:
      case Skill.performance:
      case Skill.persuasion:
        return modifiers.charisma;
      case Skill.athletics:
        return modifiers.strength;
    }
  }

  factory SkillProficiencies.fromJson(Map<String, dynamic> json) {
    final map = <Skill, ProficiencyLevel>{};

    if (json['proficiencies'] != null) {
      final proficiencies = json['proficiencies'] as Map<String, dynamic>;
      for (final entry in proficiencies.entries) {
        final skill = EnumParser.skill(entry.key);
        final level = EnumParser.proficiencyLevel(entry.value as String);
        map[skill] = level;
      }
    }

    return SkillProficiencies(proficiencies: map);
  }

  Map<String, dynamic> toJson() {
    final map = <String, String>{};
    for (final entry in proficiencies.entries) {
      map[entry.key.value] = entry.value.value;
    }
    return {'proficiencies': map};
  }

  SkillProficiencies copyWith({Map<Skill, ProficiencyLevel>? proficiencies}) {
    return SkillProficiencies(
      proficiencies: proficiencies ?? Map.from(this.proficiencies),
    );
  }
}

class SavingThrowProficiencies {
  final bool strength;
  final bool dexterity;
  final bool constitution;
  final bool intelligence;
  final bool wisdom;
  final bool charisma;

  const SavingThrowProficiencies({
    this.strength = false,
    this.dexterity = false,
    this.constitution = false,
    this.intelligence = false,
    this.wisdom = false,
    this.charisma = false,
  });

  int getModifier(
    String ability,
    CalculatedModifiers modifiers,
    int proficiencyBonus,
  ) {
    final baseModifier = _getAbilityModifier(ability, modifiers);
    final isProficient = _isProficient(ability);

    return baseModifier + (isProficient ? proficiencyBonus : 0);
  }

  int _getAbilityModifier(String ability, CalculatedModifiers modifiers) {
    switch (ability.toLowerCase()) {
      case 'strength':
        return modifiers.strength;
      case 'dexterity':
        return modifiers.dexterity;
      case 'constitution':
        return modifiers.constitution;
      case 'intelligence':
        return modifiers.intelligence;
      case 'wisdom':
        return modifiers.wisdom;
      case 'charisma':
        return modifiers.charisma;
      default:
        return 0;
    }
  }

  bool _isProficient(String ability) {
    switch (ability.toLowerCase()) {
      case 'strength':
        return strength;
      case 'dexterity':
        return dexterity;
      case 'constitution':
        return constitution;
      case 'intelligence':
        return intelligence;
      case 'wisdom':
        return wisdom;
      case 'charisma':
        return charisma;
      default:
        return false;
    }
  }

  factory SavingThrowProficiencies.fromJson(Map<String, dynamic> json) {
    return SavingThrowProficiencies(
      strength: json['strength'] as bool? ?? false,
      dexterity: json['dexterity'] as bool? ?? false,
      constitution: json['constitution'] as bool? ?? false,
      intelligence: json['intelligence'] as bool? ?? false,
      wisdom: json['wisdom'] as bool? ?? false,
      charisma: json['charisma'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strength': strength,
      'dexterity': dexterity,
      'constitution': constitution,
      'intelligence': intelligence,
      'wisdom': wisdom,
      'charisma': charisma,
    };
  }
}

class CombatStats {
  final int armorClass;
  final int initiative;
  final int speed;
  final int proficiencyBonus;
  final int passivePerception;
  final int passiveInsight;
  final int passiveInvestigation;

  const CombatStats({
    required this.armorClass,
    required this.initiative,
    required this.speed,
    required this.proficiencyBonus,
    required this.passivePerception,
    required this.passiveInsight,
    required this.passiveInvestigation,
  });

  CombatStats copyWith({
    int? armorClass,
    int? initiative,
    int? speed,
    int? proficiencyBonus,
    int? passivePerception,
    int? passiveInsight,
    int? passiveInvestigation,
  }) {
    return CombatStats(
      armorClass: armorClass ?? this.armorClass,
      initiative: initiative ?? this.initiative,
      speed: speed ?? this.speed,
      proficiencyBonus: proficiencyBonus ?? this.proficiencyBonus,
      passivePerception: passivePerception ?? this.passivePerception,
      passiveInsight: passiveInsight ?? this.passiveInsight,
      passiveInvestigation: passiveInvestigation ?? this.passiveInvestigation,
    );
  }

  factory CombatStats.fromJson(Map<String, dynamic> json) {
    return CombatStats(
      armorClass: json['armorClass'] as int,
      initiative: json['initiative'] as int,
      speed: json['speed'] as int,
      proficiencyBonus: json['proficiencyBonus'] as int,
      passivePerception: json['passivePerception'] as int,
      passiveInsight: json['passiveInsight'] as int,
      passiveInvestigation: json['passiveInvestigation'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'armorClass': armorClass,
      'initiative': initiative,
      'speed': speed,
      'proficiencyBonus': proficiencyBonus,
      'passivePerception': passivePerception,
      'passiveInsight': passiveInsight,
      'passiveInvestigation': passiveInvestigation,
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
      maxHitPoints: json['maxHitPoints'] as int,
      currentHitPoints: json['currentHitPoints'] as int,
      temporaryHitPoints: json['temporaryHitPoints'] as int? ?? 0,
      hitDice: json['hitDice'] != null
          ? (json['hitDice'] as List)
                .map((e) => HitDie.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      deathSaves: DeathSaves.fromJson(
        json['deathSaves'] as Map<String, dynamic>,
      ),
      exhaustionLevel: json['exhaustionLevel'] as int? ?? 0,
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
      sides: json['sides'] as int,
      count: json['count'] as int,
      used: json['used'] as int? ?? 0,
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
      successes: json['successes'] as int? ?? 0,
      failures: json['failures'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'successes': successes, 'failures': failures};
  }
}

class Equipment {
  final List<EquipmentItem> inventory;
  final List<Weapon> weapons;
  final List<Armor> armor;
  final double totalWeight;

  const Equipment({
    this.inventory = const [],
    this.weapons = const [],
    this.armor = const [],
    this.totalWeight = 0,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      inventory: json['inventory'] != null
          ? (json['inventory'] as List)
                .map((e) => EquipmentItem.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      weapons: json['weapons'] != null
          ? (json['weapons'] as List)
                .map((e) => Weapon.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      armor: json['armor'] != null
          ? (json['armor'] as List)
                .map((e) => Armor.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      totalWeight: (json['totalWeight'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventory': inventory.map((e) => e.toJson()).toList(),
      'weapons': weapons.map((e) => e.toJson()).toList(),
      'armor': armor.map((e) => e.toJson()).toList(),
      'totalWeight': totalWeight,
    };
  }

  Equipment copyWith({
    List<EquipmentItem>? inventory,
    List<Weapon>? weapons,
    List<Armor>? armor,
    double? totalWeight,
  }) {
    return Equipment(
      inventory: inventory ?? List.from(this.inventory),
      weapons: weapons ?? List.from(this.weapons),
      armor: armor ?? List.from(this.armor),
      totalWeight: totalWeight ?? this.totalWeight,
    );
  }
}

class EquipmentItem {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final double weight;
  final bool isEquipped;

  const EquipmentItem({
    required this.id,
    required this.name,
    this.description = '',
    this.quantity = 1,
    this.weight = 0,
    this.isEquipped = false,
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) {
    return EquipmentItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      isEquipped: json['isEquipped'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'weight': weight,
      'isEquipped': isEquipped,
    };
  }

  EquipmentItem copyWith({
    String? id,
    String? name,
    String? description,
    int? quantity,
    double? weight,
    bool? isEquipped,
  }) {
    return EquipmentItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }
}

class Weapon extends EquipmentItem {
  final String damage;
  final String damageType;
  final String properties;
  final int attackBonus;
  final int damageBonus;
  final bool isProficient;
  final String attackAbility; // New: 'strength', 'dexterity', etc.
  final int enhancementBonus; // New: +1, +2, +3
  final bool isFinesse;
  final String
  weaponType; // 'simple', 'martial', 'firearm', 'natural', 'improvised'
  final String? damageAbility; // Optional: different ability for damage (rare)

  const Weapon({
    required super.id,
    required super.name,
    super.description = '',
    super.quantity = 1,
    super.weight = 0,
    super.isEquipped = false,
    required this.damage,
    required this.damageType,
    this.properties = '',
    this.attackBonus = 0,
    this.damageBonus = 0,
    this.isProficient = true,
    this.attackAbility = 'strength',
    this.enhancementBonus = 0,
    this.isFinesse = false,
    this.weaponType = 'simple',
    this.damageAbility,
  });

  @override
  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      isEquipped: json['isEquipped'] as bool? ?? false,
      damage: json['damage'] as String,
      damageType: json['damageType'] as String,
      properties: json['properties'] as String? ?? '',
      attackBonus: json['attackBonus'] as int? ?? 0,
      damageBonus: json['damageBonus'] as int? ?? 0,
      isProficient: json['isProficient'] as bool? ?? true,
      attackAbility: json['attackAbility'] as String? ?? 'strength',
      enhancementBonus: json['enhancementBonus'] as int? ?? 0,
      isFinesse: json['isFinesse'] as bool? ?? false,
      weaponType: json['weaponType'] as String? ?? 'simple',
      damageAbility: json['damageAbility'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'damage': damage,
      'damageType': damageType,
      'properties': properties,
      'attackBonus': attackBonus,
      'damageBonus': damageBonus,
      'isProficient': isProficient,
      'attackAbility': attackAbility,
      'enhancementBonus': enhancementBonus,
      'isFinesse': isFinesse,
      'weaponType': weaponType,
      if (damageAbility != null) 'damageAbility': damageAbility,
    };
  }

  Weapon copyWith({
    String? id,
    String? name,
    String? description,
    int? quantity,
    double? weight,
    bool? isEquipped,
    String? damage,
    String? damageType,
    String? properties,
    int? attackBonus,
    int? damageBonus,
    bool? isProficient,
    String? attackAbility,
    int? enhancementBonus,
    bool? isFinesse,
    String? weaponType,
    String? damageAbility,
  }) {
    return Weapon(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      isEquipped: isEquipped ?? this.isEquipped,
      damage: damage ?? this.damage,
      damageType: damageType ?? this.damageType,
      properties: properties ?? this.properties,
      attackBonus: attackBonus ?? this.attackBonus,
      damageBonus: damageBonus ?? this.damageBonus,
      isProficient: isProficient ?? this.isProficient,
      attackAbility: attackAbility ?? this.attackAbility,
      enhancementBonus: enhancementBonus ?? this.enhancementBonus,
      isFinesse: isFinesse ?? this.isFinesse,
      weaponType: weaponType ?? this.weaponType,
      damageAbility: damageAbility ?? this.damageAbility,
    );
  }

  String get displayName {
    if (enhancementBonus > 0) {
      return '+$enhancementBonus $name';
    }
    return name;
  }
}

class Armor extends EquipmentItem {
  final int baseAC;
  final ArmorType armorType;
  final int strengthRequirement;
  final bool stealthDisadvantage;

  const Armor({
    required super.id,
    required super.name,
    super.description = '',
    super.quantity = 1,
    super.weight = 0,
    super.isEquipped = false,
    required this.baseAC,
    required this.armorType,
    this.strengthRequirement = 0,
    this.stealthDisadvantage = false,
  });

  @override
  factory Armor.fromJson(Map<String, dynamic> json) {
    return Armor(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      isEquipped: json['isEquipped'] as bool? ?? false,
      baseAC: json['baseAC'] as int,
      armorType: ArmorType.values.firstWhere(
        (e) => e.toString() == 'ArmorType.${json['armorType']}',
        orElse: () => ArmorType.light,
      ),
      strengthRequirement: json['strengthRequirement'] as int? ?? 0,
      stealthDisadvantage: json['stealthDisadvantage'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'baseAC': baseAC,
      'armorType': armorType.toString().split('.').last,
      'strengthRequirement': strengthRequirement,
      'stealthDisadvantage': stealthDisadvantage,
    };
  }

  Armor copyWith({
    String? id,
    String? name,
    String? description,
    int? quantity,
    double? weight,
    bool? isEquipped,
    int? baseAC,
    ArmorType? armorType,
    int? strengthRequirement,
    bool? stealthDisadvantage,
  }) {
    return Armor(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      isEquipped: isEquipped ?? this.isEquipped,
      baseAC: baseAC ?? this.baseAC,
      armorType: armorType ?? this.armorType,
      strengthRequirement: strengthRequirement ?? this.strengthRequirement,
      stealthDisadvantage: stealthDisadvantage ?? this.stealthDisadvantage,
    );
  }
}

enum ArmorType { light, medium, heavy, shield }

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
      copper: json['copper'] as int? ?? 0,
      silver: json['silver'] as int? ?? 0,
      electrum: json['electrum'] as int? ?? 0,
      gold: json['gold'] as int? ?? 0,
      platinum: json['platinum'] as int? ?? 0,
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
      spellSaveDC: json['spellSaveDC'] as int,
      spellAttackBonus: json['spellAttackBonus'] as int,
      spellSlots: json['spellSlots'] != null
          ? (json['spellSlots'] as List)
                .map((e) => SpellSlot.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      preparedSpells: json['preparedSpells'] != null
          ? (json['preparedSpells'] as List)
                .map((e) => Spell.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      knownSpells: json['knownSpells'] != null
          ? (json['knownSpells'] as List)
                .map((e) => Spell.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
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
      level: json['level'] as int,
      total: json['total'] as int,
      used: json['used'] as int? ?? 0,
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
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
      school: json['school'] as String? ?? '',
      isPrepared: json['isPrepared'] as bool? ?? false,
      isRitual: json['isRitual'] as bool? ?? false,
      isConcentration: json['isConcentration'] as bool? ?? false,
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
      alliesAndOrganizations: json['alliesAndOrganizations'] != null
          ? List<String>.from(json['alliesAndOrganizations'])
          : [],
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
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      levelObtained: json['levelObtained'] as int? ?? 1,
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

  const PhysicalDescription({
    this.age = 0,
    this.height = '',
    this.weight = '',
    this.eyes = '',
    this.skin = '',
    this.hair = '',
    this.deity = '',
  });

  factory PhysicalDescription.fromJson(Map<String, dynamic> json) {
    return PhysicalDescription(
      age: json['age'] as int? ?? 0,
      height: json['height'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      eyes: json['eyes'] as String? ?? '',
      skin: json['skin'] as String? ?? '',
      hair: json['hair'] as String? ?? '',
      deity: json['deity'] as String? ?? '',
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
    };
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
    switch (this.toLowerCase()) {
      case 'strength':
        return modifiers.strength;
      case 'dexterity':
        return modifiers.dexterity;
      case 'constitution':
        return modifiers.constitution;
      case 'intelligence':
        return modifiers.intelligence;
      case 'wisdom':
        return modifiers.wisdom;
      case 'charisma':
        return modifiers.charisma;
      default:
        return 0;
    }
  }
}

class EquippedCombatStats {
  final EquippedWeapon? equippedMeleeWeapon;
  final EquippedWeapon? equippedRangedWeapon;
  final EquippedArmor equippedArmor;
  final List<String> weaponProficiencies;
  final List<String> armorProficiencies;

  const EquippedCombatStats({
    this.equippedMeleeWeapon,
    this.equippedRangedWeapon,
    required this.equippedArmor,
    this.weaponProficiencies = const [],
    this.armorProficiencies = const [],
  });

  factory EquippedCombatStats.fromJson(Map<String, dynamic> json) {
    return EquippedCombatStats(
      equippedMeleeWeapon: json['equippedMeleeWeapon'] != null
          ? EquippedWeapon.fromJson(
              json['equippedMeleeWeapon'] as Map<String, dynamic>,
            )
          : null,
      equippedRangedWeapon: json['equippedRangedWeapon'] != null
          ? EquippedWeapon.fromJson(
              json['equippedRangedWeapon'] as Map<String, dynamic>,
            )
          : null,
      equippedArmor: EquippedArmor.fromJson(
        json['equippedArmor'] as Map<String, dynamic>,
      ),
      weaponProficiencies: json['weaponProficiencies'] != null
          ? List<String>.from(json['weaponProficiencies'])
          : [],
      armorProficiencies: json['armorProficiencies'] != null
          ? List<String>.from(json['armorProficiencies'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (equippedMeleeWeapon != null)
        'equippedMeleeWeapon': equippedMeleeWeapon!.toJson(),
      if (equippedRangedWeapon != null)
        'equippedRangedWeapon': equippedRangedWeapon!.toJson(),
      'equippedArmor': equippedArmor.toJson(),
      'weaponProficiencies': weaponProficiencies,
      'armorProficiencies': armorProficiencies,
    };
  }

  EquippedCombatStats copyWith({
    EquippedWeapon? equippedMeleeWeapon,
    EquippedWeapon? equippedRangedWeapon,
    EquippedArmor? equippedArmor,
    List<String>? weaponProficiencies,
    List<String>? armorProficiencies,
  }) {
    return EquippedCombatStats(
      equippedMeleeWeapon: equippedMeleeWeapon ?? this.equippedMeleeWeapon,
      equippedRangedWeapon: equippedRangedWeapon ?? this.equippedRangedWeapon,
      equippedArmor: equippedArmor ?? this.equippedArmor,
      weaponProficiencies:
          weaponProficiencies ?? List.from(this.weaponProficiencies),
      armorProficiencies:
          armorProficiencies ?? List.from(this.armorProficiencies),
    );
  }
}

class EquippedWeapon {
  final String weaponClass;
  final int enhancementBonus; // +0, +1, +2, +3
  final String ability; // 'strength', 'dexterity', etc.
  final bool isProficient;
  final bool isFinesse;
  final String damageDice; // e.g., "1d8", "2d6"
  final String damageType; // e.g., "slashing", "piercing"

  const EquippedWeapon({
    required this.weaponClass,
    this.enhancementBonus = 0,
    this.ability = 'strength',
    this.isProficient = false,
    this.isFinesse = false,
    required this.damageDice,
    required this.damageType,
  });

  factory EquippedWeapon.fromJson(Map<String, dynamic> json) {
    return EquippedWeapon(
      weaponClass: json['weaponClass'] as String,
      enhancementBonus: json['enhancementBonus'] as int? ?? 0,
      ability: json['ability'] as String? ?? 'strength',
      isProficient: json['isProficient'] as bool? ?? false,
      isFinesse: json['isFinesse'] as bool? ?? false,
      damageDice: json['damageDice'] as String,
      damageType: json['damageType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weaponClass': weaponClass,
      'enhancementBonus': enhancementBonus,
      'ability': ability,
      'isProficient': isProficient,
      'isFinesse': isFinesse,
      'damageDice': damageDice,
      'damageType': damageType,
    };
  }

  EquippedWeapon copyWith({
    String? weaponClass,
    int? enhancementBonus,
    String? ability,
    bool? isProficient,
    bool? isFinesse,
    String? damageDice,
    String? damageType,
  }) {
    return EquippedWeapon(
      weaponClass: weaponClass ?? this.weaponClass,
      enhancementBonus: enhancementBonus ?? this.enhancementBonus,
      ability: ability ?? this.ability,
      isProficient: isProficient ?? this.isProficient,
      isFinesse: isFinesse ?? this.isFinesse,
      damageDice: damageDice ?? this.damageDice,
      damageType: damageType ?? this.damageType,
    );
  }
}

class EquippedArmor {
  final String armorType; // 'cloth', 'light', 'medium', 'heavy'
  final int baseAC;
  final int manualBonus; // User can add/subtract from calculated AC
  final bool usesDexterity;
  final int
  maxDexBonus; // 0 for heavy armor, 2 for medium, unlimited for light/cloth

  const EquippedArmor({
    required this.armorType,
    required this.baseAC,
    this.manualBonus = 0,
    this.usesDexterity = true,
    this.maxDexBonus = 999,
  });

  factory EquippedArmor.fromJson(Map<String, dynamic> json) {
    return EquippedArmor(
      armorType: json['armorType'] as String,
      baseAC: json['baseAC'] as int,
      manualBonus: json['manualBonus'] as int? ?? 0,
      usesDexterity: json['usesDexterity'] as bool? ?? true,
      maxDexBonus: json['maxDexBonus'] as int? ?? 999,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'armorType': armorType,
      'baseAC': baseAC,
      'manualBonus': manualBonus,
      'usesDexterity': usesDexterity,
      'maxDexBonus': maxDexBonus,
    };
  }

  EquippedArmor copyWith({
    String? armorType,
    int? baseAC,
    int? manualBonus,
    bool? usesDexterity,
    int? maxDexBonus,
  }) {
    return EquippedArmor(
      armorType: armorType ?? this.armorType,
      baseAC: baseAC ?? this.baseAC,
      manualBonus: manualBonus ?? this.manualBonus,
      usesDexterity: usesDexterity ?? this.usesDexterity,
      maxDexBonus: maxDexBonus ?? this.maxDexBonus,
    );
  }
}
