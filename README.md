# openrpg

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
So.... We basically need to redo the entire app. After much deliberation, I decided against using the API, since it's too limited and out of our control. Instead, we'll keep the entire SRD rulebook locally, stored in new and appropriate data classes. That, in addition to some decisions I made during early development, led me to the sad conclusion that the best way is to restart from scratch. That being said, I've already started the new project, and already have a few things, but I need you to do everything from the start. Create the UI for the initial screen. Don't worry about navigation for now. We need to implement this type of object:

class MagicItem {
final String id;
final String nameKey;
final MagicItemCategory category;
final Rarity rarity;
final bool requiresAttunement;
final String? attunementPrerequisites;
final String descriptionKey;

// Core properties that apply to many items
final NumericalValues? numericalValues;
final List<ItemProperty> properties;
final List<ItemAction> actions;
final Curse? curse;

// Charge system for items with limited uses
final ChargeInfo? charges;

// Random tables for items with rollable effects
final List<RandomTable>? randomTables;

// Crafting information
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
}

class TableEntry {
final String range; // "01-05", "96-00", "5"
final TableEffect effect;

const TableEntry({
required this.range,
required this.effect,
});
}

class TableEffect {
final String descriptionKey;
final List<EffectComponent> components;

const TableEffect({
required this.descriptionKey,
this.components = const [],
});
}

class EffectComponent {
final EffectType type;
final dynamic value;

const EffectComponent({
required this.type,
required this.value,
});
}

enum EffectType {
damage,           // value: Damage object
condition,        // value: String (condition name)
spell,            // value: String (spell name)
creature,         // value: String (creature name)
item,             // value: ItemReward object
abilityModifier,  // value: AbilityScoreChange object
custom,           // value: String (custom effect description)
}

// Supporting classes for effect components
class Damage {
final String dice; // "5d4", "2d10"
final DamageType type;
final int? saveDC;
final String? saveType; // "Dexterity", "Constitution"

const Damage({
required this.dice,
required this.type,
this.saveDC,
this.saveType,
});
}

class ItemReward {
final String itemId; // Reference to another magic item
final int quantity;
final int? value; // GP value if not a magic item

const ItemReward({
required this.itemId,
this.quantity = 1,
this.value,
});
}

class AbilityScoreChange {
final String ability; // "strength", "constitution"
final int value;
final bool isPermanent;

const AbilityScoreChange({
required this.ability,
required this.value,
this.isPermanent = false,
});
}


And we have these examples



