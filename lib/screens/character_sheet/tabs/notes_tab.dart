import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class NotesTab extends StatefulWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const NotesTab({
    super.key,
    required this.character,
    required this.onCharacterUpdated,
  });

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  late Character _character;

  @override
  void initState() {
    super.initState();
    _character = widget.character;
  }

  void _updateTraits(String field, String value) {
    setState(() {
      final newTraits = Traits(
        personalityTraits: field == 'personalityTraits' ? value : _character.traits.personalityTraits,
        ideals: field == 'ideals' ? value : _character.traits.ideals,
        bonds: field == 'bonds' ? value : _character.traits.bonds,
        flaws: field == 'flaws' ? value : _character.traits.flaws,
        alliesAndOrganizations: _character.traits.alliesAndOrganizations,
      );

      // Create new character with updated traits
      _character = Character(
        id: _character.id,
        name: _character.name,
        playerName: _character.playerName,
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
      ).copyWithCalculatedValues();
    });
    widget.onCharacterUpdated(_character);
  }

  void _updateNotes(String field, String value) {
    setState(() {
      final newNotes = Notes(
        backstory: field == 'backstory' ? value : _character.notes.backstory,
        appearance: field == 'appearance' ? value : _character.notes.appearance,
        inventoryNotes: _character.notes.inventoryNotes,
        languagesNotes: _character.notes.languagesNotes,
        otherNotes: _character.notes.otherNotes,
      );

      // Create new character with updated notes
      _character = Character(
        id: _character.id,
        name: _character.name,
        playerName: _character.playerName,
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
      ).copyWithCalculatedValues();
    });
    widget.onCharacterUpdated(_character);
  }

  void _updatePhysicalDescription(String field, String value) {
    setState(() {
      final newPhysicalDescription = PhysicalDescription(
        age: field == 'age' ? int.tryParse(value) ?? _character.physicalDescription.age : _character.physicalDescription.age,
        height: field == 'height' ? value : _character.physicalDescription.height,
        weight: field == 'weight' ? value : _character.physicalDescription.weight,
        eyes: field == 'eyes' ? value : _character.physicalDescription.eyes,
        skin: field == 'skin' ? value : _character.physicalDescription.skin,
        hair: field == 'hair' ? value : _character.physicalDescription.hair,
        deity: field == 'deity' ? value : _character.physicalDescription.deity,
      );

      // Create new character with updated physical description
      _character = Character(
        id: _character.id,
        name: _character.name,
        playerName: _character.playerName,
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
      ).copyWithCalculatedValues();
    });
    widget.onCharacterUpdated(_character);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Personality
            _buildPersonalityCard(colorScheme),
            const SizedBox(height: 20),

            // Backstory & Appearance
            _buildBackstoryCard(colorScheme),
            const SizedBox(height: 20),

            // Physical Description
            _buildPhysicalDescriptionCard(colorScheme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalityCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('PERSONALITY', Icons.psychology_outlined, colorScheme),
            const SizedBox(height: 20),
            _buildLargeTextField('Personality Traits', _character.traits.personalityTraits,
                    (value) => _updateTraits('personalityTraits', value)),
            const SizedBox(height: 16),
            _buildLargeTextField('Ideals', _character.traits.ideals,
                    (value) => _updateTraits('ideals', value)),
            const SizedBox(height: 16),
            _buildLargeTextField('Bonds', _character.traits.bonds,
                    (value) => _updateTraits('bonds', value)),
            const SizedBox(height: 16),
            _buildLargeTextField('Flaws', _character.traits.flaws,
                    (value) => _updateTraits('flaws', value)),
          ],
        ),
      ),
    );
  }

  Widget _buildBackstoryCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('BACKSTORY & APPEARANCE', Icons.history_outlined, colorScheme),
            const SizedBox(height: 20),
            _buildLargeTextField('Backstory', _character.notes.backstory,
                    (value) => _updateNotes('backstory', value)),
            const SizedBox(height: 16),
            _buildLargeTextField('Appearance', _character.notes.appearance,
                    (value) => _updateNotes('appearance', value)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalDescriptionCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('PHYSICAL DESCRIPTION', Icons.person_outline_outlined, colorScheme),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDescriptionField('Age', _character.physicalDescription.age.toString(),
                        (value) => _updatePhysicalDescription('age', value)),
                _buildDescriptionField('Height', _character.physicalDescription.height,
                        (value) => _updatePhysicalDescription('height', value)),
                _buildDescriptionField('Weight', _character.physicalDescription.weight,
                        (value) => _updatePhysicalDescription('weight', value)),
                _buildDescriptionField('Eyes', _character.physicalDescription.eyes,
                        (value) => _updatePhysicalDescription('eyes', value)),
                _buildDescriptionField('Skin', _character.physicalDescription.skin,
                        (value) => _updatePhysicalDescription('skin', value)),
                _buildDescriptionField('Hair', _character.physicalDescription.hair,
                        (value) => _updatePhysicalDescription('hair', value)),
              ],
            ),
            const SizedBox(height: 16),
            _buildDescriptionField('Deity', _character.physicalDescription.deity,
                    (value) => _updatePhysicalDescription('deity', value)),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeTextField(String label, String value, Function(String) onChanged) {
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

  Widget _buildDescriptionField(String label, String value, Function(String) onChanged) {
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

  Widget _buildSectionTitle(String title, IconData icon, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: colorScheme.onSurface.withOpacity(0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}