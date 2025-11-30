// models/magic_item_fixed.dart
import 'enums.dart';

class MagicItem {
  final String id;
  final String nameKey;
  final MagicItemCategory category;
  final Rarity rarity;
  final bool requiresAttunement;
  final AttunementPrerequisites? attunementPrerequisites;
  final String descriptionKey;
  final NumericalValues? numericalValues;
  final List<ItemProperty> properties;
  final List<ItemAction> actions;
  final Curse? curse;
  final List<RandomTable>? randomTables;
  final CraftingInfo? craftingInfo;
  final SentientInfo? sentientInfo;
  final String? pairedItemId;
  final VehicleProperties? vehicleProperties;
  final ContainerProperties? containerProperties;
  final ScrollProperties? scrollProperties;
  final Durability? durability;
  final ArtifactProperties? artifactProperties;
  final SpellCastingProperties? spellCastingProperties;

  const MagicItem({
    required this.id,
    required this.nameKey,
    required this.category,
    required this.rarity,
    required this.requiresAttunement,
    this.attunementPrerequisites,
    required this.descriptionKey,
    this.numericalValues,
    this.properties = const [],
    this.actions = const [],
    this.curse,
    this.randomTables,
    this.craftingInfo,
    this.sentientInfo,
    this.pairedItemId,
    this.vehicleProperties,
    this.containerProperties,
    this.scrollProperties,
    this.durability,
    this.artifactProperties,
    this.spellCastingProperties,
  });

  factory MagicItem.fromJson(Map<String, dynamic> json) {
    return MagicItem(
      id: json['id'] as String,
      nameKey: json['nameKey'] as String,
      category: EnumParser.magicItemCategory(json['category'] as String),
      rarity: EnumParser.rarity(json['rarity'] as String),
      requiresAttunement: json['requiresAttunement'] as bool,
      attunementPrerequisites: json['attunementPrerequisites'] != null
          ? AttunementPrerequisites.fromJson(json['attunementPrerequisites'] as Map<String, dynamic>)
          : null,
      descriptionKey: json['descriptionKey'] as String,
      numericalValues: json['numericalValues'] != null
          ? NumericalValues.fromJson(json['numericalValues'] as Map<String, dynamic>)
          : null,
      properties: json['properties'] != null
          ? (json['properties'] as List).map((e) => ItemProperty.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      actions: json['actions'] != null
          ? (json['actions'] as List).map((e) => ItemAction.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      curse: json['curse'] != null ? Curse.fromJson(json['curse'] as Map<String, dynamic>) : null,
      randomTables: json['randomTables'] != null
          ? (json['randomTables'] as List).map((e) => RandomTable.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      craftingInfo: json['craftingInfo'] != null
          ? CraftingInfo.fromJson(json['craftingInfo'] as Map<String, dynamic>)
          : null,
      sentientInfo: json['sentientInfo'] != null
          ? SentientInfo.fromJson(json['sentientInfo'] as Map<String, dynamic>)
          : null,
      pairedItemId: json['pairedItemId'] as String?,
      vehicleProperties: json['vehicleProperties'] != null
          ? VehicleProperties.fromJson(json['vehicleProperties'] as Map<String, dynamic>)
          : null,
      containerProperties: json['containerProperties'] != null
          ? ContainerProperties.fromJson(json['containerProperties'] as Map<String, dynamic>)
          : null,
      scrollProperties: json['scrollProperties'] != null
          ? ScrollProperties.fromJson(json['scrollProperties'] as Map<String, dynamic>)
          : null,
      durability: json['durability'] != null
          ? Durability.fromJson(json['durability'] as Map<String, dynamic>)
          : null,
      artifactProperties: json['artifactProperties'] != null
          ? ArtifactProperties.fromJson(json['artifactProperties'] as Map<String, dynamic>)
          : null,
      spellCastingProperties: json['spellCastingProperties'] != null
          ? SpellCastingProperties.fromJson(json['spellCastingProperties'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      'category': category.value,
      'rarity': rarity.value,
      'requiresAttunement': requiresAttunement,
      if (attunementPrerequisites != null)
        'attunementPrerequisites': attunementPrerequisites!.toJson(),
      'descriptionKey': descriptionKey,
      if (numericalValues != null) 'numericalValues': numericalValues!.toJson(),
      'properties': properties.map((e) => e.toJson()).toList(),
      'actions': actions.map((e) => e.toJson()).toList(),
      if (curse != null) 'curse': curse!.toJson(),
      if (randomTables != null)
        'randomTables': randomTables!.map((e) => e.toJson()).toList(),
      if (craftingInfo != null) 'craftingInfo': craftingInfo!.toJson(),
      if (sentientInfo != null) 'sentientInfo': sentientInfo!.toJson(),
      if (pairedItemId != null) 'pairedItemId': pairedItemId,
      if (vehicleProperties != null) 'vehicleProperties': vehicleProperties!.toJson(),
      if (containerProperties != null) 'containerProperties': containerProperties!.toJson(),
      if (scrollProperties != null) 'scrollProperties': scrollProperties!.toJson(),
      if (durability != null) 'durability': durability!.toJson(),
      if (artifactProperties != null) 'artifactProperties': artifactProperties!.toJson(),
      if (spellCastingProperties != null) 'spellCastingProperties': spellCastingProperties!.toJson(),
    };
  }
}

// Supporting Classes

class NumericalValues {
  final int? attackBonus;
  final int? damageBonus;
  final int? acBonus;
  final int? savingThrowBonus;
  final int? skillBonus;
  final String? skillType;
  final Map<String, int>? abilityScores;

  const NumericalValues({
    this.attackBonus,
    this.damageBonus,
    this.acBonus,
    this.savingThrowBonus,
    this.skillBonus,
    this.skillType,
    this.abilityScores,
  });

  factory NumericalValues.fromJson(Map<String, dynamic> json) {
    return NumericalValues(
      attackBonus: json['attackBonus'] as int?,
      damageBonus: json['damageBonus'] as int?,
      acBonus: json['acBonus'] as int?,
      savingThrowBonus: json['savingThrowBonus'] as int?,
      skillBonus: json['skillBonus'] as int?,
      skillType: json['skillType'] as String?,
      abilityScores: json['abilityScores'] != null
          ? Map<String, int>.from(json['abilityScores'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (attackBonus != null) 'attackBonus': attackBonus,
      if (damageBonus != null) 'damageBonus': damageBonus,
      if (acBonus != null) 'acBonus': acBonus,
      if (savingThrowBonus != null) 'savingThrowBonus': savingThrowBonus,
      if (skillBonus != null) 'skillBonus': skillBonus,
      if (skillType != null) 'skillType': skillType,
      if (abilityScores != null) 'abilityScores': abilityScores,
    };
  }
}

class ItemProperty {
  final String type;
  final dynamic value;
  final String? target;
  final String? condition;

  const ItemProperty({
    required this.type,
    required this.value,
    this.target,
    this.condition,
  });

  factory ItemProperty.fromJson(Map<String, dynamic> json) {
    return ItemProperty(
      type: json['type'] as String,
      value: json['value'],
      target: json['target'] as String?,
      condition: json['condition'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      if (target != null) 'target': target,
      if (condition != null) 'condition': condition,
    };
  }
}

class ItemAction {
  final ActionType type;
  final String descriptionKey;
  final ActionCost cost;
  final Effect effect;
  final ChargeInfo? charges;
  final int? globalChargeCost;

  const ItemAction({
    required this.type,
    required this.descriptionKey,
    required this.cost,
    required this.effect,
    this.charges,
    this.globalChargeCost,
  });

  factory ItemAction.fromJson(Map<String, dynamic> json) {
    return ItemAction(
      type: EnumParser.actionType(json['type'] as String),
      descriptionKey: json['descriptionKey'] as String,
      cost: ActionCost.fromJson(json['cost'] as Map<String, dynamic>),
      effect: Effect.fromJson(json['effect'] as Map<String, dynamic>),
      charges: json['charges'] != null
          ? ChargeInfo.fromJson(json['charges'] as Map<String, dynamic>)
          : null,
      globalChargeCost: json['chargeCost'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'descriptionKey': descriptionKey,
      'cost': cost.toJson(),
      'effect': effect.toJson(),
      if (charges != null) 'charges': charges!.toJson(),
      if (globalChargeCost != null) 'chargeCost': globalChargeCost,
    };
  }
}

class ActionCost {
  final ActionCostType type;
  final int? value;

  const ActionCost({
    required this.type,
    this.value,
  });

  factory ActionCost.fromJson(Map<String, dynamic> json) {
    return ActionCost(
      type: EnumParser.actionCostType(json['type'] as String),
      value: json['value'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      if (value != null) 'value': value,
    };
  }
}

class ChargeInfo {
  final int max;
  final RechargeInfo recharge;

  const ChargeInfo({
    required this.max,
    required this.recharge,
  });

  factory ChargeInfo.fromJson(Map<String, dynamic> json) {
    return ChargeInfo(
      max: json['max'] as int,
      recharge: RechargeInfo.fromJson(json['recharge'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max': max,
      'recharge': recharge.toJson(),
    };
  }
}

class RechargeInfo {
  final RechargeRate rate;
  final String? dice;

  const RechargeInfo({
    required this.rate,
    this.dice,
  });

  factory RechargeInfo.fromJson(Map<String, dynamic> json) {
    return RechargeInfo(
      rate: EnumParser.rechargeRate(json['rate'] as String),
      dice: json['dice'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate.value,
      if (dice != null) 'dice': dice,
    };
  }
}

class Curse {
  final String descriptionKey;
  final List<Effect> effects;

  const Curse({
    required this.descriptionKey,
    required this.effects,
  });

  factory Curse.fromJson(Map<String, dynamic> json) {
    return Curse(
      descriptionKey: json['descriptionKey'] as String,
      effects: (json['effects'] as List).map((e) => Effect.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descriptionKey': descriptionKey,
      'effects': effects.map((e) => e.toJson()).toList(),
    };
  }
}

class RandomTable {
  final String id;
  final String nameKey;
  final String? descriptionKey;
  final DiceRoll diceRoll;
  final List<RandomTableEntry> entries;

  const RandomTable({
    required this.id,
    required this.nameKey,
    this.descriptionKey,
    required this.diceRoll,
    required this.entries,
  });

  factory RandomTable.fromJson(Map<String, dynamic> json) {
    return RandomTable(
      id: json['id'] as String,
      nameKey: json['nameKey'] as String,
      descriptionKey: json['descriptionKey'] as String?,
      diceRoll: DiceRoll.fromJson(json['diceRoll'] as Map<String, dynamic>),
      entries: (json['entries'] as List).map((e) => RandomTableEntry.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      if (descriptionKey != null) 'descriptionKey': descriptionKey,
      'diceRoll': diceRoll.toJson(),
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }
}

class DiceRoll {
  final int count;
  final int sides;

  const DiceRoll({
    required this.count,
    required this.sides,
  });

  factory DiceRoll.fromJson(Map<String, dynamic> json) {
    return DiceRoll(
      count: json['count'] as int,
      sides: json['sides'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'sides': sides,
    };
  }
}

class RandomTableEntry {
  final String range;
  final TableEffect effect;

  const RandomTableEntry({
    required this.range,
    required this.effect,
  });

  factory RandomTableEntry.fromJson(Map<String, dynamic> json) {
    return RandomTableEntry(
      range: json['range'] as String,
      effect: TableEffect.fromJson(json['effect'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range,
      'effect': effect.toJson(),
    };
  }
}

class EffectComponent {
  final EffectType type;
  final dynamic value;

  const EffectComponent({
    required this.type,
    required this.value,
  });

  factory EffectComponent.fromJson(Map<String, dynamic> json) {
    return EffectComponent(
      type: EnumParser.effectType(json['type'] as String),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'value': value,
    };
  }
}

class Effect {
  final EffectType type;
  final dynamic value;
  final String? duration;

  const Effect({
    required this.type,
    required this.value,
    this.duration,
  });

  const Effect.tableRoll(String tableId)
      : type = EffectType.tableRoll,
        value = tableId,
        duration = null;

  const Effect.damage(Damage damage)
      : type = EffectType.damage,
        value = damage,
        duration = null;

  const Effect.condition(String condition)
      : type = EffectType.condition,
        value = condition,
        duration = null;

  const Effect.spell(String spellName)
      : type = EffectType.spell,
        value = spellName,
        duration = null;

  const Effect.custom(String description)
      : type = EffectType.custom,
        value = description,
        duration = null;

  factory Effect.fromJson(Map<String, dynamic> json) {
    return Effect(
      type: EnumParser.effectType(json['type'] as String),
      value: json['value'],
      duration: json['duration'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'value': value,
      if (duration != null) 'duration': duration,
    };
  }
}

class Damage {
  final String dice;
  final DamageType type;
  final int? saveDC;
  final String? saveType;

  const Damage({
    required this.dice,
    required this.type,
    this.saveDC,
    this.saveType,
  });

  factory Damage.fromJson(Map<String, dynamic> json) {
    return Damage(
      dice: json['dice'] as String,
      type: EnumParser.damageType(json['type'] as String),
      saveDC: json['saveDC'] as int?,
      saveType: json['saveType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dice': dice,
      'type': type.value,
      if (saveDC != null) 'saveDC': saveDC,
      if (saveType != null) 'saveType': saveType,
    };
  }
}

class TableEffect {
  final String descriptionKey;
  final List<EffectComponent> components;
  final List<RandomTable>? nestedTables;

  const TableEffect({
    required this.descriptionKey,
    this.components = const [],
    this.nestedTables,
  });

  factory TableEffect.fromJson(Map<String, dynamic> json) {
    return TableEffect(
      descriptionKey: json['descriptionKey'] as String,
      components: json['components'] != null
          ? (json['components'] as List)
          .map((e) => EffectComponent.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
      nestedTables: json['nestedTables'] != null
          ? (json['nestedTables'] as List)
          .map((e) => RandomTable.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descriptionKey': descriptionKey,
      'components': components.map((e) => e.toJson()).toList(),
      if (nestedTables != null)
        'nestedTables': nestedTables!.map((e) => e.toJson()).toList(),
    };
  }
}

// Existing classes from your original code (with minor fixes)

class AttunementPrerequisites {
  final List<String> classes;
  final List<String> races;
  final bool? spellcaster;
  final int? minimumLevel;
  final MoralAlignment? alignment;

  const AttunementPrerequisites({
    this.classes = const [],
    this.races = const [],
    this.spellcaster,
    this.minimumLevel,
    this.alignment,
  });

  factory AttunementPrerequisites.fromJson(Map<String, dynamic> json) {
    return AttunementPrerequisites(
      classes: json['classes'] != null ? List<String>.from(json['classes']) : [],
      races: json['races'] != null ? List<String>.from(json['races']) : [],
      spellcaster: json['spellcaster'] as bool?,
      minimumLevel: json['minimumLevel'] as int?,
      alignment: json['alignment'] != null
          ? EnumParser.moralAlignment(json['alignment'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classes': classes,
      'races': races,
      if (spellcaster != null) 'spellcaster': spellcaster,
      if (minimumLevel != null) 'minimumLevel': minimumLevel,
      if (alignment != null) 'alignment': alignment!.value,
    };
  }
}

class SentientInfo {
  final Abilities abilities;
  final MoralAlignment alignment;
  final Communication communication;
  final Senses senses;
  final String? specialPurpose;

  const SentientInfo({
    required this.abilities,
    required this.alignment,
    required this.communication,
    required this.senses,
    this.specialPurpose,
  });

  factory SentientInfo.fromJson(Map<String, dynamic> json) {
    return SentientInfo(
      abilities: Abilities.fromJson(json['abilities'] as Map<String, dynamic>),
      alignment: EnumParser.moralAlignment(json['alignment'] as String),
      communication: Communication.fromJson(json['communication'] as Map<String, dynamic>),
      senses: Senses.fromJson(json['senses'] as Map<String, dynamic>),
      specialPurpose: json['specialPurpose'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'abilities': abilities.toJson(),
      'alignment': alignment.value,
      'communication': communication.toJson(),
      'senses': senses.toJson(),
      if (specialPurpose != null) 'specialPurpose': specialPurpose,
    };
  }
}

class Abilities {
  final int intelligence;
  final int wisdom;
  final int charisma;

  const Abilities({
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });

  factory Abilities.fromJson(Map<String, dynamic> json) {
    return Abilities(
      intelligence: json['intelligence'] as int,
      wisdom: json['wisdom'] as int,
      charisma: json['charisma'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intelligence': intelligence,
      'wisdom': wisdom,
      'charisma': charisma,
    };
  }
}

class Communication {
  final CommunicationType type;
  final List<String> languages;

  const Communication({
    required this.type,
    this.languages = const [],
  });

  factory Communication.fromJson(Map<String, dynamic> json) {
    return Communication(
      type: EnumParser.communicationType(json['type'] as String),
      languages: json['languages'] != null ? List<String>.from(json['languages']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'languages': languages,
    };
  }
}

class Senses {
  final String range;
  final bool darkvision;

  const Senses({
    required this.range,
    this.darkvision = false,
  });

  factory Senses.fromJson(Map<String, dynamic> json) {
    return Senses(
      range: json['range'] as String,
      darkvision: json['darkvision'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range,
      'darkvision': darkvision,
    };
  }
}

class VehicleProperties {
  final int ac;
  final int hp;
  final Map<String, int> speeds;
  final List<DamageType> damageImmunities;
  final List<DamageType> damageResistances;
  final String descriptionKey;

  const VehicleProperties({
    required this.ac,
    required this.hp,
    required this.speeds,
    this.damageImmunities = const [],
    this.damageResistances = const [],
    required this.descriptionKey,
  });

  factory VehicleProperties.fromJson(Map<String, dynamic> json) {
    return VehicleProperties(
      ac: json['ac'] as int,
      hp: json['hp'] as int,
      speeds: Map<String, int>.from(json['speeds']),
      damageImmunities: json['damageImmunities'] != null
          ? (json['damageImmunities'] as List).map((e) => EnumParser.damageType(e as String)).toList()
          : [],
      damageResistances: json['damageResistances'] != null
          ? (json['damageResistances'] as List).map((e) => EnumParser.damageType(e as String)).toList()
          : [],
      descriptionKey: json['descriptionKey'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ac': ac,
      'hp': hp,
      'speeds': speeds,
      'damageImmunities': damageImmunities.map((e) => e.value).toList(),
      'damageResistances': damageResistances.map((e) => e.value).toList(),
      'descriptionKey': descriptionKey,
    };
  }
}

class ContainerProperties {
  final String capacity;
  final String airSupply;
  final bool extradimensional;

  const ContainerProperties({
    required this.capacity,
    required this.airSupply,
    this.extradimensional = false,
  });

  factory ContainerProperties.fromJson(Map<String, dynamic> json) {
    return ContainerProperties(
      capacity: json['capacity'] as String,
      airSupply: json['airSupply'] as String,
      extradimensional: json['extradimensional'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'capacity': capacity,
      'airSupply': airSupply,
      'extradimensional': extradimensional,
    };
  }
}

class ScrollProperties {
  final int spellLevel;
  final int checkDC;
  final int saveDC;
  final int attackBonus;

  const ScrollProperties({
    required this.spellLevel,
    required this.checkDC,
    required this.saveDC,
    required this.attackBonus,
  });

  factory ScrollProperties.fromJson(Map<String, dynamic> json) {
    return ScrollProperties(
      spellLevel: json['spellLevel'] as int,
      checkDC: json['checkDC'] as int,
      saveDC: json['saveDC'] as int,
      attackBonus: json['attackBonus'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spellLevel': spellLevel,
      'checkDC': checkDC,
      'saveDC': saveDC,
      'attackBonus': attackBonus,
    };
  }
}

class Durability {
  final int? ac;
  final int? hp;
  final List<DamageType> immunities;
  final List<DamageType> resistances;
  final String? specialDestruction;

  const Durability({
    this.ac,
    this.hp,
    this.immunities = const [],
    this.resistances = const [],
    this.specialDestruction,
  });

  factory Durability.fromJson(Map<String, dynamic> json) {
    return Durability(
      ac: json['ac'] as int?,
      hp: json['hp'] as int?,
      immunities: json['immunities'] != null
          ? (json['immunities'] as List).map((e) => EnumParser.damageType(e as String)).toList()
          : [],
      resistances: json['resistances'] != null
          ? (json['resistances'] as List).map((e) => EnumParser.damageType(e as String)).toList()
          : [],
      specialDestruction: json['specialDestruction'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (ac != null) 'ac': ac,
      if (hp != null) 'hp': hp,
      'immunities': immunities.map((e) => e.value).toList(),
      'resistances': resistances.map((e) => e.value).toList(),
      if (specialDestruction != null) 'specialDestruction': specialDestruction,
    };
  }
}

class ArtifactProperties {
  final String destructionMethod;
  final bool immuneToNormalDamage;

  const ArtifactProperties({
    required this.destructionMethod,
    this.immuneToNormalDamage = true,
  });

  factory ArtifactProperties.fromJson(Map<String, dynamic> json) {
    return ArtifactProperties(
      destructionMethod: json['destructionMethod'] as String,
      immuneToNormalDamage: json['immuneToNormalDamage'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destructionMethod': destructionMethod,
      'immuneToNormalDamage': immuneToNormalDamage,
    };
  }
}

class SpellCastingProperties {
  final bool usesUserSpellcastingAbility;
  final int? fixedSaveDC;
  final int? fixedAttackBonus;
  final bool ignoreComponents;
  final String? customCastingTime;
  final String? customDuration;

  const SpellCastingProperties({
    this.usesUserSpellcastingAbility = false,
    this.fixedSaveDC,
    this.fixedAttackBonus,
    this.ignoreComponents = false,
    this.customCastingTime,
    this.customDuration,
  });

  factory SpellCastingProperties.fromJson(Map<String, dynamic> json) {
    return SpellCastingProperties(
      usesUserSpellcastingAbility: json['usesUserSpellcastingAbility'] as bool? ?? false,
      fixedSaveDC: json['fixedSaveDC'] as int?,
      fixedAttackBonus: json['fixedAttackBonus'] as int?,
      ignoreComponents: json['ignoreComponents'] as bool? ?? false,
      customCastingTime: json['customCastingTime'] as String?,
      customDuration: json['customDuration'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usesUserSpellcastingAbility': usesUserSpellcastingAbility,
      if (fixedSaveDC != null) 'fixedSaveDC': fixedSaveDC,
      if (fixedAttackBonus != null) 'fixedAttackBonus': fixedAttackBonus,
      'ignoreComponents': ignoreComponents,
      if (customCastingTime != null) 'customCastingTime': customCastingTime,
      if (customDuration != null) 'customDuration': customDuration,
    };
  }
}

class CraftingInfo {
  final String descriptionKey;
  final int? timeRequired;
  final int? goldCost;
  final List<String> requiredMaterials;
  final List<String> requiredTools;

  const CraftingInfo({
    required this.descriptionKey,
    this.timeRequired,
    this.goldCost,
    this.requiredMaterials = const [],
    this.requiredTools = const [],
  });

  factory CraftingInfo.fromJson(Map<String, dynamic> json) {
    return CraftingInfo(
      descriptionKey: json['descriptionKey'] as String,
      timeRequired: json['timeRequired'] as int?,
      goldCost: json['goldCost'] as int?,
      requiredMaterials: json['requiredMaterials'] != null
          ? List<String>.from(json['requiredMaterials'])
          : [],
      requiredTools: json['requiredTools'] != null
          ? List<String>.from(json['requiredTools'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descriptionKey': descriptionKey,
      if (timeRequired != null) 'timeRequired': timeRequired,
      if (goldCost != null) 'goldCost': goldCost,
      'requiredMaterials': requiredMaterials,
      'requiredTools': requiredTools,
    };
  }
}