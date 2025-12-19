import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';

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
      final characterClass = classLevel.characterClass;
      final level = classLevel.level;

      int hitDie;
      switch (characterClass.hitDie) {
        case '1d12':
          hitDie = 12;
          break;
        case '1d10':
          hitDie = 10;
          break;
        case '1d8':
          hitDie = 8;
          break;
        case '1d6':
          hitDie = 6;
          break;
        default:
          hitDie = 8;
      }

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

  // Helper for single-class characters (backward compatibility)
  static int calculateSingleClassHP({
    required CharacterClass characterClass,
    required int level,
    required int constitutionScore,
  }) {
    return calculateExpectedMaxHP(
      classes: [
        CharacterClassLevel(
          characterClass: characterClass,
          level: level,
        )
      ],
      constitutionScore: constitutionScore,
    );
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

  // Get hit die for a character class
  static int getHitDie(CharacterClass characterClass) {
    switch (characterClass.hitDie) {
      case '1d12':
        return 12;
      case '1d10':
        return 10;
      case '1d8':
        return 8;
      case '1d6':
        return 6;
      default:
        return 8;
    }
  }

  // Calculate ability modifier from score
  static int calculateAbilityModifier(int score) {
    return ((score - 10) / 2).floor();
  }

  // Get ability abbreviation
  static String getAbilityAbbreviation(String ability) {
    switch (ability.toLowerCase()) {
      case 'strength': return 'STR';
      case 'dexterity': return 'DEX';
      case 'constitution': return 'CON';
      case 'intelligence': return 'INT';
      case 'wisdom': return 'WIS';
      case 'charisma': return 'CHA';
      default: return ability.substring(0, 3).toUpperCase();
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