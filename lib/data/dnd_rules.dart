import 'package:openrpg/models/character.dart';

class DndRules {
  // Calculate expected proficiency bonus based on TOTAL character level
  static int calculateProficiencyBonus(int totalLevel) {
    if (totalLevel <= 0) return 2;
    return 2 + ((totalLevel - 1) / 4).ceil();
  }

  // Calculate expected max HP for single-class or multiclass character
  static int calculateExpectedMaxHP({
    required List<CharacterClassLevel> classes,
    required int constitutionScore,
  }) {
    final conModifier = ((constitutionScore - 10) / 2).floor();
    int totalHP = 0;
    bool isFirstClass = true;

    for (final classLevel in classes) {
      final level = classLevel.level;
      final hitDie = _hitDieForClassName(classLevel.className);

      // First level of first class gets max hit die
      if (isFirstClass) {
        totalHP += hitDie + conModifier;
        isFirstClass = false;

        // Add remaining levels for this class (average rounded up)
        for (int i = 2; i <= level; i++) {
          totalHP += (hitDie / 2).ceil() + conModifier;
        }
      } else {
        // For multiclass levels, always use average (rounded up)
        for (int i = 1; i <= level; i++) {
          totalHP += (hitDie / 2).ceil() + conModifier;
        }
      }
    }

    return totalHP;
  }

  static int calculateExpectedMaxHPFromHitDice({
    required List<HitDie> hitDice,
    required int constitutionScore,
  }) {
    final conModifier = ((constitutionScore - 10) / 2).floor();
    var totalHP = 0;
    var isFirstHitDie = true;

    for (final die in hitDice) {
      final faces = die.sides <= 0 ? 8 : die.sides;
      final count = die.count <= 0 ? 0 : die.count;
      if (count == 0) {
        continue;
      }

      if (isFirstHitDie) {
        totalHP += faces + conModifier;
        isFirstHitDie = false;
        for (var level = 2; level <= count; level++) {
          totalHP += (faces / 2).ceil() + conModifier;
        }
        continue;
      }

      for (var level = 1; level <= count; level++) {
        totalHP += (faces / 2).ceil() + conModifier;
      }
    }

    return totalHP <= 0 ? 1 : totalHP;
  }

  // Helper for single-class characters (backward compatibility)
  static int calculateSingleClassHP({
    required int hitDieFaces,
    required int level,
    required int constitutionScore,
  }) {
    final conModifier = ((constitutionScore - 10) / 2).floor();
    final hitDie = hitDieFaces <= 0 ? 8 : hitDieFaces;
    var totalHP = hitDie + conModifier;
    for (var currentLevel = 2; currentLevel <= level; currentLevel++) {
      totalHP += (hitDie / 2).ceil() + conModifier;
    }
    return totalHP;
  }

  // XP required for each level (simplified)
  static final Map<int, int> xpThresholds = {
    1: 0,
    2: 300,
    3: 900,
    4: 2700,
    5: 6500,
    6: 14000,
    7: 23000,
    8: 34000,
    9: 48000,
    10: 64000,
    11: 85000,
    12: 100000,
    13: 120000,
    14: 140000,
    15: 165000,
    16: 195000,
    17: 225000,
    18: 265000,
    19: 305000,
    20: 355000,
  };

  static int _hitDieForClassName(String className) {
    final normalized = _normalizedName(className);
    const hitDiceByClass = <String, int>{
      'barbarian': 12,
      'fighter': 10,
      'paladin': 10,
      'ranger': 10,
      'bard': 8,
      'cleric': 8,
      'druid': 8,
      'monk': 8,
      'rogue': 8,
      'warlock': 8,
      'artificer': 8,
      'sorcerer': 6,
      'wizard': 6,
    };
    return hitDiceByClass[normalized] ?? 8;
  }

  static String _normalizedName(String value) {
    return value.trim().toLowerCase().replaceAll('-', ' ');
  }

  // Calculate ability modifier from score
  static int calculateAbilityModifier(int score) {
    return ((score - 10) / 2).floor();
  }

  // Get ability abbreviation
  static String getAbilityAbbreviation(String ability) {
    switch (ability.toLowerCase()) {
      case 'strength':
        return 'STR';
      case 'dexterity':
        return 'DEX';
      case 'constitution':
        return 'CON';
      case 'intelligence':
        return 'INT';
      case 'wisdom':
        return 'WIS';
      case 'charisma':
        return 'CHA';
      default:
        return ability.substring(0, 3).toUpperCase();
    }
  }

  // Parse damage dice string (e.g., "2d6+3" returns {dice: "2d6", bonus: 3})
  static Map<String, dynamic> parseDamageString(String damage) {
    final parts = damage.split('+');
    String dice = parts[0].trim();
    int bonus = 0;

    if (parts.length > 1) {
      bonus = int.tryParse(parts[1].trim()) ?? 0;
    }

    return {'dice': dice, 'bonus': bonus};
  }

  // Calculate average damage for a damage string
  static double calculateAverageDamage(String damage) {
    final parsed = parseDamageString(damage);
    final dice = parsed['dice'] as String;
    final bonus = parsed['bonus'] as int;

    // Parse dice like "2d6"
    final diceParts = dice.split('d');
    if (diceParts.length != 2) return bonus.toDouble();

    final count = int.tryParse(diceParts[0]) ?? 1;
    final sides = int.tryParse(diceParts[1]) ?? 6;

    // Average per die is (sides + 1) / 2
    final averagePerDie = (sides + 1) / 2;

    return (count * averagePerDie) + bonus;
  }
}
