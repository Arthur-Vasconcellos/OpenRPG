import 'enums.dart';

class Character {
  final String id;
  final String name;
  final String playerName; // Add playerName field
  final CharacterClass characterClass;
  final Subclass subclass;
  final Race race;
  final Background background;
  final MoralAlignment moralAlignment;
  final int level;
  final int experiencePoints;
  final int inspiration;

  // Core Stats
  final AbilityScores abilityScores;
  final CalculatedModifiers modifiers;

  // Proficiencies
  final ProficiencySet proficiencies;

  // Combat
  final CombatStats combatStats;
  final Health health;

  // Equipment & Wealth
  final Equipment equipment;
  final Wealth wealth;

  // Spellcasting (optional)
  final SpellcastingInfo? spellcasting;

  // Features & Traits
  final Traits traits;
  final List<Feature> features;
  final List<Feature> racialTraits;
  final List<Feature> backgroundTraits;

  // Description & Notes
  final PhysicalDescription physicalDescription;
  final Notes notes;

  // Tracking
  final DateTime createdAt;
  final DateTime updatedAt;

  Character({
    required this.id,
    required this.name,
    this.playerName = '',
    required this.characterClass,
    this.subclass = Subclass.none,
    required this.race,
    required this.background,
    required this.moralAlignment,
    this.level = 1,
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
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      characterClass: EnumParser.characterClass(json['characterClass'] as String),
      subclass: EnumParser.subclass(json['subclass'] as String? ?? 'none'),
      race: EnumParser.race(json['race'] as String),
      background: EnumParser.background(json['background'] as String),
      moralAlignment: EnumParser.moralAlignment(json['moralAlignment'] as String),
      level: json['level'] as int? ?? 1,
      experiencePoints: json['experiencePoints'] as int? ?? 0,
      inspiration: json['inspiration'] as int? ?? 0,
      abilityScores: AbilityScores.fromJson(json['abilityScores'] as Map<String, dynamic>),
      modifiers: CalculatedModifiers.fromJson(json['modifiers'] as Map<String, dynamic>),
      proficiencies: ProficiencySet.fromJson(json['proficiencies'] as Map<String, dynamic>),
      combatStats: CombatStats.fromJson(json['combatStats'] as Map<String, dynamic>),
      health: Health.fromJson(json['health'] as Map<String, dynamic>),
      equipment: Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
      wealth: Wealth.fromJson(json['wealth'] as Map<String, dynamic>),
      spellcasting: json['spellcasting'] != null
          ? SpellcastingInfo.fromJson(json['spellcasting'] as Map<String, dynamic>)
          : null,
      traits: Traits.fromJson(json['traits'] as Map<String, dynamic>),
      features: json['features'] != null
          ? (json['features'] as List).map((e) => Feature.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      racialTraits: json['racialTraits'] != null
          ? (json['racialTraits'] as List).map((e) => Feature.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      backgroundTraits: json['backgroundTraits'] != null
          ? (json['backgroundTraits'] as List).map((e) => Feature.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      physicalDescription: PhysicalDescription.fromJson(json['physicalDescription'] as Map<String, dynamic>),
      notes: Notes.fromJson(json['notes'] as Map<String, dynamic>),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'characterClass': characterClass.value,
      'subclass': subclass.value,
      'race': race.value,
      'background': background.value,
      'moralAlignment': moralAlignment.value,
      'level': level,
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
      'features': features.map((e) => e.toJson()).toList(),
      'racialTraits': racialTraits.map((e) => e.toJson()).toList(),
      'backgroundTraits': backgroundTraits.map((e) => e.toJson()).toList(),
      'physicalDescription': physicalDescription.toJson(),
      'notes': notes.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Calculate all derived values
  Character copyWithCalculatedValues() {
    final calculatedModifiers = _calculateModifiers(abilityScores);
    final proficiencyBonus = _calculateProficiencyBonus(level);

    final updatedHealth = health.copyWith(
      maxHitPoints: _calculateMaxHitPoints(
        abilityScores.constitution,
        level,
        characterClass,
      ),
    );

    final updatedCombatStats = combatStats.copyWith(
      proficiencyBonus: proficiencyBonus,
      initiative: calculatedModifiers.dexterity,
      passivePerception: 10 + proficiencies.skills.getModifier(Skill.perception, calculatedModifiers, proficiencyBonus),
      passiveInsight: 10 + proficiencies.skills.getModifier(Skill.insight, calculatedModifiers, proficiencyBonus),
      passiveInvestigation: 10 + proficiencies.skills.getModifier(Skill.investigation, calculatedModifiers, proficiencyBonus),
    );

    return Character(
      id: id,
      name: name,
      characterClass: characterClass,
      subclass: subclass,
      race: race,
      background: background,
      moralAlignment: moralAlignment,
      level: level,
      experiencePoints: experiencePoints,
      inspiration: inspiration,
      abilityScores: abilityScores,
      modifiers: calculatedModifiers,
      proficiencies: proficiencies,
      combatStats: updatedCombatStats,
      health: updatedHealth,
      equipment: equipment,
      wealth: wealth,
      spellcasting: spellcasting?.copyWith(
        spellSaveDC: 8 + proficiencyBonus + (spellcasting?.spellcastingAbility?.getModifier(calculatedModifiers) ?? 0),
        spellAttackBonus: proficiencyBonus + (spellcasting?.spellcastingAbility?.getModifier(calculatedModifiers) ?? 0),
      ),
      traits: traits,
      features: features,
      racialTraits: racialTraits,
      backgroundTraits: backgroundTraits,
      physicalDescription: physicalDescription,
      notes: notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
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
    return 2 + ((level - 1) / 4).ceil();
  }

  int _calculateMaxHitPoints(int constitution, int level, CharacterClass characterClass) {
    final conModifier = ((constitution - 10) / 2).floor();
    int baseHP = 0;

    switch (characterClass) {
      case CharacterClass.barbarian:
        baseHP = 12 + conModifier;
        break;
      case CharacterClass.fighter:
      case CharacterClass.paladin:
      case CharacterClass.ranger:
      case CharacterClass.bloodHunter:
        baseHP = 10 + conModifier;
        break;
      case CharacterClass.bard:
      case CharacterClass.cleric:
      case CharacterClass.druid:
      case CharacterClass.monk:
      case CharacterClass.rogue:
      case CharacterClass.warlock:
      case CharacterClass.artificer:
        baseHP = 8 + conModifier;
        break;
      case CharacterClass.sorcerer:
      case CharacterClass.wizard:
        baseHP = 6 + conModifier;
        break;
      case CharacterClass.custom:
        baseHP = 8 + conModifier;
        break;
    }

    // Add average for additional levels
    for (int i = 2; i <= level; i++) {
      baseHP += _getAverageHitDie(characterClass) + conModifier;
    }

    return baseHP;
  }

  int _getAverageHitDie(CharacterClass characterClass) {
    switch (characterClass.hitDie) {
      case '1d12':
        return 7;
      case '1d10':
        return 6;
      case '1d8':
        return 5;
      case '1d6':
        return 4;
      default:
        return 5;
    }
  }
}

// Supporting Classes

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
      skills: SkillProficiencies.fromJson(json['skills'] as Map<String, dynamic>),
      savingThrows: SavingThrowProficiencies.fromJson(json['savingThrows'] as Map<String, dynamic>),
      languages: json['languages'] != null ? List<String>.from(json['languages']) : [],
      tools: json['tools'] != null ? List<String>.from(json['tools']) : [],
      weapons: json['weapons'] != null ? List<String>.from(json['weapons']) : [],
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
}

class SkillProficiencies {
  final Map<Skill, ProficiencyLevel> proficiencies;

  const SkillProficiencies({
    required this.proficiencies,
  });

  int getModifier(Skill skill, CalculatedModifiers modifiers, int proficiencyBonus) {
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

  int getModifier(String ability, CalculatedModifiers modifiers, int proficiencyBonus) {
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
      hitDice: hitDice ?? this.hitDice,
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
          ? (json['hitDice'] as List).map((e) => HitDie.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      deathSaves: DeathSaves.fromJson(json['deathSaves'] as Map<String, dynamic>),
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

  const HitDie({
    required this.sides,
    required this.count,
    this.used = 0,
  });

  int get remaining => count - used;

  factory HitDie.fromJson(Map<String, dynamic> json) {
    return HitDie(
      sides: json['sides'] as int,
      count: json['count'] as int,
      used: json['used'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sides': sides,
      'count': count,
      'used': used,
    };
  }
}

class DeathSaves {
  final int successes;
  final int failures;

  const DeathSaves({
    this.successes = 0,
    this.failures = 0,
  });

  factory DeathSaves.fromJson(Map<String, dynamic> json) {
    return DeathSaves(
      successes: json['successes'] as int? ?? 0,
      failures: json['failures'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'successes': successes,
      'failures': failures,
    };
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
          ? (json['inventory'] as List).map((e) => EquipmentItem.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      weapons: json['weapons'] != null
          ? (json['weapons'] as List).map((e) => Weapon.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      armor: json['armor'] != null
          ? (json['armor'] as List).map((e) => Armor.fromJson(e as Map<String, dynamic>)).toList()
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
}

class Weapon extends EquipmentItem {
  final String damage;
  final String damageType;
  final String properties;
  final int attackBonus;
  final int damageBonus;
  final bool isProficient;

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
    };
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
}

enum ArmorType {
  light,
  medium,
  heavy,
  shield,
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
      spellSlots: spellSlots ?? this.spellSlots,
      preparedSpells: preparedSpells ?? this.preparedSpells,
      knownSpells: knownSpells ?? this.knownSpells,
    );
  }

  factory SpellcastingInfo.fromJson(Map<String, dynamic> json) {
    return SpellcastingInfo(
      spellcastingAbility: json['spellcastingAbility'] as String?,
      spellSaveDC: json['spellSaveDC'] as int,
      spellAttackBonus: json['spellAttackBonus'] as int,
      spellSlots: json['spellSlots'] != null
          ? (json['spellSlots'] as List).map((e) => SpellSlot.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      preparedSpells: json['preparedSpells'] != null
          ? (json['preparedSpells'] as List).map((e) => Spell.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      knownSpells: json['knownSpells'] != null
          ? (json['knownSpells'] as List).map((e) => Spell.fromJson(e as Map<String, dynamic>)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (spellcastingAbility != null) 'spellcastingAbility': spellcastingAbility,
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

  const SpellSlot({
    required this.level,
    required this.total,
    this.used = 0,
  });

  int get remaining => total - used;

  factory SpellSlot.fromJson(Map<String, dynamic> json) {
    return SpellSlot(
      level: json['level'] as int,
      total: json['total'] as int,
      used: json['used'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'total': total,
      'used': used,
    };
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

  const Spell({
    required this.id,
    required this.name,
    required this.level,
    this.school = '',
    this.isPrepared = false,
    this.isRitual = false,
    this.isConcentration = false,
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
    };
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
  final String source; // 'class', 'race', 'background', 'feat'

  const Feature({
    required this.id,
    required this.name,
    required this.description,
    this.levelObtained = 1,
    this.source = 'class',
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      levelObtained: json['levelObtained'] as int? ?? 1,
      source: json['source'] as String? ?? 'class',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'levelObtained': levelObtained,
      'source': source,
    };
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

// Helper extension for spellcasting ability
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