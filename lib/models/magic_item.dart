import 'enums.dart';

class MagicItem {
  final String id;
  final String nameKey;
  final MagicItemCategory category;
  final Rarity rarity;
  final bool requiresAttunement;
  final String? attunementPrerequisites;
  final String descriptionKey;
  final NumericalValues? numericalValues;
  final List<ItemProperty> properties;
  final List<ItemAction> actions;
  final Curse? curse;
  final ChargeInfo? charges;
  final List<RandomTable>? randomTables;
  final CraftingInfo? craftingInfo;

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
    this.charges,
    this.randomTables,
    this.craftingInfo,
  });

  factory MagicItem.fromJson(Map<String, dynamic> json) {
    return MagicItem(
      id: json['id'] as String,
      nameKey: json['nameKey'] as String,
      category: EnumParser.magicItemCategory(json['category'] as String),
      rarity: EnumParser.rarity(json['rarity'] as String),
      requiresAttunement: json['requiresAttunement'] as bool,
      attunementPrerequisites: json['attunementPrerequisites'] as String?,
      descriptionKey: json['descriptionKey'] as String,
      numericalValues: json['numericalValues'] != null
          ? NumericalValues.fromJson(json['numericalValues'])
          : null,
      properties: json['properties'] != null
          ? (json['properties'] as List)
          .map((e) => ItemProperty.fromJson(e))
          .toList()
          : [],
      actions: json['actions'] != null
          ? (json['actions'] as List)
          .map((e) => ItemAction.fromJson(e))
          .toList()
          : [],
      curse: json['curse'] != null ? Curse.fromJson(json['curse']) : null,
      charges: json['charges'] != null
          ? ChargeInfo.fromJson(json['charges'])
          : null,
      randomTables: json['randomTables'] != null
          ? (json['randomTables'] as List)
          .map((e) => RandomTable.fromJson(e))
          .toList()
          : null,
      craftingInfo: json['craftingInfo'] != null
          ? CraftingInfo.fromJson(json['craftingInfo'])
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
        'attunementPrerequisites': attunementPrerequisites,
      'descriptionKey': descriptionKey,
      if (numericalValues != null) 'numericalValues': numericalValues!.toJson(),
      'properties': properties.map((e) => e.toJson()).toList(),
      'actions': actions.map((e) => e.toJson()).toList(),
      if (curse != null) 'curse': curse!.toJson(),
      if (charges != null) 'charges': charges!.toJson(),
      if (randomTables != null)
        'randomTables': randomTables!.map((e) => e.toJson()).toList(),
      if (craftingInfo != null) 'craftingInfo': craftingInfo!.toJson(),
    };
  }
}

class NumericalValues {
  final int? attackBonus;
  final int? damageBonus;
  final int? acBonus;
  final int? savingThrowBonus;
  final Map<String, int>? abilityScores;
  final int? skillBonus;
  final String? skillType;

  const NumericalValues({
    this.attackBonus,
    this.damageBonus,
    this.acBonus,
    this.savingThrowBonus,
    this.abilityScores,
    this.skillBonus,
    this.skillType,
  });

  factory NumericalValues.fromJson(Map<String, dynamic> json) {
    return NumericalValues(
      attackBonus: json['attackBonus'] as int?,
      damageBonus: json['damageBonus'] as int?,
      acBonus: json['acBonus'] as int?,
      savingThrowBonus: json['savingThrowBonus'] as int?,
      abilityScores: json['abilityScores'] != null
          ? Map<String, int>.from(json['abilityScores'])
          : null,
      skillBonus: json['skillBonus'] as int?,
      skillType: json['skillType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (attackBonus != null) 'attackBonus': attackBonus,
      if (damageBonus != null) 'damageBonus': damageBonus,
      if (acBonus != null) 'acBonus': acBonus,
      if (savingThrowBonus != null) 'savingThrowBonus': savingThrowBonus,
      if (abilityScores != null) 'abilityScores': abilityScores,
      if (skillBonus != null) 'skillBonus': skillBonus,
      if (skillType != null) 'skillType': skillType,
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

  const ItemAction({
    required this.type,
    required this.descriptionKey,
    required this.cost,
    required this.effect,
  });

  factory ItemAction.fromJson(Map<String, dynamic> json) {
    return ItemAction(
      type: EnumParser.actionType(json['type'] as String),
      descriptionKey: json['descriptionKey'] as String,
      cost: ActionCost.fromJson(json['cost']),
      effect: Effect.fromJson(json['effect']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'descriptionKey': descriptionKey,
      'cost': cost.toJson(),
      'effect': effect.toJson(),
    };
  }
}

class ActionCost {
  final ActionCostType type;
  final dynamic value;

  const ActionCost({required this.type, required this.value});

  const ActionCost.charge(int charges)
      : type = ActionCostType.charge,
        value = charges;
  const ActionCost.action()
      : type = ActionCostType.action,
        value = null;
  const ActionCost.bonusAction()
      : type = ActionCostType.bonusAction,
        value = null;
  const ActionCost.reaction()
      : type = ActionCostType.reaction,
        value = null;

  factory ActionCost.fromJson(Map<String, dynamic> json) {
    return ActionCost(
      type: EnumParser.actionCostType(json['type'] as String),
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

  const Effect({required this.type, required this.value});

  const Effect.tableRoll(String tableId)
      : type = EffectType.tableRoll,
        value = tableId;
  const Effect.damage(Damage damage)
      : type = EffectType.damage,
        value = damage;
  const Effect.condition(String condition)
      : type = EffectType.condition,
        value = condition;
  const Effect.spell(String spellName)
      : type = EffectType.spell,
        value = spellName;
  const Effect.custom(String description)
      : type = EffectType.custom,
        value = description;

  factory Effect.fromJson(Map<String, dynamic> json) {
    return Effect(
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

class ChargeInfo {
  final int max;
  final Recharge recharge;

  const ChargeInfo({
    required this.max,
    required this.recharge,
  });

  factory ChargeInfo.fromJson(Map<String, dynamic> json) {
    return ChargeInfo(
      max: json['max'] as int,
      recharge: Recharge.fromJson(json['recharge']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max': max,
      'recharge': recharge.toJson(),
    };
  }
}

class Recharge {
  final RechargeRate rate;
  final String? dice;

  const Recharge(this.rate, [this.dice]);

  factory Recharge.fromJson(Map<String, dynamic> json) {
    return Recharge(
      EnumParser.rechargeRate(json['rate'] as String),
      json['dice'] as String?,
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
    this.effects = const [],
  });

  factory Curse.fromJson(Map<String, dynamic> json) {
    return Curse(
      descriptionKey: json['descriptionKey'] as String,
      effects: json['effects'] != null
          ? (json['effects'] as List).map((e) => Effect.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descriptionKey': descriptionKey,
      'effects': effects.map((e) => e.toJson()).toList(),
    };
  }
}

class CraftingInfo {
  final String descriptionKey;
  final int? timeRequired;
  final int? goldCost;
  final List<String> requiredMaterials;

  const CraftingInfo({
    required this.descriptionKey,
    this.timeRequired,
    this.goldCost,
    this.requiredMaterials = const [],
  });

  factory CraftingInfo.fromJson(Map<String, dynamic> json) {
    return CraftingInfo(
      descriptionKey: json['descriptionKey'] as String,
      timeRequired: json['timeRequired'] as int?,
      goldCost: json['goldCost'] as int?,
      requiredMaterials: json['requiredMaterials'] != null
          ? List<String>.from(json['requiredMaterials'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descriptionKey': descriptionKey,
      if (timeRequired != null) 'timeRequired': timeRequired,
      if (goldCost != null) 'goldCost': goldCost,
      'requiredMaterials': requiredMaterials,
    };
  }
}

class RandomTable {
  final String id;
  final String nameKey;
  final DiceRoll diceRoll;
  final List<TableEntry> entries;
  final String? descriptionKey;

  const RandomTable({
    required this.id,
    required this.nameKey,
    required this.diceRoll,
    required this.entries,
    this.descriptionKey,
  });

  factory RandomTable.fromJson(Map<String, dynamic> json) {
    return RandomTable(
      id: json['id'] as String,
      nameKey: json['nameKey'] as String,
      diceRoll: DiceRoll.fromJson(json['diceRoll']),
      entries: (json['entries'] as List)
          .map((e) => TableEntry.fromJson(e))
          .toList(),
      descriptionKey: json['descriptionKey'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      'diceRoll': diceRoll.toJson(),
      'entries': entries.map((e) => e.toJson()).toList(),
      if (descriptionKey != null) 'descriptionKey': descriptionKey,
    };
  }
}

class TableEntry {
  final String range;
  final TableEffect effect;

  const TableEntry({
    required this.range,
    required this.effect,
  });

  factory TableEntry.fromJson(Map<String, dynamic> json) {
    return TableEntry(
      range: json['range'] as String,
      effect: TableEffect.fromJson(json['effect']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range,
      'effect': effect.toJson(),
    };
  }
}

class TableEffect {
  final String descriptionKey;
  final List<EffectComponent> components;

  const TableEffect({
    required this.descriptionKey,
    this.components = const [],
  });

  factory TableEffect.fromJson(Map<String, dynamic> json) {
    return TableEffect(
      descriptionKey: json['descriptionKey'] as String,
      components: json['components'] != null
          ? (json['components'] as List)
          .map((e) => EffectComponent.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descriptionKey': descriptionKey,
      'components': components.map((e) => e.toJson()).toList(),
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

class ItemReward {
  final String itemId;
  final int quantity;
  final int? value;

  const ItemReward({
    required this.itemId,
    this.quantity = 1,
    this.value,
  });

  factory ItemReward.fromJson(Map<String, dynamic> json) {
    return ItemReward(
      itemId: json['itemId'] as String,
      quantity: json['quantity'] as int? ?? 1,
      value: json['value'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'quantity': quantity,
      if (value != null) 'value': value,
    };
  }
}

class AbilityScoreChange {
  final String ability;
  final int value;
  final bool isPermanent;

  const AbilityScoreChange({
    required this.ability,
    required this.value,
    this.isPermanent = false,
  });

  factory AbilityScoreChange.fromJson(Map<String, dynamic> json) {
    return AbilityScoreChange(
      ability: json['ability'] as String,
      value: json['value'] as int,
      isPermanent: json['isPermanent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ability': ability,
      'value': value,
      'isPermanent': isPermanent,
    };
  }
}