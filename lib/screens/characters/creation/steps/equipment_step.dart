import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/tabs/equipment_tab.dart';
import 'package:openrpg/screens/characters/creation/ability_score_generation.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';

class EquipmentStep extends StatelessWidget {
  final CharacterEditorController controller;
  final ValueChanged<CharacterBuilderStepId>? onGoToStep;

  const EquipmentStep({super.key, required this.controller, this.onGoToStep});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    if (character.primaryRulesetId.trim().isEmpty) {
      return _RulesetRequiredCard(onGoToStep: onGoToStep);
    }

    final startingEquipment = _StartingEquipmentSummary.fromController(
      controller,
    );
    final choices = _StartingEquipmentChoices.fromExtraData(
      character.extraData,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _EquipmentHeaderCard(),
        const SizedBox(height: 16),
        _StartingEquipmentCard(
          summary: startingEquipment,
          choices: choices,
          onSelectChoice: _selectStartingEquipmentChoice,
        ),
        const SizedBox(height: 16),
        _LoadoutSummaryCard(character: character),
        const SizedBox(height: 16),
        _EquipmentIssuesCard(character: character),
        const SizedBox(height: 16),
        _AdvancedInventorySection(controller: controller),
      ],
    );
  }

  Future<void> _selectStartingEquipmentChoice(
    _StartingEquipmentSource source,
    _StartingEquipmentChoice choice,
  ) {
    return controller.updateManual((current) {
      final extraData = Map<String, dynamic>.from(current.extraData);
      final creation = characterCreationData(extraData);
      final rawEquipment = creation['equipment'];
      final equipment = rawEquipment is Map
          ? Map<String, dynamic>.from(rawEquipment.cast<String, dynamic>())
          : <String, dynamic>{};
      final rawStartingEquipment = equipment['startingEquipment'];
      final startingEquipment = rawStartingEquipment is Map
          ? Map<String, dynamic>.from(
              rawStartingEquipment.cast<String, dynamic>(),
            )
          : <String, dynamic>{};
      final rawChoices = startingEquipment['choices'];
      final choices = rawChoices is Map
          ? Map<String, dynamic>.from(rawChoices.cast<String, dynamic>())
          : <String, dynamic>{};

      choices[source.sourceKey] = {
        'sourceName': source.sourceName,
        'sourceType': source.sourceType,
        'choiceId': choice.id,
        'choiceKind': choice.isGoldOnly ? 'gold' : 'package',
      };
      startingEquipment['choices'] = choices;
      equipment['startingEquipment'] = startingEquipment;
      creation['equipment'] = equipment;
      extraData['creation'] = creation;
      return current.copyWith(extraData: extraData);
    });
  }
}

class _RulesetRequiredCard extends StatelessWidget {
  final ValueChanged<CharacterBuilderStepId>? onGoToStep;

  const _RulesetRequiredCard({required this.onGoToStep});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a ruleset before equipment',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The D&D equipment checklist uses the selected ruleset for compendium items and previews. Pick the ruleset in Basics, then come back here.',
                  style: TextStyle(color: colorScheme.onSecondaryContainer),
                ),
                if (onGoToStep != null) ...[
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () => onGoToStep!(CharacterBuilderStepId.basics),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go to Basics'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EquipmentHeaderCard extends StatelessWidget {
  const _EquipmentHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'D&D Equipment Checklist',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Review starting equipment choices, confirm the active loadout, then use Advanced Inventory for manual item work.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _StartingEquipmentCard extends StatelessWidget {
  final _StartingEquipmentSummary summary;
  final _StartingEquipmentChoices choices;
  final Future<void> Function(
    _StartingEquipmentSource source,
    _StartingEquipmentChoice choice,
  )
  onSelectChoice;

  const _StartingEquipmentCard({
    required this.summary,
    required this.choices,
    required this.onSelectChoice,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Starting Equipment',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'These D&D package choices come from the selected class and background. Choosing one records your creation preference; use Advanced Inventory to add exact items to the sheet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (summary.sources.isEmpty)
              Text(
                'Choose a class or background with starting equipment data to see packages here.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...summary.sources.map(
                (source) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _StartingEquipmentSourceCard(
                    source: source,
                    selectedChoiceId: choices.choiceIdFor(source.sourceKey),
                    onSelectChoice: onSelectChoice,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StartingEquipmentSourceCard extends StatelessWidget {
  final _StartingEquipmentSource source;
  final String? selectedChoiceId;
  final Future<void> Function(
    _StartingEquipmentSource source,
    _StartingEquipmentChoice choice,
  )
  onSelectChoice;

  const _StartingEquipmentSourceCard({
    required this.source,
    required this.selectedChoiceId,
    required this.onSelectChoice,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${source.sourceType}: ${source.sourceName}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...source.choices.map(
            (choice) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _StartingEquipmentChoiceTile(
                choice: choice,
                selected: selectedChoiceId == choice.id,
                onTap: () => onSelectChoice(source, choice),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StartingEquipmentChoiceTile extends StatelessWidget {
  final _StartingEquipmentChoice choice;
  final bool selected;
  final VoidCallback onTap;

  const _StartingEquipmentChoiceTile({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    choice.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: selected ? colorScheme.onPrimaryContainer : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final line in choice.lines)
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(line.label),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadoutSummaryCard extends StatelessWidget {
  final Character character;

  const _LoadoutSummaryCard({required this.character});

  @override
  Widget build(BuildContext context) {
    final equipment = character.equipment;
    final loadout = equipment.loadout;
    final armor = _entryById(equipment.entries, loadout.armorEntryId);
    final melee = _entryById(equipment.entries, loadout.meleeEntryId);
    final ranged = _entryById(equipment.entries, loadout.rangedEntryId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loadout Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'These slots are the D&D equipment currently driving armor and weapon expectations.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final columns = width >= 720
                    ? 3
                    : width >= 460
                    ? 2
                    : 1;
                final spacing = 10.0;
                final tileWidth = (width - spacing * (columns - 1)) / columns;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    SizedBox(
                      width: tileWidth,
                      child: _LoadoutSummaryTile(
                        label: 'Armor',
                        icon: Icons.shield_outlined,
                        entry: armor,
                      ),
                    ),
                    SizedBox(
                      width: tileWidth,
                      child: _LoadoutSummaryTile(
                        label: 'Melee Weapon',
                        icon: Icons.gavel_outlined,
                        entry: melee,
                      ),
                    ),
                    SizedBox(
                      width: tileWidth,
                      child: _LoadoutSummaryTile(
                        label: 'Ranged Weapon',
                        icon: Icons.ads_click_outlined,
                        entry: ranged,
                      ),
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

  CharacterInventoryEntry? _entryById(
    List<CharacterInventoryEntry> entries,
    String? id,
  ) {
    if (id == null) {
      return null;
    }
    for (final entry in entries) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }
}

class _LoadoutSummaryTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final CharacterInventoryEntry? entry;

  const _LoadoutSummaryTile({
    required this.label,
    required this.icon,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(
                  entry?.displayName ?? 'Not assigned',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: entry == null ? colorScheme.onSurfaceVariant : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentIssuesCard extends StatelessWidget {
  final Character character;

  const _EquipmentIssuesCard({required this.character});

  @override
  Widget build(BuildContext context) {
    final issues = _equipmentWarnings(character);
    if (issues.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Equipment checklist has no warnings.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Equipment Warnings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'These are warnings only; they do not block finishing the guided checklist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ...issues.map(
              (issue) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _WarningRow(message: issue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _equipmentWarnings(Character character) {
    final entries = character.equipment.entries;
    final loadout = character.equipment.loadout;
    if (entries.isEmpty) {
      return const <String>[
        'No equipment selected. Add inventory from the compendium or keep this as a deliberate blank slate.',
      ];
    }
    if (loadout.armorEntryId == null &&
        loadout.meleeEntryId == null &&
        loadout.rangedEntryId == null) {
      return const <String>[
        'Inventory exists, but no armor or weapon slots are assigned.',
      ];
    }
    return const <String>[];
  }
}

class _WarningRow extends StatelessWidget {
  final String message;

  const _WarningRow({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvancedInventorySection extends StatelessWidget {
  final CharacterEditorController controller;

  const _AdvancedInventorySection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: const Text('Advanced Inventory'),
        subtitle: const Text(
          'Use this for D&D item edits, compendium adds, quantities, notes, and exact loadout assignment.',
        ),
        children: [
          SizedBox(height: 900, child: EquipmentTab(controller: controller)),
        ],
      ),
    );
  }
}

class _StartingEquipmentSummary {
  final List<_StartingEquipmentSource> sources;

  const _StartingEquipmentSummary({required this.sources});

  factory _StartingEquipmentSummary.fromController(
    CharacterEditorController controller,
  ) {
    final sources = <_StartingEquipmentSource>[];
    final background = controller.resolvedBuild.background;
    if (background != null) {
      final parsed = _StartingEquipmentSource.fromData(
        sourceKey:
            '${background.ref.rulesetId}:${background.ref.entityType}:${background.ref.entityId}',
        sourceType: 'Background',
        sourceName: background.detail.entity.displayName,
        rawStartingEquipment:
            background.detail.entity.data['startingEquipment'],
      );
      if (parsed != null) {
        sources.add(parsed);
      }
    }

    final seenClasses = <String>{};
    for (final entity in controller.resolvedBuild.entityByKey.values) {
      if (entity.ref.entityType != 'class') {
        continue;
      }
      final sourceKey =
          '${entity.ref.rulesetId}:${entity.ref.entityType}:${entity.ref.entityId}';
      if (!seenClasses.add(sourceKey)) {
        continue;
      }
      final parsed = _StartingEquipmentSource.fromData(
        sourceKey: sourceKey,
        sourceType: 'Class',
        sourceName: entity.detail.entity.displayName,
        rawStartingEquipment: entity.detail.entity.data['startingEquipment'],
      );
      if (parsed != null) {
        sources.add(parsed);
      }
    }

    return _StartingEquipmentSummary(sources: sources);
  }
}

class _StartingEquipmentSource {
  final String sourceKey;
  final String sourceType;
  final String sourceName;
  final List<_StartingEquipmentChoice> choices;

  const _StartingEquipmentSource({
    required this.sourceKey,
    required this.sourceType,
    required this.sourceName,
    required this.choices,
  });

  static _StartingEquipmentSource? fromData({
    required String sourceKey,
    required String sourceType,
    required String sourceName,
    required dynamic rawStartingEquipment,
  }) {
    final packageData = _packageData(rawStartingEquipment);
    final choices = <_StartingEquipmentChoice>[];

    if (packageData is List) {
      for (final group in packageData.whereType<Map>()) {
        choices.addAll(_choicesFromGroup(group));
      }
    } else if (packageData is Map) {
      choices.addAll(_choicesFromGroup(packageData));
    }

    if (choices.isEmpty) {
      return null;
    }
    return _StartingEquipmentSource(
      sourceKey: sourceKey,
      sourceType: sourceType,
      sourceName: sourceName,
      choices: choices,
    );
  }

  static dynamic _packageData(dynamic rawStartingEquipment) {
    if (rawStartingEquipment is Map) {
      return rawStartingEquipment['defaultData'] ??
          rawStartingEquipment['data'] ??
          rawStartingEquipment['packages'] ??
          rawStartingEquipment['equipment'];
    }
    return rawStartingEquipment;
  }

  static List<_StartingEquipmentChoice> _choicesFromGroup(Map group) {
    final choices = <_StartingEquipmentChoice>[];
    for (final entry in group.entries) {
      final id = entry.key.toString();
      if (id.trim().isEmpty) {
        continue;
      }
      final rawLines = entry.value;
      if (rawLines is! List) {
        continue;
      }
      final lines = rawLines
          .map(_StartingEquipmentLine.fromRaw)
          .whereType<_StartingEquipmentLine>()
          .toList(growable: false);
      if (lines.isEmpty) {
        continue;
      }
      choices.add(_StartingEquipmentChoice(id: id, lines: lines));
    }
    choices.sort((left, right) => left.id.compareTo(right.id));
    return choices;
  }
}

class _StartingEquipmentChoice {
  final String id;
  final List<_StartingEquipmentLine> lines;

  const _StartingEquipmentChoice({required this.id, required this.lines});

  bool get isGoldOnly => lines.every((line) => line.isCurrency);

  String get title => isGoldOnly ? 'Gold Option $id' : 'Package $id';
}

class _StartingEquipmentLine {
  final String label;
  final bool isCurrency;

  const _StartingEquipmentLine({required this.label, required this.isCurrency});

  static _StartingEquipmentLine? fromRaw(dynamic raw) {
    if (raw is String) {
      return _StartingEquipmentLine(label: _titleCase(raw), isCurrency: false);
    }
    if (raw is! Map) {
      return null;
    }
    final displayName = raw['displayName']?.toString().trim();
    final item = raw['item']?.toString().trim();
    final quantity = _intValue(raw['quantity']);
    final value = _intValue(raw['value']);

    if (value != null) {
      return _StartingEquipmentLine(
        label: _formatCopperValue(value),
        isCurrency: true,
      );
    }
    if (displayName != null && displayName.isNotEmpty) {
      return _StartingEquipmentLine(
        label: _quantityLabel(displayName, quantity),
        isCurrency: false,
      );
    }
    if (item != null && item.isNotEmpty) {
      return _StartingEquipmentLine(
        label: _quantityLabel(_itemNameFromReference(item), quantity),
        isCurrency: false,
      );
    }

    final equipmentType = raw['equipmentType']?.toString().trim();
    if (equipmentType != null && equipmentType.isNotEmpty) {
      return _StartingEquipmentLine(
        label: 'Choose ${_titleCase(_splitCamelCase(equipmentType))}',
        isCurrency: false,
      );
    }
    final equipmentTypes = raw['equipmentTypes'];
    if (equipmentTypes is List && equipmentTypes.isNotEmpty) {
      return _StartingEquipmentLine(
        label:
            'Choose ${equipmentTypes.map((entry) => _titleCase(_splitCamelCase(entry.toString()))).join(' or ')}',
        isCurrency: false,
      );
    }
    return null;
  }
}

class _StartingEquipmentChoices {
  final Map<String, String> choiceIdsBySource;

  const _StartingEquipmentChoices({required this.choiceIdsBySource});

  factory _StartingEquipmentChoices.fromExtraData(
    Map<String, dynamic> extraData,
  ) {
    final creation = characterCreationData(extraData);
    final equipment = creation['equipment'];
    final startingEquipment = equipment is Map
        ? equipment['startingEquipment']
        : null;
    final rawChoices = startingEquipment is Map
        ? startingEquipment['choices']
        : null;
    final choices = <String, String>{};
    if (rawChoices is Map) {
      for (final entry in rawChoices.entries) {
        final value = entry.value;
        if (value is Map) {
          final choiceId = value['choiceId']?.toString();
          if (choiceId != null && choiceId.trim().isNotEmpty) {
            choices[entry.key.toString()] = choiceId;
          }
        }
      }
    }
    return _StartingEquipmentChoices(choiceIdsBySource: choices);
  }

  String? choiceIdFor(String sourceKey) => choiceIdsBySource[sourceKey];
}

int? _intValue(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '');
}

String _formatCopperValue(int copper) {
  if (copper >= 100 && copper % 100 == 0) {
    return '${copper ~/ 100} GP';
  }
  if (copper >= 10 && copper % 10 == 0) {
    return '${copper ~/ 10} SP';
  }
  return '$copper CP';
}

String _quantityLabel(String label, int? quantity) {
  if (quantity == null || quantity <= 1) {
    return label;
  }
  return '$label x$quantity';
}

String _itemNameFromReference(String reference) {
  return _titleCase(reference.split('|').first.trim());
}

String _titleCase(String value) {
  return value
      .replaceAll('_', ' ')
      .split(RegExp(r'\s+'))
      .where((part) => part.trim().isNotEmpty)
      .map((part) {
        if (part.length == 1) {
          return part.toUpperCase();
        }
        return '${part.substring(0, 1).toUpperCase()}${part.substring(1).toLowerCase()}';
      })
      .join(' ');
}

String _splitCamelCase(String value) {
  return value.replaceAllMapped(
    RegExp(r'([a-z])([A-Z])'),
    (match) => '${match.group(1)} ${match.group(2)}',
  );
}
