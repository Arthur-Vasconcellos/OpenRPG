import '../models/magic_item.dart';
import '../models/enums.dart';

class SampleMagicItems {
  static List<MagicItem> get allItems => [
    _createLongswordPlus1(),
    _createWandOfWonder(),
    _createBagOfBeans(),
    _createAmuletOfHealth(),
    _createDragonSlayerLongsword(),
    _createCursedItem(),
    _createStaffOfHealing(),
  ];

  static MagicItem _createLongswordPlus1() {
    return MagicItem(
      id: "longsword_plus_1",
      nameKey: "longsword_plus_1_name",
      category: MagicItemCategory.weapon,
      rarity: Rarity.uncommon,
      requiresAttunement: false,
      descriptionKey: "longsword_plus_1_description",
      numericalValues: NumericalValues(
        attackBonus: 1,
        damageBonus: 1,
      ),
    );
  }

  static MagicItem _createWandOfWonder() {
    return MagicItem(
      id: "wand_of_wonder",
      nameKey: "wand_of_wonder_name",
      category: MagicItemCategory.wand,
      rarity: Rarity.rare,
      requiresAttunement: true,
      descriptionKey: "wand_of_wonder_description",
      charges: ChargeInfo(
        max: 7,
        recharge: Recharge(RechargeRate.dawn, "1d6+1"),
      ),
      actions: [
        ItemAction(
          type: ActionType.magicAction,
          descriptionKey: "wand_of_wonder_activate",
          cost: ActionCost.charge(1),
          effect: Effect.tableRoll("wand_of_wonder_effects"),
        ),
      ],
      randomTables: [
        RandomTable(
          id: "wand_of_wonder_effects",
          nameKey: "wand_of_wonder_effects_name",
          diceRoll: DiceRoll.d100(),
          entries: [
            TableEntry(
              range: "01-20",
              effect: TableEffect(
                descriptionKey: "wand_of_wonder_effect_01_20",
                components: [
                  EffectComponent(
                    type: EffectType.custom,
                    value: "Random spell from sub-table",
                  ),
                ],
              ),
            ),
            TableEntry(
              range: "21-25",
              effect: TableEffect(
                descriptionKey: "wand_of_wonder_effect_21_25",
                components: [
                  EffectComponent(
                    type: EffectType.condition,
                    value: "Stunned",
                  ),
                ],
              ),
            ),
            TableEntry(
              range: "26-30",
              effect: TableEffect(
                descriptionKey: "wand_of_wonder_effect_26_30",
                components: [
                  EffectComponent(
                    type: EffectType.spell,
                    value: "Gust of Wind",
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static MagicItem _createBagOfBeans() {
    return MagicItem(
      id: "bag_of_beans",
      nameKey: "bag_of_beans_name",
      category: MagicItemCategory.wondrousItem,
      rarity: Rarity.rare,
      requiresAttunement: false,
      descriptionKey: "bag_of_beans_description",
      randomTables: [
        RandomTable(
          id: "bag_of_beans_effects",
          nameKey: "bag_of_beans_effects_name",
          diceRoll: DiceRoll.d100(),
          entries: [
            TableEntry(
              range: "01",
              effect: TableEffect(
                descriptionKey: "bag_of_beans_effect_01",
                components: [
                  EffectComponent(
                    type: EffectType.custom,
                    value: "5d4 toadstools with special properties",
                  ),
                ],
              ),
            ),
            TableEntry(
              range: "02-10",
              effect: TableEffect(
                descriptionKey: "bag_of_beans_effect_02_10",
                components: [
                  EffectComponent(
                    type: EffectType.custom,
                    value: "Geyser of liquid",
                  ),
                ],
              ),
            ),
            TableEntry(
              range: "11-20",
              effect: TableEffect(
                descriptionKey: "bag_of_beans_effect_11_20",
                components: [
                  EffectComponent(
                    type: EffectType.creature,
                    value: "Treant",
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static MagicItem _createAmuletOfHealth() {
    return MagicItem(
      id: "amulet_of_health",
      nameKey: "amulet_of_health_name",
      descriptionKey: "amulet_of_health_description",
      category: MagicItemCategory.wondrousItem,
      rarity: Rarity.rare,
      requiresAttunement: true,
      numericalValues: NumericalValues(
        abilityScores: {"constitution": 19},
      ),
      properties: [
        ItemProperty(
          type: "ability_score",
          value: 19,
          target: "constitution",
          condition: "if_lower_than_19",
        ),
      ],
    );
  }

  static MagicItem _createDragonSlayerLongsword() {
    return MagicItem(
      id: "dragon_slayer_longsword",
      nameKey: "dragon_slayer_longsword_name",
      category: MagicItemCategory.weapon,
      rarity: Rarity.rare,
      requiresAttunement: true,
      descriptionKey: "dragon_slayer_longsword_description",
      numericalValues: NumericalValues(
        attackBonus: 1,
        damageBonus: 1,
      ),
      properties: [
        ItemProperty(
          type: "dragon_slayer",
          value: "extra_damage",
          target: "dragons",
        ),
      ],
      actions: [
        ItemAction(
          type: ActionType.action,
          descriptionKey: "dragon_slayer_attack",
          cost: ActionCost.action(),
          effect: Effect.damage(
            Damage(
              dice: "3d6",
              type: DamageType.slashing,
            ),
          ),
        ),
      ],
    );
  }

  static MagicItem _createCursedItem() {
    return MagicItem(
      id: "berserker_axe",
      nameKey: "berserker_axe_name",
      category: MagicItemCategory.weapon,
      rarity: Rarity.uncommon,
      requiresAttunement: true,
      descriptionKey: "berserker_axe_description",
      numericalValues: NumericalValues(
        attackBonus: 1,
        damageBonus: 1,
      ),
      curse: Curse(
        descriptionKey: "berserker_axe_curse_description",
        effects: [
          Effect.condition("Cursed - cannot be removed willingly"),
          Effect.condition("Must attack nearest creature while raging"),
        ],
      ),
    );
  }

  static MagicItem _createStaffOfHealing() {
    return MagicItem(
      id: "staff_of_healing",
      nameKey: "staff_of_healing_name",
      category: MagicItemCategory.staff,
      rarity: Rarity.rare,
      requiresAttunement: true,
      attunementPrerequisites: "by a cleric, druid, or bard",
      descriptionKey: "staff_of_healing_description",
      charges: ChargeInfo(
        max: 10,
        recharge: Recharge(RechargeRate.dawn, "1d6+4"),
      ),
      actions: [
        ItemAction(
          type: ActionType.action,
          descriptionKey: "staff_of_healing_cure_wounds",
          cost: ActionCost.charge(1),
          effect: Effect.spell("Cure Wounds"),
        ),
        ItemAction(
          type: ActionType.action,
          descriptionKey: "staff_of_healing_lesser_restoration",
          cost: ActionCost.charge(2),
          effect: Effect.spell("Lesser Restoration"),
        ),
      ],
      craftingInfo: CraftingInfo(
        descriptionKey: "staff_of_healing_crafting_description",
        timeRequired: 30,
        goldCost: 5000,
        requiredMaterials: [
          "Diamond worth 1000 GP",
          "Staff carved from blessed oak",
          "Holy water blessed by a high priest",
        ],
      ),
    );
  }
}