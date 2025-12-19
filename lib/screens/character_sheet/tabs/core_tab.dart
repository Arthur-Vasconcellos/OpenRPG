import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';
import 'package:openrpg/data/dnd_rules.dart';
import 'package:openrpg/screens/character_sheet/widget/attribute_card.dart';
import 'package:openrpg/screens/character_sheet/widget/saving_throw_grid.dart';

class CoreTab extends StatefulWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const CoreTab({
    super.key,
    required this.character,
    required this.onCharacterUpdated,
  });

  @override
  State<CoreTab> createState() => _CoreTabState();
}

class _CoreTabState extends State<CoreTab> {
  late Character _character;
  SkillSortOrder _skillSortOrder = SkillSortOrder.byProficiency;

  @override
  void initState() {
    super.initState();
    _character = widget.character;
  }

  void _updateCharacter(Character newCharacter) {
    setState(() {
      _character = newCharacter;
    });
    widget.onCharacterUpdated(_character);
  }

  void _updateAttribute(String attribute, int value) {
    value = value.clamp(1, 30);

    final newAbilityScores = _character.abilityScores.copyWith(
      strength: attribute == 'strength' ? value : null,
      dexterity: attribute == 'dexterity' ? value : null,
      constitution: attribute == 'constitution' ? value : null,
      intelligence: attribute == 'intelligence' ? value : null,
      wisdom: attribute == 'wisdom' ? value : null,
      charisma: attribute == 'charisma' ? value : null,
    );

    final newCharacter = _character.copyWith(
      abilityScores: newAbilityScores,
    );

    _updateCharacter(newCharacter);
  }

  void _updateProficiencyBonus(int newBonus) {
    final newProficiencies = _character.proficiencies.copyWith(
      proficiencyBonus: newBonus.clamp(0, 6),
    );

    final newCharacter = _character.copyWith(
      proficiencies: newProficiencies,
    );

    _updateCharacter(newCharacter);
  }

  void _updateField(String field, dynamic value) {
    Character newCharacter;

    switch (field) {
      case 'name':
        newCharacter = _character.copyWith(name: value as String);
        break;
      case 'race':
        newCharacter = _character.copyWith(
          race: value as Race,
          racialTraits: [], // Reset racial traits
        );
        break;
      case 'background':
        newCharacter = _character.copyWith(
          background: value as Background,
          backgroundTraits: [], // Reset background traits
        );
        break;
      case 'moralAlignment':
        newCharacter = _character.copyWith(moralAlignment: value as MoralAlignment);
        break;
      case 'experiencePoints':
        newCharacter = _character.copyWith(experiencePoints: value as int);
        break;
      default:
        return;
    }

    _updateCharacter(newCharacter);
  }

  void _addClass() {
    final newClasses = List<CharacterClassLevel>.from(_character.classes)
      ..add(CharacterClassLevel(
        characterClass: CharacterClass.fighter,
        level: 1,
      ));

    final newCharacter = _character.copyWith(classes: newClasses);
    _updateCharacter(newCharacter);
  }

  void _removeClass(int index) {
    if (_character.classes.length <= 1) return;

    final newClasses = List<CharacterClassLevel>.from(_character.classes);
    newClasses.removeAt(index);

    final newCharacter = _character.copyWith(classes: newClasses);
    _updateCharacter(newCharacter);
  }

  void _updateClass(int index, CharacterClassLevel updatedClass) {
    final newClasses = List<CharacterClassLevel>.from(_character.classes);
    newClasses[index] = updatedClass;

    final newCharacter = _character.copyWith(classes: newClasses);
    _updateCharacter(newCharacter);
  }

  void _toggleSkillProficiency(Skill skill, ProficiencyLevel current) {
    final newProficiencies = Map<Skill, ProficiencyLevel>.from(
        _character.proficiencies.skills.proficiencies
    );

    newProficiencies[skill] = current == ProficiencyLevel.none
        ? ProficiencyLevel.proficient
        : current == ProficiencyLevel.proficient
        ? ProficiencyLevel.expert
        : ProficiencyLevel.none;

    final newSkills = _character.proficiencies.skills.copyWith(
      proficiencies: newProficiencies,
    );
    final newProficiencySet = _character.proficiencies.copyWith(
      skills: newSkills,
    );

    final newCharacter = _character.copyWith(
      proficiencies: newProficiencySet,
    );

    _updateCharacter(newCharacter);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Character Basics Card
                  _buildCharacterBasicsCard(colorScheme),
                  const SizedBox(height: 16),

                  // Proficiency Bonus Card
                  _buildProficiencyBonusCard(colorScheme),
                  const SizedBox(height: 16),

                  // Attributes Grid
                  _buildAttributesCard(colorScheme),
                  const SizedBox(height: 16),

                  // Skills Card
                  _buildSkillsCard(colorScheme),
                  const SizedBox(height: 16),

                  // Saving Throws
                  _buildSavingThrowsCard(colorScheme),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCharacterBasicsCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('CHARACTER BASICS', Icons.person_outline, colorScheme),
            const SizedBox(height: 16),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
              onChanged: (value) => _updateField('name', value),
            ),
            const SizedBox(height: 12),

            // Multiclass fields
            _buildClassFields(colorScheme),
            const SizedBox(height: 12),

            // Race, Background, Alignment, XP
            _buildBasicInfoFields(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildClassFields(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.class_outlined, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'CLASSES (Total Level: ${_character.totalLevel})',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.7),
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.add, color: colorScheme.primary),
              onPressed: _addClass,
              tooltip: 'Add another class',
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._character.classes.asMap().entries.map((entry) {
          final index = entry.key;
          final classLevel = entry.value;

          return _buildClassRow(index, classLevel, colorScheme);
        }).toList(),
      ],
    );
  }

  Widget _buildClassRow(int index, CharacterClassLevel classLevel, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<CharacterClass>(
                    value: classLevel.characterClass,
                    decoration: InputDecoration(
                      labelText: 'Class ${index + 1}',
                      labelStyle: TextStyle(color: colorScheme.onSurface),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: CharacterClass.values.map((cls) {
                      return DropdownMenuItem(
                        value: cls,
                        child: Text(
                          cls.displayName,
                          style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _updateClass(index, classLevel.copyWith(characterClass: value));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: TextEditingController(text: classLevel.level.toString()),
                    decoration: InputDecoration(
                      labelText: 'Level',
                      labelStyle: TextStyle(color: colorScheme.onSurface),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                    onChanged: (value) {
                      final level = int.tryParse(value) ?? classLevel.level;
                      _updateClass(index, classLevel.copyWith(level: level.clamp(1, 20)));
                    },
                  ),
                ),
                if (_character.classes.length > 1)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                    onPressed: () => _removeClass(index),
                    tooltip: 'Remove this class',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoFields(ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 400) {
          return _buildVerticalBasicFields(colorScheme);
        } else {
          return _buildHorizontalBasicFields(colorScheme);
        }
      },
    );
  }

  Widget _buildVerticalBasicFields(ColorScheme colorScheme) {
    return Column(
      children: [
        DropdownButtonFormField<Race>(
          value: _character.race,
          decoration: InputDecoration(
            labelText: 'Race',
            labelStyle: TextStyle(color: colorScheme.onSurface),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: Race.values.map((race) {
            return DropdownMenuItem(
              value: race,
              child: Text(
                race.displayName,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _updateField('race', value);
            }
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Background>(
          value: _character.background,
          decoration: InputDecoration(
            labelText: 'Background',
            labelStyle: TextStyle(color: colorScheme.onSurface),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: Background.values.map((bg) {
            return DropdownMenuItem(
              value: bg,
              child: Text(
                bg.displayName,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _updateField('background', value);
            }
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<MoralAlignment>(
                value: _character.moralAlignment,
                decoration: InputDecoration(
                  labelText: 'Alignment',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: MoralAlignment.values.map((align) {
                  return DropdownMenuItem<MoralAlignment>(
                    value: align,
                    child: Text(
                      align.displayName,
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (MoralAlignment? value) {
                  if (value != null) {
                    _updateField('moralAlignment', value);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: _character.experiencePoints.toString()),
                decoration: InputDecoration(
                  labelText: 'XP',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
                onChanged: (value) {
                  final xp = int.tryParse(value) ?? _character.experiencePoints;
                  _updateField('experiencePoints', xp);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHorizontalBasicFields(ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Race>(
                value: _character.race,
                decoration: InputDecoration(
                  labelText: 'Race',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: Race.values.map((race) {
                  return DropdownMenuItem(
                    value: race,
                    child: Text(
                      race.displayName,
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _updateField('race', value);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<Background>(
                value: _character.background,
                decoration: InputDecoration(
                  labelText: 'Background',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: Background.values.map((bg) {
                  return DropdownMenuItem(
                    value: bg,
                    child: Text(
                      bg.displayName,
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _updateField('background', value);
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
              child: DropdownButtonFormField<MoralAlignment>(
                value: _character.moralAlignment,
                decoration: InputDecoration(
                  labelText: 'Alignment',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: MoralAlignment.values.map((align) {
                  return DropdownMenuItem<MoralAlignment>(
                    value: align,
                    child: Text(
                      align.displayName,
                      style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (MoralAlignment? value) {
                  if (value != null) {
                    _updateField('moralAlignment', value);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: _character.experiencePoints.toString()),
                decoration: InputDecoration(
                  labelText: 'XP',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
                onChanged: (value) {
                  final xp = int.tryParse(value) ?? _character.experiencePoints;
                  _updateField('experiencePoints', xp);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProficiencyBonusCard(ColorScheme colorScheme) {
    final expectedBonus = DndRules.calculateProficiencyBonus(_character.totalLevel);
    final isExpected = _character.proficiencies.proficiencyBonus == expectedBonus;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star_outline, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'PROFICIENCY BONUS (Level ${_character.totalLevel})',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (!isExpected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Expected: +$expectedBonus',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Icon(Icons.refresh, size: 16, color: colorScheme.primary),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _updateProficiencyBonus(expectedBonus);
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Bonus',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+${_character.proficiencies.proficiencyBonus}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: isExpected ? colorScheme.primary : colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Expected by Level ${_character.totalLevel}',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+$expectedBonus',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.remove, size: 20),
                    label: const Text('Decrease'),
                    onPressed: () {
                      if (_character.proficiencies.proficiencyBonus > 0) {
                        _updateProficiencyBonus(_character.proficiencies.proficiencyBonus - 1);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error.withOpacity(0.1),
                      foregroundColor: colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Increase'),
                    onPressed: () {
                      if (_character.proficiencies.proficiencyBonus < 6) {
                        _updateProficiencyBonus(_character.proficiencies.proficiencyBonus + 1);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      foregroundColor: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributesCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('ATTRIBUTES', Icons.fitness_center_outlined, colorScheme),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 400 ? 2 : 3;
                final childAspectRatio = constraints.maxWidth < 400 ? 0.9 : 0.85;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    AttributeCard(
                      abbreviation: 'STR',
                      name: 'Strength',
                      value: _character.abilityScores.strength,
                      modifier: _character.modifiers.strength,
                      onDecrement: () => _updateAttribute('strength', _character.abilityScores.strength - 1),
                      onIncrement: () => _updateAttribute('strength', _character.abilityScores.strength + 1),
                    ),
                    AttributeCard(
                      abbreviation: 'DEX',
                      name: 'Dexterity',
                      value: _character.abilityScores.dexterity,
                      modifier: _character.modifiers.dexterity,
                      onDecrement: () => _updateAttribute('dexterity', _character.abilityScores.dexterity - 1),
                      onIncrement: () => _updateAttribute('dexterity', _character.abilityScores.dexterity + 1),
                    ),
                    AttributeCard(
                      abbreviation: 'CON',
                      name: 'Constitution',
                      value: _character.abilityScores.constitution,
                      modifier: _character.modifiers.constitution,
                      onDecrement: () => _updateAttribute('constitution', _character.abilityScores.constitution - 1),
                      onIncrement: () => _updateAttribute('constitution', _character.abilityScores.constitution + 1),
                    ),
                    AttributeCard(
                      abbreviation: 'INT',
                      name: 'Intelligence',
                      value: _character.abilityScores.intelligence,
                      modifier: _character.modifiers.intelligence,
                      onDecrement: () => _updateAttribute('intelligence', _character.abilityScores.intelligence - 1),
                      onIncrement: () => _updateAttribute('intelligence', _character.abilityScores.intelligence + 1),
                    ),
                    AttributeCard(
                      abbreviation: 'WIS',
                      name: 'Wisdom',
                      value: _character.abilityScores.wisdom,
                      modifier: _character.modifiers.wisdom,
                      onDecrement: () => _updateAttribute('wisdom', _character.abilityScores.wisdom - 1),
                      onIncrement: () => _updateAttribute('wisdom', _character.abilityScores.wisdom + 1),
                    ),
                    AttributeCard(
                      abbreviation: 'CHA',
                      name: 'Charisma',
                      value: _character.abilityScores.charisma,
                      modifier: _character.modifiers.charisma,
                      onDecrement: () => _updateAttribute('charisma', _character.abilityScores.charisma - 1),
                      onIncrement: () => _updateAttribute('charisma', _character.abilityScores.charisma + 1),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.psychology_outlined, color: colorScheme.primary, size: 20),
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
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _skillSortOrder == SkillSortOrder.byProficiency
                        ? Icons.sort_by_alpha
                        : Icons.star_outline,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _skillSortOrder = _skillSortOrder == SkillSortOrder.byProficiency
                          ? SkillSortOrder.alphabetical
                          : SkillSortOrder.byProficiency;
                    });
                  },
                  tooltip: _skillSortOrder == SkillSortOrder.byProficiency
                      ? 'Sort alphabetically'
                      : 'Sort by proficiency',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSkillsGrid(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(ColorScheme colorScheme) {
    final skills = [
      {'skill': Skill.acrobatics, 'name': 'Acrobatics', 'ability': 'DEX'},
      {'skill': Skill.animalHandling, 'name': 'Animal Handling', 'ability': 'WIS'},
      {'skill': Skill.arcana, 'name': 'Arcana', 'ability': 'INT'},
      {'skill': Skill.athletics, 'name': 'Athletics', 'ability': 'STR'},
      {'skill': Skill.deception, 'name': 'Deception', 'ability': 'CHA'},
      {'skill': Skill.history, 'name': 'History', 'ability': 'INT'},
      {'skill': Skill.insight, 'name': 'Insight', 'ability': 'WIS'},
      {'skill': Skill.intimidation, 'name': 'Intimidation', 'ability': 'CHA'},
      {'skill': Skill.investigation, 'name': 'Investigation', 'ability': 'INT'},
      {'skill': Skill.medicine, 'name': 'Medicine', 'ability': 'WIS'},
      {'skill': Skill.nature, 'name': 'Nature', 'ability': 'INT'},
      {'skill': Skill.perception, 'name': 'Perception', 'ability': 'WIS'},
      {'skill': Skill.performance, 'name': 'Performance', 'ability': 'CHA'},
      {'skill': Skill.persuasion, 'name': 'Persuasion', 'ability': 'CHA'},
      {'skill': Skill.religion, 'name': 'Religion', 'ability': 'INT'},
      {'skill': Skill.sleightOfHand, 'name': 'Sleight of Hand', 'ability': 'DEX'},
      {'skill': Skill.stealth, 'name': 'Stealth', 'ability': 'DEX'},
      {'skill': Skill.survival, 'name': 'Survival', 'ability': 'WIS'},
    ];

    List<Map<String, dynamic>> sortedSkills = List.from(skills);

    if (_skillSortOrder == SkillSortOrder.byProficiency) {
      sortedSkills.sort((a, b) {
        final skillA = a['skill'] as Skill;
        final skillB = b['skill'] as Skill;

        final proficiencyA = _character.proficiencies.skills.proficiencies[skillA] ?? ProficiencyLevel.none;
        final proficiencyB = _character.proficiencies.skills.proficiencies[skillB] ?? ProficiencyLevel.none;

        if (proficiencyA != proficiencyB) {
          return proficiencyB.index.compareTo(proficiencyA.index);
        }

        return (a['name'] as String).compareTo(b['name'] as String);
      });
    } else {
      sortedSkills.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 400 ? 1 : 2;
        final childAspectRatio = constraints.maxWidth < 400 ? 5.0 : 4.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: sortedSkills.length,
          itemBuilder: (context, index) {
            final skillData = sortedSkills[index];
            final skill = skillData['skill'] as Skill;
            final name = skillData['name'] as String;
            final ability = skillData['ability'] as String;
            final mod = _character.proficiencies.skills.getModifier(
                skill,
                _character.modifiers,
                _character.proficiencies.proficiencyBonus
            );
            final proficiency = _character.proficiencies.skills.proficiencies[skill] ?? ProficiencyLevel.none;

            return GestureDetector(
              onTap: () {
                _toggleSkillProficiency(skill, proficiency);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getSkillBorderColor(proficiency, colorScheme),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: proficiency != ProficiencyLevel.none
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: colorScheme.onSurface,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              ability,
                              style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
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
                                color: Colors.blue,
                              ),
                            ),
                          if (proficiency == ProficiencyLevel.proficient)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Colors.green,
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          },
        );
      },
    );
  }

  Color _getSkillBorderColor(ProficiencyLevel proficiency, ColorScheme colorScheme) {
    switch (proficiency) {
      case ProficiencyLevel.expert:
        return Colors.blue;
      case ProficiencyLevel.proficient:
        return Colors.green;
      case ProficiencyLevel.none:
        return colorScheme.outline.withOpacity(0.3);
      case ProficiencyLevel.jackOfAllTrades:
        return colorScheme.secondary;
    }
  }

  Widget _buildSavingThrowsCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('SAVING THROWS', Icons.shield_outlined, colorScheme),
            const SizedBox(height: 12),
            SavingThrowGrid(
              character: _character,
              onCharacterUpdated: (newCharacter) {
                _updateCharacter(newCharacter);
              },
            ),
          ],
        ),
      ),
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