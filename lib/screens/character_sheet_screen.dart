import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';
import 'magic_item_list_screen.dart';

class CharacterSheetScreen extends StatefulWidget {
  const CharacterSheetScreen({super.key});

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen> with SingleTickerProviderStateMixin {
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
            // Note: You'll need to implement a method to calculate HP gain
            Text('+? HP (+${_character.modifiers.constitution} from CON)'),
            const SizedBox(height: 16),
            // TODO: Check if this is a feature level
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
                // _character = _character.copyWith(
                //   level: _character.level + 1,
                // ).copyWithCalculatedValues();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_character.name.isEmpty ? 'New Character' : _character.name),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Character saved')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: _navigateToMagicItems,
            tooltip: 'Magic Items',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: _showLevelUpDialog,
            tooltip: 'Level Up',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Core Info'),
            Tab(text: 'Combat'),
            Tab(text: 'Equipment'),
            Tab(text: 'Spells'),
            Tab(text: 'Features'),
            Tab(text: 'Notes'),
          ],
        ),
      ),
      body: TabBarView(
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
    );
  }

  Widget _buildCoreInfoTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Character Basics Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('CHARACTER BASICS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(text: _character.name),
                      decoration: const InputDecoration(labelText: 'Character Name'),
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
                    const SizedBox(height: 12),
                    TextField(
                      controller: TextEditingController(text: _character.playerName),
                      decoration: const InputDecoration(labelText: 'Player Name'),
                      onChanged: (value) => setState(() {
                        // Note: Player name not in new model, you might need to add it
                      }),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<CharacterClass>(
                            value: _character.characterClass,
                            decoration: const InputDecoration(labelText: 'Class'),
                            items: CharacterClass.values.map((cls) {
                              return DropdownMenuItem(
                                value: cls,
                                child: Text(cls.displayName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _character = Character(
                                    id: _character.id,
                                    name: _character.name,
                                    characterClass: value,
                                    subclass: Subclass.none, // Reset subclass when class changes
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
                                    spellcasting: null, // Reset spellcasting when class changes
                                    traits: _character.traits,
                                    features: [], // Reset features when class changes
                                    racialTraits: _character.racialTraits,
                                    backgroundTraits: _character.backgroundTraits,
                                    physicalDescription: _character.physicalDescription,
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
                            controller: TextEditingController(text: _character.level.toString()),
                            decoration: const InputDecoration(labelText: 'Level'),
                            keyboardType: TextInputType.number,
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
                                  physicalDescription: _character.physicalDescription,
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Race>(
                            value: _character.race,
                            decoration: const InputDecoration(labelText: 'Race'),
                            items: Race.values.map((race) {
                              return DropdownMenuItem(
                                value: race,
                                child: Text(race.displayName),
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
                                    racialTraits: [], // Reset racial traits when race changes
                                    backgroundTraits: _character.backgroundTraits,
                                    physicalDescription: _character.physicalDescription,
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
                            decoration: const InputDecoration(labelText: 'Background'),
                            items: Background.values.map((bg) {
                              return DropdownMenuItem(
                                value: bg,
                                child: Text(bg.displayName),
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
                                    backgroundTraits: [], // Reset background traits when background changes
                                    physicalDescription: _character.physicalDescription,
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                    Expanded(
                    child: DropdownButtonFormField<MoralAlignment>( // Changed from Alignment to MoralAlignment
                      value: _character.moralAlignment, // This should match the field name in Character
                      decoration: const InputDecoration(labelText: 'Alignment'),
                      items: MoralAlignment.values.map((align) {
                        return DropdownMenuItem<MoralAlignment>( // Specify the type here
                          value: align,
                          child: Text(align.displayName),
                        );
                      }).toList(),
                      onChanged: (MoralAlignment? value) { // Add type annotation
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
                              moralAlignment: value, // Make sure this matches the field name
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
                          });
                        }
                      },
                    ),
              ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: _character.experiencePoints.toString()),
                            decoration: const InputDecoration(labelText: 'Experience Points'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final xp = int.tryParse(value) ?? _character.experiencePoints;
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
                                  physicalDescription: _character.physicalDescription,
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

            const SizedBox(height: 16),

            // Attributes Grid
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('ATTRIBUTES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _buildAttributeCard('STR', 'Strength', _character.abilityScores.strength, _character.modifiers.strength),
                        _buildAttributeCard('DEX', 'Dexterity', _character.abilityScores.dexterity, _character.modifiers.dexterity),
                        _buildAttributeCard('CON', 'Constitution', _character.abilityScores.constitution, _character.modifiers.constitution),
                        _buildAttributeCard('INT', 'Intelligence', _character.abilityScores.intelligence, _character.modifiers.intelligence),
                        _buildAttributeCard('WIS', 'Wisdom', _character.abilityScores.wisdom, _character.modifiers.wisdom),
                        _buildAttributeCard('CHA', 'Charisma', _character.abilityScores.charisma, _character.modifiers.charisma),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Skills Grid
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('SKILLS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    _buildSkillsGrid(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Saving Throws
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('SAVING THROWS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    _buildSavingThrowGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeCard(String abbreviation, String name, int value, int modifier) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(abbreviation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              modifier >= 0 ? '+$modifier' : '$modifier',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 16),
                onPressed: () => _updateAttribute(name.toLowerCase(), value - 1),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 16),
                onPressed: () => _updateAttribute(name.toLowerCase(), value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateAttribute(String attribute, int value) {
    setState(() {
      value = value.clamp(1, 30); // D&D attribute range

      final newAbilityScores = AbilityScores(
        strength: attribute == 'strength' ? value : _character.abilityScores.strength,
        dexterity: attribute == 'dexterity' ? value : _character.abilityScores.dexterity,
        constitution: attribute == 'constitution' ? value : _character.abilityScores.constitution,
        intelligence: attribute == 'intelligence' ? value : _character.abilityScores.intelligence,
        wisdom: attribute == 'wisdom' ? value : _character.abilityScores.wisdom,
        charisma: attribute == 'charisma' ? value : _character.abilityScores.charisma,
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
    final saves = [
      {'name': 'STR', 'mod': _character.proficiencies.savingThrows.getModifier('strength', _character.modifiers, _character.proficiencies.proficiencyBonus), 'proficient': _character.proficiencies.savingThrows.strength},
      {'name': 'DEX', 'mod': _character.proficiencies.savingThrows.getModifier('dexterity', _character.modifiers, _character.proficiencies.proficiencyBonus), 'proficient': _character.proficiencies.savingThrows.dexterity},
      {'name': 'CON', 'mod': _character.proficiencies.savingThrows.getModifier('constitution', _character.modifiers, _character.proficiencies.proficiencyBonus), 'proficient': _character.proficiencies.savingThrows.constitution},
      {'name': 'INT', 'mod': _character.proficiencies.savingThrows.getModifier('intelligence', _character.modifiers, _character.proficiencies.proficiencyBonus), 'proficient': _character.proficiencies.savingThrows.intelligence},
      {'name': 'WIS', 'mod': _character.proficiencies.savingThrows.getModifier('wisdom', _character.modifiers, _character.proficiencies.proficiencyBonus), 'proficient': _character.proficiencies.savingThrows.wisdom},
      {'name': 'CHA', 'mod': _character.proficiencies.savingThrows.getModifier('charisma', _character.modifiers, _character.proficiencies.proficiencyBonus), 'proficient': _character.proficiencies.savingThrows.charisma},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: saves.map((save) {
        final name = save['name'] as String;
        final mod = save['mod'] as int;
        final proficient = save['proficient'] as bool;

        return GestureDetector(
          onTap: () {
            setState(() {
              final newSavingThrows = SavingThrowProficiencies(
                strength: name == 'STR' ? !proficient : _character.proficiencies.savingThrows.strength,
                dexterity: name == 'DEX' ? !proficient : _character.proficiencies.savingThrows.dexterity,
                constitution: name == 'CON' ? !proficient : _character.proficiencies.savingThrows.constitution,
                intelligence: name == 'INT' ? !proficient : _character.proficiencies.savingThrows.intelligence,
                wisdom: name == 'WIS' ? !proficient : _character.proficiencies.savingThrows.wisdom,
                charisma: name == 'CHA' ? !proficient : _character.proficiencies.savingThrows.charisma,
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
              border: Border.all(
                color: proficient ? Colors.blue : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: proficient ? Colors.blue : Colors.grey,
                  )),
                  Text(
                    mod >= 0 ? '+$mod' : '$mod',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      childAspectRatio: 5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 4,
      children: skills.map((skillData) {
        final skill = skillData['skill'] as Skill;
        final name = skillData['name'] as String;
        final mod = _character.proficiencies.skills.getModifier(skill, _character.modifiers, _character.proficiencies.proficiencyBonus);
        final proficiency = _character.proficiencies.skills.proficiencies[skill] ?? ProficiencyLevel.none;

        return GestureDetector(
          onTap: () {
            setState(() {
              final newProficiencies = Map<Skill, ProficiencyLevel>.from(_character.proficiencies.skills.proficiencies);
              newProficiencies[skill] = proficiency == ProficiencyLevel.none
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
              border: Border.all(
                color: proficiency == ProficiencyLevel.expert ? Colors.amber :
                proficiency == ProficiencyLevel.proficient ? Colors.green :
                Colors.grey,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: proficiency != ProficiencyLevel.none ? FontWeight.bold : FontWeight.normal,
                        color: proficiency == ProficiencyLevel.expert ? Colors.amber :
                        proficiency == ProficiencyLevel.proficient ? Colors.green :
                        Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      mod >= 0 ? '+$mod' : '$mod',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildCombatTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Combat Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard('ARMOR CLASS', '${_character.combatStats.armorClass}', Colors.blue),
                _buildStatCard('INITIATIVE', '${_character.combatStats.initiative}', Colors.green),
                _buildStatCard('SPEED', '${_character.combatStats.speed} ft', Colors.orange),
                _buildStatCard('PROFICIENCY', '+${_character.proficiencies.proficiencyBonus}', Colors.purple),
              ],
            ),

            const SizedBox(height: 16),

            // Hit Points
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('HIT POINTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _updateHitPoints(-1),
                        ),
                        Column(
                          children: [
                            Text(
                              '${_character.health.currentHitPoints} / ${_character.health.maxHitPoints}',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Temp HP: ${_character.health.temporaryHitPoints}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _updateHitPoints(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Hit Dice: ${_character.health.hitDice.map((hd) => '${hd.count - hd.used}/${hd.count}d${hd.sides}').join(', ')}'),
                    const SizedBox(height: 12),
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

            const SizedBox(height: 16),

            // Death Saves
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('DEATH SAVES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Successes', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        final newDeathSaves = DeathSaves(
                                          successes: index + 1,
                                          failures: _character.health.deathSaves.failures,
                                        );
                                        final newHealth = _character.health.copyWith(deathSaves: newDeathSaves);
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
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.green, width: 2),
                                        color: index < _character.health.deathSaves.successes ? Colors.green : Colors.transparent,
                                      ),
                                      child: index < _character.health.deathSaves.successes
                                          ? const Icon(Icons.check, size: 20, color: Colors.white)
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
                          height: 60,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Failures', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        final newDeathSaves = DeathSaves(
                                          successes: _character.health.deathSaves.successes,
                                          failures: index + 1,
                                        );
                                        final newHealth = _character.health.copyWith(deathSaves: newDeathSaves);
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
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.red, width: 2),
                                        color: index < _character.health.deathSaves.failures ? Colors.red : Colors.transparent,
                                      ),
                                      child: index < _character.health.deathSaves.failures
                                          ? const Icon(Icons.close, size: 20, color: Colors.white)
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

            const SizedBox(height: 16),

            // Weapons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('WEAPONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ..._character.equipment.weapons.take(3).map((weapon) => _buildWeaponRow(weapon)),
                    if (_character.equipment.weapons.length > 3)
                      TextButton(
                        onPressed: () {
                          // TODO: Show all weapons
                        },
                        child: const Text('Show all weapons...'),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: color)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildHitDieButton(String text, {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.blue,
      ),
      child: Text(text),
    );
  }

  Widget _buildWeaponRow(Weapon weapon) {
    return ListTile(
      leading: const Icon(Icons.gavel),
      title: Text(weapon.name),
      subtitle: Text('${weapon.damage} ${weapon.damageType}'),
      trailing: Text('+${weapon.attackBonus} to hit'),
      onTap: () {
        // TODO: Show weapon details
      },
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Currency
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('CURRENCY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCurrencyItem('CP', _character.wealth.copper, Colors.orange),
                        _buildCurrencyItem('SP', _character.wealth.silver, Colors.grey),
                        _buildCurrencyItem('EP', _character.wealth.electrum, Colors.yellow[700]!),
                        _buildCurrencyItem('GP', _character.wealth.gold, Colors.yellow),
                        _buildCurrencyItem('PP', _character.wealth.platinum, Colors.blue[200]!),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Equipment
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('EQUIPMENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ..._character.equipment.inventory.map((item) => _buildEquipmentItem(item)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Armor
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('ARMOR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ..._character.equipment.armor.map((armor) => _buildArmorItem(armor)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyItem(String label, int amount, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text('$amount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEquipmentItem(EquipmentItem item) {
    return ListTile(
      leading: Checkbox(
        value: item.isEquipped,
        onChanged: (value) {
          // TODO: Update equipment
        },
      ),
      title: Text(item.name),
      subtitle: Text('Qty: ${item.quantity} • Weight: ${item.weight} lb'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          // TODO: Remove equipment
        },
      ),
    );
  }

  Widget _buildArmorItem(Armor armor) {
    return ListTile(
      leading: Checkbox(
        value: armor.isEquipped,
        onChanged: (value) {
          // TODO: Update armor
        },
      ),
      title: Text(armor.name),
      subtitle: Text('AC ${armor.baseAC} • ${armor.armorType}'),
      trailing: Text(armor.stealthDisadvantage ? 'Stealth Dis.' : ''),
    );
  }

  Widget _buildSpellsTab() {
    if (_character.spellcasting == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No Spellcasting'),
            Text(
              '${_character.characterClass.displayName} does not have spellcasting',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Spellcasting Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('SPELLCASTING', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSpellStat('SPELL DC', '${_character.spellcasting!.spellSaveDC}'),
                        _buildSpellStat('ATTACK BONUS', '+${_character.spellcasting!.spellAttackBonus}'),
                        _buildSpellStat('ABILITY', _character.spellcasting!.spellcastingAbility?.toUpperCase() ?? ''),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Spell Slots
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('SPELL SLOTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    _buildSpellSlots(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Prepared Spells
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('PREPARED SPELLS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ..._character.spellcasting!.preparedSpells.take(5).map((spell) => _buildSpellRow(spell)),
                    if (_character.spellcasting!.preparedSpells.length > 5)
                      TextButton(
                        onPressed: () {
                          // TODO: Show all spells
                        },
                        child: const Text('Show all spells...'),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSpellSlots() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.2,
      children: List.generate(9, (index) {
        final slot = _character.spellcasting!.spellSlots.firstWhere(
              (s) => s.level == index + 1,
          orElse: () => SpellSlot(level: index + 1, total: 0, used: 0),
        );

        if (slot.total == 0) return Container();

        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Level ${slot.level}', style: const TextStyle(fontSize: 12)),
              Text('${slot.remaining}/${slot.total}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSpellRow(Spell spell) {
    return ListTile(
      leading: Text('${spell.level}', style: const TextStyle(fontWeight: FontWeight.bold)),
      title: Text(spell.name),
      subtitle: Text(spell.school),
      trailing: Wrap(
        spacing: 4,
        children: [
          if (spell.isRitual)
            const Chip(label: Text('Ritual', style: TextStyle(fontSize: 10))),
          if (spell.isConcentration)
            const Chip(label: Text('Conc.', style: TextStyle(fontSize: 10))),
        ],
      ),
    );
  }

  Widget _buildFeaturesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Class Features
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('CLASS FEATURES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ..._character.features.where((f) => f.source == 'class').map((feature) => _buildFeatureItem(feature)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Racial Features
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('RACIAL FEATURES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ..._character.racialTraits.map((feature) => _buildFeatureItem(feature)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Background Features
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('BACKGROUND FEATURES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ..._character.backgroundTraits.map((feature) => _buildFeatureItem(feature)),
                  ],
                ),
              ),
            ),

            // Note: Feats are not in the new model, you might need to add them
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(Feature feature) {
    return ExpansionTile(
      title: Text(feature.name),
      subtitle: Text('Level ${feature.levelObtained}'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(feature.description),
        ),
      ],
    );
  }

  Widget _buildNotesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Personality
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('PERSONALITY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    _buildLargeTextField('Traits', _character.traits.personalityTraits, (value) {
                      setState(() {
                        final newTraits = Traits(
                          personalityTraits: value,
                          ideals: _character.traits.ideals,
                          bonds: _character.traits.bonds,
                          flaws: _character.traits.flaws,
                          alliesAndOrganizations: _character.traits.alliesAndOrganizations,
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
                    const SizedBox(height: 12),
                    _buildLargeTextField('Ideals', _character.traits.ideals, (value) {
                      setState(() {
                        final newTraits = Traits(
                          personalityTraits: _character.traits.personalityTraits,
                          ideals: value,
                          bonds: _character.traits.bonds,
                          flaws: _character.traits.flaws,
                          alliesAndOrganizations: _character.traits.alliesAndOrganizations,
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
                    const SizedBox(height: 12),
                    _buildLargeTextField('Bonds', _character.traits.bonds, (value) {
                      setState(() {
                        final newTraits = Traits(
                          personalityTraits: _character.traits.personalityTraits,
                          ideals: _character.traits.ideals,
                          bonds: value,
                          flaws: _character.traits.flaws,
                          alliesAndOrganizations: _character.traits.alliesAndOrganizations,
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
                    const SizedBox(height: 12),
                    _buildLargeTextField('Flaws', _character.traits.flaws, (value) {
                      setState(() {
                        final newTraits = Traits(
                          personalityTraits: _character.traits.personalityTraits,
                          ideals: _character.traits.ideals,
                          bonds: _character.traits.bonds,
                          flaws: value,
                          alliesAndOrganizations: _character.traits.alliesAndOrganizations,
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

            const SizedBox(height: 16),

            // Backstory & Appearance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('BACKSTORY & APPEARANCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    _buildLargeTextField('Backstory', _character.notes.backstory, (value) {
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
                    const SizedBox(height: 12),
                    _buildLargeTextField('Appearance', _character.notes.appearance, (value) {
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

            const SizedBox(height: 16),

            // Physical Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('PHYSICAL DESCRIPTION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _buildDescriptionField('Age', _character.physicalDescription.age.toString(), (value) {
                          final age = int.tryParse(value) ?? _character.physicalDescription.age;
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
                        _buildDescriptionField('Height', _character.physicalDescription.height, (value) {
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
                        _buildDescriptionField('Weight', _character.physicalDescription.weight, (value) {
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
                        _buildDescriptionField('Eyes', _character.physicalDescription.eyes, (value) {
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
                        _buildDescriptionField('Skin', _character.physicalDescription.skin, (value) {
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
                        _buildDescriptionField('Hair', _character.physicalDescription.hair, (value) {
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeTextField(String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDescriptionField(String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        TextField(
          controller: TextEditingController(text: value),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
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