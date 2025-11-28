// magic_item_detail_screen_updated.dart
import 'package:flutter/material.dart';
import 'package:openrpg/models/magic_item.dart';
import 'package:openrpg/models/localization_keys.dart';
import 'package:openrpg/models/enums.dart';

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
            _buildHeaderSection(),
            const SizedBox(height: 24),
            _buildDescriptionSection(),
            const SizedBox(height: 24),

            // New fields sections
            if (item.attunementPrerequisites != null) ...[
              _buildAttunementPrerequisitesSection(),
              const SizedBox(height: 24),
            ],

            if (item.numericalValues != null) ...[
              _buildNumericalValuesSection(),
              const SizedBox(height: 24),
            ],

            if (item.properties.isNotEmpty) ...[
              _buildPropertiesSection(),
              const SizedBox(height: 24),
            ],

            if (item.actions.isNotEmpty) ...[
              _buildActionsSection(),
              const SizedBox(height: 24),
            ],

            if (item.curse != null) ...[
              _buildCurseSection(),
              const SizedBox(height: 24),
            ],

            if (item.randomTables != null && item.randomTables!.isNotEmpty) ...[
              _buildRandomTablesSection(),
              const SizedBox(height: 24),
            ],

            if (item.craftingInfo != null) ...[
              _buildCraftingInfoSection(),
              const SizedBox(height: 24),
            ],

            if (item.sentientInfo != null) ...[
              _buildSentientInfoSection(),
              const SizedBox(height: 24),
            ],

            if (item.vehicleProperties != null) ...[
              _buildVehiclePropertiesSection(),
              const SizedBox(height: 24),
            ],

            if (item.containerProperties != null) ...[
              _buildContainerPropertiesSection(),
              const SizedBox(height: 24),
            ],

            if (item.scrollProperties != null) ...[
              _buildScrollPropertiesSection(),
              const SizedBox(height: 24),
            ],

            if (item.durability != null) ...[
              _buildDurabilitySection(),
              const SizedBox(height: 24),
            ],

            if (item.artifactProperties != null) ...[
              _buildArtifactPropertiesSection(),
              const SizedBox(height: 24),
            ],

            if (item.spellCastingProperties != null) ...[
              _buildSpellCastingPropertiesSection(),
              const SizedBox(height: 24),
            ],

            if (item.pairedItemId != null) ...[
              _buildPairedItemSection(),
              const SizedBox(height: 24),
            ],

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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    LocalizationService.getRarity(item.rarity),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: _getRarityColor(item.rarity).withAlpha(51),
                ),
                Chip(
                  label: Text(LocalizationService.getCategory(item.category)),
                  backgroundColor: Colors.blueGrey.withAlpha(25),
                ),
                if (item.requiresAttunement) ...[
                  Chip(
                    label: const Text('Requires Attunement'),
                    backgroundColor: Colors.orange.withAlpha(51),
                  ),
                ] else
                  const Chip(
                    label: Text('No Attunement Required'),
                    backgroundColor: Colors.green,
                  ),
                if (item.curse != null)
                  Chip(
                    label: const Text('Cursed'),
                    backgroundColor: Colors.red.withAlpha(51),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildAttunementPrerequisitesSection() {
    final prereq = item.attunementPrerequisites!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attunement Prerequisites',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (prereq.classes.isNotEmpty)
                  _buildValueChip('Classes', prereq.classes.join(', ')),
                if (prereq.races.isNotEmpty)
                  _buildValueChip('Races', prereq.races.join(', ')),
                if (prereq.spellcaster != null)
                  _buildValueChip(
                    'Spellcaster',
                    prereq.spellcaster! ? 'Required' : 'Not Required',
                  ),
                if (prereq.minimumLevel != null)
                  _buildValueChip('Minimum Level', '${prereq.minimumLevel}'),
                if (prereq.alignment != null)
                  _buildValueChip(
                    'Alignment',
                    _getAlignmentText(prereq.alignment!),
                  ),
              ],
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  _buildValueChip(
                    'Saving Throw Bonus',
                    '+${values.savingThrowBonus}',
                  ),
                if (values.skillBonus != null)
                  _buildValueChip(
                    '${values.skillType ?? "Skill"} Bonus',
                    '+${values.skillBonus}',
                  ),
                if (values.abilityScores != null) ...[
                  for (final entry in values.abilityScores!.entries)
                    _buildValueChip(
                      '${_capitalize(entry.key)}',
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...item.properties.map(
              (property) => Padding(
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
              ),
            ),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...item.actions.map(
              (action) => Container(
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
                          backgroundColor: Colors.blue.withAlpha(25),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(_getActionCostText(action.cost)),
                          backgroundColor: Colors.green.withAlpha(25),
                        ),
                      ],
                    ),
                    if (action.charges != null) ...[
                      const SizedBox(height: 8),
                      _buildActionChargesInfo(action.charges!),
                    ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehiclePropertiesSection() {
    final vehicle = item.vehicleProperties!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Properties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildValueChip('AC', '${vehicle.ac}'),
                _buildValueChip('HP', '${vehicle.hp}'),
                ...vehicle.speeds.entries.map(
                  (entry) => _buildValueChip(
                    '${_capitalize(entry.key)} speed',
                    '${entry.value} ft',
                  ),
                ),
              ],
            ),
            if (vehicle.damageImmunities.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Damage Immunities:'),
              Wrap(
                spacing: 8,
                children: vehicle.damageImmunities
                    .map((type) => Chip(label: Text(_getDamageTypeText(type))))
                    .toList(),
              ),
            ],
            if (vehicle.damageResistances.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Damage Resistances:'),
              Wrap(
                spacing: 8,
                children: vehicle.damageResistances
                    .map((type) => Chip(label: Text(_getDamageTypeText(type))))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContainerPropertiesSection() {
    final container = item.containerProperties!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Container Properties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildValueChip('Capacity', container.capacity),
                _buildValueChip('Air Supply', container.airSupply),
                if (container.extradimensional)
                  const Chip(label: Text('Extradimensional')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollPropertiesSection() {
    final scroll = item.scrollProperties!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scroll Properties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildValueChip('Spell Level', '${scroll.spellLevel}'),
                _buildValueChip('Check DC', '${scroll.checkDC}'),
                _buildValueChip('Save DC', '${scroll.saveDC}'),
                _buildValueChip('Attack Bonus', '+${scroll.attackBonus}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentientInfoSection() {
    final sentient = item.sentientInfo!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sentient Item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildValueChip('Alignment', _getAlignmentText(sentient.alignment)),
            const SizedBox(height: 12),
            const Text('Abilities:'),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildValueChip('INT', '${sentient.abilities.intelligence}'),
                _buildValueChip('WIS', '${sentient.abilities.wisdom}'),
                _buildValueChip('CHA', '${sentient.abilities.charisma}'),
              ],
            ),
            const SizedBox(height: 12),
            _buildValueChip(
              'Communication',
              _getCommunicationTypeText(sentient.communication.type),
            ),
            if (sentient.communication.languages.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildValueChip(
                'Languages',
                sentient.communication.languages.join(', '),
              ),
            ],
            const SizedBox(height: 12),
            _buildValueChip('Senses Range', sentient.senses.range),
            if (sentient.senses.darkvision)
              _buildValueChip('Darkvision', 'Yes'),
            if (sentient.specialPurpose != null) ...[
              const SizedBox(height: 12),
              _buildValueChip('Special Purpose', sentient.specialPurpose!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionWarningsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interaction Warnings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPairedItemSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paired Item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('This item is paired with: ${item.pairedItemId}'),
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
              ...curse.effects.map(
                (effect) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('• ${_getEffectText(effect)}'),
                ),
              ),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...item.randomTables!.map(
              (table) => Container(
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
                      'Roll: ${table.diceRoll.count}d${table.diceRoll.sides}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...table.entries.map(
                      (entry) => Container(
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(25),
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
                                    LocalizationService.getString(
                                      entry.effect.descriptionKey,
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  if (entry.effect.components.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 4,
                                      children: entry.effect.components
                                          .map(
                                            (component) => Chip(
                                              label: Text(
                                                _getEffectComponentText(
                                                  component,
                                                ),
                                              ),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  _buildValueChip(
                    'Time Required',
                    '${crafting.timeRequired} days',
                  ),
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
              ...crafting.requiredMaterials.map(
                (material) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('• $material'),
                ),
              ),
            ],
            if (crafting.requiredTools.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Required Tools:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...crafting.requiredTools.map(
                (tool) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('• $tool'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDurabilitySection() {
    final durability = item.durability!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Durability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (durability.ac != null)
                  _buildValueChip('AC', '${durability.ac}'),
                if (durability.hp != null)
                  _buildValueChip('HP', '${durability.hp}'),
              ],
            ),
            if (durability.immunities.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Damage Immunities:'),
              Wrap(
                spacing: 8,
                children: durability.immunities
                    .map((type) => Chip(label: Text(_getDamageTypeText(type))))
                    .toList(),
              ),
            ],
            if (durability.resistances.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Damage Resistances:'),
              Wrap(
                spacing: 8,
                children: durability.resistances
                    .map((type) => Chip(label: Text(_getDamageTypeText(type))))
                    .toList(),
              ),
            ],
            if (durability.specialDestruction != null) ...[
              const SizedBox(height: 12),
              _buildValueChip(
                'Special Destruction',
                durability.specialDestruction!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildArtifactPropertiesSection() {
    final artifact = item.artifactProperties!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Artifact Properties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildValueChip('Destruction Method', artifact.destructionMethod),
            if (artifact.immuneToNormalDamage)
              _buildValueChip('Immune to Normal Damage', 'Yes'),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellCastingPropertiesSection() {
    final spellCasting = item.spellCastingProperties!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spell Casting Properties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (spellCasting.usesUserSpellcastingAbility)
                  _buildValueChip('Uses User Spellcasting', 'Yes'),
                if (spellCasting.ignoreComponents)
                  _buildValueChip('Ignores Components', 'Yes'),
                if (spellCasting.fixedSaveDC != null)
                  _buildValueChip(
                    'Fixed Save DC',
                    '${spellCasting.fixedSaveDC}',
                  ),
                if (spellCasting.fixedAttackBonus != null)
                  _buildValueChip(
                    'Fixed Attack Bonus',
                    '+${spellCasting.fixedAttackBonus}',
                  ),
                if (spellCasting.customCastingTime != null)
                  _buildValueChip(
                    'Custom Casting Time',
                    spellCasting.customCastingTime!,
                  ),
                if (spellCasting.customDuration != null)
                  _buildValueChip(
                    'Custom Duration',
                    spellCasting.customDuration!,
                  ),
              ],
            ),
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

  // Helper Methods
  Widget _buildValueChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.blueGrey.withAlpha(25),
      side: BorderSide.none,
    );
  }

  Widget _buildActionChargesInfo(ChargeInfo charges) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.amber.withAlpha(76)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.battery_charging_full,
            size: 16,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            'Charges: ${charges.max}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.amber.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Recharge: ${_getRechargeRateText(charges.recharge.rate)}${charges.recharge.dice != null ? ' (${charges.recharge.dice})' : ''}',
            style: TextStyle(fontSize: 14, color: Colors.amber.shade700),
          ),
        ],
      ),
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
      default:
        return 'Unknown';
    }
  }

  String _getActionCostText(ActionCost cost) {
    switch (cost.type) {
      case ActionCostType.charge:
        return '${cost.value} Charge${cost.value! > 1 ? 's' : ''}';
      case ActionCostType.action:
        return 'Action';
      case ActionCostType.bonusAction:
        return 'Bonus Action';
      case ActionCostType.reaction:
        return 'Reaction';
      case ActionCostType.specialMovement:
        return 'Special Movement';
      default:
        return 'Unknown';
    }
  }

  String _getEffectText(Effect effect) {
    switch (effect.type) {
      case EffectType.tableRoll:
        return 'Roll on table: ${effect.value}';
      case EffectType.damage:
        if (effect.value is Map) {
          final damageMap = effect.value as Map<String, dynamic>;
          final dice = damageMap['dice'] ?? '';
          final type = damageMap['type'] ?? '';
          final saveDC = damageMap['saveDC'];
          final saveType = damageMap['saveType'];

          return '${dice} ${type} damage${saveDC != null ? ' (DC $saveDC ${saveType} save)' : ''}';
        }
        return effect.value.toString();
      case EffectType.condition:
        return 'Apply condition: ${effect.value}';
      case EffectType.spell:
        return 'Cast spell: ${effect.value}';
      case EffectType.custom:
        return effect.value.toString();
      case EffectType.creature:
        return effect.value.toString();
      default:
        return 'Unknown effect';
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
      default:
        return 'Unknown';
    }
  }

  String _getEffectComponentText(EffectComponent component) {
    switch (component.type) {
      case EffectType.damage:
        if (component.value is Map) {
          final damageMap = component.value as Map<String, dynamic>;
          final dice = damageMap['dice'] ?? '';
          final type = damageMap['type'] ?? '';
          return '${dice} ${type} damage';
        }
        return component.value.toString();
      case EffectType.condition:
        return 'Condition: ${component.value}';
      case EffectType.spell:
        return 'Spell: ${component.value}';
      case EffectType.custom:
        return component.value.toString();
      case EffectType.tableRoll:
        return 'Table: ${component.value}';
      case EffectType.creature:
        return component.value.toString();
      default:
        return 'Unknown component';
    }
  }

  String _getAlignmentText(MoralAlignment alignment) {
    switch (alignment) {
      case MoralAlignment.lawfulGood:
        return 'Lawful Good';
      case MoralAlignment.neutralGood:
        return 'Neutral Good';
      case MoralAlignment.chaoticGood:
        return 'Chaotic Good';
      case MoralAlignment.lawfulNeutral:
        return 'Lawful Neutral';
      case MoralAlignment.neutral:
        return 'True Neutral';
      case MoralAlignment.chaoticNeutral:
        return 'Chaotic Neutral';
      case MoralAlignment.lawfulEvil:
        return 'Lawful Evil';
      case MoralAlignment.neutralEvil:
        return 'Neutral Evil';
      case MoralAlignment.chaoticEvil:
        return 'Chaotic Evil';
      default:
        return 'Unknown';
    }
  }

  String _getCommunicationTypeText(CommunicationType type) {
    switch (type) {
      case CommunicationType.telepathy:
        return 'Telepathy';
      case CommunicationType.speech:
        return 'Speech';
      case CommunicationType.emotions:
        return 'Emotions';
      default:
        return 'Unknown';
    }
  }

  String _getDamageTypeText(DamageType type) {
    switch (type) {
      case DamageType.acid:
        return 'Acid';
      case DamageType.bludgeoning:
        return 'Bludgeoning';
      case DamageType.cold:
        return 'Cold';
      case DamageType.fire:
        return 'Fire';
      case DamageType.force:
        return 'Force';
      case DamageType.lightning:
        return 'Lightning';
      case DamageType.necrotic:
        return 'Necrotic';
      case DamageType.piercing:
        return 'Piercing';
      case DamageType.poison:
        return 'Poison';
      case DamageType.psychic:
        return 'Psychic';
      case DamageType.radiant:
        return 'Radiant';
      case DamageType.slashing:
        return 'Slashing';
      case DamageType.thunder:
        return 'Thunder';
      default:
        return 'Unknown';
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
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
      default:
        return Colors.grey;
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
      default:
        return Icons.help_outline;
    }
  }
}
