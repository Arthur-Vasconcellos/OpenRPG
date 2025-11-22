import 'package:flutter/material.dart';
import '../models/magic_item.dart';
import '../models/localization_keys.dart';
import '../models/enums.dart';

class MagicItemDetailScreen extends StatelessWidget {
  final MagicItem item;

  const MagicItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.getString(item.nameKey)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),

            const SizedBox(height: 24),

            // Description
            _buildDescriptionSection(),

            const SizedBox(height: 24),

            // Core Properties
            if (item.numericalValues != null) ...[
              _buildNumericalValuesSection(),
              const SizedBox(height: 24),
            ],

            // Properties
            if (item.properties.isNotEmpty) ...[
              _buildPropertiesSection(),
              const SizedBox(height: 24),
            ],

            // Actions
            if (item.actions.isNotEmpty) ...[
              _buildActionsSection(),
              const SizedBox(height: 24),
            ],

            // Charges
            if (item.charges != null) ...[
              _buildChargesSection(),
              const SizedBox(height: 24),
            ],

            // Curse
            if (item.curse != null) ...[
              _buildCurseSection(),
              const SizedBox(height: 24),
            ],

            // Random Tables
            if (item.randomTables != null && item.randomTables!.isNotEmpty) ...[
              _buildRandomTablesSection(),
              const SizedBox(height: 24),
            ],

            // Crafting Info
            if (item.craftingInfo != null) ...[
              _buildCraftingInfoSection(),
              const SizedBox(height: 24),
            ],

            // Metadata
            _buildMetadataSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Icon
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getRarityColor(item.rarity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getRarityColor(item.rarity).withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.category),
                    color: _getRarityColor(item.rarity),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocalizationService.getString(item.nameKey),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${item.id}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Property Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    LocalizationService.getRarity(item.rarity),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: _getRarityColor(item.rarity).withOpacity(0.2),
                ),
                Chip(
                  label: Text(LocalizationService.getCategory(item.category)),
                  backgroundColor: Colors.blueGrey.withOpacity(0.1),
                ),
                if (item.requiresAttunement) ...[
                  Chip(
                    label: const Text('Requires Attunement'),
                    backgroundColor: Colors.orange.withOpacity(0.2),
                  ),
                  if (item.attunementPrerequisites != null)
                    Chip(
                      label: Text(item.attunementPrerequisites!),
                      backgroundColor: Colors.orange.withOpacity(0.1),
                    ),
                ] else
                  const Chip(
                    label: Text('No Attunement Required'),
                    backgroundColor: Colors.green,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              LocalizationService.getString(item.descriptionKey),
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumericalValuesSection() {
    final values = item.numericalValues!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Numerical Values',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (values.attackBonus != null)
                  _buildValueChip('Attack Bonus', '+${values.attackBonus}'),
                if (values.damageBonus != null)
                  _buildValueChip('Damage Bonus', '+${values.damageBonus}'),
                if (values.acBonus != null)
                  _buildValueChip('AC Bonus', '+${values.acBonus}'),
                if (values.savingThrowBonus != null)
                  _buildValueChip('Saving Throw Bonus', '+${values.savingThrowBonus}'),
                if (values.skillBonus != null)
                  _buildValueChip('${values.skillType ?? "Skill"} Bonus', '+${values.skillBonus}'),
                if (values.abilityScores != null) ...[
                  for (final entry in values.abilityScores!.entries)
                    _buildValueChip(
                      '${entry.key[0].toUpperCase()}${entry.key.substring(1)}',
                      '${entry.value}',
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Properties',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...item.properties.map((property) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 8, right: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${property.type} (${property.value})',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (property.target != null)
                          Text('Target: ${property.target}'),
                        if (property.condition != null)
                          Text('Condition: ${property.condition}'),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...item.actions.map((action) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(_getActionTypeText(action.type)),
                        backgroundColor: Colors.blue.withOpacity(0.1),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(_getActionCostText(action.cost)),
                        backgroundColor: Colors.green.withOpacity(0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocalizationService.getString(action.descriptionKey),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Effect: ${_getEffectText(action.effect)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildChargesSection() {
    final charges = item.charges!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Charges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildValueChip('Max Charges', '${charges.max}'),
                const SizedBox(width: 12),
                _buildValueChip(
                  'Recharge',
                  '${_getRechargeRateText(charges.recharge.rate)}${charges.recharge.dice != null ? ' (${charges.recharge.dice})' : ''}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurseSection() {
    final curse = item.curse!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Curse',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              LocalizationService.getString(curse.descriptionKey),
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            if (curse.effects.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Effects:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...curse.effects.map((effect) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('• ${_getEffectText(effect)}'),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRandomTablesSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Random Tables',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...item.randomTables!.map((table) => Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocalizationService.getString(table.nameKey),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (table.descriptionKey != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      LocalizationService.getString(table.descriptionKey!),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Roll: ${table.diceRoll}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...table.entries.map((entry) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            entry.range,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocalizationService.getString(entry.effect.descriptionKey),
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (entry.effect.components.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 4,
                                  children: entry.effect.components.map((component) => Chip(
                                    label: Text(_getEffectComponentText(component)),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  )).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCraftingInfoSection() {
    final crafting = item.craftingInfo!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crafting Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              LocalizationService.getString(crafting.descriptionKey),
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (crafting.timeRequired != null)
                  _buildValueChip('Time Required', '${crafting.timeRequired} days'),
                if (crafting.goldCost != null)
                  _buildValueChip('Gold Cost', '${crafting.goldCost} GP'),
              ],
            ),
            if (crafting.requiredMaterials.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Required Materials:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...crafting.requiredMaterials.map((material) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('• $material'),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataSection() {
    return Card(
      elevation: 1,
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Technical Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            SelectableText(
              'Item ID: ${item.id}',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.grey,
              ),
            ),
            SelectableText(
              'Name Key: ${item.nameKey}',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.grey,
              ),
            ),
            SelectableText(
              'Description Key: ${item.descriptionKey}',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for displaying various data types
  Widget _buildValueChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.blueGrey.withOpacity(0.1),
      side: BorderSide.none,
    );
  }

  String _getActionTypeText(ActionType type) {
    switch (type) {
      case ActionType.action:
        return 'Action';
      case ActionType.bonusAction:
        return 'Bonus Action';
      case ActionType.reaction:
        return 'Reaction';
      case ActionType.magicAction:
        return 'Magic Action';
      case ActionType.utilizeAction:
        return 'Utilize Action';
      case ActionType.other:
        return 'Other';
      case ActionType.specialMovement:
        return 'Special Movement';
    }
  }

  String _getActionCostText(ActionCost cost) {
    switch (cost.type) {
      case ActionCostType.charge:
        return '${cost.value} Charge${cost.value > 1 ? 's' : ''}';
      case ActionCostType.action:
        return 'Action';
      case ActionCostType.bonusAction:
        return 'Bonus Action';
      case ActionCostType.reaction:
        return 'Reaction';
      case ActionCostType.specialMovement:
        return 'Special Movement';
    }
  }

  String _getEffectText(Effect effect) {
    switch (effect.type) {
      case EffectType.tableRoll:
        return 'Roll on table: ${effect.value}';
      case EffectType.damage:
        final damage = effect.value as Damage;
        return '${damage.dice} ${damage.type.name} damage${damage.saveDC != null ? ' (DC ${damage.saveDC} ${damage.saveType} save)' : ''}';
      case EffectType.condition:
        return 'Apply condition: ${effect.value}';
      case EffectType.spell:
        return 'Cast spell: ${effect.value}';
      case EffectType.custom:
        return effect.value;
      case EffectType.creature:
        return effect.value;
    }
  }

  String _getRechargeRateText(RechargeRate rate) {
    switch (rate) {
      case RechargeRate.dawn:
        return 'At dawn';
      case RechargeRate.dusk:
        return 'At dusk';
      case RechargeRate.sunrise:
        return 'At sunrise';
      case RechargeRate.sunset:
        return 'At sunset';
      case RechargeRate.daily:
        return 'Daily';
      case RechargeRate.weekly:
        return 'Weekly';
      case RechargeRate.monthly:
        return 'Monthly';
      case RechargeRate.never:
        return 'Never';
    }
  }

  String _getEffectComponentText(EffectComponent component) {
    switch (component.type) {
      case EffectType.damage:
        final damage = component.value as Damage;
        return '${damage.dice} ${damage.type.name}';
      case EffectType.condition:
        return 'Condition: ${component.value}';
      case EffectType.spell:
        return 'Spell: ${component.value}';
      case EffectType.custom:
        return component.value;
      case EffectType.tableRoll:
        return 'Table: ${component.value}';
      case EffectType.creature:
        return component.value;
    }
  }

  Color _getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return Colors.grey;
      case Rarity.uncommon:
        return Colors.green;
      case Rarity.rare:
        return Colors.blue;
      case Rarity.veryRare:
        return Colors.purple;
      case Rarity.legendary:
        return Colors.orange;
      case Rarity.artifact:
        return Colors.red;
    }
  }

  IconData _getCategoryIcon(MagicItemCategory category) {
    switch (category) {
      case MagicItemCategory.weapon:
        return Icons.gavel;
      case MagicItemCategory.armor:
        return Icons.security;
      case MagicItemCategory.potion:
        return Icons.local_drink;
      case MagicItemCategory.ring:
        return Icons.lens;
      case MagicItemCategory.rod:
        return Icons.straighten;
      case MagicItemCategory.staff:
        return Icons.forest;
      case MagicItemCategory.wand:
        return Icons.auto_awesome;
      case MagicItemCategory.wondrousItem:
        return Icons.auto_awesome_mosaic;
      case MagicItemCategory.scroll:
        return Icons.description;
      case MagicItemCategory.ammunition:
        return Icons.arrow_circle_right;
    }
  }
}