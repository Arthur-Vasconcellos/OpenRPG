import 'dart:convert';

import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/models/character.dart';

class ResolvedCharacterBuild {
  final List<CharacterClassLevel> classes;
  final Map<String, CharacterResolvedEntity> entityByKey;
  final List<Feature> classFeatures;
  final List<Feature> subclassFeatures;
  final List<Feature> raceTraits;
  final List<Feature> backgroundFeatures;
  final CharacterResolvedEntity? background;
  final String? spellcastingAbility;
  final String? spellcastingClassName;
  final List<SpellSlot> spellSlots;
  final int? preparedSpellCapacity;
  final int? knownSpellCapacity;
  final int? cantripCapacity;
  final int expectedSpeed;
  final List<HitDie> hitDice;
  final SavingThrowProficiencies savingThrowDefaults;
  final List<String> weaponProficiencies;
  final List<String> armorProficiencies;
  final List<String> toolProficiencies;
  final bool barbarianUnarmoredDefense;
  final bool monkUnarmoredDefense;

  const ResolvedCharacterBuild({
    required this.classes,
    required this.entityByKey,
    required this.classFeatures,
    required this.subclassFeatures,
    required this.raceTraits,
    required this.backgroundFeatures,
    required this.background,
    required this.spellcastingAbility,
    required this.spellcastingClassName,
    required this.spellSlots,
    required this.preparedSpellCapacity,
    required this.knownSpellCapacity,
    required this.cantripCapacity,
    required this.expectedSpeed,
    required this.hitDice,
    required this.savingThrowDefaults,
    required this.weaponProficiencies,
    required this.armorProficiencies,
    required this.toolProficiencies,
    required this.barbarianUnarmoredDefense,
    required this.monkUnarmoredDefense,
  });

  const ResolvedCharacterBuild.empty()
    : classes = const [],
      entityByKey = const {},
      classFeatures = const [],
      subclassFeatures = const [],
      raceTraits = const [],
      backgroundFeatures = const [],
      background = null,
      spellcastingAbility = null,
      spellcastingClassName = null,
      spellSlots = const [],
      preparedSpellCapacity = null,
      knownSpellCapacity = null,
      cantripCapacity = null,
      expectedSpeed = 30,
      hitDice = const [],
      savingThrowDefaults = const SavingThrowProficiencies(
        proficientAbilityIds: {},
      ),
      weaponProficiencies = const [],
      armorProficiencies = const [],
      toolProficiencies = const [],
      barbarianUnarmoredDefense = false,
      monkUnarmoredDefense = false;

  List<Feature> get allFeatures => [
    ...classFeatures,
    ...subclassFeatures,
    ...raceTraits,
    ...backgroundFeatures,
  ];

  bool get hasSpellcasting =>
      spellcastingAbility != null || spellSlots.isNotEmpty;
}

class CharacterBuildResolver {
  final CharacterCompendiumService _compendium;

  CharacterBuildResolver({CharacterCompendiumService? compendium})
    : _compendium = compendium ?? CharacterCompendiumService();

  Future<ResolvedCharacterBuild> resolve(Character character) async {
    if (character.primaryRulesetId.trim().isEmpty) {
      return const ResolvedCharacterBuild.empty();
    }

    final entityCache = <String, Future<CharacterResolvedEntity?>>{};
    Future<CharacterResolvedEntity?> loadRef(CharacterEntityRef? ref) {
      if (ref == null || !ref.isResolved) {
        return Future<CharacterResolvedEntity?>.value(null);
      }
      final cacheKey = '${ref.rulesetId}:${ref.entityType}:${ref.entityId}';
      return entityCache.putIfAbsent(
        cacheKey,
        () => _compendium.loadResolvedEntity(ref),
      );
    }

    final resolvedRace = await loadRef(character.raceRef);
    final resolvedBackground = await loadRef(character.backgroundRef);
    final resolvedClasses = <CharacterClassLevel>[];
    final entityByKey = <String, CharacterResolvedEntity>{};
    final classFeatures = <Feature>[];
    final subclassFeatures = <Feature>[];
    final hitDice = <HitDie>[];
    final weaponProficiencies = <String>{};
    final armorProficiencies = <String>{};
    final toolProficiencies = <String>{};

    String? spellcastingAbility;
    String? spellcastingClassName;
    int? preparedSpellCapacity;
    int? knownSpellCapacity;
    int? cantripCapacity;
    final spellSlotBuckets = <int, int>{};
    var expectedSpeed = _extractSpeed(resolvedRace?.detail.entity.data) ?? 30;
    final savingThrowDefaults = _savingThrowsFor(
      await loadRef(
        character.classes.isEmpty ? null : character.classes.first.classRef,
      ),
    );

    var barbarianUnarmoredDefense = false;
    var monkUnarmoredDefense = false;

    for (final entry in character.classes) {
      resolvedClasses.add(entry);
      final resolvedClass = await loadRef(entry.classRef);
      if (resolvedClass != null) {
        entityByKey['class:${entry.level}:${resolvedClass.ref.entityId}'] =
            resolvedClass;
      }
      final resolvedSubclass = await loadRef(entry.subclassRef);
      if (resolvedSubclass != null) {
        entityByKey['subclass:${entry.level}:${resolvedSubclass.ref.entityId}'] =
            resolvedSubclass;
      }

      if (resolvedClass == null) {
        continue;
      }

      final classData = resolvedClass.detail.entity.data;
      final className = resolvedClass.detail.entity.displayName;
      final hitDieFaces = _extractHitDieFaces(classData) ?? 8;
      hitDice.add(HitDie(sides: hitDieFaces, count: entry.level));

      final classArmor = _extractProficiencyStrings(
        classData['startingProficiencies'],
        key: 'armor',
      );
      final classWeapons = _extractProficiencyStrings(
        classData['startingProficiencies'],
        key: 'weapons',
      );
      final classTools = _extractProficiencyStrings(
        classData['startingProficiencies'],
        key: 'tools',
      );
      armorProficiencies.addAll(classArmor);
      weaponProficiencies.addAll(classWeapons);
      toolProficiencies.addAll(classTools);

      final rawClassFeatures = classData['classFeatures'] is List
          ? classData['classFeatures'] as List
          : const [];
      final resolvedClassFeatures = await _resolveFeatureReferences(
        rawClassFeatures,
        source: 'class',
        levelCap: entry.level,
        preferredRulesetId: resolvedClass.ref.rulesetId,
      );
      classFeatures.addAll(resolvedClassFeatures);

      final subclassData = resolvedSubclass?.detail.entity.data;
      if (subclassData != null && subclassData['subclassFeatures'] is List) {
        final resolvedSubclassFeatures = await _resolveFeatureReferences(
          subclassData['subclassFeatures'] as List,
          source: 'subclass',
          levelCap: entry.level,
          preferredRulesetId: resolvedSubclass!.ref.rulesetId,
        );
        subclassFeatures.addAll(resolvedSubclassFeatures);
      }

      final featureNames = {
        for (final feature in resolvedClassFeatures) feature.name.toLowerCase(),
      };
      if (className.toLowerCase() == 'barbarian' &&
          featureNames.contains('unarmored defense')) {
        barbarianUnarmoredDefense = true;
      }
      if (className.toLowerCase() == 'monk' &&
          featureNames.contains('unarmored defense')) {
        monkUnarmoredDefense = true;
      }

      final classSpellcastingAbility = classData['spellcastingAbility']
          ?.toString();
      final classPreparedProgression = _progressionValue(
        classData['preparedSpellsProgression'],
        entry.level,
      );
      final classKnownProgression = _progressionValue(
        classData['spellsKnownProgressionFixedByLevel'],
        entry.level,
      );
      final classCantripProgression = _progressionValue(
        classData['cantripProgression'],
        entry.level,
      );

      if (classSpellcastingAbility != null && spellcastingAbility == null) {
        spellcastingAbility = classSpellcastingAbility;
        spellcastingClassName = className;
        preparedSpellCapacity = classPreparedProgression;
        knownSpellCapacity = classKnownProgression;
        cantripCapacity = classCantripProgression;
      }

      final rawProgression = classData['casterProgression']?.toString();
      if (rawProgression != null) {
        final derivedSlots = _extractSpellSlotsFromClassData(
          classData,
          level: entry.level,
        );
        for (final slot in derivedSlots) {
          spellSlotBuckets.update(
            slot.level,
            (current) => current + slot.total,
            ifAbsent: () => slot.total,
          );
        }
      }
    }

    final raceTraits = _extractInlineFeatures(
      resolvedRace?.detail.entity.data['entries'],
      source: 'race',
      sourceId: resolvedRace?.ref.entityId ?? 'race',
      sourceName:
          resolvedRace?.detail.entity.displayName ??
          character.raceRef?.displayName ??
          'Race',
    );
    final backgroundFeatures = _extractInlineFeatures(
      resolvedBackground?.detail.entity.data['entries'],
      source: 'background',
      sourceId: resolvedBackground?.ref.entityId ?? 'background',
      sourceName:
          resolvedBackground?.detail.entity.displayName ??
          character.backgroundRef?.displayName ??
          'Background',
    );

    return ResolvedCharacterBuild(
      classes: resolvedClasses,
      entityByKey: entityByKey,
      classFeatures: classFeatures,
      subclassFeatures: subclassFeatures,
      raceTraits: raceTraits,
      backgroundFeatures: backgroundFeatures,
      background: resolvedBackground,
      spellcastingAbility: spellcastingAbility,
      spellcastingClassName: spellcastingClassName,
      spellSlots:
          spellSlotBuckets.entries
              .map((entry) => SpellSlot(level: entry.key, total: entry.value))
              .toList(growable: false)
            ..sort((left, right) => left.level.compareTo(right.level)),
      preparedSpellCapacity: preparedSpellCapacity,
      knownSpellCapacity: knownSpellCapacity,
      cantripCapacity: cantripCapacity,
      expectedSpeed: expectedSpeed,
      hitDice: hitDice,
      savingThrowDefaults: savingThrowDefaults,
      weaponProficiencies: weaponProficiencies.toList(growable: false),
      armorProficiencies: armorProficiencies.toList(growable: false),
      toolProficiencies: toolProficiencies.toList(growable: false),
      barbarianUnarmoredDefense: barbarianUnarmoredDefense,
      monkUnarmoredDefense: monkUnarmoredDefense,
    );
  }

  SavingThrowProficiencies _savingThrowsFor(
    CharacterResolvedEntity? resolvedClass,
  ) {
    if (resolvedClass == null) {
      return const SavingThrowProficiencies(proficientAbilityIds: {});
    }

    final values = resolvedClass.detail.entity.data['proficiency'];
    final entries = values is List
        ? values
              .map((entry) => canonicalAbilityId(entry.toString()))
              .where((entry) => entry.isNotEmpty)
              .toSet()
        : <String>{};
    return SavingThrowProficiencies(proficientAbilityIds: entries);
  }

  int? _extractHitDieFaces(Map<String, dynamic> data) {
    final hitDie = data['hd'];
    if (hitDie is Map) {
      final faces = hitDie['faces'];
      if (faces is int) {
        return faces;
      }
      if (faces is num) {
        return faces.toInt();
      }
    }
    return null;
  }

  int? _extractSpeed(Map<String, dynamic>? data) {
    final speed = data?['speed'];
    if (speed is int) {
      return speed;
    }
    if (speed is num) {
      return speed.toInt();
    }
    if (speed is Map) {
      final walk = speed['walk'];
      if (walk is int) {
        return walk;
      }
      if (walk is num) {
        return walk.toInt();
      }
    }
    return null;
  }

  List<String> _extractProficiencyStrings(dynamic raw, {required String key}) {
    if (raw is! Map) {
      return const <String>[];
    }

    final values = raw[key];
    if (values is! List) {
      return const <String>[];
    }

    return values
        .map((entry) {
          if (entry is String) {
            return entry;
          }
          if (entry is Map) {
            return entry.keys.join(', ');
          }
          return '';
        })
        .where((entry) => entry.trim().isNotEmpty)
        .toList(growable: false);
  }

  int? _progressionValue(dynamic raw, int level) {
    if (raw is! List || raw.isEmpty || level <= 0) {
      return null;
    }
    final index = level - 1;
    if (index < 0 || index >= raw.length) {
      return null;
    }
    final value = raw[index];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  List<SpellSlot> _extractSpellSlotsFromClassData(
    Map<String, dynamic> data, {
    required int level,
  }) {
    final tableGroups = data['classTableGroups'];
    if (tableGroups is! List || level <= 0) {
      return const <SpellSlot>[];
    }

    for (final group in tableGroups.whereType<Map>()) {
      if (group['rowsSpellProgression'] is List) {
        final rows = group['rowsSpellProgression'] as List;
        if (level - 1 < 0 || level - 1 >= rows.length) {
          continue;
        }

        final row = rows[level - 1];
        if (row is! List) {
          continue;
        }

        return row
            .asMap()
            .entries
            .where(
              (entry) =>
                  (entry.value as num?) != null && (entry.value as num) > 0,
            )
            .map(
              (entry) => SpellSlot(
                level: entry.key + 1,
                total: (entry.value as num).toInt(),
              ),
            )
            .toList(growable: false);
      }
    }

    final progression = data['casterProgression']?.toString();
    if (progression == 'pact') {
      for (final group in tableGroups.whereType<Map>()) {
        final rows = group['rows'];
        if (rows is! List || level - 1 < 0 || level - 1 >= rows.length) {
          continue;
        }
        final row = rows[level - 1];
        if (row is! List || row.length < 5) {
          continue;
        }

        final slotCount = row[row.length - 2];
        final slotLevel = row[row.length - 1];
        if (slotCount is num &&
            slotLevel is num &&
            slotCount > 0 &&
            slotLevel > 0) {
          return [
            SpellSlot(level: slotLevel.toInt(), total: slotCount.toInt()),
          ];
        }
      }
    }

    return const <SpellSlot>[];
  }

  Future<List<Feature>> _resolveFeatureReferences(
    List<dynamic> values, {
    required String source,
    required int levelCap,
    required String preferredRulesetId,
  }) async {
    final candidates = <Future<Feature?>>[];
    for (final value in values) {
      if (value is Map &&
          value['gainSubclassFeature'] == true &&
          value.containsKey('classFeature')) {
        continue;
      }

      final candidate = value is String
          ? CompendiumLinkParser.tryParsePlainReference(
              value,
              hintedFieldKey: 'classFeatures',
            )
          : value is Map
          ? CompendiumLinkParser.extractReferenceFromMap(
              value.cast<String, dynamic>(),
            )
          : null;
      if (candidate == null) {
        continue;
      }

      final referenceLevel = _referenceLevel(candidate.parts);
      if (referenceLevel != null && referenceLevel > levelCap) {
        continue;
      }

      candidates.add(
        _compendium
            .resolveCandidate(candidate, preferredRulesetId: preferredRulesetId)
            .then((resolved) {
              if (resolved == null) {
                return null;
              }
              return Feature(
                id: resolved.entityId,
                name: resolved.displayName,
                description: '',
                levelObtained: referenceLevel ?? levelCap,
                source: source,
                reference: resolved,
              );
            }),
      );
    }

    final resolved = await Future.wait(candidates);
    return resolved.whereType<Feature>().toList(growable: false);
  }

  int? _referenceLevel(List<String> parts) {
    for (final value in parts.reversed) {
      final parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    return null;
  }

  List<Feature> _extractInlineFeatures(
    dynamic rawEntries, {
    required String source,
    required String sourceId,
    required String sourceName,
  }) {
    if (rawEntries is! List) {
      return const <Feature>[];
    }

    final results = <Feature>[];
    for (var index = 0; index < rawEntries.length; index++) {
      final entry = rawEntries[index];
      if (entry is Map) {
        final map = entry.cast<String, dynamic>();
        final name = map['name']?.toString().trim();
        if (name == null || name.isEmpty) {
          continue;
        }
        results.add(
          Feature(
            id: '$sourceId:$source:$index',
            name: name,
            description: _plainTextFromContent(map['entries'] ?? map['entry']),
            levelObtained: 1,
            source: source,
            content: map['entries'] ?? map['entry'],
          ),
        );
      }
    }

    if (results.isEmpty && rawEntries.isNotEmpty) {
      results.add(
        Feature(
          id: '$sourceId:$source:0',
          name: sourceName,
          description: _plainTextFromContent(rawEntries),
          levelObtained: 1,
          source: source,
          content: rawEntries,
        ),
      );
    }

    return results;
  }

  String _plainTextFromContent(dynamic content) {
    if (content == null) {
      return '';
    }
    if (content is String) {
      return CompendiumLinkParser.renderInlineLabel(content);
    }
    if (content is List) {
      return content
          .map(_plainTextFromContent)
          .where((entry) => entry.trim().isNotEmpty)
          .join('\n\n');
    }
    if (content is Map) {
      final map = content.cast<String, dynamic>();
      final pieces = <String>[];
      final name = map['name']?.toString();
      if (name != null && name.trim().isNotEmpty) {
        pieces.add(name.trim());
      }
      if (map['entry'] != null) {
        pieces.add(_plainTextFromContent(map['entry']));
      }
      if (map['entries'] != null) {
        pieces.add(_plainTextFromContent(map['entries']));
      }
      if (map['items'] != null) {
        pieces.add(_plainTextFromContent(map['items']));
      }
      return pieces.where((entry) => entry.trim().isNotEmpty).join('\n\n');
    }
    return jsonEncode(content);
  }
}
