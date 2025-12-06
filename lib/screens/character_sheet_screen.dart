import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';
import 'magic_item_list_screen.dart';

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
      builder: (context) => AlertDialog(
        title: const Text('Level Up!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Advancing to level ${_character.level + 1}'),
            const SizedBox(height: 16),
            const Text('New Hit Points:'),
            Text('+? HP (+${_character.modifiers.constitution} from CON)'),
            const SizedBox(height: 16),
            const Text('New class features available!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // TODO: Implement level up logic
              });
              Navigator.pop(context);
            },
            child: const Text('Level Up'),
          ),
        ],
      ),
    );
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
            _buildCoreInfoTab(),
            _buildCombatTab(),
            _buildEquipmentTab(),
            _buildSpellsTab(),
            _buildFeaturesTab(),
            _buildNotesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoreInfoTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Character Basics Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'CHARACTER BASICS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: TextEditingController(text: _character.name),
                      decoration: InputDecoration(
                        labelText: 'Character Name',
                        labelStyle: TextStyle(color: colorScheme.onSurface),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorScheme.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                      onChanged: (value) => setState(() {
                        _character = Character(
                          id: _character.id,
                          name: value,
                          characterClass: _character.characterClass,
                          subclass: _character.subclass,
                          race: _character.race,
                          background: _character.background,
                          moralAlignment: _character.moralAlignment,
                          level: _character.level,
                          experiencePoints: _character.experiencePoints,
                          inspiration: _character.inspiration,
                          abilityScores: _character.abilityScores,
                          modifiers: _character.modifiers,
                          proficiencies: _character.proficiencies,
                          combatStats: _character.combatStats,
                          health: _character.health,
                          equipment: _character.equipment,
                          wealth: _character.wealth,
                          spellcasting: _character.spellcasting,
                          traits: _character.traits,
                          features: _character.features,
                          racialTraits: _character.racialTraits,
                          backgroundTraits: _character.backgroundTraits,
                          physicalDescription: _character.physicalDescription,
                          notes: _character.notes,
                          createdAt: _character.createdAt,
                          updatedAt: DateTime.now(),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<CharacterClass>(
                            value: _character.characterClass,
                            decoration: InputDecoration(
                              labelText: 'Class',
                              labelStyle:
                              TextStyle(color: colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: colorScheme.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: CharacterClass.values.map((cls) {
                              return DropdownMenuItem(
                                value: cls,
                                child: Text(
                                  cls.displayName,
                                  style: TextStyle(color: colorScheme.onSurface),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _character = Character(
                                    id: _character.id,
                                    name: _character.name,
                                    characterClass: value,
                                    subclass: Subclass.none,
                                    race: _character.race,
                                    background: _character.background,
                                    moralAlignment: _character.moralAlignment,
                                    level: _character.level,
                                    experiencePoints: _character.experiencePoints,
                                    inspiration: _character.inspiration,
                                    abilityScores: _character.abilityScores,
                                    modifiers: _character.modifiers,
                                    proficiencies: _character.proficiencies,
                                    combatStats: _character.combatStats,
                                    health: _character.health,
                                    equipment: _character.equipment,
                                    wealth: _character.wealth,
                                    spellcasting: null,
                                    traits: _character.traits,
                                    features: [],
                                    racialTraits: _character.racialTraits,
                                    backgroundTraits: _character.backgroundTraits,
                                    physicalDescription:
                                    _character.physicalDescription,
                                    notes: _character.notes,
                                    createdAt: _character.createdAt,
                                    updatedAt: DateTime.now(),
                                  ).copyWithCalculatedValues();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: _character.level.toString()),
                            decoration: InputDecoration(
                              labelText: 'Level',
                              labelStyle:
                              TextStyle(color: colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: colorScheme.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurface,
                            ),
                            onChanged: (value) {
                              final level = int.tryParse(value) ?? _character.level;
                              setState(() {
                                _character = Character(
                                  id: _character.id,
                                  name: _character.name,
                                  characterClass: _character.characterClass,
                                  subclass: _character.subclass,
                                  race: _character.race,
                                  background: _character.background,
                                  moralAlignment: _character.moralAlignment,
                                  level: level.clamp(1, 20),
                                  experiencePoints: _character.experiencePoints,
                                  inspiration: _character.inspiration,
                                  abilityScores: _character.abilityScores,
                                  modifiers: _character.modifiers,
                                  proficiencies: _character.proficiencies,
                                  combatStats: _character.combatStats,
                                  health: _character.health,
                                  equipment: _character.equipment,
                                  wealth: _character.wealth,
                                  spellcasting: _character.spellcasting,
                                  traits: _character.traits,
                                  features: _character.features,
                                  racialTraits: _character.racialTraits,
                                  backgroundTraits: _character.backgroundTraits,
                                  physicalDescription:
                                  _character.physicalDescription,
                                  notes: _character.notes,
                                  createdAt: _character.createdAt,
                                  updatedAt: DateTime.now(),
                                ).copyWithCalculatedValues();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Race>(
                            value: _character.race,
                            decoration: InputDecoration(
                              labelText: 'Race',
                              labelStyle:
                              TextStyle(color: colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: colorScheme.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: Race.values.map((race) {
                              return DropdownMenuItem(
                                value: race,
                                child: Text(
                                  race.displayName,
                                  style: TextStyle(color: colorScheme.onSurface),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _character = Character(
                                    id: _character.id,
                                    name: _character.name,
                                    characterClass: _character.characterClass,
                                    subclass: _character.subclass,
                                    race: value,
                                    background: _character.background,
                                    moralAlignment: _character.moralAlignment,
                                    level: _character.level,
                                    experiencePoints: _character.experiencePoints,
                                    inspiration: _character.inspiration,
                                    abilityScores: _character.abilityScores,
                                    modifiers: _character.modifiers,
                                    proficiencies: _character.proficiencies,
                                    combatStats: _character.combatStats,
                                    health: _character.health,
                                    equipment: _character.equipment,
                                    wealth: _character.wealth,
                                    spellcasting: _character.spellcasting,
                                    traits: _character.traits,
                                    features: _character.features,
                                    racialTraits: [],
                                    backgroundTraits: _character.backgroundTraits,
                                    physicalDescription:
                                    _character.physicalDescription,
                                    notes: _character.notes,
                                    createdAt: _character.createdAt,
                                    updatedAt: DateTime.now(),
                                  ).copyWithCalculatedValues();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<Background>(
                            value: _character.background,
                            decoration: InputDecoration(
                              labelText: 'Background',
                              labelStyle:
                              TextStyle(color: colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: colorScheme.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: Background.values.map((bg) {
                              return DropdownMenuItem(
                                value: bg,
                                child: Text(
                                  bg.displayName,
                                  style: TextStyle(color: colorScheme.onSurface),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _character = Character(
                                    id: _character.id,
                                    name: _character.name,
                                    characterClass: _character.characterClass,
                                    subclass: _character.subclass,
                                    race: _character.race,
                                    background: value,
                                    moralAlignment: _character.moralAlignment,
                                    level: _character.level,
                                    experiencePoints: _character.experiencePoints,
                                    inspiration: _character.inspiration,
                                    abilityScores: _character.abilityScores,
                                    modifiers: _character.modifiers,
                                    proficiencies: _character.proficiencies,
                                    combatStats: _character.combatStats,
                                    health: _character.health,
                                    equipment: _character.equipment,
                                    wealth: _character.wealth,
                                    spellcasting: _character.spellcasting,
                                    traits: _character.traits,
                                    features: _character.features,
                                    racialTraits: _character.racialTraits,
                                    backgroundTraits: [],
                                    physicalDescription:
                                    _character.physicalDescription,
                                    notes: _character.notes,
                                    createdAt: _character.createdAt,
                                    updatedAt: DateTime.now(),
                                  ).copyWithCalculatedValues();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<MoralAlignment>(
                            value: _character.moralAlignment,
                            decoration: InputDecoration(
                              labelText: 'Alignment',
                              labelStyle:
                              TextStyle(color: colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: colorScheme.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: MoralAlignment.values.map((align) {
                              return DropdownMenuItem<MoralAlignment>(
                                value: align,
                                child: Text(
                                  align.displayName,
                                  style: TextStyle(color: colorScheme.onSurface),
                                ),
                              );
                            }).toList(),
                            onChanged: (MoralAlignment? value) {
                              if (value != null) {
                                setState(() {
                                  _character = Character(
                                    id: _character.id,
                                    name: _character.name,
                                    playerName: _character.playerName,
                                    characterClass: _character.characterClass,
                                    subclass: _character.subclass,
                                    race: _character.race,
                                    background: _character.background,
                                    moralAlignment: value,
                                    level: _character.level,
                                    experiencePoints: _character.experiencePoints,
                                    inspiration: _character.inspiration,
                                    abilityScores: _character.abilityScores,
                                    modifiers: _character.modifiers,
                                    proficiencies: _character.proficiencies,
                                    combatStats: _character.combatStats,
                                    health: _character.health,
                                    equipment: _character.equipment,
                                    wealth: _character.wealth,
                                    spellcasting: _character.spellcasting,
                                    traits: _character.traits,
                                    features: _character.features,
                                    racialTraits: _character.racialTraits,
                                    backgroundTraits: _character.backgroundTraits,
                                    physicalDescription:
                                    _character.physicalDescription,
                                    notes: _character.notes,
                                    createdAt: _character.createdAt,
                                    updatedAt: DateTime.now(),
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: _character.experiencePoints.toString()),
                            decoration: InputDecoration(
                              labelText: 'Experience Points',
                              labelStyle:
                              TextStyle(color: colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: colorScheme.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.onSurface,
                            ),
                            onChanged: (value) {
                              final xp = int.tryParse(value) ??
                                  _character.experiencePoints;
                              setState(() {
                                _character = Character(
                                  id: _character.id,
                                  name: _character.name,
                                  characterClass: _character.characterClass,
                                  subclass: _character.subclass,
                                  race: _character.race,
                                  background: _character.background,
                                  moralAlignment: _character.moralAlignment,
                                  level: _character.level,
                                  experiencePoints: xp,
                                  inspiration: _character.inspiration,
                                  abilityScores: _character.abilityScores,
                                  modifiers: _character.modifiers,
                                  proficiencies: _character.proficiencies,
                                  combatStats: _character.combatStats,
                                  health: _character.health,
                                  equipment: _character.equipment,
                                  wealth: _character.wealth,
                                  spellcasting: _character.spellcasting,
                                  traits: _character.traits,
                                  features: _character.features,
                                  racialTraits: _character.racialTraits,
                                  backgroundTraits: _character.backgroundTraits,
                                  physicalDescription:
                                  _character.physicalDescription,
                                  notes: _character.notes,
                                  createdAt: _character.createdAt,
                                  updatedAt: DateTime.now(),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Attributes Grid
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.fitness_center_outlined,
                            color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ATTRIBUTES',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildAttributeCard(
                            'STR', 'Strength', _character.abilityScores.strength,
                            _character.modifiers.strength),
                        _buildAttributeCard('DEX', 'Dexterity',
                            _character.abilityScores.dexterity,
                            _character.modifiers.dexterity),
                        _buildAttributeCard('CON', 'Constitution',
                            _character.abilityScores.constitution,
                            _character.modifiers.constitution),
                        _buildAttributeCard('INT', 'Intelligence',
                            _character.abilityScores.intelligence,
                            _character.modifiers.intelligence),
                        _buildAttributeCard(
                            'WIS', 'Wisdom', _character.abilityScores.wisdom,
                            _character.modifiers.wisdom),
                        _buildAttributeCard('CHA', 'Charisma',
                            _character.abilityScores.charisma,
                            _character.modifiers.charisma),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Skills Grid
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.psychology_outlined,
                            color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'SKILLS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSkillsGrid(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Saving Throws
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shield_outlined,
                            color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'SAVING THROWS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSavingThrowGrid(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeCard(
      String abbreviation, String name, int value, int modifier) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPositive = modifier >= 0;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            abbreviation,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isPositive
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPositive ? '+$modifier' : '$modifier',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isPositive ? colorScheme.primary : colorScheme.error,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: colorScheme.error,
                  size: 20,
                ),
                onPressed: () =>
                    _updateAttribute(name.toLowerCase(), value - 1),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
                onPressed: () =>
                    _updateAttribute(name.toLowerCase(), value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateAttribute(String attribute, int value) {
    setState(() {
      value = value.clamp(1, 30);

      final newAbilityScores = AbilityScores(
        strength: attribute == 'strength'
            ? value
            : _character.abilityScores.strength,
        dexterity: attribute == 'dexterity'
            ? value
            : _character.abilityScores.dexterity,
        constitution: attribute == 'constitution'
            ? value
            : _character.abilityScores.constitution,
        intelligence: attribute == 'intelligence'
            ? value
            : _character.abilityScores.intelligence,
        wisdom:
        attribute == 'wisdom' ? value : _character.abilityScores.wisdom,
        charisma:
        attribute == 'charisma' ? value : _character.abilityScores.charisma,
      );

      _character = Character(
        id: _character.id,
        name: _character.name,
        characterClass: _character.characterClass,
        subclass: _character.subclass,
        race: _character.race,
        background: _character.background,
        moralAlignment: _character.moralAlignment,
        level: _character.level,
        experiencePoints: _character.experiencePoints,
        inspiration: _character.inspiration,
        abilityScores: newAbilityScores,
        modifiers: _character.modifiers,
        proficiencies: _character.proficiencies,
        combatStats: _character.combatStats,
        health: _character.health,
        equipment: _character.equipment,
        wealth: _character.wealth,
        spellcasting: _character.spellcasting,
        traits: _character.traits,
        features: _character.features,
        racialTraits: _character.racialTraits,
        backgroundTraits: _character.backgroundTraits,
        physicalDescription: _character.physicalDescription,
        notes: _character.notes,
        createdAt: _character.createdAt,
        updatedAt: DateTime.now(),
      ).copyWithCalculatedValues();
    });
  }

  Widget _buildSavingThrowGrid() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final saves = [
      {
        'name': 'STR',
        'mod': _character.proficiencies.savingThrows.getModifier(
            'strength',
            _character.modifiers,
            _character.proficiencies.proficiencyBonus),
        'proficient': _character.proficiencies.savingThrows.strength
      },
      {
        'name': 'DEX',
        'mod': _character.proficiencies.savingThrows.getModifier(
            'dexterity',
            _character.modifiers,
            _character.proficiencies.proficiencyBonus),
        'proficient': _character.proficiencies.savingThrows.dexterity
      },
      {
        'name': 'CON',
        'mod': _character.proficiencies.savingThrows.getModifier(
            'constitution',
            _character.modifiers,
            _character.proficiencies.proficiencyBonus),
        'proficient': _character.proficiencies.savingThrows.constitution
      },
      {
        'name': 'INT',
        'mod': _character.proficiencies.savingThrows.getModifier(
            'intelligence',
            _character.modifiers,
            _character.proficiencies.proficiencyBonus),
        'proficient': _character.proficiencies.savingThrows.intelligence
      },
      {
        'name': 'WIS',
        'mod': _character.proficiencies.savingThrows.getModifier('wisdom',
            _character.modifiers, _character.proficiencies.proficiencyBonus),
        'proficient': _character.proficiencies.savingThrows.wisdom
      },
      {
        'name': 'CHA',
        'mod': _character.proficiencies.savingThrows.getModifier(
            'charisma',
            _character.modifiers,
            _character.proficiencies.proficiencyBonus),
        'proficient': _character.proficiencies.savingThrows.charisma
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: saves.map((save) {
        final name = save['name'] as String;
        final mod = save['mod'] as int;
        final proficient = save['proficient'] as bool;

        return GestureDetector(
          onTap: () {
            setState(() {
              final newSavingThrows = SavingThrowProficiencies(
                strength: name == 'STR'
                    ? !proficient
                    : _character.proficiencies.savingThrows.strength,
                dexterity: name == 'DEX'
                    ? !proficient
                    : _character.proficiencies.savingThrows.dexterity,
                constitution: name == 'CON'
                    ? !proficient
                    : _character.proficiencies.savingThrows.constitution,
                intelligence: name == 'INT'
                    ? !proficient
                    : _character.proficiencies.savingThrows.intelligence,
                wisdom: name == 'WIS'
                    ? !proficient
                    : _character.proficiencies.savingThrows.wisdom,
                charisma: name == 'CHA'
                    ? !proficient
                    : _character.proficiencies.savingThrows.charisma,
              );

              final newProficiencies = ProficiencySet(
                proficiencyBonus: _character.proficiencies.proficiencyBonus,
                skills: _character.proficiencies.skills,
                savingThrows: newSavingThrows,
                languages: _character.proficiencies.languages,
                tools: _character.proficiencies.tools,
                weapons: _character.proficiencies.weapons,
                armor: _character.proficiencies.armor,
                other: _character.proficiencies.other,
              );

              _character = Character(
                id: _character.id,
                name: _character.name,
                characterClass: _character.characterClass,
                subclass: _character.subclass,
                race: _character.race,
                background: _character.background,
                moralAlignment: _character.moralAlignment,
                level: _character.level,
                experiencePoints: _character.experiencePoints,
                inspiration: _character.inspiration,
                abilityScores: _character.abilityScores,
                modifiers: _character.modifiers,
                proficiencies: newProficiencies,
                combatStats: _character.combatStats,
                health: _character.health,
                equipment: _character.equipment,
                wealth: _character.wealth,
                spellcasting: _character.spellcasting,
                traits: _character.traits,
                features: _character.features,
                racialTraits: _character.racialTraits,
                backgroundTraits: _character.backgroundTraits,
                physicalDescription: _character.physicalDescription,
                notes: _character.notes,
                createdAt: _character.createdAt,
                updatedAt: DateTime.now(),
              ).copyWithCalculatedValues();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: proficient
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: proficient
                    ? colorScheme.primary
                    : colorScheme.outline.withOpacity(0.3),
                width: proficient ? 2 : 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: proficient
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mod >= 0 ? '+$mod' : '$mod',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (proficient)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.check_circle,
                        size: 12,
                        color: colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillsGrid() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final skills = [
      {'skill': Skill.acrobatics, 'name': 'Acrobatics'},
      {'skill': Skill.animalHandling, 'name': 'Animal Handling'},
      {'skill': Skill.arcana, 'name': 'Arcana'},
      {'skill': Skill.athletics, 'name': 'Athletics'},
      {'skill': Skill.deception, 'name': 'Deception'},
      {'skill': Skill.history, 'name': 'History'},
      {'skill': Skill.insight, 'name': 'Insight'},
      {'skill': Skill.intimidation, 'name': 'Intimidation'},
      {'skill': Skill.investigation, 'name': 'Investigation'},
      {'skill': Skill.medicine, 'name': 'Medicine'},
      {'skill': Skill.nature, 'name': 'Nature'},
      {'skill': Skill.perception, 'name': 'Perception'},
      {'skill': Skill.performance, 'name': 'Performance'},
      {'skill': Skill.persuasion, 'name': 'Persuasion'},
      {'skill': Skill.religion, 'name': 'Religion'},
      {'skill': Skill.sleightOfHand, 'name': 'Sleight of Hand'},
      {'skill': Skill.stealth, 'name': 'Stealth'},
      {'skill': Skill.survival, 'name': 'Survival'},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 6,
      crossAxisSpacing: 12,
      mainAxisSpacing: 8,
      children: skills.map((skillData) {
        final skill = skillData['skill'] as Skill;
        final name = skillData['name'] as String;
        final mod = _character.proficiencies.skills.getModifier(
            skill, _character.modifiers, _character.proficiencies.proficiencyBonus);
        final proficiency =
            _character.proficiencies.skills.proficiencies[skill] ??
                ProficiencyLevel.none;

        return GestureDetector(
          onTap: () {
            setState(() {
              final newProficiencies =
              Map<Skill, ProficiencyLevel>.from(
                  _character.proficiencies.skills.proficiencies);
              newProficiencies[skill] =
              proficiency == ProficiencyLevel.none
                  ? ProficiencyLevel.proficient
                  : proficiency == ProficiencyLevel.proficient
                  ? ProficiencyLevel.expert
                  : ProficiencyLevel.none;

              final newSkills = SkillProficiencies(proficiencies: newProficiencies);
              final newProficiencySet = ProficiencySet(
                proficiencyBonus: _character.proficiencies.proficiencyBonus,
                skills: newSkills,
                savingThrows: _character.proficiencies.savingThrows,
                languages: _character.proficiencies.languages,
                tools: _character.proficiencies.tools,
                weapons: _character.proficiencies.weapons,
                armor: _character.proficiencies.armor,
                other: _character.proficiencies.other,
              );

              _character = Character(
                id: _character.id,
                name: _character.name,
                characterClass: _character.characterClass,
                subclass: _character.subclass,
                race: _character.race,
                background: _character.background,
                moralAlignment: _character.moralAlignment,
                level: _character.level,
                experiencePoints: _character.experiencePoints,
                inspiration: _character.inspiration,
                abilityScores: _character.abilityScores,
                modifiers: _character.modifiers,
                proficiencies: newProficiencySet,
                combatStats: _character.combatStats,
                health: _character.health,
                equipment: _character.equipment,
                wealth: _character.wealth,
                spellcasting: _character.spellcasting,
                traits: _character.traits,
                features: _character.features,
                racialTraits: _character.racialTraits,
                backgroundTraits: _character.backgroundTraits,
                physicalDescription: _character.physicalDescription,
                notes: _character.notes,
                createdAt: _character.createdAt,
                updatedAt: DateTime.now(),
              ).copyWithCalculatedValues();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: proficiency != ProficiencyLevel.none
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (proficiency == ProficiencyLevel.expert)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.star,
                            size: 14,
                            color: colorScheme.secondary,
                          ),
                        ),
                      if (proficiency == ProficiencyLevel.proficient)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.check_circle,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          mod >= 0 ? '+$mod' : '$mod',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCombatTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Combat Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard('ARMOR CLASS', '${_character.combatStats.armorClass}',
                    colorScheme.primary),
                _buildStatCard('INITIATIVE', '${_character.combatStats.initiative}',
                    colorScheme.secondary),
                _buildStatCard('SPEED', '${_character.combatStats.speed} ft',
                    colorScheme.tertiary),
                _buildStatCard('PROFICIENCY',
                    '+${_character.proficiencies.proficiencyBonus}', colorScheme.primary),
              ],
            ),

            const SizedBox(height: 20),

            // Hit Points
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite_border,
                            color: colorScheme.error, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'HIT POINTS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline,
                              color: colorScheme.error),
                          onPressed: () => _updateHitPoints(-1),
                        ),
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${_character.health.currentHitPoints}',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w800,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / ${_character.health.maxHitPoints}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Temp HP: ${_character.health.temporaryHitPoints}',
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline,
                              color: colorScheme.primary),
                          onPressed: () => _updateHitPoints(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_character.health.hitDice.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HIT DICE',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _character.health.hitDice
                                .map((hd) => Chip(
                              label: Text(
                                  '${hd.count - hd.used}/${hd.count}d${hd.sides}'),
                              backgroundColor:
                              colorScheme.surfaceVariant,
                            ))
                                .toList(),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHitDieButton('Use 1', onPressed: () {
                          // TODO: Implement hit dice usage
                        }),
                        _buildHitDieButton('Short Rest', onPressed: () {
                          // TODO: Implement short rest
                        }),
                        _buildHitDieButton('Long Rest', onPressed: () {
                          // TODO: Implement long rest
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Death Saves
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.medical_information_outlined,
                            color: colorScheme.error, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'DEATH SAVES',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text('Successes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                  )),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        final newDeathSaves = DeathSaves(
                                          successes: index + 1,
                                          failures:
                                          _character.health.deathSaves.failures,
                                        );
                                        final newHealth = _character.health
                                            .copyWith(deathSaves: newDeathSaves);
                                        _character = Character(
                                          id: _character.id,
                                          name: _character.name,
                                          characterClass: _character.characterClass,
                                          subclass: _character.subclass,
                                          race: _character.race,
                                          background: _character.background,
                                          moralAlignment: _character.moralAlignment,
                                          level: _character.level,
                                          experiencePoints:
                                          _character.experiencePoints,
                                          inspiration: _character.inspiration,
                                          abilityScores: _character.abilityScores,
                                          modifiers: _character.modifiers,
                                          proficiencies: _character.proficiencies,
                                          combatStats: _character.combatStats,
                                          health: newHealth,
                                          equipment: _character.equipment,
                                          wealth: _character.wealth,
                                          spellcasting: _character.spellcasting,
                                          traits: _character.traits,
                                          features: _character.features,
                                          racialTraits: _character.racialTraits,
                                          backgroundTraits:
                                          _character.backgroundTraits,
                                          physicalDescription:
                                          _character.physicalDescription,
                                          notes: _character.notes,
                                          createdAt: _character.createdAt,
                                          updatedAt: DateTime.now(),
                                        );
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 6),
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index <
                                            _character
                                                .health.deathSaves.successes
                                            ? colorScheme.primary
                                            : colorScheme.surfaceVariant,
                                        border: Border.all(
                                          color: colorScheme.primary,
                                          width: 2,
                                        ),
                                      ),
                                      child: index <
                                          _character
                                              .health.deathSaves.successes
                                          ? Icon(Icons.check,
                                          size: 20, color: Colors.white)
                                          : null,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 80,
                          color: colorScheme.outline.withOpacity(0.2),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Failures',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                  )),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        final newDeathSaves = DeathSaves(
                                          successes:
                                          _character.health.deathSaves.successes,
                                          failures: index + 1,
                                        );
                                        final newHealth = _character.health
                                            .copyWith(deathSaves: newDeathSaves);
                                        _character = Character(
                                          id: _character.id,
                                          name: _character.name,
                                          characterClass: _character.characterClass,
                                          subclass: _character.subclass,
                                          race: _character.race,
                                          background: _character.background,
                                          moralAlignment: _character.moralAlignment,
                                          level: _character.level,
                                          experiencePoints:
                                          _character.experiencePoints,
                                          inspiration: _character.inspiration,
                                          abilityScores: _character.abilityScores,
                                          modifiers: _character.modifiers,
                                          proficiencies: _character.proficiencies,
                                          combatStats: _character.combatStats,
                                          health: newHealth,
                                          equipment: _character.equipment,
                                          wealth: _character.wealth,
                                          spellcasting: _character.spellcasting,
                                          traits: _character.traits,
                                          features: _character.features,
                                          racialTraits: _character.racialTraits,
                                          backgroundTraits:
                                          _character.backgroundTraits,
                                          physicalDescription:
                                          _character.physicalDescription,
                                          notes: _character.notes,
                                          createdAt: _character.createdAt,
                                          updatedAt: DateTime.now(),
                                        );
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 6),
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index <
                                            _character
                                                .health.deathSaves.failures
                                            ? colorScheme.error
                                            : colorScheme.surfaceVariant,
                                        border: Border.all(
                                          color: colorScheme.error,
                                          width: 2,
                                        ),
                                      ),
                                      child: index <
                                          _character
                                              .health.deathSaves.failures
                                          ? Icon(Icons.close,
                                          size: 20, color: Colors.white)
                                          : null,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Weapons
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.gavel_outlined,
                            color: colorScheme.onSurface, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'WEAPONS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_character.equipment.weapons.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No weapons equipped',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ..._character.equipment.weapons
                        .take(3)
                        .map((weapon) => _buildWeaponRow(weapon)),
                    if (_character.equipment.weapons.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextButton(
                          onPressed: () {
                            // TODO: Show all weapons
                          },
                          child: const Text('Show all weapons...'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 2),
              ),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHitDieButton(String text, {required VoidCallback onPressed}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.surfaceVariant,
        foregroundColor: colorScheme.onSurfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildWeaponRow(Weapon weapon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(Icons.gavel_outlined, color: colorScheme.primary),
        title: Text(
          weapon.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          '${weapon.damage} ${weapon.damageType}',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '+${weapon.attackBonus}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ),
        onTap: () {
          // TODO: Show weapon details
        },
      ),
    );
  }

  void _updateHitPoints(int change) {
    setState(() {
      final newCurrentHP = (_character.health.currentHitPoints + change)
          .clamp(0, _character.health.maxHitPoints);
      final newHealth = _character.health.copyWith(currentHitPoints: newCurrentHP);

      _character = Character(
        id: _character.id,
        name: _character.name,
        characterClass: _character.characterClass,
        subclass: _character.subclass,
        race: _character.race,
        background: _character.background,
        moralAlignment: _character.moralAlignment,
        level: _character.level,
        experiencePoints: _character.experiencePoints,
        inspiration: _character.inspiration,
        abilityScores: _character.abilityScores,
        modifiers: _character.modifiers,
        proficiencies: _character.proficiencies,
        combatStats: _character.combatStats,
        health: newHealth,
        equipment: _character.equipment,
        wealth: _character.wealth,
        spellcasting: _character.spellcasting,
        traits: _character.traits,
        features: _character.features,
        racialTraits: _character.racialTraits,
        backgroundTraits: _character.backgroundTraits,
        physicalDescription: _character.physicalDescription,
        notes: _character.notes,
        createdAt: _character.createdAt,
        updatedAt: DateTime.now(),
      );
    });
  }

  Widget _buildEquipmentTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Currency
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.monetization_on_outlined,
                            color: colorScheme.secondary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'CURRENCY',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCurrencyItem('CP', _character.wealth.copper,
                            Colors.orange.shade700),
                        _buildCurrencyItem(
                            'SP', _character.wealth.silver, Colors.grey.shade600),
                        _buildCurrencyItem(
                            'EP', _character.wealth.electrum, Colors.yellow.shade800),
                        _buildCurrencyItem(
                            'GP', _character.wealth.gold, Colors.yellow.shade600),
                        _buildCurrencyItem('PP', _character.wealth.platinum,
                            Colors.blue.shade300),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Equipment
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.backpack_outlined,
                            color: colorScheme.onSurface, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'EQUIPMENT',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_character.equipment.inventory.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No equipment items',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ..._character.equipment.inventory
                        .map((item) => _buildEquipmentItem(item)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Armor
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shield_outlined,
                            color: colorScheme.onSurface, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ARMOR',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_character.equipment.armor.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No armor equipped',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ..._character.equipment.armor
                        .map((armor) => _buildArmorItem(armor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyItem(String label, int amount, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$amount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentItem(EquipmentItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Checkbox(
          value: item.isEquipped,
          onChanged: (value) {
            // TODO: Update equipment
          },
          activeColor: colorScheme.primary,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          'Qty: ${item.quantity} • Weight: ${item.weight} lb',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline,
              color: colorScheme.onSurface.withOpacity(0.5)),
          onPressed: () {
            // TODO: Remove equipment
          },
        ),
      ),
    );
  }

  Widget _buildArmorItem(Armor armor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Checkbox(
          value: armor.isEquipped,
          onChanged: (value) {
            // TODO: Update armor
          },
          activeColor: colorScheme.primary,
        ),
        title: Text(
          armor.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AC ${armor.baseAC} • ${armor.armorType}',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
            if (armor.stealthDisadvantage)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Icon(Icons.visibility_off, size: 12,
                        color: colorScheme.error),
                    const SizedBox(width: 4),
                    Text(
                      'Stealth Disadvantage',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellsTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_character.spellcasting == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_outlined,
                size: 80, color: colorScheme.onSurface.withOpacity(0.3)),
            const SizedBox(height: 20),
            Text(
              'No Spellcasting',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_character.characterClass.displayName} does not have spellcasting',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Spellcasting Stats
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome_outlined,
                            color: colorScheme.tertiary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'SPELLCASTING',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSpellStat('SPELL DC',
                            '${_character.spellcasting!.spellSaveDC}'),
                        _buildSpellStat('ATTACK BONUS',
                            '+${_character.spellcasting!.spellAttackBonus}'),
                        _buildSpellStat('ABILITY',
                            _character.spellcasting!.spellcastingAbility
                                ?.toUpperCase() ??
                                ''),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Spell Slots
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.layers_outlined,
                            color: colorScheme.onSurface, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'SPELL SLOTS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSpellSlots(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Prepared Spells
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.book_outlined,
                            color: colorScheme.onSurface, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'PREPARED SPELLS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_character.spellcasting!.preparedSpells.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No spells prepared',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ..._character.spellcasting!.preparedSpells
                        .take(5)
                        .map((spell) => _buildSpellRow(spell)),
                    if (_character.spellcasting!.preparedSpells.length > 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextButton(
                          onPressed: () {
                            // TODO: Show all spells
                          },
                          child: const Text('Show all spells...'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellStat(String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.tertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.tertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpellSlots() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(9, (index) {
        final slot = _character.spellcasting!.spellSlots.firstWhere(
              (s) => s.level == index + 1,
          orElse: () => SpellSlot(level: index + 1, total: 0, used: 0),
        );

        if (slot.total == 0) return Container();

        final remaining = slot.remaining;
        final isLow = remaining <= slot.total * 0.3;

        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isLow
                ? colorScheme.error.withOpacity(0.1)
                : colorScheme.tertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLow
                  ? colorScheme.error.withOpacity(0.3)
                  : colorScheme.tertiary.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Level ${slot.level}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$remaining',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isLow ? colorScheme.error : colorScheme.tertiary,
                ),
              ),
              Text(
                '/ ${slot.total}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSpellRow(Spell spell) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.tertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              spell.level == 0 ? 'C' : '${spell.level}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: colorScheme.tertiary,
              ),
            ),
          ),
        ),
        title: Text(
          spell.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          spell.school,
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            if (spell.isRitual)
              Chip(
                label: Text('Ritual',
                    style: TextStyle(fontSize: 10, color: colorScheme.primary)),
                backgroundColor: colorScheme.primary.withOpacity(0.1),
              ),
            if (spell.isConcentration)
              Chip(
                label: Text('Conc.',
                    style: TextStyle(fontSize: 10, color: colorScheme.secondary)),
                backgroundColor: colorScheme.secondary.withOpacity(0.1),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Class Features
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.class_outlined,
                            color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'CLASS FEATURES',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_character.features
                        .where((f) => f.source == 'class')
                        .isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No class features',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ..._character.features
                        .where((f) => f.source == 'class')
                        .map((feature) => _buildFeatureItem(feature)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Racial Features
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people_outline,
                            color: colorScheme.secondary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'RACIAL FEATURES',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_character.racialTraits.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No racial features',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ..._character.racialTraits
                        .map((feature) => _buildFeatureItem(feature)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Background Features
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.work_outline,
                            color: colorScheme.tertiary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'BACKGROUND FEATURES',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_character.backgroundTraits.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No background features',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ..._character.backgroundTraits
                        .map((feature) => _buildFeatureItem(feature)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(Feature feature) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          feature.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          'Level ${feature.levelObtained}',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              feature.description,
              style: TextStyle(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Personality
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.psychology_outlined,
                            color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'PERSONALITY',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildLargeTextField(
                        'Personality Traits',
                        _character.traits.personalityTraits,
                            (value) {
                          setState(() {
                            final newTraits = Traits(
                              personalityTraits: value,
                              ideals: _character.traits.ideals,
                              bonds: _character.traits.bonds,
                              flaws: _character.traits.flaws,
                              alliesAndOrganizations:
                              _character.traits.alliesAndOrganizations,
                            );
                            _character = Character(
                              id: _character.id,
                              name: _character.name,
                              characterClass: _character.characterClass,
                              subclass: _character.subclass,
                              race: _character.race,
                              background: _character.background,
                              moralAlignment: _character.moralAlignment,
                              level: _character.level,
                              experiencePoints: _character.experiencePoints,
                              inspiration: _character.inspiration,
                              abilityScores: _character.abilityScores,
                              modifiers: _character.modifiers,
                              proficiencies: _character.proficiencies,
                              combatStats: _character.combatStats,
                              health: _character.health,
                              equipment: _character.equipment,
                              wealth: _character.wealth,
                              spellcasting: _character.spellcasting,
                              traits: newTraits,
                              features: _character.features,
                              racialTraits: _character.racialTraits,
                              backgroundTraits: _character.backgroundTraits,
                              physicalDescription:
                              _character.physicalDescription,
                              notes: _character.notes,
                              createdAt: _character.createdAt,
                              updatedAt: DateTime.now(),
                            );
                          });
                        }),
                    const SizedBox(height: 16),
                    _buildLargeTextField('Ideals', _character.traits.ideals,
                            (value) {
                          setState(() {
                            final newTraits = Traits(
                              personalityTraits: _character.traits.personalityTraits,
                              ideals: value,
                              bonds: _character.traits.bonds,
                              flaws: _character.traits.flaws,
                              alliesAndOrganizations:
                              _character.traits.alliesAndOrganizations,
                            );
                            _character = Character(
                              id: _character.id,
                              name: _character.name,
                              characterClass: _character.characterClass,
                              subclass: _character.subclass,
                              race: _character.race,
                              background: _character.background,
                              moralAlignment: _character.moralAlignment,
                              level: _character.level,
                              experiencePoints: _character.experiencePoints,
                              inspiration: _character.inspiration,
                              abilityScores: _character.abilityScores,
                              modifiers: _character.modifiers,
                              proficiencies: _character.proficiencies,
                              combatStats: _character.combatStats,
                              health: _character.health,
                              equipment: _character.equipment,
                              wealth: _character.wealth,
                              spellcasting: _character.spellcasting,
                              traits: newTraits,
                              features: _character.features,
                              racialTraits: _character.racialTraits,
                              backgroundTraits: _character.backgroundTraits,
                              physicalDescription: _character.physicalDescription,
                              notes: _character.notes,
                              createdAt: _character.createdAt,
                              updatedAt: DateTime.now(),
                            );
                          });
                        }),
                    const SizedBox(height: 16),
                    _buildLargeTextField('Bonds', _character.traits.bonds,
                            (value) {
                          setState(() {
                            final newTraits = Traits(
                              personalityTraits: _character.traits.personalityTraits,
                              ideals: _character.traits.ideals,
                              bonds: value,
                              flaws: _character.traits.flaws,
                              alliesAndOrganizations:
                              _character.traits.alliesAndOrganizations,
                            );
                            _character = Character(
                              id: _character.id,
                              name: _character.name,
                              characterClass: _character.characterClass,
                              subclass: _character.subclass,
                              race: _character.race,
                              background: _character.background,
                              moralAlignment: _character.moralAlignment,
                              level: _character.level,
                              experiencePoints: _character.experiencePoints,
                              inspiration: _character.inspiration,
                              abilityScores: _character.abilityScores,
                              modifiers: _character.modifiers,
                              proficiencies: _character.proficiencies,
                              combatStats: _character.combatStats,
                              health: _character.health,
                              equipment: _character.equipment,
                              wealth: _character.wealth,
                              spellcasting: _character.spellcasting,
                              traits: newTraits,
                              features: _character.features,
                              racialTraits: _character.racialTraits,
                              backgroundTraits: _character.backgroundTraits,
                              physicalDescription: _character.physicalDescription,
                              notes: _character.notes,
                              createdAt: _character.createdAt,
                              updatedAt: DateTime.now(),
                            );
                          });
                        }),
                    const SizedBox(height: 16),
                    _buildLargeTextField('Flaws', _character.traits.flaws,
                            (value) {
                          setState(() {
                            final newTraits = Traits(
                              personalityTraits: _character.traits.personalityTraits,
                              ideals: _character.traits.ideals,
                              bonds: _character.traits.bonds,
                              flaws: value,
                              alliesAndOrganizations:
                              _character.traits.alliesAndOrganizations,
                            );
                            _character = Character(
                              id: _character.id,
                              name: _character.name,
                              characterClass: _character.characterClass,
                              subclass: _character.subclass,
                              race: _character.race,
                              background: _character.background,
                              moralAlignment: _character.moralAlignment,
                              level: _character.level,
                              experiencePoints: _character.experiencePoints,
                              inspiration: _character.inspiration,
                              abilityScores: _character.abilityScores,
                              modifiers: _character.modifiers,
                              proficiencies: _character.proficiencies,
                              combatStats: _character.combatStats,
                              health: _character.health,
                              equipment: _character.equipment,
                              wealth: _character.wealth,
                              spellcasting: _character.spellcasting,
                              traits: newTraits,
                              features: _character.features,
                              racialTraits: _character.racialTraits,
                              backgroundTraits: _character.backgroundTraits,
                              physicalDescription: _character.physicalDescription,
                              notes: _character.notes,
                              createdAt: _character.createdAt,
                              updatedAt: DateTime.now(),
                            );
                          });
                        }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Backstory & Appearance
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history_outlined,
                            color: colorScheme.secondary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'BACKSTORY & APPEARANCE',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildLargeTextField('Backstory', _character.notes.backstory,
                            (value) {
                          setState(() {
                            final newNotes = Notes(
                              backstory: value,
                              appearance: _character.notes.appearance,
                              inventoryNotes: _character.notes.inventoryNotes,
                              languagesNotes: _character.notes.languagesNotes,
                              otherNotes: _character.notes.otherNotes,
                            );
                            _character = Character(
                              id: _character.id,
                              name: _character.name,
                              characterClass: _character.characterClass,
                              subclass: _character.subclass,
                              race: _character.race,
                              background: _character.background,
                              moralAlignment: _character.moralAlignment,
                              level: _character.level,
                              experiencePoints: _character.experiencePoints,
                              inspiration: _character.inspiration,
                              abilityScores: _character.abilityScores,
                              modifiers: _character.modifiers,
                              proficiencies: _character.proficiencies,
                              combatStats: _character.combatStats,
                              health: _character.health,
                              equipment: _character.equipment,
                              wealth: _character.wealth,
                              spellcasting: _character.spellcasting,
                              traits: _character.traits,
                              features: _character.features,
                              racialTraits: _character.racialTraits,
                              backgroundTraits: _character.backgroundTraits,
                              physicalDescription: _character.physicalDescription,
                              notes: newNotes,
                              createdAt: _character.createdAt,
                              updatedAt: DateTime.now(),
                            );
                          });
                        }),
                    const SizedBox(height: 16),
                    _buildLargeTextField('Appearance', _character.notes.appearance,
                            (value) {
                          setState(() {
                            final newNotes = Notes(
                              backstory: _character.notes.backstory,
                              appearance: value,
                              inventoryNotes: _character.notes.inventoryNotes,
                              languagesNotes: _character.notes.languagesNotes,
                              otherNotes: _character.notes.otherNotes,
                            );
                            _character = Character(
                              id: _character.id,
                              name: _character.name,
                              characterClass: _character.characterClass,
                              subclass: _character.subclass,
                              race: _character.race,
                              background: _character.background,
                              moralAlignment: _character.moralAlignment,
                              level: _character.level,
                              experiencePoints: _character.experiencePoints,
                              inspiration: _character.inspiration,
                              abilityScores: _character.abilityScores,
                              modifiers: _character.modifiers,
                              proficiencies: _character.proficiencies,
                              combatStats: _character.combatStats,
                              health: _character.health,
                              equipment: _character.equipment,
                              wealth: _character.wealth,
                              spellcasting: _character.spellcasting,
                              traits: _character.traits,
                              features: _character.features,
                              racialTraits: _character.racialTraits,
                              backgroundTraits: _character.backgroundTraits,
                              physicalDescription: _character.physicalDescription,
                              notes: newNotes,
                              createdAt: _character.createdAt,
                              updatedAt: DateTime.now(),
                            );
                          });
                        }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Physical Description
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline_outlined,
                            color: colorScheme.tertiary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'PHYSICAL DESCRIPTION',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildDescriptionField('Age',
                            _character.physicalDescription.age.toString(),
                                (value) {
                              final age = int.tryParse(value) ??
                                  _character.physicalDescription.age;
                              setState(() {
                                final newPhysicalDescription = PhysicalDescription(
                                  age: age,
                                  height: _character.physicalDescription.height,
                                  weight: _character.physicalDescription.weight,
                                  eyes: _character.physicalDescription.eyes,
                                  skin: _character.physicalDescription.skin,
                                  hair: _character.physicalDescription.hair,
                                  deity: _character.physicalDescription.deity,
                                );
                                _character = Character(
                                  id: _character.id,
                                  name: _character.name,
                                  characterClass: _character.characterClass,
                                  subclass: _character.subclass,
                                  race: _character.race,
                                  background: _character.background,
                                  moralAlignment: _character.moralAlignment,
                                  level: _character.level,
                                  experiencePoints: _character.experiencePoints,
                                  inspiration: _character.inspiration,
                                  abilityScores: _character.abilityScores,
                                  modifiers: _character.modifiers,
                                  proficiencies: _character.proficiencies,
                                  combatStats: _character.combatStats,
                                  health: _character.health,
                                  equipment: _character.equipment,
                                  wealth: _character.wealth,
                                  spellcasting: _character.spellcasting,
                                  traits: _character.traits,
                                  features: _character.features,
                                  racialTraits: _character.racialTraits,
                                  backgroundTraits: _character.backgroundTraits,
                                  physicalDescription: newPhysicalDescription,
                                  notes: _character.notes,
                                  createdAt: _character.createdAt,
                                  updatedAt: DateTime.now(),
                                );
                              });
                            }),
                        _buildDescriptionField(
                            'Height', _character.physicalDescription.height,
                                (value) {
                              setState(() {
                                final newPhysicalDescription = PhysicalDescription(
                                  age: _character.physicalDescription.age,
                                  height: value,
                                  weight: _character.physicalDescription.weight,
                                  eyes: _character.physicalDescription.eyes,
                                  skin: _character.physicalDescription.skin,
                                  hair: _character.physicalDescription.hair,
                                  deity: _character.physicalDescription.deity,
                                );
                                _character = Character(
                                  id: _character.id,
                                  name: _character.name,
                                  characterClass: _character.characterClass,
                                  subclass: _character.subclass,
                                  race: _character.race,
                                  background: _character.background,
                                  moralAlignment: _character.moralAlignment,
                                  level: _character.level,
                                  experiencePoints: _character.experiencePoints,
                                  inspiration: _character.inspiration,
                                  abilityScores: _character.abilityScores,
                                  modifiers: _character.modifiers,
                                  proficiencies: _character.proficiencies,
                                  combatStats: _character.combatStats,
                                  health: _character.health,
                                  equipment: _character.equipment,
                                  wealth: _character.wealth,
                                  spellcasting: _character.spellcasting,
                                  traits: _character.traits,
                                  features: _character.features,
                                  racialTraits: _character.racialTraits,
                                  backgroundTraits: _character.backgroundTraits,
                                  physicalDescription: newPhysicalDescription,
                                  notes: _character.notes,
                                  createdAt: _character.createdAt,
                                  updatedAt: DateTime.now(),
                                );
                              });
                            }),
                        _buildDescriptionField(
                            'Weight', _character.physicalDescription.weight,
                                (value) {
                              setState(() {
                                final newPhysicalDescription = PhysicalDescription(
                                  age: _character.physicalDescription.age,
                                  height: _character.physicalDescription.height,
                                  weight: value,
                                  eyes: _character.physicalDescription.eyes,
                                  skin: _character.physicalDescription.skin,
                                  hair: _character.physicalDescription.hair,
                                  deity: _character.physicalDescription.deity,
                                );
                                _character = Character(
                                  id: _character.id,
                                  name: _character.name,
                                  characterClass: _character.characterClass,
                                  subclass: _character.subclass,
                                  race: _character.race,
                                  background: _character.background,
                                  moralAlignment: _character.moralAlignment,
                                  level: _character.level,
                                  experiencePoints: _character.experiencePoints,
                                  inspiration: _character.inspiration,
                                  abilityScores: _character.abilityScores,
                                  modifiers: _character.modifiers,
                                  proficiencies: _character.proficiencies,
                                  combatStats: _character.combatStats,
                                  health: _character.health,
                                  equipment: _character.equipment,
                                  wealth: _character.wealth,
                                  spellcasting: _character.spellcasting,
                                  traits: _character.traits,
                                  features: _character.features,
                                  racialTraits: _character.racialTraits,
                                  backgroundTraits: _character.backgroundTraits,
                                  physicalDescription: newPhysicalDescription,
                                  notes: _character.notes,
                                  createdAt: _character.createdAt,
                                  updatedAt: DateTime.now(),
                                );
                              });
                            }),
                        _buildDescriptionField(
                            'Eyes', _character.physicalDescription.eyes,
                                (value) {
                              setState(() {
                                final newPhysicalDescription = PhysicalDescription(
                                  age: _character.physicalDescription.age,
                                  height: _character.physicalDescription.height,
                                  weight: _character.physicalDescription.weight,
                                  eyes: value,
                                  skin: _character.physicalDescription.skin,
                                  hair: _character.physicalDescription.hair,
                                  deity: _character.physicalDescription.deity,
                                );
                                _character = Character(
                                  id: _character.id,
                                  name: _character.name,
                                  characterClass: _character.characterClass,
                                  subclass: _character.subclass,
                                  race: _character.race,
                                  background: _character.background,
                                  moralAlignment: _character.moralAlignment,
                                  level: _character.level,
                                  experiencePoints: _character.experiencePoints,
                                  inspiration: _character.inspiration,
                                  abilityScores: _character.abilityScores,
                                  modifiers: _character.modifiers,
                                  proficiencies: _character.proficiencies,
                                  combatStats: _character.combatStats,
                                  health: _character.health,
                                  equipment: _character.equipment,
                                  wealth: _character.wealth,
                                  spellcasting: _character.spellcasting,
                                  traits: _character.traits,
                                  features: _character.features,
                                  racialTraits: _character.racialTraits,
                                  backgroundTraits: _character.backgroundTraits,
                                  physicalDescription: newPhysicalDescription,
                                  notes: _character.notes,
                                  createdAt: _character.createdAt,
                                  updatedAt: DateTime.now(),
                                );
                              });
                            }),
                        _buildDescriptionField(
                            'Skin', _character.physicalDescription.skin,
                                (value) {
                              setState(() {
                                final newPhysicalDescription = PhysicalDescription(
                                  age: _character.physicalDescription.age,
                                  height: _character.physicalDescription.height,
                                  weight: _character.physicalDescription.weight,
                                  eyes: _character.physicalDescription.eyes,
                                  skin: value,
                                  hair: _character.physicalDescription.hair,
                                  deity: _character.physicalDescription.deity,
                                );
                                _character = Character(
                                  id: _character.id,
                                  name: _character.name,
                                  characterClass: _character.characterClass,
                                  subclass: _character.subclass,
                                  race: _character.race,
                                  background: _character.background,
                                  moralAlignment: _character.moralAlignment,
                                  level: _character.level,
                                  experiencePoints: _character.experiencePoints,
                                  inspiration: _character.inspiration,
                                  abilityScores: _character.abilityScores,
                                  modifiers: _character.modifiers,
                                  proficiencies: _character.proficiencies,
                                  combatStats: _character.combatStats,
                                  health: _character.health,
                                  equipment: _character.equipment,
                                  wealth: _character.wealth,
                                  spellcasting: _character.spellcasting,
                                  traits: _character.traits,
                                  features: _character.features,
                                  racialTraits: _character.racialTraits,
                                  backgroundTraits: _character.backgroundTraits,
                                  physicalDescription: newPhysicalDescription,
                                  notes: _character.notes,
                                  createdAt: _character.createdAt,
                                  updatedAt: DateTime.now(),
                                );
                              });
                            }),
                        _buildDescriptionField(
                            'Hair', _character.physicalDescription.hair,
                                (value) {
                              setState(() {
                                final newPhysicalDescription = PhysicalDescription(
                                  age: _character.physicalDescription.age,
                                  height: _character.physicalDescription.height,
                                  weight: _character.physicalDescription.weight,
                                  eyes: _character.physicalDescription.eyes,
                                  skin: _character.physicalDescription.skin,
                                  hair: value,
                                  deity: _character.physicalDescription.deity,
                                );
                                _character = Character(
                                  id: _character.id,
                                  name: _character.name,
                                  characterClass: _character.characterClass,
                                  subclass: _character.subclass,
                                  race: _character.race,
                                  background: _character.background,
                                  moralAlignment: _character.moralAlignment,
                                  level: _character.level,
                                  experiencePoints: _character.experiencePoints,
                                  inspiration: _character.inspiration,
                                  abilityScores: _character.abilityScores,
                                  modifiers: _character.modifiers,
                                  proficiencies: _character.proficiencies,
                                  combatStats: _character.combatStats,
                                  health: _character.health,
                                  equipment: _character.equipment,
                                  wealth: _character.wealth,
                                  spellcasting: _character.spellcasting,
                                  traits: _character.traits,
                                  features: _character.features,
                                  racialTraits: _character.racialTraits,
                                  backgroundTraits: _character.backgroundTraits,
                                  physicalDescription: newPhysicalDescription,
                                  notes: _character.notes,
                                  createdAt: _character.createdAt,
                                  updatedAt: DateTime.now(),
                                );
                              });
                            }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDescriptionField(
                        'Deity', _character.physicalDescription.deity,
                            (value) {
                          setState(() {
                            final newPhysicalDescription = PhysicalDescription(
                              age: _character.physicalDescription.age,
                              height: _character.physicalDescription.height,
                              weight: _character.physicalDescription.weight,
                              eyes: _character.physicalDescription.eyes,
                              skin: _character.physicalDescription.skin,
                              hair: _character.physicalDescription.hair,
                              deity: value,
                            );
                            _character = Character(
                              id: _character.id,
                              name: _character.name,
                              characterClass: _character.characterClass,
                              subclass: _character.subclass,
                              race: _character.race,
                              background: _character.background,
                              moralAlignment: _character.moralAlignment,
                              level: _character.level,
                              experiencePoints: _character.experiencePoints,
                              inspiration: _character.inspiration,
                              abilityScores: _character.abilityScores,
                              modifiers: _character.modifiers,
                              proficiencies: _character.proficiencies,
                              combatStats: _character.combatStats,
                              health: _character.health,
                              equipment: _character.equipment,
                              wealth: _character.wealth,
                              spellcasting: _character.spellcasting,
                              traits: _character.traits,
                              features: _character.features,
                              racialTraits: _character.racialTraits,
                              backgroundTraits: _character.backgroundTraits,
                              physicalDescription: newPhysicalDescription,
                              notes: _character.notes,
                              createdAt: _character.createdAt,
                              updatedAt: DateTime.now(),
                            );
                          });
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeTextField(
      String label, String value, Function(String) onChanged) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            filled: true,
            fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
          ),
          style: TextStyle(color: colorScheme.onSurface),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDescriptionField(
      String label, String value, Function(String) onChanged) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
          ),
          style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}