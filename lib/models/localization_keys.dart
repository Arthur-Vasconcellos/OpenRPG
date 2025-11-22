import '../models/enums.dart';

class LocalizationService {
  static const Map<String, String> _translations = {
    // Categories
    'category_weapon': 'Weapon',
    'category_armor': 'Armor',
    'category_potion': 'Potion',
    'category_ring': 'Ring',
    'category_rod': 'Rod',
    'category_staff': 'Staff',
    'category_wand': 'Wand',
    'category_wondrous_item': 'Wondrous Item',
    'category_scroll': 'Scroll',
    'category_ammunition': 'Ammunition',
    'apparatus_of_the_crab_name': 'Apparatus of the Crab',
    'armor_plus1_name': '+1 Armor',
    'armor_plus2_name': '+2 Armor',
    'armor_plus3_name': '+3 Armor',
    'armor_of_invulnerability_name': 'Armor of Invulnerability',
    'armor_of_resistance_name': 'Armor of Resistance',
    'armor_of_vulnerability_name': 'Armor of Vulnerability',
    'arrow_catching_shield_name': 'Arrow-Catching Shield',

    // Magic Items - Names
    'bag_of_beans_name': 'Bag of Beans',
    'bag_of_devouring_name': 'Bag of Devouring',
    'bag_of_holding_name': 'Bag of Holding',
    'bag_of_tricks_gray_name': 'Gray Bag of Tricks',
    'bag_of_tricks_rust_name': 'Rust Bag of Tricks',
    'bag_of_tricks_tan_name': 'Tan Bag of Tricks',
    'bead_of_force_name': 'Bead of Force',
    'belt_of_dwarvenkind_name': 'Belt of Dwarvenkind',
    'belt_of_giant_strength_hill_name': 'Belt of Giant Strength (Hill)',
    'belt_of_giant_strength_frost_name': 'Belt of Giant Strength (Frost)',
    'belt_of_giant_strength_stone_name': 'Belt of Giant Strength (Stone)',
    'belt_of_giant_strength_fire_name': 'Belt of Giant Strength (Fire)',
    'belt_of_giant_strength_cloud_name': 'Belt of Giant Strength (Cloud)',
    'belt_of_giant_strength_storm_name': 'Belt of Giant Strength (Storm)',

// Magic Items - Descriptions
    'bag_of_beans_description': 'This heavy cloth bag contains 3d4 dry beans. If you dump beans out of the bag, they explode in a 10-foot radius sphere. If you plant a bean in dirt or sand and water it, it produces a magical effect 1 minute later.',
    'bag_of_devouring_description': 'This bag resembles a Bag of Holding but is a feeding orifice for a gigantic extradimensional creature. Animal or vegetable matter placed wholly in the bag is devoured and lost forever.',
    'bag_of_holding_description': 'This bag has an interior space considerably larger than its outside dimensions, roughly 2 feet square and 4 feet deep on the inside. The bag can hold up to 500 pounds, not exceeding a volume of 64 cubic feet.',
    'bag_of_tricks_gray_description': 'This gray cloth bag appears empty. You can pull a fuzzy object from it and throw it to create a creature.',
    'bag_of_tricks_rust_description': 'This rust-colored cloth bag appears empty. You can pull a fuzzy object from it and throw it to create a creature.',
    'bag_of_tricks_tan_description': 'This tan cloth bag appears empty. You can pull a fuzzy object from it and throw it to create a creature.',
    'bead_of_force_description': 'This small black sphere can be thrown up to 60 feet. It explodes on impact in a 10-foot radius sphere, dealing force damage and trapping creatures that fail their save.',
    'belt_of_dwarvenkind_description': 'While wearing this belt, you gain the following benefits: You know Dwarvish, have advantage on Charisma (Persuasion) checks with dwarves, your Constitution increases by 2, and you may grow a beard.',
    'belt_of_giant_strength_hill_description': 'While wearing this belt, your Strength score becomes 21. It has no effect if your Strength is already 21 or higher.',
    'belt_of_giant_strength_frost_description': 'While wearing this belt, your Strength score becomes 23. It has no effect if your Strength is already 23 or higher.',
    'belt_of_giant_strength_stone_description': 'While wearing this belt, your Strength score becomes 23. It has no effect if your Strength is already 23 or higher.',
    'belt_of_giant_strength_fire_description': 'While wearing this belt, your Strength score becomes 25. It has no effect if your Strength is already 25 or higher.',
    'belt_of_giant_strength_cloud_description': 'While wearing this belt, your Strength score becomes 27. It has no effect if your Strength is already 27 or higher.',
    'belt_of_giant_strength_storm_description': 'While wearing this belt, your Strength score becomes 29. It has no effect if your Strength is already 29 or higher.',

// Action Descriptions
    'bag_of_beans_plant': 'Plant a bean in the ground and water it',
    'bag_of_tricks_draw': 'Pull a fuzzy object from the bag and throw it',
    'bead_of_force_throw': 'Throw the bead up to 60 feet',

// Table Names
    'bag_of_beans_effects_name': 'Bag of Beans Effects',
    'gray_bag_of_tricks_name': 'Gray Bag of Tricks Creatures',
    'rust_bag_of_tricks_name': 'Rust Bag of Tricks Creatures',
    'tan_bag_of_tricks_name': 'Tan Bag of Tricks Creatures',

// Table Effects
    'bag_of_beans_effect_01': '5d4 toadstools sprout',
    'bag_of_beans_effect_02_10': 'A geyser erupts and spouts liquid for 1d4 minutes',
    'bag_of_beans_effect_11_20': 'A treant sprouts (random alignment)',
    'bag_of_beans_effect_21_30': 'An immobile stone statue in your likeness rises and threatens you',
    'bag_of_beans_effect_31_40': 'A campfire with green flames springs forth and burns for 24 hours',
    'bag_of_beans_effect_41_50': 'Three shrieker fungi sprout',
    'bag_of_beans_effect_51_60': '1d4 + 4 bright-pink toads crawl forth',
    'bag_of_beans_effect_61_70': 'A hungry bulette burrows up and attacks',
    'bag_of_beans_effect_71_80': 'A fruit tree grows with 1d8 magical fruits',
    'bag_of_beans_effect_81_90': 'A nest of 1d4 + 3 rainbow-colored eggs springs up',
    'bag_of_beans_effect_91_95': 'A pyramid with a mummy bursts upward',
    'bag_of_beans_effect_96_00': 'A giant beanstalk sprouts, growing to a great height',

// Creature Types for Bags of Tricks
    'creature_weasel': 'Weasel',
    'creature_giant_rat': 'Giant Rat',
    'creature_badger': 'Badger',
    'creature_boar': 'Boar',
    'creature_panther': 'Panther',
    'creature_giant_badger': 'Giant Badger',
    'creature_dire_wolf': 'Dire Wolf',
    'creature_giant_elk': 'Giant Elk',
    'creature_rat': 'Rat',
    'creature_owl': 'Owl',
    'creature_mastiff': 'Mastiff',
    'creature_goat': 'Goat',
    'creature_giant_goat': 'Giant Goat',
    'creature_giant_boar': 'Giant Boar',
    'creature_lion': 'Lion',
    'creature_brown_bear': 'Brown Bear',
    'creature_jackal': 'Jackal',
    'creature_ape': 'Ape',
    'creature_baboon': 'Baboon',
    'creature_axe_beak': 'Axe Beak',
    'creature_black_bear': 'Black Bear',
    'creature_giant_weasel': 'Giant Weasel',
    'creature_giant_hyena': 'Giant Hyena',
    'creature_tiger': 'Tiger',

// Magic Items - Descriptions
    'apparatus_of_the_crab_description': 'This item first appears to be a sealed iron barrel weighing 500 pounds. The barrel has a hidden catch, which can be found with a successful DC 20 Intelligence (Investigation) check. Releasing the catch unlocks a hatch at one end of the barrel, allowing two Medium or smaller creatures to crawl inside. Ten levers are set in a row at the far end, each in a neutral position, able to move up or down. When certain levers are used, the apparatus transforms to resemble a giant lobster.',
    'armor_plus1_description': 'You have a +1 bonus to AC while wearing this armor.',
    'armor_plus2_description': 'You have a +2 bonus to AC while wearing this armor.',
    'armor_plus3_description': 'You have a +3 bonus to AC while wearing this armor.',
    'armor_of_invulnerability_description': 'You have resistance to nonmagical damage while you wear this armor. Additionally, you can use an action to make yourself immune to nonmagical damage for 10 minutes or until you are no longer wearing the armor. Once this special action is used, it can\'t be used again until the next dawn.',
    'armor_of_resistance_description': 'You have resistance to one type of damage while you wear this armor. The GM chooses the type or determines it randomly.',
    'armor_of_vulnerability_description': 'While wearing this armor, you have resistance to one of the following damage types: bludgeoning, piercing, or slashing. The GM chooses the type or determines it randomly.',
    'arrow_catching_shield_description': 'You gain a +2 bonus to AC against ranged attacks while you wield this shield. This bonus is in addition to the shield\'s normal bonus to AC. When a creature within 5 feet of you is hit by an attack with a ranged weapon, you can use your reaction to become the target of the attack instead.',

// Action Descriptions
    'apparatus_lever_operate': 'Operate up to two levers on the apparatus',
    'armor_of_invulnerability_activate': 'Become immune to nonmagical damage for 10 minutes',
    'arrow_catching_shield_intercept': 'Intercept a ranged attack targeting a nearby ally',

// Curse Descriptions
    'armor_of_vulnerability_curse_description': 'This armor is cursed, a fact that is revealed only when an identify spell is cast on the armor or you attune to it. Attuning to the armor curses you until you are targeted by the remove curse spell or similar magic; removing the armor fails to end the curse. While cursed, you have vulnerability to two of the three damage types associated with the armor (not the one to which it grants resistance).',

// Table Names and Damage Resistances
    'armor_resistance_type_name': 'Armor of Resistance Damage Types',
    'resistance_acid': 'Acid Resistance',
    'resistance_cold': 'Cold Resistance',
    'resistance_fire': 'Fire Resistance',
    'resistance_force': 'Force Resistance',
    'resistance_lightning': 'Lightning Resistance',
    'resistance_necrotic': 'Necrotic Resistance',
    'resistance_poison': 'Poison Resistance',
    'resistance_psychic': 'Psychic Resistance',
    'resistance_radiant': 'Radiant Resistance',
    'resistance_thunder': 'Thunder Resistance',

    // Rarities
    'rarity_common': 'Common',
    'rarity_uncommon': 'Uncommon',
    'rarity_rare': 'Rare',
    'rarity_very_rare': 'Very Rare',
    'rarity_legendary': 'Legendary',
    'rarity_artifact': 'Artifact',

    // Magic Items - Names
    'adamantine_armor_name': 'Adamantine Armor',
    'ammunition_plus1_name': '+1 Ammunition',
    'ammunition_plus2_name': '+2 Ammunition',
    'ammunition_plus3_name': '+3 Ammunition',
    'ammunition_of_slaying_name': 'Ammunition of Slaying',
    'amulet_of_health_name': 'Amulet of Health',
    'amulet_of_proof_against_detection_and_location_name': 'Amulet of Proof against Detection and Location',
    'amulet_of_the_planes_name': 'Amulet of the Planes',
    'animated_shield_name': 'Animated Shield',
    'longsword_plus_1_name': '+1 Longsword',
    'longsword_plus_1_description': 'You have a +1 bonus to attack and damage rolls made with this magic weapon.',

    'wand_of_wonder_name': 'Wand of Wonder',
    'wand_of_wonder_description': 'This wand has 7 charges. While holding it, you can use an action to expend 1 of its charges and choose a target within 120 feet of you.',
    'wand_of_wonder_activate': 'Activate the wand\'s random magical effect',
    'wand_of_wonder_effects_name': 'Wand of Wonder Effects',
    'wand_of_wonder_effect_01_20': 'Cast a random spell from a sub-table',
    'wand_of_wonder_effect_21_25': 'Target is stunned until the end of your next turn',
    'wand_of_wonder_effect_26_30': 'Cast Gust of Wind centered on yourself',

    // Action Descriptions
    'amulet_of_the_planes_activate': 'Name a location on another plane and attempt to cast Plane Shift',
    'animated_shield_animate': 'Cause the shield to animate and hover protectively',

// Table Names and Descriptions
    'slaying_ammunition_creature_type_name': 'Ammunition of Slaying Creature Types',
    'amulet_planes_mishap_name': 'Amulet of the Planes Mishap Destinations',

    // Magic Items - Names
    'berserker_axe_name': 'Berserker Axe',
    'boots_of_elvenkind_name': 'Boots of Elvenkind',
    'boots_of_levitation_name': 'Boots of Levitation',
    'boots_of_speed_name': 'Boots of Speed',
    'boots_of_striding_and_springing_name': 'Boots of Striding and Springing',
    'boots_of_the_winterlands_name': 'Boots of the Winterlands',
    'bowl_of_commanding_water_elementals_name': 'Bowl of Commanding Water Elementals',
    'bracers_of_archery_name': 'Bracers of Archery',
    'bracers_of_defense_name': 'Bracers of Defense',
    'brazier_of_commanding_fire_elementals_name': 'Brazier of Commanding Fire Elementals',
    'brooch_of_shielding_name': 'Brooch of Shielding',
    'broom_of_flying_name': 'Broom of Flying',
    'candle_of_invocation_name': 'Candle of Invocation',
    'cape_of_the_mountebank_name': 'Cape of the Mountebank',
    'carpet_of_flying_name': 'Carpet of Flying',
    'censer_of_controlling_air_elementals_name': 'Censer of Controlling Air Elementals',
    'chime_of_opening_name': 'Chime of Opening',

// Magic Items - Descriptions
    'berserker_axe_description': 'You gain a +1 bonus to attack and damage rolls made with this magic weapon. In addition, while you are attuned to this weapon, your hit point maximum increases by 1 for each level you have attained.',
    'boots_of_elvenkind_description': 'While you wear these boots, your steps make no sound, regardless of the surface you are moving across. You also have advantage on Dexterity (Stealth) checks.',
    'boots_of_levitation_description': 'While you wear these boots, you can cast the Levitate spell on yourself.',
    'boots_of_speed_description': 'While you wear these boots, you can use a bonus action to click the boots\' heels together. If you do, the boots double your speed, and any creature that makes an opportunity attack against you has disadvantage on the attack roll.',
    'boots_of_striding_and_springing_description': 'While you wear these boots, your speed becomes 30 feet, unless your speed is higher, and your speed isn\'t reduced by wearing heavy armor. You can jump three times the normal distance.',
    'boots_of_the_winterlands_description': 'These furred boots are snug and feel warm. While wearing them, you gain resistance to cold damage and can tolerate temperatures as low as -50 degrees Fahrenheit without any additional protection. You also ignore difficult terrain created by ice or snow.',
    'bowl_of_commanding_water_elementals_description': 'While this bowl is filled with water, you can use an action to summon a water elemental, as if you had cast the conjure elemental spell. The bowl can\'t be used this way again until the next dawn.',
    'bracers_of_archery_description': 'While wearing these bracers, you have proficiency with the longbow and shortbow, and you gain a +2 bonus to damage rolls on ranged attacks made with such weapons.',
    'bracers_of_defense_description': 'While wearing these bracers, you gain a +2 bonus to AC if you are wearing no armor and using no shield.',
    'brazier_of_commanding_fire_elementals_description': 'While this brazier is lit, you can use an action to summon a fire elemental, as if you had cast the conjure elemental spell. The brazier can\'t be used this way again until the next dawn.',
    'brooch_of_shielding_description': 'While wearing this brooch, you have resistance to force damage, and you have immunity to damage from the magic missile spell.',
    'broom_of_flying_description': 'This wooden broom, which weighs 3 pounds, functions like a mundane broom until you stand astride it and speak its command word. It then hovers and can be ridden through the air. It has a flying speed of 50 feet.',
    'candle_of_invocation_description': 'This slender, white candle is dedicated to a specific deity. When used by a cleric or druid of that deity, the candle allows the spellcaster to cast spells with advantage on attack rolls and saving throws for 1 hour.',
    'cape_of_the_mountebank_description': 'This cape smells faintly of brimstone. While wearing it, you can use it to cast the dimension door spell as an action. This property of the cape can\'t be used again until the next dawn.',
    'carpet_of_flying_description': 'You can speak the carpet\'s command word as an action to make the carpet hover and fly. It moves according to your spoken directions.',
    'censer_of_controlling_air_elementals_description': 'While incense burns in this censer, you can use an action to summon an air elemental, as if you had cast the conjure elemental spell. The censer can\'t be used this way again until the next dawn.',
    'chime_of_opening_description': 'This hollow metal tube measures about 1 foot long and weighs 1 pound. You can strike it as an action, pointing it at an object within 120 feet that can be opened, such as a door, lid, or lock.',

// Action Descriptions
    'boots_of_levitation_activate': 'Cast Levitate on yourself',
    'boots_of_speed_activate': 'Click heels to double speed',
    'boots_of_striding_springing_jump': 'Make an extraordinary jump',
    'bowl_of_water_elementals_summon': 'Summon a water elemental',
    'brazier_of_fire_elementals_summon': 'Summon a fire elemental',
    'broom_of_flying_activate': 'Activate flying capability',
    'candle_of_invocation_light': 'Light the candle',
    'cape_of_the_mountebank_teleport': 'Cast Dimension Door',
    'carpet_of_flying_activate': 'Activate flying carpet',
    'censer_of_air_elementals_summon': 'Summon an air elemental',
    'chime_of_opening_ring': 'Ring chime to cast Knock',

// Curse Descriptions
    'berserker_axe_curse_description': 'This weapon is cursed, and becoming attuned to it extends the curse to you. As long as you remain cursed, you are unwilling to part with the weapon, keeping it within reach at all times. You also have disadvantage on attack rolls with weapons other than this one. When you take damage while holding this weapon, you must succeed on a DC 15 Wisdom saving throw or go berserk.',

// Table Names and Effects
    'carpet_of_flying_sizes_name': 'Carpet of Flying Sizes',
    'carpet_size_3x5': '3 ft. × 5 ft. - 200 lb. capacity, 80 ft. fly speed',
    'carpet_size_4x6': '4 ft. × 6 ft. - 400 lb. capacity, 60 ft. fly speed',
    'carpet_size_5x7': '5 ft. × 7 ft. - 600 lb. capacity, 40 ft. fly speed',
    'carpet_size_6x9': '6 ft. × 9 ft. - 800 lb. capacity, 30 ft. fly speed',

// Creature Types for Ammunition of Slaying
    'creature_aberrations': 'Aberrations',
    'creature_beasts': 'Beasts',
    'creature_celestials': 'Celestials',
    'creature_constructs': 'Constructs',
    'creature_dragons': 'Dragons',
    'creature_elementals': 'Elementals',
    'creature_humanoids': 'Humanoids',
    'creature_fey': 'Fey',
    'creature_fiends': 'Fiends',
    'creature_giants': 'Giants',
    'creature_monstrosities': 'Monstrosities',
    'creature_oozes': 'Oozes',
    'creature_plants': 'Plants',
    'creature_undead': 'Undead',

// Amulet of the Planes Mishap Destinations
    'random_location_named_plane': 'Random location on the plane you named',
    'random_inner_plane': 'Random location on an Inner Plane',
    'random_outer_plane_good': 'Random location on a Good-aligned Outer Plane',
    'random_outer_plane_evil': 'Random location on an Evil-aligned Outer Plane',
    'astral_plane': 'Random location on the Astral Plane',
    'dragon_slayer_longsword_name': 'Dragon Slayer Longsword',
    'dragon_slayer_longsword_description': 'You gain a +1 bonus to attack and damage rolls made with this magic weapon. When you hit a dragon with this weapon, the dragon takes an extra 3d6 damage of the weapon\'s type.',
    'dragon_slayer_attack': 'Make a melee weapon attack against a dragon',
    // Magic Items - Descriptions
    'adamantine_armor_description': 'This suit of armor is reinforced with adamantine, one of the hardest substances in existence. While you\'re wearing it, any critical hit against you becomes a normal hit.',
    'ammunition_plus1_description': 'You have a +1 bonus to attack and damage rolls made with this piece of magic ammunition. The bonus is determined by the rarity of the ammunition. Once it hits a target, the ammunition is no longer magical.',
    'ammunition_plus2_description': 'You have a +2 bonus to attack and damage rolls made with this piece of magic ammunition. Once it hits a target, the ammunition is no longer magical.',
    'ammunition_plus3_description': 'You have a +3 bonus to attack and damage rolls made with this piece of magic ammunition. Once it hits a target, the ammunition is no longer magical.',
    'ammunition_of_slaying_description': 'This magic ammunition is meant to slay creatures of a particular type. If a creature of that type takes damage from the ammunition, the creature makes a DC 17 Constitution saving throw, taking an extra 6d10 force damage on a failed save or half as much extra damage on a successful one.',
    'amulet_of_health_description': 'Your Constitution score is 19 while you wear this amulet. It has no effect on you if your Constitution is already 19 or higher.',
    'amulet_of_proof_against_detection_and_location_description': 'While wearing this amulet, you can\'t be targeted by divination spells or perceived through magical scrying sensors unless you allow it.',
    'amulet_of_the_planes_description': 'While wearing this amulet, you can use an action to name a location that you are familiar with on another plane of existence. Then make a DC 15 Intelligence (Arcana) check. On a successful check, you cast the plane shift spell. On a failed check, you and each creature and object within 15 feet of you travel to a random destination.',
    'animated_shield_description': 'While holding this shield, you can speak its command word as a bonus action to cause it to animate. The shield leaps into the air and hovers in your space to protect you as if you were wielding it, leaving your hands free. The shield remains animated for 1 minute, until you use a bonus action to end this effect, or until you are incapacitated or die, at which point the shield falls to the ground or into your hand if you have one free.',

    'staff_of_healing_name': 'Staff of Healing',
    'staff_of_healing_description': 'This staff has 10 charges. While holding it, you can use an action to expend 1 or more of its charges to cast one of the following spells from it, using your spell save DC.',
    'staff_of_healing_cure_wounds': 'Expend 1 charge to cast Cure Wounds',
    'staff_of_healing_lesser_restoration': 'Expend 2 charges to cast Lesser Restoration',
    'staff_of_healing_crafting_description': 'The staff must be carved during a full moon and blessed by a high priest.',
  };

  static String getString(String key) {
    return _translations[key] ?? '[MISSING: $key]';
  }

  static String getRarity(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return getString('rarity_common');
      case Rarity.uncommon:
        return getString('rarity_uncommon');
      case Rarity.rare:
        return getString('rarity_rare');
      case Rarity.veryRare:
        return getString('rarity_very_rare');
      case Rarity.legendary:
        return getString('rarity_legendary');
      case Rarity.artifact:
        return getString('rarity_artifact');
    }
  }

  static String getCategory(MagicItemCategory category) {
    switch (category) {
      case MagicItemCategory.weapon:
        return getString('category_weapon');
      case MagicItemCategory.armor:
        return getString('category_armor');
      case MagicItemCategory.potion:
        return getString('category_potion');
      case MagicItemCategory.ring:
        return getString('category_ring');
      case MagicItemCategory.rod:
        return getString('category_rod');
      case MagicItemCategory.staff:
        return getString('category_staff');
      case MagicItemCategory.wand:
        return getString('category_wand');
      case MagicItemCategory.wondrousItem:
        return getString('category_wondrous_item');
      case MagicItemCategory.scroll:
        return getString('category_scroll');
      case MagicItemCategory.ammunition:
        return getString('category_ammunition');
    }
  }
}