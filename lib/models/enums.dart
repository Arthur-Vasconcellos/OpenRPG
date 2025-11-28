// Enum definitions with string values for JSON serialization
enum MagicItemCategory {
  weapon('weapon'),
  armor('armor'),
  potion('potion'),
  ring('ring'),
  rod('rod'),
  staff('staff'),
  wand('wand'),
  wondrousItem('wondrousItem'),
  scroll('scroll'),
  ammunition('ammunition');

  const MagicItemCategory(this.value);

  final String value;
}

enum Rarity {
  common('common'),
  uncommon('uncommon'),
  rare('rare'),
  veryRare('veryRare'),
  legendary('legendary'),
  artifact('artifact');

  const Rarity(this.value);

  final String value;
}

enum ActionType {
  action('action'),
  bonusAction('bonusAction'),
  reaction('reaction'),
  magicAction('magicAction'),
  utilizeAction('utilizeAction'),
  specialMovement('specialMovement'),
  other('other');

  const ActionType(this.value);

  final String value;
}

enum ActionCostType {
  charge('charge'),
  action('action'),
  bonusAction('bonusAction'),
  specialMovement('specialMovement'),
  reaction('reaction');

  const ActionCostType(this.value);

  final String value;
}

enum EffectType {
  tableRoll('tableRoll'),
  damage('damage'),
  condition('condition'),
  spell('spell'),
  custom('custom'),
  creature('creature');

  const EffectType(this.value);

  final String value;
}

enum DamageType {
  acid('acid'),
  cold('cold'),
  fire('fire'),
  force('force'),
  lightning('lightning'),
  necrotic('necrotic'),
  poison('poison'),
  psychic('psychic'),
  radiant('radiant'),
  thunder('thunder'),
  bludgeoning('bludgeoning'),
  piercing('piercing'),
  slashing('slashing');

  const DamageType(this.value);

  final String value;
}

enum CreatureType {
  aberration('aberration'),
  beast('beast'),
  celestial('celestial'),
  construct('construct'),
  dragon('dragon'),
  elemental('elemental'),
  fey('fey'),
  fiend('fiend'),
  giant('giant'),
  humanoid('humanoid'),
  monstrosity('monstrosity'),
  ooze('ooze'),
  plant('plant'),
  undead('undead');

  const CreatureType(this.value);

  final String value;
}

enum RechargeRate {
  dawn('dawn'),
  dusk('dusk'),
  sunrise('sunrise'),
  sunset('sunset'),
  daily('daily'),
  weekly('weekly'),
  monthly('monthly'),
  never('never');

  const RechargeRate(this.value);

  final String value;
}

// Generic enum parsing utilities
class EnumParser {
  static T fromString<T extends Enum>(List<T> values, String value) {
    for (T enumValue in values) {
      if (enumValue is MagicItemCategory && enumValue.value == value)
        return enumValue;
      if (enumValue is Rarity && enumValue.value == value) return enumValue;
      if (enumValue is ActionType && enumValue.value == value) return enumValue;
      if (enumValue is ActionCostType && enumValue.value == value)
        return enumValue;
      if (enumValue is EffectType && enumValue.value == value) return enumValue;
      if (enumValue is DamageType && enumValue.value == value) return enumValue;
      if (enumValue is CreatureType && enumValue.value == value)
        return enumValue;
      if (enumValue is RechargeRate && enumValue.value == value)
        return enumValue;
      if (enumValue is MoralAlignment && enumValue.value == value)
        return enumValue;
      if (enumValue is CommunicationType && enumValue.value == value)
        return enumValue;
    }
    throw ArgumentError('Unknown enum value: $value for type ${T.toString()}');
  }

  // Convenience methods for each enum type
  static MagicItemCategory magicItemCategory(String value) =>
      fromString(MagicItemCategory.values, value);

  static Rarity rarity(String value) => fromString(Rarity.values, value);

  static ActionType actionType(String value) =>
      fromString(ActionType.values, value);

  static ActionCostType actionCostType(String value) =>
      fromString(ActionCostType.values, value);

  static EffectType effectType(String value) =>
      fromString(EffectType.values, value);

  static DamageType damageType(String value) =>
      fromString(DamageType.values, value);

  static CreatureType creatureType(String value) =>
      fromString(CreatureType.values, value);

  static RechargeRate rechargeRate(String value) =>
      fromString(RechargeRate.values, value);

  static MoralAlignment moralAlignment(String value) =>
      fromString(MoralAlignment.values, value);

  static CommunicationType communicationType(String value) =>
      fromString(CommunicationType.values, value);
}

// Add to enums.dart
enum MoralAlignment {
  lawfulGood('lawful_good'),
  neutralGood('neutral_good'),
  chaoticGood('chaotic_good'),
  lawfulNeutral('lawful_neutral'),
  neutral('neutral'),
  chaoticNeutral('chaotic_neutral'),
  lawfulEvil('lawful_evil'),
  neutralEvil('neutral_evil'),
  chaoticEvil('chaotic_evil');

  const MoralAlignment(this.value);

  final String value;
}

enum CommunicationType {
  emotions('emotions'),
  speech('speech'),
  telepathy('telepathy');

  const CommunicationType(this.value);

  final String value;
}

// DiceRoll class with JSON support
class DiceRoll {
  final int sides;
  final int count;

  const DiceRoll(this.sides, [this.count = 1]);

  const DiceRoll.d4([this.count = 1]) : sides = 4;

  const DiceRoll.d6([this.count = 1]) : sides = 6;

  const DiceRoll.d8([this.count = 1]) : sides = 8;

  const DiceRoll.d10([this.count = 1]) : sides = 10;

  const DiceRoll.d12([this.count = 1]) : sides = 12;

  const DiceRoll.d20([this.count = 1]) : sides = 20;

  const DiceRoll.d100([this.count = 1]) : sides = 100;

  factory DiceRoll.fromJson(Map<String, dynamic> json) {
    return DiceRoll(json['sides'] as int, json['count'] as int? ?? 1);
  }

  Map<String, dynamic> toJson() => {'sides': sides, 'count': count};

  @override
  String toString() => count > 1 ? '${count}d$sides' : 'd$sides';
}
