import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/tabs/spells_tab.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';

class SpellsStep extends StatelessWidget {
  final CharacterEditorController controller;
  final ValueChanged<CharacterBuilderStepId>? onGoToStep;

  const SpellsStep({super.key, required this.controller, this.onGoToStep});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final spellcasting = character.spellcasting;
    final hasSelectedSpells = spellcasting?.allSpells.isNotEmpty ?? false;
    final hasSpellcasting =
        controller.resolvedBuild.hasSpellcasting || hasSelectedSpells;

    if (!hasSpellcasting) {
      return _NoSpellcastingState(onGoToStep: onGoToStep);
    }

    final metrics = _SpellMetrics.from(spellcasting, controller);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SpellsHeader(onGoToStep: onGoToStep),
        const SizedBox(height: 16),
        _SpellcastingSummaryCard(controller: controller, metrics: metrics),
        const SizedBox(height: 16),
        _SelectedSpellGroups(spellcasting: spellcasting, metrics: metrics),
        const SizedBox(height: 16),
        _AdvancedSpellEditor(controller: controller),
      ],
    );
  }
}

class _SpellsHeader extends StatelessWidget {
  final ValueChanged<CharacterBuilderStepId>? onGoToStep;

  const _SpellsHeader({required this.onGoToStep});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guided Spell Checklist',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Review the D&D spellcasting profile resolved from Class & Level, then use the advanced editor when you need to add, remove, or retag selected spells.',
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
            if (onGoToStep != null) ...[
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => onGoToStep!(CharacterBuilderStepId.classLevel),
                icon: const Icon(Icons.school_outlined),
                label: const Text('Review Class & Level'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NoSpellcastingState extends StatelessWidget {
  final ValueChanged<CharacterBuilderStepId>? onGoToStep;

  const _NoSpellcastingState({required this.onGoToStep});

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
                Icon(
                  Icons.auto_stories_outlined,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your current class does not use spellcasting.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'D&D spell choices appear here after Class & Level resolves a spellcasting class.',
                  style: TextStyle(color: colorScheme.onSecondaryContainer),
                ),
                if (onGoToStep != null) ...[
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        onGoToStep!(CharacterBuilderStepId.classLevel),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go to Class & Level'),
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

class _SpellcastingSummaryCard extends StatelessWidget {
  final CharacterEditorController controller;
  final _SpellMetrics metrics;

  const _SpellcastingSummaryCard({
    required this.controller,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final spellcasting = controller.character!.spellcasting;
    final className =
        controller.resolvedBuild.spellcastingClassName ?? 'Spellcasting class';
    final abilityId =
        spellcasting?.spellcastingAbility ??
        controller.resolvedBuild.spellcastingAbility;
    final abilityLabel = abilityId == null
        ? null
        : controller.sheetSchema.abilityLabel(abilityId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spellcasting Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SummaryChip(
                  icon: Icons.school_outlined,
                  label: 'Class',
                  value: className,
                ),
                if (abilityLabel != null)
                  _SummaryChip(
                    icon: Icons.psychology_alt_outlined,
                    label: 'Ability',
                    value: abilityLabel,
                  ),
                if (spellcasting != null)
                  _SummaryChip(
                    icon: Icons.shield_outlined,
                    label: 'Spell Save DC',
                    value: '${spellcasting.spellSaveDC}',
                  ),
                if (spellcasting != null)
                  _SummaryChip(
                    icon: Icons.bolt_outlined,
                    label: 'Spell Attack',
                    value: _signed(spellcasting.spellAttackBonus),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _CapacityGrid(metrics: metrics),
            if (metrics.hasWarnings) ...[
              const SizedBox(height: 12),
              ...metrics.warningMessages.map(
                (message) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _InlineWarning(message: message),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text('$label: $value'));
  }
}

class _CapacityGrid extends StatelessWidget {
  final _SpellMetrics metrics;

  const _CapacityGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _CapacityTileData(
        label: 'Cantrips',
        count: metrics.cantripCount,
        capacity: metrics.cantripCapacity,
        isOverCapacity: metrics.cantripsOverCapacity,
      ),
      _CapacityTileData(
        label: 'Known Spells',
        count: metrics.knownSpellCount,
        capacity: metrics.knownSpellCapacity,
        isOverCapacity: metrics.knownSpellsOverCapacity,
      ),
      _CapacityTileData(
        label: 'Prepared Spells',
        count: metrics.preparedSpellCount,
        capacity: metrics.preparedSpellCapacity,
        isOverCapacity: metrics.preparedSpellsOverCapacity,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 720
            ? 3
            : width >= 460
            ? 2
            : 1;
        final spacing = 10.0;
        final tileWidth = (width - (spacing * (columns - 1))) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final tile in tiles)
              SizedBox(
                width: tileWidth,
                child: _CapacityTile(data: tile),
              ),
          ],
        );
      },
    );
  }
}

class _CapacityTileData {
  final String label;
  final int count;
  final int? capacity;
  final bool isOverCapacity;

  const _CapacityTileData({
    required this.label,
    required this.count,
    required this.capacity,
    required this.isOverCapacity,
  });

  String get displayValue =>
      capacity == null ? '$count selected' : '$count / $capacity';
}

class _CapacityTile extends StatelessWidget {
  final _CapacityTileData data;

  const _CapacityTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = data.isOverCapacity
        ? colorScheme.onErrorContainer
        : colorScheme.onSurface;
    final background = data.isOverCapacity
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerLow;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: data.isOverCapacity
              ? colorScheme.error
              : colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: foreground),
          ),
          const SizedBox(height: 4),
          Text(
            data.displayValue,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineWarning extends StatelessWidget {
  final String message;

  const _InlineWarning({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedSpellGroups extends StatelessWidget {
  final SpellcastingInfo? spellcasting;
  final _SpellMetrics metrics;

  const _SelectedSpellGroups({
    required this.spellcasting,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final cantrips =
        spellcasting?.allSpells.where((spell) => spell.level == 0).toList() ??
        const <Spell>[];
    final knownSpells =
        spellcasting?.knownSpells.where((spell) => spell.level > 0).toList() ??
        const <Spell>[];
    final preparedSpells =
        spellcasting?.preparedSpells
            .where((spell) => spell.level > 0)
            .toList() ??
        const <Spell>[];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Spells',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Grouped by the D&D buckets that matter during creation: cantrips, known spells, and prepared spells.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _SpellGroup(
              title: 'Cantrips',
              countLabel: metrics.cantripCapacity == null
                  ? '${metrics.cantripCount} selected'
                  : '${metrics.cantripCount} / ${metrics.cantripCapacity}',
              emptyLabel: 'No cantrips selected.',
              spells: cantrips,
            ),
            const SizedBox(height: 14),
            _SpellGroup(
              title: 'Known Spells',
              countLabel: metrics.knownSpellCapacity == null
                  ? '${metrics.knownSpellCount} selected'
                  : '${metrics.knownSpellCount} / ${metrics.knownSpellCapacity}',
              emptyLabel: 'No known spells selected.',
              spells: knownSpells,
            ),
            const SizedBox(height: 14),
            _SpellGroup(
              title: 'Prepared Spells',
              countLabel: metrics.preparedSpellCapacity == null
                  ? '${metrics.preparedSpellCount} selected'
                  : '${metrics.preparedSpellCount} / ${metrics.preparedSpellCapacity}',
              emptyLabel: 'No prepared spells selected.',
              spells: preparedSpells,
            ),
          ],
        ),
      ),
    );
  }
}

class _SpellGroup extends StatelessWidget {
  final String title;
  final String countLabel;
  final String emptyLabel;
  final List<Spell> spells;

  const _SpellGroup({
    required this.title,
    required this.countLabel,
    required this.emptyLabel,
    required this.spells,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text(countLabel),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (spells.isEmpty)
            Text(emptyLabel, style: Theme.of(context).textTheme.bodyMedium)
          else
            ..._groupSpellsByLevel(spells).entries.map(
              (entry) =>
                  _SpellLevelGroup(level: entry.key, spells: entry.value),
            ),
        ],
      ),
    );
  }
}

class _SpellLevelGroup extends StatelessWidget {
  final int level;
  final List<Spell> spells;

  const _SpellLevelGroup({required this.level, required this.spells});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            level == 0 ? 'Cantrip' : 'Level $level',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          ...spells.map(
            (spell) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _GuidedSpellRow(spell: spell),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidedSpellRow extends StatelessWidget {
  final Spell spell;

  const _GuidedSpellRow({required this.spell});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            child: Text(spell.level == 0 ? 'C' : '${spell.level}'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(spell.name, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (spell.school.trim().isNotEmpty)
                      Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(spell.school),
                      ),
                    if (spell.isRitual)
                      const Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text('Ritual'),
                      ),
                    if (spell.isConcentration)
                      const Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text('Concentration'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvancedSpellEditor extends StatelessWidget {
  final CharacterEditorController controller;

  const _AdvancedSpellEditor({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        'Advanced Spell Editor',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: const Text(
        'Open the full spell editor to add, remove, preview, or retag D&D spell selections.',
      ),
      children: [
        const SizedBox(height: 8),
        SizedBox(height: 760, child: SpellsTab(controller: controller)),
      ],
    );
  }
}

class _SpellMetrics {
  final int cantripCount;
  final int knownSpellCount;
  final int preparedSpellCount;
  final int concentrationCount;
  final int? cantripCapacity;
  final int? knownSpellCapacity;
  final int? preparedSpellCapacity;

  const _SpellMetrics({
    required this.cantripCount,
    required this.knownSpellCount,
    required this.preparedSpellCount,
    required this.concentrationCount,
    required this.cantripCapacity,
    required this.knownSpellCapacity,
    required this.preparedSpellCapacity,
  });

  factory _SpellMetrics.from(
    SpellcastingInfo? spellcasting,
    CharacterEditorController controller,
  ) {
    return _SpellMetrics(
      cantripCount:
          spellcasting?.allSpells.where((spell) => spell.level == 0).length ??
          0,
      knownSpellCount:
          spellcasting?.knownSpells.where((spell) => spell.level > 0).length ??
          0,
      preparedSpellCount:
          spellcasting?.preparedSpells
              .where((spell) => spell.level > 0)
              .length ??
          0,
      concentrationCount:
          spellcasting?.allSpells
              .where((spell) => spell.isConcentration)
              .length ??
          0,
      cantripCapacity: controller.resolvedBuild.cantripCapacity,
      knownSpellCapacity: controller.resolvedBuild.knownSpellCapacity,
      preparedSpellCapacity: controller.resolvedBuild.preparedSpellCapacity,
    );
  }

  bool get cantripsOverCapacity =>
      cantripCapacity != null && cantripCount > cantripCapacity!;
  bool get knownSpellsOverCapacity =>
      knownSpellCapacity != null && knownSpellCount > knownSpellCapacity!;
  bool get preparedSpellsOverCapacity =>
      preparedSpellCapacity != null &&
      preparedSpellCount > preparedSpellCapacity!;
  bool get manyConcentrationSpells => concentrationCount >= 4;

  bool get hasWarnings =>
      cantripsOverCapacity ||
      knownSpellsOverCapacity ||
      preparedSpellsOverCapacity ||
      manyConcentrationSpells;

  Iterable<String> get warningMessages sync* {
    if (cantripsOverCapacity) {
      yield 'Cantrips exceed capacity: $cantripCount / $cantripCapacity selected.';
    }
    if (knownSpellsOverCapacity) {
      yield 'Known spells exceed capacity: $knownSpellCount / $knownSpellCapacity selected.';
    }
    if (preparedSpellsOverCapacity) {
      yield 'Prepared spells exceed capacity: $preparedSpellCount / $preparedSpellCapacity selected.';
    }
    if (manyConcentrationSpells) {
      yield 'Many concentration spells selected: $concentrationCount selected. In D&D you can normally concentrate on only one spell at a time.';
    }
  }
}

Map<int, List<Spell>> _groupSpellsByLevel(List<Spell> spells) {
  final grouped = <int, List<Spell>>{};
  final sorted = List<Spell>.from(spells)
    ..sort((left, right) {
      final levelOrder = left.level.compareTo(right.level);
      if (levelOrder != 0) {
        return levelOrder;
      }
      return left.name.compareTo(right.name);
    });
  for (final spell in sorted) {
    grouped.putIfAbsent(spell.level, () => <Spell>[]).add(spell);
  }
  return grouped;
}

String _signed(int value) {
  if (value >= 0) {
    return '+$value';
  }
  return '$value';
}
