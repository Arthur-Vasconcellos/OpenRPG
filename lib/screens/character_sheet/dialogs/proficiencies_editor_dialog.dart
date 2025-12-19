import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class ProficienciesEditorDialog extends StatefulWidget {
  final Character character;
  final Function(ProficiencySet) onSave;

  const ProficienciesEditorDialog({
    super.key,
    required this.character,
    required this.onSave,
  });

  @override
  State<ProficienciesEditorDialog> createState() => _ProficienciesEditorDialogState();
}

class _ProficienciesEditorDialogState extends State<ProficienciesEditorDialog> {
  late List<String> _weaponProficiencies;
  late List<String> _armorProficiencies;

  // Common D&D 5e weapon proficiencies
  final List<String> _standardWeaponProficiencies = [
    'Simple Weapons',
    'Martial Weapons',
    'Hand Crossbows',
    'Heavy Crossbows',
    'Light Crossbows',
    'Longbows',
    'Shortbows',
    'Clubs',
    'Daggers',
    'Greatclubs',
    'Handaxes',
    'Javelins',
    'Light Hammers',
    'Maces',
    'Quarterstaffs',
    'Sickles',
    'Spears',
    'Battleaxes',
    'Flails',
    'Glaives',
    'Greataxes',
    'Greatswords',
    'Halberds',
    'Lances',
    'Longswords',
    'Mauls',
    'Morningstars',
    'Pikes',
    'Rapiers',
    'Scimitars',
    'Shortswords',
    'Tridents',
    'War Picks',
    'Warhammers',
    'Whips',
    'Blowguns',
    'Darts',
    'Nets',
    'Slings',
    'Firearms',
  ];

  // Common D&D 5e armor proficiencies
  final List<String> _standardArmorProficiencies = [
    'Light Armor',
    'Medium Armor',
    'Heavy Armor',
    'Shields',
    'Padded',
    'Leather',
    'Studded Leather',
    'Hide',
    'Chain Shirt',
    'Scale Mail',
    'Breastplate',
    'Half Plate',
    'Ring Mail',
    'Chain Mail',
    'Splint',
    'Plate',
  ];

  late TextEditingController _customWeaponController;
  late TextEditingController _customArmorController;

  @override
  void initState() {
    super.initState();
    _weaponProficiencies = List.from(widget.character.proficiencies.weapons);
    _armorProficiencies = List.from(widget.character.proficiencies.armor);
    _customWeaponController = TextEditingController();
    _customArmorController = TextEditingController();
  }

  @override
  void dispose() {
    _customWeaponController.dispose();
    _customArmorController.dispose();
    super.dispose();
  }

  void _toggleWeaponProficiency(String proficiency) {
    setState(() {
      if (_weaponProficiencies.contains(proficiency)) {
        _weaponProficiencies.remove(proficiency);
      } else {
        _weaponProficiencies.add(proficiency);
      }
    });
  }

  void _toggleArmorProficiency(String proficiency) {
    setState(() {
      if (_armorProficiencies.contains(proficiency)) {
        _armorProficiencies.remove(proficiency);
      } else {
        _armorProficiencies.add(proficiency);
      }
    });
  }

  void _addCustomWeaponProficiency() {
    final text = _customWeaponController.text.trim();
    if (text.isNotEmpty && !_weaponProficiencies.contains(text)) {
      setState(() {
        _weaponProficiencies.add(text);
        _customWeaponController.clear();
      });
    }
  }

  void _addCustomArmorProficiency() {
    final text = _customArmorController.text.trim();
    if (text.isNotEmpty && !_armorProficiencies.contains(text)) {
      setState(() {
        _armorProficiencies.add(text);
        _customArmorController.clear();
      });
    }
  }

  void _removeCustomWeaponProficiency(String proficiency) {
    setState(() {
      _weaponProficiencies.remove(proficiency);
    });
  }

  void _removeCustomArmorProficiency(String proficiency) {
    setState(() {
      _armorProficiencies.remove(proficiency);
    });
  }

  void _saveProficiencies() {
    final newProficiencies = widget.character.proficiencies.copyWith(
      weapons: _weaponProficiencies,
      armor: _armorProficiencies,
    );
    widget.onSave(newProficiencies);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          children: [
            AppBar(
              title: const Text('Edit Proficiencies'),
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _saveProficiencies,
                  tooltip: 'Save',
                ),
              ],
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      color: colorScheme.surface,
                      child: TabBar(
                        indicatorColor: colorScheme.primary,
                        labelColor: colorScheme.primary,
                        tabs: const [
                          Tab(text: 'Weapons'),
                          Tab(text: 'Armor'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Weapons Tab
                          _buildWeaponsTab(context),
                          // Armor Tab
                          _buildArmorTab(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProficiencies,
                      child: const Text('Save'),
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

  Widget _buildWeaponsTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Separate standard and custom proficiencies
    final standardWeapons = _standardWeaponProficiencies;
    final customWeapons = _weaponProficiencies
        .where((prof) => !_standardWeaponProficiencies.contains(prof))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Standard Weapon Proficiencies
          Text(
            'Standard Weapon Proficiencies',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Check the weapons your character is proficient with:',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: standardWeapons.map((proficiency) {
              final isSelected = _weaponProficiencies.contains(proficiency);
              return FilterChip(
                label: Text(proficiency),
                selected: isSelected,
                onSelected: (selected) => _toggleWeaponProficiency(proficiency),
                checkmarkColor: Colors.white,
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : colorScheme.onSurface,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Custom Weapon Proficiencies
          Text(
            'Custom Weapon Proficiencies',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add any custom or homebrew weapon proficiencies:',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),

          // Add custom proficiency
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customWeaponController,
                  decoration: InputDecoration(
                    labelText: 'Custom weapon proficiency',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addCustomWeaponProficiency,
                    ),
                  ),
                  onSubmitted: (_) => _addCustomWeaponProficiency(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of custom proficiencies
          if (customWeapons.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: customWeapons.map((proficiency) {
                return Chip(
                  label: Text(proficiency),
                  onDeleted: () => _removeCustomWeaponProficiency(proficiency),
                  deleteIconColor: colorScheme.error,
                );
              }).toList(),
            ),

          const SizedBox(height: 8),
          if (customWeapons.isEmpty)
            Text(
              'No custom weapon proficiencies added',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildArmorTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Separate standard and custom proficiencies
    final standardArmor = _standardArmorProficiencies;
    final customArmor = _armorProficiencies
        .where((prof) => !_standardArmorProficiencies.contains(prof))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Standard Armor Proficiencies
          Text(
            'Standard Armor Proficiencies',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Check the armor types your character is proficient with:',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: standardArmor.map((proficiency) {
              final isSelected = _armorProficiencies.contains(proficiency);
              return FilterChip(
                label: Text(proficiency),
                selected: isSelected,
                onSelected: (selected) => _toggleArmorProficiency(proficiency),
                checkmarkColor: Colors.white,
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : colorScheme.onSurface,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Custom Armor Proficiencies
          Text(
            'Custom Armor Proficiencies',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add any custom or homebrew armor proficiencies:',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),

          // Add custom proficiency
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customArmorController,
                  decoration: InputDecoration(
                    labelText: 'Custom armor proficiency',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addCustomArmorProficiency,
                    ),
                  ),
                  onSubmitted: (_) => _addCustomArmorProficiency(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of custom proficiencies
          if (customArmor.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: customArmor.map((proficiency) {
                return Chip(
                  label: Text(proficiency),
                  onDeleted: () => _removeCustomArmorProficiency(proficiency),
                  deleteIconColor: colorScheme.error,
                );
              }).toList(),
            ),

          const SizedBox(height: 8),
          if (customArmor.isEmpty)
            Text(
              'No custom armor proficiencies added',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}