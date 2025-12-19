import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/models/enums.dart';

class WeaponEditorDialog extends StatefulWidget {
  final Weapon? weapon;
  final Character character;
  final Function(Weapon) onSave;
  final Function()? onDelete;

  const WeaponEditorDialog({
    super.key,
    this.weapon,
    required this.character,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<WeaponEditorDialog> createState() => _WeaponEditorDialogState();
}

class _WeaponEditorDialogState extends State<WeaponEditorDialog> {
  late TextEditingController _nameController;
  late TextEditingController _damageController;
  late TextEditingController _damageTypeController;
  late TextEditingController _propertiesController;
  late TextEditingController _weightController;
  late TextEditingController _quantityController;

  late String _attackAbility;
  late int _enhancementBonus;
  late bool _isProficient;
  late bool _isFinesse;
  late String _weaponType;

  final List<String> _abilityOptions = [
    'strength',
    'dexterity',
    'constitution',
    'intelligence',
    'wisdom',
    'charisma',
  ];

  final List<String> _weaponTypeOptions = [
    'simple',
    'martial',
    'firearm',
    'natural',
    'improvised',
    'custom',
  ];

  @override
  void initState() {
    super.initState();

    final weapon = widget.weapon;
    _nameController = TextEditingController(text: weapon?.name ?? '');
    _damageController = TextEditingController(text: weapon?.damage ?? '1d8');
    _damageTypeController = TextEditingController(text: weapon?.damageType ?? 'piercing');
    _propertiesController = TextEditingController(text: weapon?.properties ?? '');
    _weightController = TextEditingController(text: weapon?.weight.toString() ?? '0');
    _quantityController = TextEditingController(text: weapon?.quantity.toString() ?? '1');

    _attackAbility = weapon?.attackAbility ?? 'strength';
    _enhancementBonus = weapon?.enhancementBonus ?? 0;
    _isProficient = weapon?.isProficient ?? true;
    _isFinesse = weapon?.isFinesse ?? false;
    _weaponType = weapon?.weaponType ?? 'simple';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _damageController.dispose();
    _damageTypeController.dispose();
    _propertiesController.dispose();
    _weightController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(widget.weapon == null ? 'Add Weapon' : 'Edit Weapon'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Weapon Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _damageController,
                    decoration: const InputDecoration(
                      labelText: 'Damage Dice',
                      hintText: '1d8',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _damageTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Damage Type',
                      hintText: 'piercing',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _propertiesController,
              decoration: const InputDecoration(
                labelText: 'Properties',
                hintText: 'Light, finesse, thrown (20/60)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (lbs)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Enhancement Bonus
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Magic Enhancement',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (int i = 0; i <= 3; i++)
                          Expanded(
                            child: ChoiceChip(
                              label: Text(i == 0 ? '+0' : '+$i'),
                              selected: _enhancementBonus == i,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _enhancementBonus = i);
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Attack Ability
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attack Ability',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _abilityOptions.map((ability) {
                        return ChoiceChip(
                          label: Text(ability.substring(0, 3).toUpperCase()),
                          selected: _attackAbility == ability,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _attackAbility = ability);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Weapon Type and Properties
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _weaponType,
                    decoration: const InputDecoration(
                      labelText: 'Weapon Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _weaponTypeOptions.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type[0].toUpperCase() + type.substring(1)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _weaponType = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SwitchListTile(
                  title: const Text('Finesse'),
                  value: _isFinesse,
                  onChanged: (value) => setState(() => _isFinesse = value),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(width: 12),
                SwitchListTile(
                  title: const Text('Proficient'),
                  value: _isProficient,
                  onChanged: (value) => setState(() => _isProficient = value),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (widget.weapon != null && widget.onDelete != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete!();
            },
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: const Text('Delete'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveWeapon,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveWeapon() {
    final weapon = Weapon(
      id: widget.weapon?.id ?? UniqueKey().toString(),
      name: _nameController.text.trim(),
      damage: _damageController.text.trim(),
      damageType: _damageTypeController.text.trim(),
      properties: _propertiesController.text.trim(),
      weight: double.tryParse(_weightController.text) ?? 0,
      quantity: int.tryParse(_quantityController.text) ?? 1,
      attackAbility: _attackAbility,
      enhancementBonus: _enhancementBonus,
      isProficient: _isProficient,
      isFinesse: _isFinesse,
      weaponType: _weaponType,
    );

    widget.onSave(weapon);
    Navigator.pop(context);
  }
}