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

enum MoralAlignment {
  lawfulGood('lawful_good', 'Lawful Good'),
  neutralGood('neutral_good', 'Neutral Good'),
  chaoticGood('chaotic_good', 'Chaotic Good'),
  lawfulNeutral('lawful_neutral', 'Lawful Neutral'),
  neutral('neutral', 'Neutral'),
  chaoticNeutral('chaotic_neutral', 'Chaotic Neutral'),
  lawfulEvil('lawful_evil', 'Lawful Evil'),
  neutralEvil('neutral_evil', 'Neutral Evil'),
  chaoticEvil('chaotic_evil', 'Chaotic Evil');

  const MoralAlignment(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum CommunicationType {
  emotions('emotions'),
  speech('speech'),
  telepathy('telepathy');

  const CommunicationType(this.value);

  final String value;
}

// Character-related enums
enum CharacterClass {
  barbarian('barbarian', 'Barbarian', '1d12'),
  bard('bard', 'Bard', '1d8'),
  cleric('cleric', 'Cleric', '1d8'),
  druid('druid', 'Druid', '1d8'),
  fighter('fighter', 'Fighter', '1d10'),
  monk('monk', 'Monk', '1d8'),
  paladin('paladin', 'Paladin', '1d10'),
  ranger('ranger', 'Ranger', '1d10'),
  rogue('rogue', 'Rogue', '1d8'),
  sorcerer('sorcerer', 'Sorcerer', '1d6'),
  warlock('warlock', 'Warlock', '1d8'),
  wizard('wizard', 'Wizard', '1d6'),
  artificer('artificer', 'Artificer', '1d8'),
  bloodHunter('bloodHunter', 'Blood Hunter', '1d10'),
  custom('custom', 'Custom', '1d8');

  final String value;
  final String displayName;
  final String hitDie;

  const CharacterClass(this.value, this.displayName, this.hitDie);
}

enum Race {
  dragonborn('dragonborn', 'Dragonborn'),
  dwarf('dwarf', 'Dwarf'),
  elf('elf', 'Elf'),
  gnome('gnome', 'Gnome'),
  halfElf('halfElf', 'Half-Elf'),
  halfling('halfling', 'Halfling'),
  halfOrc('halfOrc', 'Half-Orc'),
  human('human', 'Human'),
  tiefling('tiefling', 'Tiefling'),
  aarakocra('aarakocra', 'Aarakocra'),
  genasi('genasi', 'Genasi'),
  goliath('goliath', 'Goliath'),
  aasimar('aasimar', 'Aasimar'),
  bugbear('bugbear', 'Bugbear'),
  goblin('goblin', 'Goblin'),
  hobgoblin('hobgoblin', 'Hobgoblin'),
  kenku('kenku', 'Kenku'),
  kobold('kobold', 'Kobold'),
  lizardfolk('lizardfolk', 'Lizardfolk'),
  orc('orc', 'Orc'),
  tabaxi('tabaxi', 'Tabaxi'),
  triton('triton', 'Triton'),
  yuanTi('yuanTi', 'Yuan-ti'),
  firbolg('firbolg', 'Firbolg'),
  tortle('tortle', 'Tortle'),
  changeling('changeling', 'Changeling'),
  kalashtar('kalashtar', 'Kalashtar'),
  shifter('shifter', 'Shifter'),
  warforged('warforged', 'Warforged'),
  gith('gith', 'Gith'),
  centaur('centaur', 'Centaur'),
  loxodon('loxodon', 'Loxodon'),
  minotaur('minotaur', 'Minotaur'),
  simicHybrid('simicHybrid', 'Simic Hybrid'),
  vedalken('vedalken', 'Vedalken'),
  custom('custom', 'Custom');

  final String value;
  final String displayName;

  const Race(this.value, this.displayName);
}

enum Background {
  acolyte('acolyte', 'Acolyte'),
  charlatan('charlatan', 'Charlatan'),
  criminal('criminal', 'Criminal'),
  entertainer('entertainer', 'Entertainer'),
  folkHero('folkHero', 'Folk Hero'),
  guildArtisan('guildArtisan', 'Guild Artisan'),
  hermit('hermit', 'Hermit'),
  noble('noble', 'Noble'),
  outlander('outlander', 'Outlander'),
  sage('sage', 'Sage'),
  sailor('sailor', 'Sailor'),
  soldier('soldier', 'Soldier'),
  urchin('urchin', 'Urchin'),
  pirate('pirate', 'Pirate'),
  knight('knight', 'Knight'),
  mercenaryVeteran('mercenaryVeteran', 'Mercenary Veteran'),
  cityWatch('cityWatch', 'City Watch'),
  investigator('investigator', 'Investigator'),
  courtier('courtier', 'Courtier'),
  spy('spy', 'Spy'),
  archaeologist('archaeologist', 'Archaeologist'),
  anthropologist('anthropologist', 'Anthropologist'),
  gladiator('gladiator', 'Gladiator'),
  smuggler('smuggler', 'Smuggler'),
  gambler('gambler', 'Gambler'),
  hauntedOne('hauntedOne', 'Haunted One'),
  custom('custom', 'Custom');

  final String value;
  final String displayName;

  const Background(this.value, this.displayName);
}

enum Subclass {
  // Barbarian
  berserker('berserker', 'Berserker'),
  totemWarrior('totemWarrior', 'Totem Warrior'),
  ancestralGuardian('ancestralGuardian', 'Ancestral Guardian'),
  stormHerald('stormHerald', 'Storm Herald'),
  zealot('zealot', 'Zealot'),
  beast('beast', 'Beast'),
  wildMagic('wildMagic', 'Wild Magic'),

  // Bard
  lore('lore', 'Lore'),
  valor('valor', 'Valor'),
  swords('swords', 'Swords'),
  whispers('whispers', 'Whispers'),
  creation('creation', 'Creation'),
  eloquence('eloquence', 'Eloquence'),
  spirits('spirits', 'Spirits'),

  // Cleric
  life('life', 'Life'),
  light('light', 'Light'),
  knowledge('knowledge', 'Knowledge'),
  nature('nature', 'Nature'),
  tempest('tempest', 'Tempest'),
  trickery('trickery', 'Trickery'),
  war('war', 'War'),
  arcana('arcana', 'Arcana'),
  forge('forge', 'Forge'),
  grave('grave', 'Grave'),
  order('order', 'Order'),
  peace('peace', 'Peace'),
  twilight('twilight', 'Twilight'),

  // Continue with other classes...
  none('none', 'None');

  final String value;
  final String displayName;

  const Subclass(this.value, this.displayName);
}

enum ArmorType {
  light('light'),
  medium('medium'),
  heavy('heavy'),
  shield('shield');

  final String value;

  const ArmorType(this.value);
}

enum Skill {
  acrobatics('acrobatics', 'Acrobatics'),
  animalHandling('animalHandling', 'Animal Handling'),
  arcana('arcana', 'Arcana'),
  athletics('athletics', 'Athletics'),
  deception('deception', 'Deception'),
  history('history', 'History'),
  insight('insight', 'Insight'),
  intimidation('intimidation', 'Intimidation'),
  investigation('investigation', 'Investigation'),
  medicine('medicine', 'Medicine'),
  nature('nature', 'Nature'),
  perception('perception', 'Perception'),
  performance('performance', 'Performance'),
  persuasion('persuasion', 'Persuasion'),
  religion('religion', 'Religion'),
  sleightOfHand('sleightOfHand', 'Sleight of Hand'),
  stealth('stealth', 'Stealth'),
  survival('survival', 'Survival');

  final String value;
  final String displayName;

  const Skill(this.value, this.displayName);
}

enum ProficiencyLevel {
  none('none', 'None'),
  proficient('proficient', 'Proficient'),
  expert('expert', 'Expert'),
  jackOfAllTrades('jackOfAllTrades', 'Jack of All Trades');

  final String value;
  final String displayName;

  const ProficiencyLevel(this.value, this.displayName);
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
  if (enumValue is CharacterClass && enumValue.value == value)
  return enumValue;
  if (enumValue is Race && enumValue.value == value) return enumValue;
  if (enumValue is Background && enumValue.value == value) return enumValue;
  // Remove Alignment from here since we're using MoralAlignment
  if (enumValue is Subclass && enumValue.value == value) return enumValue;
  if (enumValue is Skill && enumValue.value == value) return enumValue;
  if (enumValue is ProficiencyLevel && enumValue.value == value)
  return enumValue;
  if (enumValue is ArmorType && enumValue.value == value) return enumValue;
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

  static CharacterClass characterClass(String value) =>
      fromString(CharacterClass.values, value);

  static Race race(String value) => fromString(Race.values, value);

  static Background background(String value) =>
      fromString(Background.values, value);

  static Subclass subclass(String value) => fromString(Subclass.values, value);

  static Skill skill(String value) => fromString(Skill.values, value);

  static ProficiencyLevel proficiencyLevel(String value) =>
      fromString(ProficiencyLevel.values, value);
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
