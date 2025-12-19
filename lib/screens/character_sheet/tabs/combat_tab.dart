import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';
import 'package:openrpg/data/combat_calculations.dart';
import 'package:openrpg/data/dnd_rules.dart';
import 'package:openrpg/screens/character_sheet/widget/death_saves_widget.dart';
import 'package:openrpg/screens/character_sheet/widget/hit_points_widget.dart';

class CombatTab extends StatefulWidget {
  final Character character;
  final Function(Character) onCharacterUpdated;

  const CombatTab({
    super.key,
    required this.character,
    required this.onCharacterUpdated,
  });

  @override
  State<CombatTab> createState() => _CombatTabState();
}

class _CombatTabState extends State<CombatTab> {
  // Default equipped armor if none exists
  EquippedArmor get _defaultArmor => const EquippedArmor(
    armorType: 'cloth',
    baseAC: 10,
    usesDexterity: true,
    maxDexBonus: 999,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Row: Combat Stats
            _buildCombatStatsRow(context),
            const SizedBox(height: 20),

            // Armor Section
            _buildArmorSection(context),
            const SizedBox(height: 20),

            // Weapons Section (Melee and Ranged)
            _buildWeaponsSection(context),
            const SizedBox(height: 20),

            // Proficiencies Section
            _buildProficienciesSection(context),
            const SizedBox(height: 20),

            // Health Section
            _buildHealthSection(context),
            const SizedBox(height: 20),

            // Death Saves
            DeathSavesWidget(
              character: widget.character,
              onCharacterUpdated: widget.onCharacterUpdated,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatStatsRow(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final expectedInitiative = CombatCalculations.calculateExpectedInitiative(widget.character);
    final expectedSpeed = CombatCalculations.calculateExpectedSpeed(widget.character);
    final expectedProficiency = DndRules.calculateProficiencyBonus(widget.character.totalLevel);

    // Get equipped armor or default
    final equippedArmor = widget.character.equippedCombatStats.equippedArmor;
    final expectedAC = CombatCalculations.calculateExpectedAC(
      character: widget.character,
      armor: equippedArmor,
    );
    final totalAC = CombatCalculations.calculateTotalAC(
      character: widget.character,
      armor: equippedArmor,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEditableStat(
                context: context,
                label: 'ARMOR CLASS',
                value: totalAC,
                expectedValue: expectedAC,
                color: colorScheme.primary,
                icon: Icons.shield_outlined,
                onUpdate: (value) => _updateAC(value),
              ),
              _buildEditableStat(
                context: context,
                label: 'INITIATIVE',
                value: widget.character.combatStats.initiative,
                expectedValue: expectedInitiative,
                color: colorScheme.secondary,
                icon: Icons.timer_outlined,
                onUpdate: (value) => _updateInitiative(value),
              ),
              _buildEditableStat(
                context: context,
                label: 'SPEED',
                value: widget.character.combatStats.speed,
                expectedValue: expectedSpeed,
                color: colorScheme.tertiary,
                icon: Icons.directions_run_outlined,
                onUpdate: (value) => _updateSpeed(value),
                unit: ' ft',
              ),
              _buildEditableStat(
                context: context,
                label: 'PROFICIENCY',
                value: widget.character.proficiencies.proficiencyBonus,
                expectedValue: expectedProficiency,
                color: colorScheme.primary,
                icon: Icons.star_outlined,
                onUpdate: (value) => _updateProficiencyBonus(value),
                prefix: '+',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableStat({
    required BuildContext context,
    required String label,
    required int value,
    required int expectedValue,
    required Color color,
    required IconData icon,
    required Function(int) onUpdate,
    String prefix = '',
    String unit = '',
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isExpected = value == expectedValue;

    return GestureDetector(
      onTap: () => _showEditStatDialog(
        context,
        label,
        value,
        expectedValue,
        onUpdate,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: isExpected ? color.withOpacity(0.3) : Colors.orange,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$prefix$value$unit',
                  style: TextStyle(
                    fontSize: label == 'PROFICIENCY' ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: isExpected ? color : Colors.orange,
                  ),
                ),
                if (!isExpected)
                  Text(
                    '$prefix$expectedValue$unit',
                    style: TextStyle(
                      fontSize: 10,
                      color: color.withOpacity(0.6),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArmorSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final equippedArmor = widget.character.equippedCombatStats.equippedArmor;
    final expectedAC = CombatCalculations.calculateExpectedAC(
      character: widget.character,
      armor: equippedArmor,
    );
    final totalAC = CombatCalculations.calculateTotalAC(
      character: widget.character,
      armor: equippedArmor,
    );

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
                Icon(Icons.shield_outlined, color: colorScheme.primary, size: 20),
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

            // Armor Type Selection
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: equippedArmor.armorType,
                    decoration: InputDecoration(
                      labelText: 'Armor Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ['cloth', 'light', 'medium', 'heavy'].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type[0].toUpperCase() + type.substring(1)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _updateArmor(equippedArmor.copyWith(armorType: value));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: equippedArmor.baseAC.toString()),
                    decoration: InputDecoration(
                      labelText: 'Base AC',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final baseAC = int.tryParse(value) ?? equippedArmor.baseAC;
                      _updateArmor(equippedArmor.copyWith(baseAC: baseAC));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // AC Display and Manual Bonus
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'EXPECTED AC',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            expectedAC.toString(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Based on armor + DEX',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'MANUAL BONUS',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 16),
                                onPressed: () {
                                  _updateArmor(equippedArmor.copyWith(
                                    manualBonus: equippedArmor.manualBonus - 1,
                                  ));
                                },
                              ),
                              Text(
                                equippedArmor.manualBonus >= 0
                                    ? '+${equippedArmor.manualBonus}'
                                    : '${equippedArmor.manualBonus}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: equippedArmor.manualBonus == 0
                                      ? colorScheme.onSurface.withOpacity(0.5)
                                      : equippedArmor.manualBonus > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 16),
                                onPressed: () {
                                  _updateArmor(equippedArmor.copyWith(
                                    manualBonus: equippedArmor.manualBonus + 1,
                                  ));
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Adjust manually',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Total AC Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL ARMOR CLASS',
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        Text(
                          totalAC.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (totalAC != expectedAC)
                    TextButton(
                      onPressed: () => _updateAC(expectedAC),
                      child: Text(
                        'Reset to Expected ($expectedAC)',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                        ),
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

  Widget _buildWeaponsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final meleeWeapon = widget.character.equippedCombatStats.equippedMeleeWeapon;
    final rangedWeapon = widget.character.equippedCombatStats.equippedRangedWeapon;

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
                Icon(Icons.gavel_outlined, color: colorScheme.primary, size: 20),
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

            // Melee Weapon
            _buildWeaponField(
              context: context,
              label: 'MELEE WEAPON',
              weapon: meleeWeapon,
              isMelee: true,
              onUpdate: (weapon) => _updateMeleeWeapon(weapon),
            ),
            const SizedBox(height: 20),

            // Ranged Weapon
            _buildWeaponField(
              context: context,
              label: 'RANGED WEAPON',
              weapon: rangedWeapon,
              isMelee: false,
              onUpdate: (weapon) => _updateRangedWeapon(weapon),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaponField({
    required BuildContext context,
    required String label,
    required EquippedWeapon? weapon,
    required bool isMelee,
    required Function(EquippedWeapon?) onUpdate,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Common weapon options
    final meleeWeapons = [
      'Dagger (1d4 piercing, finesse, light, thrown)',
      'Shortsword (1d6 piercing, finesse, light)',
      'Longsword (1d8 slashing, versatile 1d10)',
      'Greatsword (2d6 slashing, heavy, two-handed)',
      'Greataxe (1d12 slashing, heavy, two-handed)',
      'Rapier (1d8 piercing, finesse)',
      'Warhammer (1d8 bludgeoning, versatile 1d10)',
      'Spear (1d6 piercing, thrown, versatile 1d8)',
    ];

    final rangedWeapons = [
      'Shortbow (1d6 piercing, ammunition, range 80/320, two-handed)',
      'Longbow (1d8 piercing, ammunition, range 150/600, heavy, two-handed)',
      'Light Crossbow (1d8 piercing, ammunition, range 80/320, loading, two-handed)',
      'Heavy Crossbow (1d10 piercing, ammunition, range 100/400, heavy, loading, two-handed)',
      'Hand Crossbow (1d6 piercing, ammunition, range 30/120, light, loading)',
      'Sling (1d4 bludgeoning, ammunition, range 30/120)',
      'Dart (1d4 piercing, finesse, thrown, range 20/60)',
    ];

    final weapons = isMelee ? meleeWeapons : rangedWeapons;

    // Parse weapon string to extract damage and properties
    EquippedWeapon? _parseWeaponString(String weaponString) {
      try {
        final parts = weaponString.split(' (');
        final name = parts[0];
        final details = parts[1].replaceAll(')', '');
        final detailParts = details.split(', ');

        String damageDice = '1d4';
        String damageType = 'piercing';
        bool isFinesse = false;
        List<String> properties = [];

        for (final part in detailParts) {
          if (part.startsWith('1d') || part.startsWith('2d')) {
            damageDice = part.split(' ')[0];
            damageType = part.split(' ')[1];
          } else if (part == 'finesse') {
            isFinesse = true;
            properties.add('finesse');
          } else if (part.isNotEmpty) {
            properties.add(part);
          }
        }

        // Create a unique weapon class name that includes the weapon string
        // This ensures uniqueness even for weapons with the same name
        final uniqueWeaponClass = weaponString; // Use the full string as the unique identifier

        return EquippedWeapon(
          weaponClass: uniqueWeaponClass,
          damageDice: damageDice,
          damageType: damageType,
          isFinesse: isFinesse,
        );
      } catch (e) {
        return null;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),

        // Weapon Selection
        DropdownButtonFormField<String>(
          value: weapon?.weaponClass,
          decoration: InputDecoration(
            labelText: 'Select Weapon',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(
                'None',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
              ),
            ),
            ...weapons.asMap().entries.map((entry) {
              final index = entry.key;
              final weaponStr = entry.value;
              final weaponName = weaponStr.split(' (')[0];
              return DropdownMenuItem(
                value: '$index:$weaponStr',
                child: Text(weaponName),
              );
            }).toList(),
          ],
          onChanged: (value) {
            if (value == null) {
              onUpdate(null);
            } else {
              final parsedWeapon = _parseWeaponString(value);
              if (parsedWeapon != null) {
                onUpdate(parsedWeapon);
              }
            }
          },
        ),
        const SizedBox(height: 12),

        if (weapon != null) ...[
          // Enhancement Bonus
          Row(
            children: [
              Expanded(
                child: Text(
                  'Enhancement Bonus',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
              Row(
                children: [
                  for (int i = 0; i <= 3; i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: ChoiceChip(
                        label: Text(i == 0 ? '+0' : '+$i'),
                        selected: weapon.enhancementBonus == i,
                        onSelected: (selected) {
                          if (selected) {
                            onUpdate(weapon.copyWith(enhancementBonus: i));
                          }
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ability Selection
          Row(
            children: [
              Expanded(
                child: Text(
                  'Attack Ability',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: weapon.ability,
                items: ['strength', 'dexterity', 'constitution', 'intelligence', 'wisdom', 'charisma']
                    .map((ability) {
                  return DropdownMenuItem(
                    value: ability,
                    child: Text(ability.substring(0, 3).toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onUpdate(weapon.copyWith(ability: value));
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Proficiency Checkbox
          Row(
            children: [
              Checkbox(
                value: weapon.isProficient,
                onChanged: (value) {
                  onUpdate(weapon.copyWith(isProficient: value ?? false));
                },
              ),
              Text(
                'Proficient with this weapon',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Calculations Display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'ATTACK BONUS',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            '+${CombatCalculations.calculateAttackBonus(
                              character: widget.character,
                              weapon: weapon,
                            )}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'DAMAGE BONUS',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            '+${CombatCalculations.calculateDamageBonus(
                              character: widget.character,
                              weapon: weapon,
                            )}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'DAMAGE',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            weapon.damageDice,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            weapon.damageType,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'DAMAGE RANGE',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            CombatCalculations.calculateDamageRange(
                              weapon: weapon,
                              character: widget.character,
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            'per hit',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProficienciesSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // D&D 5e standard proficiencies
    final simpleMeleeWeapons = [
      'Club', 'Dagger', 'Greatclub', 'Handaxe', 'Javelin', 'Light Hammer',
      'Mace', 'Quarterstaff', 'Sickle', 'Spear'
    ];

    simpleMeleeWeapons.sort();

    final simpleRangedWeapons = [
      'Light Crossbow', 'Dart', 'Shortbow', 'Sling'
    ];

    simpleRangedWeapons.sort();

    final martialMeleeWeapons = [
      'Battleaxe', 'Flail', 'Glaive', 'Greataxe', 'Greatsword', 'Halberd',
      'Lance', 'Longsword', 'Maul', 'Morningstar', 'Pike', 'Rapier',
      'Scimitar', 'Shortsword', 'Trident', 'War Pick', 'Warhammer', 'Whip'
    ];

    martialMeleeWeapons.sort();

    final martialRangedWeapons = [
      'Blowgun', 'Hand Crossbow', 'Heavy Crossbow', 'Longbow', 'Net'
    ];

    martialRangedWeapons.sort();

    final armorProficiencies = [
      'Light Armor',
      'Medium Armor',
      'Heavy Armor',
      'Shields',
    ];

    final currentProficiencies = widget.character.equippedCombatStats.weaponProficiencies;

    void _toggleProficiency(String proficiency) {
      final newProficiencies = List<String>.from(currentProficiencies);
      if (newProficiencies.contains(proficiency)) {
        newProficiencies.remove(proficiency);
      } else {
        newProficiencies.add(proficiency);
      }

      final newCombatStats = widget.character.equippedCombatStats.copyWith(
        weaponProficiencies: newProficiencies,
      );

      final newCharacter = widget.character.copyWith(
        equippedCombatStats: newCombatStats,
      );

      widget.onCharacterUpdated(newCharacter);
    }

    Widget _buildProficiencyCategory(String title, List<String> proficiencies) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: proficiencies.map((proficiency) {
              final isProficient = currentProficiencies.contains(proficiency);
              return FilterChip(
                label: Text(proficiency),
                selected: isProficient,
                onSelected: (selected) => _toggleProficiency(proficiency),
                checkmarkColor: Colors.white,
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  color: isProficient ? Colors.white : colorScheme.onSurface,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

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
                Icon(Icons.checklist_outlined, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'PROFICIENCIES',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.refresh, size: 18),
                  onPressed: () {
                    // Reset to class/race proficiencies
                    // This would need to be implemented based on character class
                  },
                  tooltip: 'Reset to class defaults',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Simple Weapons
            _buildProficiencyCategory('Simple Melee Weapons', simpleMeleeWeapons),
            _buildProficiencyCategory('Simple Ranged Weapons', simpleRangedWeapons),
            _buildProficiencyCategory('Martial Melee Weapons', martialMeleeWeapons),
            _buildProficiencyCategory('Martial Ranged Weapons', martialRangedWeapons),

            // Armor Proficiencies
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Armor Proficiencies',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: armorProficiencies.map((proficiency) {
                    final isProficient = widget.character.equippedCombatStats.armorProficiencies.contains(proficiency);
                    return FilterChip(
                      label: Text(proficiency),
                      selected: isProficient,
                      onSelected: (selected) {
                        final newArmorProficiencies = List<String>.from(
                            widget.character.equippedCombatStats.armorProficiencies
                        );
                        if (selected) {
                          newArmorProficiencies.add(proficiency);
                        } else {
                          newArmorProficiencies.remove(proficiency);
                        }

                        final newCombatStats = widget.character.equippedCombatStats.copyWith(
                          armorProficiencies: newArmorProficiencies,
                        );

                        final newCharacter = widget.character.copyWith(
                          equippedCombatStats: newCombatStats,
                        );

                        widget.onCharacterUpdated(newCharacter);
                      },
                      checkmarkColor: Colors.white,
                      selectedColor: Colors.green,
                      labelStyle: TextStyle(
                        color: isProficient ? Colors.white : colorScheme.onSurface,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final health = widget.character.health;

    // Calculate expected hit dice
    final expectedHitDice = CombatCalculations.calculateExpectedHitDice(widget.character.classes);

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
                Icon(Icons.favorite_border, color: colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Text(
                  'HEALTH',
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

            // Max HP
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MAXIMUM HIT POINTS',
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 16),
                            onPressed: () {
                              final newHealth = health.copyWith(
                                maxHitPoints: health.maxHitPoints - 1,
                              );
                              final newCharacter = widget.character.copyWith(
                                health: newHealth,
                              );
                              widget.onCharacterUpdated(newCharacter);
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: health.maxHitPoints.toString()),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.error,
                              ),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) {
                                final maxHP = int.tryParse(value) ?? health.maxHitPoints;
                                final newHealth = health.copyWith(maxHitPoints: maxHP);
                                final newCharacter = widget.character.copyWith(
                                  health: newHealth,
                                );
                                widget.onCharacterUpdated(newCharacter);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 16),
                            onPressed: () {
                              final newHealth = health.copyWith(
                                maxHitPoints: health.maxHitPoints + 1,
                              );
                              final newCharacter = widget.character.copyWith(
                                health: newHealth,
                              );
                              widget.onCharacterUpdated(newCharacter);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: colorScheme.outline.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT HIT POINTS',
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 16),
                            onPressed: () {
                              final newHealth = health.copyWith(
                                currentHitPoints: health.currentHitPoints - 1,
                              );
                              final newCharacter = widget.character.copyWith(
                                health: newHealth,
                              );
                              widget.onCharacterUpdated(newCharacter);
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: health.currentHitPoints.toString()),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) {
                                final currentHP = int.tryParse(value) ?? health.currentHitPoints;
                                final newHealth = health.copyWith(currentHitPoints: currentHP);
                                final newCharacter = widget.character.copyWith(
                                  health: newHealth,
                                );
                                widget.onCharacterUpdated(newCharacter);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 16),
                            onPressed: () {
                              final newHealth = health.copyWith(
                                currentHitPoints: health.currentHitPoints + 1,
                              );
                              final newCharacter = widget.character.copyWith(
                                health: newHealth,
                              );
                              widget.onCharacterUpdated(newCharacter);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hit Dice
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HIT DICE (Expected based on class levels)',
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: expectedHitDice.map((hitDie) {
                    return Chip(
                      label: Text('${hitDie.count}d${hitDie.sides}'),
                      backgroundColor: colorScheme.surfaceVariant,
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rest Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.self_improvement_outlined),
                    label: const Text('SHORT REST'),
                    onPressed: () => _performShortRest(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.hotel_outlined),
                    label: const Text('LONG REST'),
                    onPressed: () => _performLongRest(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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

  // Helper Methods
  void _showEditStatDialog(
      BuildContext context,
      String label,
      int currentValue,
      int expectedValue,
      Function(int) onUpdate,
      ) {
    final controller = TextEditingController(text: currentValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Current Value',
                border: const OutlineInputBorder(),
                suffixText: label == 'SPEED' ? 'ft' : '',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final value = int.tryParse(controller.text) ?? currentValue;
                      onUpdate(value);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onUpdate(expectedValue);
                      Navigator.pop(context);
                    },
                    child: const Text('Set to Expected'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _updateAC(int value) {
    final newCombatStats = widget.character.combatStats.copyWith(
      armorClass: value,
    );
    final newCharacter = widget.character.copyWith(
      combatStats: newCombatStats,
    );
    widget.onCharacterUpdated(newCharacter);
  }

  void _updateInitiative(int value) {
    final newCombatStats = widget.character.combatStats.copyWith(
      initiative: value,
    );
    final newCharacter = widget.character.copyWith(
      combatStats: newCombatStats,
    );
    widget.onCharacterUpdated(newCharacter);
  }

  void _updateSpeed(int value) {
    final newCombatStats = widget.character.combatStats.copyWith(
      speed: value,
    );
    final newCharacter = widget.character.copyWith(
      combatStats: newCombatStats,
    );
    widget.onCharacterUpdated(newCharacter);
  }

  void _updateProficiencyBonus(int value) {
    final newProficiencies = widget.character.proficiencies.copyWith(
      proficiencyBonus: value,
    );
    final newCharacter = widget.character.copyWith(
      proficiencies: newProficiencies,
    );
    widget.onCharacterUpdated(newCharacter);
  }

  void _updateArmor(EquippedArmor armor) {
    final newCombatStats = widget.character.equippedCombatStats.copyWith(
      equippedArmor: armor,
    );
    final newCharacter = widget.character.copyWith(
      equippedCombatStats: newCombatStats,
    );
    widget.onCharacterUpdated(newCharacter);
  }

  void _updateMeleeWeapon(EquippedWeapon? weapon) {
    final newCombatStats = widget.character.equippedCombatStats.copyWith(
      equippedMeleeWeapon: weapon,
    );
    final newCharacter = widget.character.copyWith(
      equippedCombatStats: newCombatStats,
    );
    widget.onCharacterUpdated(newCharacter);
  }

  void _updateRangedWeapon(EquippedWeapon? weapon) {
    final newCombatStats = widget.character.equippedCombatStats.copyWith(
      equippedRangedWeapon: weapon,
    );
    final newCharacter = widget.character.copyWith(
      equippedCombatStats: newCombatStats,
    );
    widget.onCharacterUpdated(newCharacter);
  }

  void _performShortRest() {
    // In a short rest, you can spend hit dice to heal
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Short rest: You can spend hit dice to heal.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _performLongRest() {
    // In a long rest, you regain all hit points and half your hit dice
    final newHealth = widget.character.health.copyWith(
      currentHitPoints: widget.character.health.maxHitPoints,
      temporaryHitPoints: 0,
    );

    final newCharacter = widget.character.copyWith(
      health: newHealth,
    );

    widget.onCharacterUpdated(newCharacter);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Long rest: Full health restored, hit dice partially restored.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}