import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/models/character.dart';

class CharacterAbilityDescriptor {
  final String id;
  final String label;
  final String abbreviation;

  const CharacterAbilityDescriptor({
    required this.id,
    required this.label,
    required this.abbreviation,
  });
}

class CharacterSkillDescriptor {
  final String id;
  final String label;
  final String abilityId;
  final String description;

  const CharacterSkillDescriptor({
    required this.id,
    required this.label,
    required this.abilityId,
    this.description = '',
  });
}

class CharacterSheetSectionDescriptor {
  final String id;
  final String title;
  final String iconKey;

  const CharacterSheetSectionDescriptor({
    required this.id,
    required this.title,
    required this.iconKey,
  });
}

class CharacterSheetSchema {
  static const CharacterSheetSchema empty = CharacterSheetSchema(
    rulesetId: '',
    abilities: <CharacterAbilityDescriptor>[],
    skills: <CharacterSkillDescriptor>[],
    sections: <CharacterSheetSectionDescriptor>[
      CharacterSheetSectionDescriptor(
        id: 'core',
        title: 'Core',
        iconKey: 'person',
      ),
      CharacterSheetSectionDescriptor(
        id: 'notes',
        title: 'Notes',
        iconKey: 'notes',
      ),
    ],
  );

  final String rulesetId;
  final List<CharacterAbilityDescriptor> abilities;
  final List<CharacterSkillDescriptor> skills;
  final List<CharacterSheetSectionDescriptor> sections;

  const CharacterSheetSchema({
    required this.rulesetId,
    required this.abilities,
    required this.skills,
    required this.sections,
  });

  CharacterAbilityDescriptor? abilityFor(String abilityId) {
    final normalized = canonicalAbilityId(abilityId);
    for (final ability in abilities) {
      if (ability.id == normalized) {
        return ability;
      }
    }
    return null;
  }

  String abilityLabel(String abilityId) {
    return abilityFor(abilityId)?.label ?? _labelForAbilityId(abilityId);
  }

  String abilityAbbreviation(String abilityId) {
    return abilityFor(abilityId)?.abbreviation ??
        _abbreviationForAbilityId(abilityId);
  }

  CharacterSkillDescriptor? skillFor(String skillId) {
    final normalized = skillId.trim().toLowerCase();
    for (final skill in skills) {
      if (skill.id == normalized) {
        return skill;
      }
    }
    return null;
  }

  List<CharacterSkillDescriptor> get highlightedPassiveSkills {
    final prioritized = <CharacterSkillDescriptor>[];
    const preferredOrder = <String>[
      'skill:perception',
      'skill:insight',
      'skill:investigation',
    ];
    for (final skillId in preferredOrder) {
      final skill = skillFor(skillId);
      if (skill != null) {
        prioritized.add(skill);
      }
    }
    return prioritized;
  }
}

class CharacterSheetSchemaResolver {
  final CharacterCompendiumService _compendium;

  CharacterSheetSchemaResolver({CharacterCompendiumService? compendium})
    : _compendium = compendium ?? CharacterCompendiumService();

  Future<CharacterSheetSchema> load(String rulesetId) async {
    if (rulesetId.trim().isEmpty) {
      return CharacterSheetSchema.empty;
    }

    final collectionSummaries = await _compendium.browseRepository
        .loadCollectionSummaries(rulesetId);
    final abilities = await _loadAbilities(rulesetId);
    final skills = await _loadSkills(rulesetId);

    return CharacterSheetSchema(
      rulesetId: rulesetId,
      abilities: abilities,
      skills: skills,
      sections: _buildSections(collectionSummaries),
    );
  }

  Future<List<CharacterAbilityDescriptor>> _loadAbilities(
    String rulesetId,
  ) async {
    final abilityIds = <String>{};

    for (final skill in await _loadSkills(rulesetId)) {
      if (skill.abilityId.isNotEmpty) {
        abilityIds.add(skill.abilityId);
      }
    }

    final classPage = await _compendium.browseRepository.loadCollectionPage(
      rulesetId: rulesetId,
      entityType: 'class',
      pageSize: 200,
    );
    for (final preview in classPage.items) {
      final detail = await _compendium.browseRepository.loadEntityDetail(
        rulesetId: preview.rulesetId,
        entityType: preview.entityType,
        entityId: preview.entityId,
      );
      final data = detail.entity.data;
      final primaryAbility = data['primaryAbility'];
      if (primaryAbility is List) {
        for (final entry in primaryAbility.whereType<Map>()) {
          for (final key in entry.keys) {
            final abilityId = canonicalAbilityId(key);
            if (abilityId.isNotEmpty) {
              abilityIds.add(abilityId);
            }
          }
        }
      }
      final proficiency = data['proficiency'];
      if (proficiency is List) {
        for (final entry in proficiency) {
          final abilityId = canonicalAbilityId(entry.toString());
          if (abilityId.isNotEmpty) {
            abilityIds.add(abilityId);
          }
        }
      }
    }

    final descriptors = abilityIds
        .map(
          (abilityId) => CharacterAbilityDescriptor(
            id: abilityId,
            label: _labelForAbilityId(abilityId),
            abbreviation: _abbreviationForAbilityId(abilityId),
          ),
        )
        .toList(growable: false);
    descriptors.sort((left, right) {
      final rankOrder = _abilityRank(left.id).compareTo(_abilityRank(right.id));
      if (rankOrder != 0) {
        return rankOrder;
      }
      return left.label.compareTo(right.label);
    });
    return descriptors;
  }

  Future<List<CharacterSkillDescriptor>> _loadSkills(String rulesetId) async {
    final page = await _compendium.browseRepository.loadCollectionPage(
      rulesetId: rulesetId,
      entityType: 'skill',
      pageSize: 500,
    );
    final descriptors = <CharacterSkillDescriptor>[];
    for (final preview in page.items) {
      final detail = await _compendium.browseRepository.loadEntityDetail(
        rulesetId: preview.rulesetId,
        entityType: preview.entityType,
        entityId: preview.entityId,
      );
      final data = detail.entity.data;
      descriptors.add(
        CharacterSkillDescriptor(
          id: preview.entityId.trim().toLowerCase(),
          label: preview.displayName,
          abilityId: canonicalAbilityId(data['ability']?.toString()),
          description: _firstDescription(data['entries']),
        ),
      );
    }
    descriptors.sort((left, right) => left.label.compareTo(right.label));
    return descriptors;
  }

  List<CharacterSheetSectionDescriptor> _buildSections(
    List<RulesetCollectionSummary> collections,
  ) {
    final entityTypes = collections
        .where((entry) => entry.entityCount > 0)
        .map((entry) => entry.entityType)
        .toSet();

    final sections = <CharacterSheetSectionDescriptor>[
      const CharacterSheetSectionDescriptor(
        id: 'core',
        title: 'Core',
        iconKey: 'person',
      ),
      if (entityTypes.contains('class') ||
          entityTypes.contains('item') ||
          entityTypes.contains('race'))
        const CharacterSheetSectionDescriptor(
          id: 'combat',
          title: 'Combat',
          iconKey: 'shield',
        ),
      if (entityTypes.contains('item'))
        const CharacterSheetSectionDescriptor(
          id: 'equipment',
          title: 'Equipment',
          iconKey: 'backpack',
        ),
      if (entityTypes.contains('spell'))
        const CharacterSheetSectionDescriptor(
          id: 'spells',
          title: 'Spells',
          iconKey: 'magic',
        ),
      if (entityTypes.contains('classFeature') ||
          entityTypes.contains('subclassFeature') ||
          entityTypes.contains('race') ||
          entityTypes.contains('background') ||
          entityTypes.contains('feat'))
        const CharacterSheetSectionDescriptor(
          id: 'features',
          title: 'Features',
          iconKey: 'star',
        ),
      const CharacterSheetSectionDescriptor(
        id: 'notes',
        title: 'Notes',
        iconKey: 'notes',
      ),
    ];

    return sections;
  }
}

String _firstDescription(dynamic entries) {
  if (entries is! List) {
    return '';
  }
  for (final entry in entries) {
    if (entry is String && entry.trim().isNotEmpty) {
      return entry.trim();
    }
  }
  return '';
}

int _abilityRank(String abilityId) {
  return switch (canonicalAbilityId(abilityId)) {
    'str' => 0,
    'dex' => 1,
    'con' => 2,
    'int' => 3,
    'wis' => 4,
    'cha' => 5,
    _ => 100,
  };
}

String _labelForAbilityId(String abilityId) {
  return switch (canonicalAbilityId(abilityId)) {
    'str' => 'Strength',
    'dex' => 'Dexterity',
    'con' => 'Constitution',
    'int' => 'Intelligence',
    'wis' => 'Wisdom',
    'cha' => 'Charisma',
    _ => _humanize(abilityId),
  };
}

String _abbreviationForAbilityId(String abilityId) {
  return switch (canonicalAbilityId(abilityId)) {
    'str' => 'STR',
    'dex' => 'DEX',
    'con' => 'CON',
    'int' => 'INT',
    'wis' => 'WIS',
    'cha' => 'CHA',
    _ => canonicalAbilityId(abilityId).toUpperCase(),
  };
}

String _humanize(String value) {
  final words = value
      .trim()
      .replaceAll(RegExp(r'[_\\-]+'), ' ')
      .split(RegExp(r'\\s+'))
      .where((entry) => entry.isNotEmpty)
      .toList(growable: false);
  if (words.isEmpty) {
    return value.trim();
  }
  return words
      .map(
        (word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');
}

