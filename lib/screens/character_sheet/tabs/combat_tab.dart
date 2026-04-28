import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_build_resolver.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';

class CombatTab extends StatelessWidget {
  final CharacterEditorController controller;

  const CombatTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final build = controller.resolvedBuild;
    final schema = controller.sheetSchema;
    final entries = character.equipment.entries;
    final loadout = character.equipment.loadout;
    final armorEntry = _findEntry(entries, loadout.armorEntryId);
    final meleeEntry = _findEntry(entries, loadout.meleeEntryId);
    final rangedEntry = _findEntry(entries, loadout.rangedEntryId);
    final armorProfile = _ArmorBreakdown.resolve(
      character: character,
      build: build,
      entry: armorEntry,
    );
    final meleeProfile = _WeaponBreakdown.resolve(
      character: character,
      build: build,
      entry: meleeEntry,
      slotLabel: 'Melee',
    );
    final rangedProfile = _WeaponBreakdown.resolve(
      character: character,
      build: build,
      entry: rangedEntry,
      slotLabel: 'Ranged',
    );
    final unresolvedEquipmentRefs = entries
        .where(
          (entry) => entry.reference != null && !entry.reference!.isResolved,
        )
        .length;
    final relevantFeatures = build.allFeatures
        .where(_looksCombatRelevant)
        .take(8)
        .toList(growable: false);
    final browseRepository = controller.compendium.browseRepository;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Combat Snapshot', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Active loadout selections now drive the combat readout shown here, so the numbers stay tied to the same compendium-backed inventory entries you equip in the Equipment tab.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _CombatStatChip(
                      label: 'Armor Class',
                      value: '${armorProfile.totalArmorClass}',
                    ),
                    _CombatStatChip(
                      label: 'Initiative',
                      value: _signed(character.combatStats.initiative),
                    ),
                    _CombatStatChip(
                      label: 'Speed',
                      value: '${build.expectedSpeed} ft',
                    ),
                    _CombatStatChip(
                      label: 'Proficiency',
                      value: _signed(character.proficiencies.proficiencyBonus),
                    ),
                    ...schema.highlightedPassiveSkills.map(
                      (skill) => _CombatStatChip(
                        label: 'Passive ${skill.label}',
                        value: '${controller.passiveSkillScoreFor(skill)}',
                      ),
                    ),
                    _CombatStatChip(
                      label: 'Hit Points',
                      value:
                          '${character.health.currentHitPoints}/${character.health.maxHitPoints}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        '${entries.where((entry) => entry.equipped).length} equipped item${entries.where((entry) => entry.equipped).length == 1 ? '' : 's'}',
                      ),
                    ),
                    if (unresolvedEquipmentRefs > 0)
                      Chip(
                        label: Text(
                          '$unresolvedEquipmentRefs unresolved equipment ref${unresolvedEquipmentRefs == 1 ? '' : 's'}',
                        ),
                      ),
                    if (build.barbarianUnarmoredDefense)
                      const Chip(label: Text('Barbarian defense available')),
                    if (build.monkUnarmoredDefense)
                      const Chip(label: Text('Monk defense available')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loadout Breakdown', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Each slot shows the exact source entry, the formula currently applied, and the contributors behind the total.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                _ArmorBreakdownTile(
                  title: 'Armor Source',
                  breakdown: armorProfile,
                  browseRepository: browseRepository,
                ),
                const SizedBox(height: 12),
                _WeaponBreakdownTile(
                  breakdown: meleeProfile,
                  browseRepository: browseRepository,
                ),
                const SizedBox(height: 12),
                _WeaponBreakdownTile(
                  breakdown: rangedProfile,
                  browseRepository: browseRepository,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Build Contributors', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'These are the compendium-driven features and proficiencies currently shaping the combat sheet.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: Text(
                        '${build.weaponProficiencies.length} weapon proficiencies',
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${build.armorProficiencies.length} armor proficiencies',
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${relevantFeatures.length} combat-relevant features',
                      ),
                    ),
                  ],
                ),
                if (relevantFeatures.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: relevantFeatures
                        .map((feature) {
                          final ref = feature.reference;
                          if (ref == null) {
                            return Chip(label: Text(feature.name));
                          }
                          return ActionChip(
                            label: Text(feature.name),
                            onPressed: () {
                              showCompendiumEntityPreviewSurface(
                                context,
                                rulesetId: ref.rulesetId,
                                entityType: ref.entityType,
                                entityId: ref.entityId,
                                browseRepository: browseRepository,
                              );
                            },
                          );
                        })
                        .toList(growable: false),
                  ),
                ],
                const SizedBox(height: 16),
                Text('Combat notes', style: theme.textTheme.labelLarge),
                const SizedBox(height: 6),
                Text(
                  character.notes.otherNotes.trim().isEmpty
                      ? 'No combat notes recorded yet.'
                      : character.notes.otherNotes,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  CharacterInventoryEntry? _findEntry(
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

class _CombatStatChip extends StatelessWidget {
  final String label;
  final String value;

  const _CombatStatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArmorBreakdownTile extends StatelessWidget {
  final String title;
  final _ArmorBreakdown breakdown;
  final CompendiumBrowseRepository browseRepository;

  const _ArmorBreakdownTile({
    required this.title,
    required this.breakdown,
    required this.browseRepository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          _CombatEntryHeader(
            entry: breakdown.entry,
            fallbackLabel: 'No armor slot selected',
            browseRepository: browseRepository,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('Total AC ${breakdown.totalArmorClass}')),
              if (breakdown.entry != null && breakdown.categoryLabel.isNotEmpty)
                Chip(label: Text(breakdown.categoryLabel)),
              if (breakdown.sheetValue != breakdown.totalArmorClass)
                Chip(label: Text('Stored sheet AC ${breakdown.sheetValue}')),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            breakdown.formulaLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: breakdown.contributors
                .map((entry) => Chip(label: Text(entry)))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _WeaponBreakdownTile extends StatelessWidget {
  final _WeaponBreakdown breakdown;
  final CompendiumBrowseRepository browseRepository;

  const _WeaponBreakdownTile({
    required this.breakdown,
    required this.browseRepository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${breakdown.slotLabel} Attack',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _CombatEntryHeader(
            entry: breakdown.entry,
            fallbackLabel:
                'No ${breakdown.slotLabel.toLowerCase()} weapon selected',
            browseRepository: browseRepository,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('Attack ${breakdown.attackBonusLabel}')),
              Chip(label: Text('Damage ${breakdown.damageExpression}')),
              Chip(label: Text(breakdown.proficiencyLabel)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            breakdown.formulaLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: breakdown.contributors
                .map((entry) => Chip(label: Text(entry)))
                .toList(growable: false),
          ),
          if (breakdown.entry?.notes.trim().isNotEmpty == true) ...[
            const SizedBox(height: 10),
            Text(breakdown.entry!.notes, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _CombatEntryHeader extends StatelessWidget {
  final CharacterInventoryEntry? entry;
  final String fallbackLabel;
  final CompendiumBrowseRepository browseRepository;

  const _CombatEntryHeader({
    required this.entry,
    required this.fallbackLabel,
    required this.browseRepository,
  });

  @override
  Widget build(BuildContext context) {
    final selectedEntry = entry;
    if (selectedEntry == null) {
      return Text(fallbackLabel, style: Theme.of(context).textTheme.bodyLarge);
    }

    final ref = selectedEntry.reference;
    if (ref == null) {
      return Text(
        selectedEntry.displayName,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      );
    }

    return CompendiumReferenceAnchor(
      rulesetId: ref.rulesetId,
      entityType: ref.entityType,
      entityId: ref.entityId,
      entityName: ref.displayName,
      browseRepository: browseRepository,
      onTap: () {
        showCompendiumEntityPreviewSurface(
          context,
          rulesetId: ref.rulesetId,
          entityType: ref.entityType,
          entityId: ref.entityId,
          browseRepository: browseRepository,
        );
      },
      child: Text(
        selectedEntry.displayName,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ArmorBreakdown {
  final CharacterInventoryEntry? entry;
  final int totalArmorClass;
  final int sheetValue;
  final String formulaLabel;
  final String categoryLabel;
  final List<String> contributors;

  const _ArmorBreakdown({
    required this.entry,
    required this.totalArmorClass,
    required this.sheetValue,
    required this.formulaLabel,
    required this.categoryLabel,
    required this.contributors,
  });

  factory _ArmorBreakdown.resolve({
    required Character character,
    required ResolvedCharacterBuild build,
    required CharacterInventoryEntry? entry,
  }) {
    final armorCategory =
        entry?.overrides.armorCategory?.trim().toLowerCase() ?? '';
    final usesDexterity = entry?.overrides.usesDexterity ?? true;
    final maxDexterity = entry?.overrides.maxDexterityBonus ?? 999;
    final baseArmorClass = entry?.overrides.armorClass ?? 10;
    final dexterityBonus = usesDexterity
        ? math.min(_abilityModifierFor(character, 'dex'), maxDexterity)
        : 0;
    final isUnarmored =
        entry == null || armorCategory.isEmpty || armorCategory == 'cloth';

    var bestTotal = baseArmorClass + dexterityBonus;
    var formulaLabel =
        'Base $baseArmorClass ${usesDexterity ? '+ DEX ${_signed(dexterityBonus)}' : '(no Dexterity bonus)'}';
    final contributors = <String>['Base $baseArmorClass'];
    if (usesDexterity) {
      contributors.add('DEX ${_signed(dexterityBonus)}');
    }

    if (isUnarmored && build.barbarianUnarmoredDefense) {
      final candidate =
          10 +
          _abilityModifierFor(character, 'dex') +
          _abilityModifierFor(character, 'con');
      if (candidate > bestTotal) {
        bestTotal = candidate;
        formulaLabel =
            '10 + DEX ${_signed(_abilityModifierFor(character, 'dex'))} + CON ${_signed(_abilityModifierFor(character, 'con'))}';
        contributors
          ..clear()
          ..add('Base 10')
          ..add('DEX ${_signed(_abilityModifierFor(character, 'dex'))}')
          ..add('CON ${_signed(_abilityModifierFor(character, 'con'))}')
          ..add('Barbarian Unarmored Defense');
      }
    }

    if (isUnarmored && build.monkUnarmoredDefense) {
      final candidate =
          10 +
          _abilityModifierFor(character, 'dex') +
          _abilityModifierFor(character, 'wis');
      if (candidate > bestTotal) {
        bestTotal = candidate;
        formulaLabel =
            '10 + DEX ${_signed(_abilityModifierFor(character, 'dex'))} + WIS ${_signed(_abilityModifierFor(character, 'wis'))}';
        contributors
          ..clear()
          ..add('Base 10')
          ..add('DEX ${_signed(_abilityModifierFor(character, 'dex'))}')
          ..add('WIS ${_signed(_abilityModifierFor(character, 'wis'))}')
          ..add('Monk Unarmored Defense');
      }
    }

    final categoryLabel = switch (armorCategory) {
      'heavy' => 'Heavy armor',
      'medium' => 'Medium armor',
      'light' => 'Light armor',
      'shield' => 'Shield',
      _ => 'Unarmored / cloth',
    };

    return _ArmorBreakdown(
      entry: entry,
      totalArmorClass: bestTotal,
      sheetValue: character.combatStats.armorClass,
      formulaLabel: formulaLabel,
      categoryLabel: categoryLabel,
      contributors: contributors,
    );
  }
}

class _WeaponBreakdown {
  final CharacterInventoryEntry? entry;
  final String slotLabel;
  final int attackBonus;
  final String attackBonusLabel;
  final String damageExpression;
  final String proficiencyLabel;
  final String formulaLabel;
  final List<String> contributors;

  const _WeaponBreakdown({
    required this.entry,
    required this.slotLabel,
    required this.attackBonus,
    required this.attackBonusLabel,
    required this.damageExpression,
    required this.proficiencyLabel,
    required this.formulaLabel,
    required this.contributors,
  });

  factory _WeaponBreakdown.resolve({
    required Character character,
    required ResolvedCharacterBuild build,
    required CharacterInventoryEntry? entry,
    required String slotLabel,
  }) {
    if (entry == null) {
      return _WeaponBreakdown(
        entry: null,
        slotLabel: slotLabel,
        attackBonus: 0,
        attackBonusLabel: '+0',
        damageExpression: 'No weapon selected',
        proficiencyLabel: 'Not assigned',
        formulaLabel:
            'Assign a weapon in Equipment to derive combat math here.',
        contributors: const <String>[],
      );
    }

    final abilityName = _resolveAttackAbility(character, entry);
    final abilityModifier = _abilityModifierFor(character, abilityName);
    final enhancementBonus = entry.overrides.enhancementBonus ?? 0;
    final damageDice = entry.overrides.damageDice?.trim().isNotEmpty == true
        ? entry.overrides.damageDice!.trim()
        : '1d4';
    final proficient = _isWeaponProficient(entry, build.weaponProficiencies);
    final proficiencyBonus = proficient
        ? character.proficiencies.proficiencyBonus
        : 0;
    final attackBonus = abilityModifier + proficiencyBonus + enhancementBonus;
    final damageBonus = abilityModifier + enhancementBonus;
    final contributors = <String>[
      '${_abilityLabel(abilityName)} ${_signed(abilityModifier)}',
      if (proficient) 'Proficiency ${_signed(proficiencyBonus)}',
      if (!proficient) 'No proficiency bonus',
      if (enhancementBonus != 0) 'Enhancement ${_signed(enhancementBonus)}',
    ];

    return _WeaponBreakdown(
      entry: entry,
      slotLabel: slotLabel,
      attackBonus: attackBonus,
      attackBonusLabel: _signed(attackBonus),
      damageExpression:
          '$damageDice${damageBonus == 0
              ? ''
              : damageBonus > 0
              ? '+$damageBonus'
              : '$damageBonus'}'
          '${entry.overrides.damageType?.trim().isNotEmpty == true ? ' ${entry.overrides.damageType}' : ''}',
      proficiencyLabel: proficient ? 'Proficient' : 'Not proficient',
      formulaLabel:
          '${_abilityLabel(abilityName)} ${_signed(abilityModifier)}${proficient ? ' + proficiency ${_signed(proficiencyBonus)}' : ''}${enhancementBonus == 0 ? '' : ' + enhancement ${_signed(enhancementBonus)}'}',
      contributors: contributors,
    );
  }
}

String _resolveAttackAbility(
  Character character,
  CharacterInventoryEntry entry,
) {
  if (entry.overrides.finesse == true) {
    return _abilityModifierFor(character, 'dex') >=
            _abilityModifierFor(character, 'str')
        ? 'dex'
        : 'str';
  }
  return canonicalAbilityId(entry.overrides.attackAbility ?? 'str');
}

int _abilityModifierFor(Character character, String ability) {
  return character.modifiers.modifierFor(ability);
}

String _abilityLabel(String ability) {
  return switch (canonicalAbilityId(ability)) {
    'str' => 'STR',
    'dex' => 'DEX',
    'con' => 'CON',
    'int' => 'INT',
    'wis' => 'WIS',
    'cha' => 'CHA',
    _ => canonicalAbilityId(ability).toUpperCase(),
  };
}

bool _isWeaponProficient(
  CharacterInventoryEntry entry,
  List<String> proficiencies,
) {
  final displayName = entry.displayName.toLowerCase();
  final category = entry.overrides.weaponCategory?.toLowerCase() ?? '';
  for (final proficiency in proficiencies) {
    final normalized = proficiency.toLowerCase();
    if (normalized.contains('all weapons') ||
        normalized.contains('all martial weapons') &&
            category.contains('martial') ||
        normalized.contains('all simple weapons') &&
            category.contains('simple') ||
        normalized.contains(category) ||
        normalized.contains(displayName) ||
        displayName.contains(normalized)) {
      return true;
    }
  }
  return false;
}

bool _looksCombatRelevant(Feature feature) {
  final haystack = '${feature.name} ${feature.description} ${feature.source}'
      .toLowerCase();
  const keywords = <String>[
    'armor',
    'attack',
    'damage',
    'weapon',
    'shield',
    'defense',
    'initiative',
    'speed',
    'hit point',
    'saving throw',
    'combat',
  ];
  return keywords.any(haystack.contains);
}

String _signed(int value) => value >= 0 ? '+$value' : '$value';

