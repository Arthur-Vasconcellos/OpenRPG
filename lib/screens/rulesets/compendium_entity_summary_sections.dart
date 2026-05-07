import 'package:flutter/material.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';

typedef CompendiumReferenceTap =
    Future<void> Function(CompendiumLinkCandidate candidate);

Set<String> compendiumSummaryHiddenKeysFor(String entityType) {
  return switch (entityType) {
    'class' => {
      'primaryAbility',
      'hd',
      'spellcastingAbility',
      'casterProgression',
      'startingProficiencies',
      'classFeatures',
    },
    'spell' => {'school', 'time', 'range', 'components', 'duration'},
    'monster' => {
      'ac',
      'hp',
      'speed',
      'cr',
      'senses',
      'str',
      'dex',
      'con',
      'int',
      'wis',
      'cha',
    },
    'item' => {
      'type',
      'rarity',
      'weight',
      'value',
      'bonusWeapon',
      'bonusSpellAttack',
    },
    'race' => {'size', 'speed', 'creatureTypes'},
    _ => const <String>{},
  };
}

class CompendiumEntitySummarySections extends StatelessWidget {
  final String entityType;
  final Map<String, dynamic> data;
  final bool compact;
  final CompendiumReferenceTap? onLinkTap;

  const CompendiumEntitySummarySections({
    super.key,
    required this.entityType,
    required this.data,
    required this.compact,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final sections = switch (entityType) {
      'class' => _buildClassSections(context),
      'spell' => _buildSpellSections(context),
      'monster' => _buildMonsterSections(context),
      'item' => _buildItemSections(context),
      'race' => _buildRaceSections(context),
      _ => const <Widget>[],
    };

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...sections,
        SizedBox(height: compact ? 12 : 16),
      ],
    );
  }

  List<Widget> _buildClassSections(BuildContext context) {
    final primaryAbility = _formatPrimaryAbility(data['primaryAbility']);
    final hitDie = _formatHitDie(data['hd']);
    final spellcastingSummary = _formatSpellcastingSummary(data);
    final proficiencies = _classProficiencies(data);
    final featureCandidates = _extractReferenceCandidates(
      data['classFeatures'],
      hintedFieldKey: 'classFeatures',
    );

    final sections = <Widget>[
      _SummaryCard(
        title: 'Class Summary',
        compact: compact,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SummaryChip(label: 'Primary Ability', value: primaryAbility),
            _SummaryChip(label: 'Hit Die', value: hitDie),
            if (spellcastingSummary != null)
              _SummaryChip(label: 'Spellcasting', value: spellcastingSummary),
          ],
        ),
      ),
    ];

    if (proficiencies.isNotEmpty) {
      sections.add(
        _SummaryCard(
          title: 'Proficiencies',
          compact: compact,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final proficiency in proficiencies)
                Chip(label: Text(proficiency)),
            ],
          ),
        ),
      );
    }

    if (featureCandidates.isNotEmpty) {
      sections.add(
        _SummaryCard(
          title: 'Feature Progression',
          compact: compact,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final candidate in featureCandidates)
                ActionChip(
                  avatar: const Icon(Icons.visibility_outlined, size: 18),
                  label: Text(candidate.displayText),
                  onPressed: onLinkTap == null ? null : () => onLinkTap!(candidate),
                ),
            ],
          ),
        ),
      );
    }

    return sections;
  }

  List<Widget> _buildSpellSections(BuildContext context) {
    return [
      _SummaryCard(
        title: 'Spell Summary',
        compact: compact,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SummaryChip(label: 'Level', value: _spellLevel(data['level'])),
            _SummaryChip(label: 'School', value: data['school']?.toString() ?? 'Unknown'),
            _SummaryChip(
              label: 'Casting Time',
              value: _formatActivationList(data['time']) ?? 'Not listed',
            ),
            _SummaryChip(
              label: 'Range',
              value: _formatRange(data['range']) ?? 'Not listed',
            ),
            _SummaryChip(
              label: 'Components',
              value: _formatComponents(data['components']) ?? 'Not listed',
            ),
            _SummaryChip(
              label: 'Duration',
              value: _formatDuration(data['duration']) ?? 'Not listed',
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildMonsterSections(BuildContext context) {
    return [
      _SummaryCard(
        title: 'Monster Snapshot',
        compact: compact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SummaryChip(label: 'AC', value: _formatArmorClass(data['ac'])),
                _SummaryChip(label: 'HP', value: _formatHitPoints(data['hp'])),
                _SummaryChip(label: 'Speed', value: _formatSpeed(data['speed'])),
                _SummaryChip(label: 'CR', value: _formatChallengeRating(data['cr'])),
                _SummaryChip(label: 'Senses', value: _formatStringList(data['senses'])),
              ],
            ),
            SizedBox(height: compact ? 10 : 12),
            _StatBlockRow(data: data),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildItemSections(BuildContext context) {
    return [
      _SummaryCard(
        title: 'Item Summary',
        compact: compact,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SummaryChip(label: 'Kind', value: data['type']?.toString() ?? 'Item'),
            if (data['rarity'] != null)
              _SummaryChip(label: 'Rarity', value: data['rarity'].toString()),
            if (data['weight'] != null)
              _SummaryChip(label: 'Weight', value: '${data['weight']} lb'),
            if (data['value'] != null)
              _SummaryChip(label: 'Value', value: data['value'].toString()),
            if (data['bonusWeapon'] != null)
              _SummaryChip(label: 'Weapon Bonus', value: data['bonusWeapon'].toString()),
            if (data['bonusSpellAttack'] != null)
              _SummaryChip(
                label: 'Spell Attack',
                value: data['bonusSpellAttack'].toString(),
              ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildRaceSections(BuildContext context) {
    final standoutTraits = _entryTitles(data['entries']);
    return [
      _SummaryCard(
        title: 'Race Summary',
        compact: compact,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SummaryChip(label: 'Size', value: _formatStringList(data['size'])),
            _SummaryChip(label: 'Speed', value: _formatSpeed(data['speed'])),
            _SummaryChip(
              label: 'Creature Type',
              value: _formatStringList(data['creatureTypes']),
            ),
          ],
        ),
      ),
      if (standoutTraits.isNotEmpty)
        _SummaryCard(
          title: 'Standout Traits',
          compact: compact,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final trait in standoutTraits.take(6)) Chip(label: Text(trait))],
          ),
        ),
    ];
  }

  List<String> _classProficiencies(Map<String, dynamic> value) {
    final proficiencies = <String>[];
    final starting = value['startingProficiencies'];
    if (starting is! Map) {
      return proficiencies;
    }

    final armor = (starting['armor'] as List<dynamic>? ?? const [])
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .join(', ');
    if (armor.isNotEmpty) {
      proficiencies.add('Armor: $armor');
    }

    final weapons = (starting['weapons'] as List<dynamic>? ?? const [])
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .join(', ');
    if (weapons.isNotEmpty) {
      proficiencies.add('Weapons: $weapons');
    }

    final skills = (starting['skills'] as List<dynamic>? ?? const []);
    for (final skill in skills) {
      if (skill is Map && skill['choose'] is Map) {
        final choose = skill['choose'] as Map;
        final options = (choose['from'] as List<dynamic>? ?? const [])
            .map((item) => item.toString())
            .join(', ');
        final count = choose['count']?.toString() ?? '1';
        proficiencies.add('Skills: choose $count from $options');
      }
    }

    return proficiencies;
  }

  List<CompendiumLinkCandidate> _extractReferenceCandidates(
    dynamic value, {
    required String hintedFieldKey,
  }) {
    final candidates = <CompendiumLinkCandidate>[];
    final seen = <String>{};

    void visit(dynamic node) {
      if (node is String) {
        final candidate = CompendiumLinkParser.tryParsePlainReference(
          node,
          hintedFieldKey: hintedFieldKey,
        );
        if (candidate != null &&
            seen.add(
              '${candidate.targetEntityType}|${candidate.lookupName}|${candidate.displayText}',
            )) {
          candidates.add(candidate);
        }
        return;
      }

      if (node is Map<String, dynamic>) {
        final candidate = CompendiumLinkParser.extractReferenceFromMap(node);
        if (candidate != null &&
            seen.add(
              '${candidate.targetEntityType}|${candidate.lookupName}|${candidate.displayText}',
            )) {
          candidates.add(candidate);
        }
        return;
      }

      if (node is List) {
        for (final item in node) {
          visit(item);
        }
      }
    }

    visit(value);
    return candidates;
  }

  String _formatPrimaryAbility(dynamic value) {
    if (value is! List || value.isEmpty) {
      return 'Not listed';
    }

    final first = value.first;
    if (first is Map) {
      final labels = <String>[];
      for (final entry in first.entries) {
        if (entry.value == true) {
          labels.add(_abilityLabel(entry.key.toString()));
        }
      }
      if (labels.isNotEmpty) {
        return labels.join(' / ');
      }
    }

    return 'Not listed';
  }

  String _formatHitDie(dynamic value) {
    if (value is Map && value['faces'] != null) {
      return 'd${value['faces']}';
    }
    return 'Not listed';
  }

  String? _formatSpellcastingSummary(Map<String, dynamic> value) {
    if (value['spellcastingAbility'] != null) {
      return _abilityLabel(value['spellcastingAbility'].toString());
    }
    if (value['casterProgression'] != null) {
      return value['casterProgression'].toString();
    }
    return null;
  }

  String _spellLevel(dynamic value) {
    final level = (value as num?)?.toInt() ?? 0;
    if (level == 0) {
      return 'Cantrip';
    }
    return 'Level $level';
  }

  String? _formatActivationList(dynamic value) {
    if (value is! List || value.isEmpty) {
      return null;
    }
    final first = value.first;
    if (first is! Map) {
      return first.toString();
    }
    final number = first['number']?.toString() ?? '1';
    final unit = first['unit']?.toString() ?? '';
    return '$number $unit'.trim();
  }

  String? _formatRange(dynamic value) {
    if (value is! Map) {
      return value?.toString();
    }
    if (value['distance'] is Map) {
      final distance = value['distance'] as Map;
      final amount = distance['amount']?.toString();
      final type = distance['type']?.toString() ?? value['type']?.toString() ?? '';
      if (amount != null && amount.isNotEmpty) {
        return '$amount $type'.trim();
      }
    }
    return value['type']?.toString();
  }

  String? _formatComponents(dynamic value) {
    if (value is! Map) {
      return value?.toString();
    }
    final parts = <String>[];
    if (value['v'] == true) {
      parts.add('V');
    }
    if (value['s'] == true) {
      parts.add('S');
    }
    if (value['m'] != null) {
      parts.add('M');
    }
    return parts.isEmpty ? null : parts.join(', ');
  }

  String? _formatDuration(dynamic value) {
    if (value is! List || value.isEmpty) {
      return value?.toString();
    }
    final first = value.first;
    if (first is! Map) {
      return first.toString();
    }
    final type = first['type']?.toString();
    if (type == 'instant') {
      return 'Instantaneous';
    }
    if (first['duration'] is Map) {
      final duration = first['duration'] as Map;
      final amount = duration['amount']?.toString();
      final unit = duration['type']?.toString() ?? '';
      if (amount != null && amount.isNotEmpty) {
        return '$amount $unit'.trim();
      }
    }
    return type;
  }

  String _formatArmorClass(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return value.first.toString();
    }
    return value?.toString() ?? 'Not listed';
  }

  String _formatHitPoints(dynamic value) {
    if (value is Map && value['average'] != null) {
      return value['average'].toString();
    }
    return value?.toString() ?? 'Not listed';
  }

  String _formatSpeed(dynamic value) {
    if (value is num) {
      return '$value ft';
    }
    if (value is Map) {
      final parts = value.entries
          .where((entry) => entry.value != null)
          .map((entry) => '${entry.key} ${entry.value}')
          .toList(growable: false);
      if (parts.isNotEmpty) {
        return parts.join(', ');
      }
    }
    return value?.toString() ?? 'Not listed';
  }

  String _formatChallengeRating(dynamic value) {
    if (value is Map && value['cr'] != null) {
      return value['cr'].toString();
    }
    return value?.toString() ?? 'Not listed';
  }

  String _formatStringList(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return value.map((item) => item.toString()).join(', ');
    }
    return value?.toString() ?? 'Not listed';
  }

  List<String> _entryTitles(dynamic value) {
    if (value is! List) {
      return const <String>[];
    }
    return value
        .whereType<Map>()
        .map((entry) => entry['name']?.toString() ?? '')
        .where((entry) => entry.trim().isNotEmpty)
        .toList(growable: false);
  }

  String _abilityLabel(String key) {
    return switch (key.toLowerCase()) {
      'str' => 'Strength',
      'dex' => 'Dexterity',
      'con' => 'Constitution',
      'int' => 'Intelligence',
      'wis' => 'Wisdom',
      'cha' => 'Charisma',
      _ => key,
    };
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final bool compact;
  final Widget child;

  const _SummaryCard({
    required this.title,
    required this.compact,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: compact ? 10 : 14),
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(compact ? 18 : 22),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: compact ? 10 : 12),
          child,
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _StatBlockRow extends StatelessWidget {
  final Map<String, dynamic> data;

  const _StatBlockRow({required this.data});

  @override
  Widget build(BuildContext context) {
    const keys = <String>['str', 'dex', 'con', 'int', 'wis', 'cha'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final key in keys)
          Chip(
            label: Text(
              '${key.toUpperCase()} ${(data[key] as num?)?.toString() ?? '-'}',
            ),
          ),
      ],
    );
  }
}
