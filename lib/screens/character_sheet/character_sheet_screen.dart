import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';
import 'package:openrpg/data/dnd_rules.dart';
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
      playerName: '',
      classes: [
        CharacterClassLevel(
          characterClass: CharacterClass.fighter,
          subclass: Subclass.none,
          level: 1,
        )
      ],
      race: Race.human,
      background: Background.folkHero,
      moralAlignment: MoralAlignment.neutral,
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
      equippedCombatStats: EquippedCombatStats(
        equippedArmor: EquippedArmor(
          armorType: 'cloth', // or 'light', 'medium', 'heavy'
          baseAC: 10,
          manualBonus: 0,
          usesDexterity: true,
          maxDexBonus: 999,
        ),
        equippedMeleeWeapon: null,
        equippedRangedWeapon: null,
        weaponProficiencies: [],
        armorProficiencies: [],
      ),
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

  void _showSetToExpectedMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildSetToExpectedMenu(context);
      },
    );
  }

  Widget _buildSetToExpectedMenu(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Override with Expected Values',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'WARNING: This will override any custom values and reset to D&D 5e rules.',
            style: TextStyle(
              color: colorScheme.error,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Calculations are based on character classes, total level, and Constitution.',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.star_outline),
                  label: const Text('Override Proficiency Bonus'),
                  onPressed: () {
                    Navigator.pop(context);
                    _showConfirmationDialog(
                      context,
                      'Override Proficiency Bonus',
                      'This will replace your current proficiency bonus (+${_character.proficiencies.proficiencyBonus}) with the expected value for level ${_character.totalLevel} (+${DndRules.calculateProficiencyBonus(_character.totalLevel)}).',
                      _setProficiencyBonusToExpected,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error.withOpacity(0.1),
                    foregroundColor: colorScheme.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.favorite_outline),
                  label: const Text('Override Hit Points'),
                  onPressed: () {
                    Navigator.pop(context);
                    final expectedHP = DndRules.calculateExpectedMaxHP(
                      classes: _character.classes,
                      constitutionScore: _character.abilityScores.constitution,
                    );
                    _showConfirmationDialog(
                      context,
                      'Override Hit Points',
                      'This will replace your current max HP (${_character.health.maxHitPoints}) with the expected value ($expectedHP) based on your classes, total level, and Constitution.',
                      _setHitPointsToExpected,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error.withOpacity(0.1),
                    foregroundColor: colorScheme.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.all_inclusive),
                  label: const Text('Override Both'),
                  onPressed: () {
                    Navigator.pop(context);
                    final expectedBonus = DndRules.calculateProficiencyBonus(_character.totalLevel);
                    final expectedHP = DndRules.calculateExpectedMaxHP(
                      classes: _character.classes,
                      constitutionScore: _character.abilityScores.constitution,
                    );
                    _showConfirmationDialog(
                      context,
                      'Override All',
                      'This will override both proficiency bonus (+${_character.proficiencies.proficiencyBonus} → +$expectedBonus) and hit points (${_character.health.maxHitPoints} → $expectedHP) with expected values.',
                      _setBothToExpected,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close confirmation
              onConfirm(); // Execute the override
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Override'),
          ),
        ],
      ),
    );
  }

  void _setProficiencyBonusToExpected() {
    final expectedBonus = DndRules.calculateProficiencyBonus(_character.totalLevel);

    final newProficiencies = _character.proficiencies.copyWith(
      proficiencyBonus: expectedBonus,
    );

    final newCharacter = _character.copyWith(
      proficiencies: newProficiencies,
    );

    _updateCharacter(newCharacter);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proficiency bonus overridden and set to +$expectedBonus (level ${_character.totalLevel})'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _setHitPointsToExpected() {
    final expectedHP = DndRules.calculateExpectedMaxHP(
      classes: _character.classes,
      constitutionScore: _character.abilityScores.constitution,
    );

    final newHealth = _character.health.copyWith(
      maxHitPoints: expectedHP,
      // Keep current HP if it's less than new max, otherwise cap it
      currentHitPoints: _character.health.currentHitPoints > expectedHP
          ? expectedHP
          : _character.health.currentHitPoints,
    );

    final newCharacter = _character.copyWith(
      health: newHealth,
    );

    _updateCharacter(newCharacter);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Max HP overridden and set to $expectedHP (multiclass calculation)'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _setBothToExpected() {
    _setProficiencyBonusToExpected();
    _setHitPointsToExpected();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _character.name.isEmpty ? 'New Character' : _character.name,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              'Level ${_character.totalLevel} ${_character.classes.map((c) => '${c.characterClass.displayName} ${c.level}').join('/')}',
              style: TextStyle(
                color: colorScheme.onPrimary.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
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
            icon: const Icon(Icons.calculate_outlined),
            onPressed: _showSetToExpectedMenu,
            tooltip: 'Set to Expected',
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