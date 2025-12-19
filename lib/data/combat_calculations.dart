import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';

class CombatCalculations {
  // Parse damage dice string (e.g., "1d4+3")
  static Map<String, dynamic> parseDamageDice(String damageDice) {
    try {
      final parts = damageDice.split('+');
      String dicePart = parts[0].trim();
      int bonus = parts.length > 1 ? int.tryParse(parts[1].trim()) ?? 0 : 0;

      final diceParts = dicePart.split('d');
      if (diceParts.length != 2) {
        return {'count': 1, 'sides': 4, 'bonus': bonus};
      }

      final count = int.tryParse(diceParts[0]) ?? 1;
      final sides = int.tryParse(diceParts[1]) ?? 6;

      return {'count': count, 'sides': sides, 'bonus': bonus};
    } catch (e) {
      return {'count': 1, 'sides': 4, 'bonus': 0};
    }
  }

  // Calculate attack bonus for a weapon
  static int calculateAttackBonus({
    required Character character,
    required EquippedWeapon weapon,
  }) {
    int bonus = 0;

    // Ability modifier
    final abilityMod = _getAbilityModifier(character.modifiers, weapon.ability);
    bonus += abilityMod;

    // Proficiency bonus if proficient
    if (weapon.isProficient) {
      bonus += character.proficiencies.proficiencyBonus;
    }

    // Enhancement bonus
    bonus += weapon.enhancementBonus;

    return bonus;
  }

  // Calculate damage bonus for a weapon
  static int calculateDamageBonus({
    required Character character,
    required EquippedWeapon weapon,
  }) {
    int bonus = 0;

    // Ability modifier (for most weapons)
    if (!_isTwoHandedWeapon(weapon.weaponClass)) {
      final abilityMod = _getAbilityModifier(character.modifiers, weapon.ability);
      bonus += abilityMod;
    }

    // Enhancement bonus
    bonus += weapon.enhancementBonus;

    return bonus;
  }

  // Calculate damage range (e.g., "1d4+3" -> "4-7")
  static String calculateDamageRange({
    required EquippedWeapon weapon,
    required Character character,
  }) {
    final parsed = parseDamageDice(weapon.damageDice);
    final count = parsed['count'] as int;
    final sides = parsed['sides'] as int;
    final bonus = parsed['bonus'] as int;

    // Add ability modifier to damage bonus for range calculation
    final damageBonus = calculateDamageBonus(character: character, weapon: weapon);
    final totalBonus = bonus + damageBonus;

    final minDamage = count + totalBonus;
    final maxDamage = (count * sides) + totalBonus;

    return '$minDamage-$maxDamage';
  }

  // Calculate expected AC based on equipped armor
  static int calculateExpectedAC({
    required Character character,
    required EquippedArmor armor,
  }) {
    int ac = armor.baseAC;

    // Add dexterity modifier if armor uses it
    if (armor.usesDexterity) {
      int dexMod = character.modifiers.dexterity;

      // Apply max dex bonus for medium armor
      if (armor.maxDexBonus != 999) {
        dexMod = dexMod > armor.maxDexBonus ? armor.maxDexBonus : dexMod;
      }

      ac += dexMod;
    }

    // Add CON modifier for Barbarian/Monk unarmored defense
    for (final classLevel in character.classes) {
      if (classLevel.characterClass == CharacterClass.barbarian && armor.armorType == 'cloth') {
        ac += character.modifiers.constitution;
      }
      if (classLevel.characterClass == CharacterClass.monk && armor.armorType == 'cloth') {
        ac += character.modifiers.wisdom;
      }
    }

    // Add manual bonus
    ac += armor.manualBonus;

    return ac;
  }

  // Calculate total AC (expected + any combat stats override)
  static int calculateTotalAC({
    required Character character,
    required EquippedArmor armor,
  }) {
    final expectedAC = calculateExpectedAC(character: character, armor: armor);

    // If combatStats.armorClass is different from expected, use that (manual override)
    return character.combatStats.armorClass != 10 ? character.combatStats.armorClass : expectedAC;
  }

  // Get ability modifier
  static int _getAbilityModifier(CalculatedModifiers modifiers, String ability) {
    switch (ability.toLowerCase()) {
      case 'strength': return modifiers.strength;
      case 'dexterity': return modifiers.dexterity;
      case 'constitution': return modifiers.constitution;
      case 'intelligence': return modifiers.intelligence;
      case 'wisdom': return modifiers.wisdom;
      case 'charisma': return modifiers.charisma;
      default: return 0;
    }
  }

  // Check if weapon is two-handed (no ability bonus to damage)
  static bool _isTwoHandedWeapon(String weaponClass) {
    final twoHandedWeapons = [
      'Greatsword', 'Greataxe', 'Maul', 'Heavy Crossbow', 'Longbow'
    ];
    return twoHandedWeapons.contains(weaponClass);
  }

  // Calculate expected initiative
  static int calculateExpectedInitiative(Character character) {
    return character.modifiers.dexterity;
  }

  // Calculate expected speed (default 30, can be modified by race)
  static int calculateExpectedSpeed(Character character) {
    // Base speed is 30 for most races
    int speed = 30;

    // Dwarves have 25 speed
    if (character.race == Race.dwarf) {
      speed = 25;
    }

    // Elves, half-elves have 35
    if (character.race == Race.elf || character.race == Race.halfElf) {
      speed = 35;
    }

    return speed;
  }

  // Calculate expected hit dice based on classes
  static List<HitDie> calculateExpectedHitDice(List<CharacterClassLevel> classes) {
    final hitDice = <HitDie>[];

    for (final classLevel in classes) {
      final characterClass = classLevel.characterClass;
      final level = classLevel.level;

      int sides;
      switch (characterClass.hitDie) {
        case '1d12': sides = 12; break;
        case '1d10': sides = 10; break;
        case '1d8': sides = 8; break;
        case '1d6': sides = 6; break;
        default: sides = 8;
      }

      hitDice.add(HitDie(sides: sides, count: level, used: 0));
    }

    return hitDice;
  }

  // Check if character has proficiency
  static bool hasProficiency(List<String> proficiencies, String proficiency) {
    return proficiencies.any((p) => p.toLowerCase().contains(proficiency.toLowerCase()) ||
        proficiency.toLowerCase().contains(p.toLowerCase()));
  }
}