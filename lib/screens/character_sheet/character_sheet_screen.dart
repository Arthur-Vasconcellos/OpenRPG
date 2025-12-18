import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';
import 'package:openrpg/screens/character_sheet/tabs/core_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/combat_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/equipment_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/spells_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/features_tab.dart';
import 'package:openrpg/screens/character_sheet/tabs/notes_tab.dart';
import 'package:openrpg/screens/character_sheet/dialogs/level_up_dialog.dart';
import 'package:openrpg/screens/magic_item_list_screen.dart';

class CharacterSheetScreen extends StatefulWidget {
  const CharacterSheetScreen({super.key});

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Character _character = _createDefaultCharacter();

  static Character _createDefaultCharacter() {
    final abilityScores = AbilityScores(
      strength: 10,
      dexterity: 10,
      constitution: 10,
      intelligence: 10,
      wisdom: 10,
      charisma: 10,
    );

    final proficiencies = ProficiencySet(
      proficiencyBonus: 2,
      skills: SkillProficiencies(proficiencies: {}),
      savingThrows: SavingThrowProficiencies(),
      languages: [],
      tools: [],
      weapons: [],
      armor: [],
      other: [],
    );

    final combatStats = CombatStats(
      armorClass: 10,
      initiative: 0,
      speed: 30,
      proficiencyBonus: 2,
      passivePerception: 10,
      passiveInsight: 10,
      passiveInvestigation: 10,
    );

    final health = Health(
      maxHitPoints: 10,
      currentHitPoints: 10,
      temporaryHitPoints: 0,
      hitDice: [],
      deathSaves: DeathSaves(),
      exhaustionLevel: 0,
    );

    final equipment = Equipment(
      inventory: [],
      weapons: [],
      armor: [],
      totalWeight: 0,
    );

    final wealth = Wealth();

    final traits = Traits();

    final physicalDescription = PhysicalDescription();

    final notes = Notes();

    return Character(
      id: '1',
      name: 'New Character',
      characterClass: CharacterClass.fighter,
      subclass: Subclass.none,
      race: Race.human,
      background: Background.folkHero,
      moralAlignment: MoralAlignment.neutral,
      level: 1,
      experiencePoints: 0,
      inspiration: 0,
      abilityScores: abilityScores,
      modifiers: CalculatedModifiers(
        strength: 0,
        dexterity: 0,
        constitution: 0,
        intelligence: 0,
        wisdom: 0,
        charisma: 0,
      ),
      proficiencies: proficiencies,
      combatStats: combatStats,
      health: health,
      equipment: equipment,
      wealth: wealth,
      spellcasting: null,
      traits: traits,
      features: [],
      racialTraits: [],
      backgroundTraits: [],
      physicalDescription: physicalDescription,
      notes: notes,
    ).copyWithCalculatedValues();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  void _navigateToMagicItems() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MagicItemListScreen(),
      ),
    );
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (context) => LevelUpDialog(
        character: _character,
        onLevelUp: () {
          // TODO: Implement level up logic
          setState(() {});
        },
      ),
    );
  }

  void _updateCharacter(Character newCharacter) {
    setState(() {
      _character = newCharacter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _character.name.isEmpty ? 'New Character' : _character.name,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Character saved'),
                  backgroundColor: colorScheme.primary,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome_outlined),
            onPressed: _navigateToMagicItems,
            tooltip: 'Magic Items',
          ),
          IconButton(
            icon: const Icon(Icons.trending_up_outlined),
            onPressed: _showLevelUpDialog,
            tooltip: 'Level Up',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: colorScheme.primary,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(icon: Icon(Icons.person_outline), text: 'Core'),
                Tab(icon: Icon(Icons.shield_outlined), text: 'Combat'),
                Tab(icon: Icon(Icons.backpack_outlined), text: 'Equipment'),
                Tab(icon: Icon(Icons.auto_awesome_outlined), text: 'Spells'),
                Tab(icon: Icon(Icons.star_outline), text: 'Features'),
                Tab(icon: Icon(Icons.notes_outlined), text: 'Notes'),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: colorScheme.surfaceVariant.withOpacity(0.1),
        child: TabBarView(
          controller: _tabController,
          children: [
            CoreTab(
              character: _character,
              onCharacterUpdated: _updateCharacter,
            ),
            CombatTab(
              character: _character,
              onCharacterUpdated: _updateCharacter,
            ),
            EquipmentTab(
              character: _character,
              onCharacterUpdated: _updateCharacter,
            ),
            SpellsTab(
              character: _character,
              onCharacterUpdated: _updateCharacter,
            ),
            FeaturesTab(
              character: _character,
              onCharacterUpdated: _updateCharacter,
            ),
            NotesTab(
              character: _character,
              onCharacterUpdated: _updateCharacter,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}