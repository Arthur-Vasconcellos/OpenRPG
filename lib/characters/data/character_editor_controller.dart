import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:openrpg/characters/data/character_build_resolver.dart';
import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/characters/data/character_portability.dart';
import 'package:openrpg/characters/data/character_repository.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/characters/creation/ability_score_generation.dart';

class CharacterEditorController extends ChangeNotifier {
  final String characterId;
  final CharacterRepository _repository;
  final CharacterCompendiumService _compendium;
  final CharacterBuildResolver _resolver;
  final CharacterSheetSchemaResolver _sheetSchemaResolver;

  Character? _character;
  ResolvedCharacterBuild _resolvedBuild = const ResolvedCharacterBuild.empty();
  CharacterSheetSchema _sheetSchema = CharacterSheetSchema.empty;
  List<RulesetSummary> _installedRulesets = const [];
  Map<String, dynamic> _primaryRulesetExtraData = const <String, dynamic>{};

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isResolving = false;
  String? _loadError;
  String? _saveError;
  DateTime? _lastSavedAt;

  Timer? _saveDebounce;
  int _refreshRevision = 0;
  bool _disposed = false;

  CharacterEditorController({
    required this.characterId,
    CharacterRepository? repository,
    CharacterCompendiumService? compendium,
    CharacterBuildResolver? resolver,
    CharacterSheetSchemaResolver? sheetSchemaResolver,
  }) : _repository = repository ?? CharacterRepository(),
       _compendium = compendium ?? CharacterCompendiumService(),
       _resolver =
           resolver ??
           CharacterBuildResolver(
             compendium: compendium ?? CharacterCompendiumService(),
           ),
       _sheetSchemaResolver =
           sheetSchemaResolver ??
           CharacterSheetSchemaResolver(
             compendium: compendium ?? CharacterCompendiumService(),
           );

  CharacterRepository get repository => _repository;
  CharacterCompendiumService get compendium => _compendium;
  CharacterBuildResolver get resolver => _resolver;
  CharacterSheetSchema get sheetSchema => _sheetSchema;

  Character? get character => _character;
  ResolvedCharacterBuild get resolvedBuild => _resolvedBuild;
  List<RulesetSummary> get installedRulesets => _installedRulesets;
  Map<String, dynamic> get primaryRulesetExtraData => _primaryRulesetExtraData;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isResolving => _isResolving;
  bool get isReady => !_isLoading && _character != null && _loadError == null;
  String? get loadError => _loadError;
  String? get saveError => _saveError;
  DateTime? get lastSavedAt => _lastSavedAt;
  int get unresolvedSelectionCount {
    final current = _character;
    if (current == null) {
      return 0;
    }

    var count = 0;
    if (current.primaryRulesetId.trim().isNotEmpty &&
        !_installedRulesets.any(
          (ruleset) => ruleset.id == current.primaryRulesetId,
        )) {
      count++;
    }
    if (current.raceRef != null && !current.raceRef!.isResolved) {
      count++;
    }
    if (current.backgroundRef != null && !current.backgroundRef!.isResolved) {
      count++;
    }
    for (final entry in current.classes) {
      if (entry.classRef != null && !entry.classRef!.isResolved) {
        count++;
      }
      if (entry.subclassRef != null && !entry.subclassRef!.isResolved) {
        count++;
      }
    }
    final spellcasting = current.spellcasting;
    if (spellcasting != null) {
      for (final spell in spellcasting.allSpells) {
        final reference = spell.reference;
        if (reference != null && !reference.isResolved) {
          count++;
        }
      }
    }
    for (final entry in current.equipment.entries) {
      final reference = entry.reference;
      if (reference != null && !reference.isResolved) {
        count++;
      }
    }
    final deityRef = current.physicalDescription.deityRef;
    if (deityRef != null && !deityRef.isResolved) {
      count++;
    }
    return count;
  }

  Future<void> initialize() async {
    _isLoading = true;
    _loadError = null;
    _saveError = null;
    _notifySafely();

    try {
      _installedRulesets = await _repository.loadInstalledRulesets();
      final loaded = await _repository.loadCharacter(characterId);
      await _repository.markOpened(characterId);
      _primaryRulesetExtraData = await _loadRulesetExtraData(
        loaded.primaryRulesetId,
      );
      _sheetSchema = await _sheetSchemaResolver.load(loaded.primaryRulesetId);
      final canonical = await _compendium.canonicalizeSelections(
        _applySheetSchema(loaded),
      );
      _character = _applySheetSchema(canonical);
      await _refreshResolvedBuild(
        sourceCharacter: _character!,
        persistImmediately: true,
      );
      _isLoading = false;
      _notifySafely();
    } catch (error) {
      _isLoading = false;
      _loadError = error.toString();
      _notifySafely();
    }
  }

  Future<void> reload() async {
    await initialize();
  }

  Future<void> updateManual(
    Character Function(Character current) transform,
  ) async {
    final current = _character;
    if (current == null) {
      return;
    }

    _character = _applySheetSchema(transform(current));
    _saveError = null;
    _notifySafely();
    _scheduleSave();
  }

  Future<void> updateBuild(
    Character Function(Character current) transform,
  ) async {
    final current = _character;
    if (current == null) {
      return;
    }

    final updated = _applySheetSchema(transform(current));
    _character = updated;
    _saveError = null;
    _notifySafely();
    await _refreshResolvedBuild(
      sourceCharacter: updated,
      persistImmediately: true,
    );
  }

  Future<void> setName(String value) {
    return updateManual((current) => current.copyWith(name: value));
  }

  Future<void> setAlignment(String value) {
    return updateManual((current) => current.copyWith(alignment: value.trim()));
  }

  Future<void> setPlayerName(String value) {
    return updateManual(
      (current) => current.copyWith(playerName: value.trim()),
    );
  }

  Future<void> setCreationExtraValue(String key, Object? value) {
    return updateManual((current) {
      final extraData = Map<String, dynamic>.from(current.extraData);
      final rawCreation = extraData['creation'];
      final creation = rawCreation is Map
          ? Map<String, dynamic>.from(rawCreation.cast<String, dynamic>())
          : <String, dynamic>{};
      if (value == null) {
        creation.remove(key);
      } else {
        creation[key] = value;
      }
      extraData['creation'] = creation;
      return current.copyWith(extraData: extraData);
    });
  }

  Future<void> setCreationExtraData(Map<String, dynamic> values) {
    return updateManual((current) {
      final extraData = Map<String, dynamic>.from(current.extraData);
      final rawCreation = extraData['creation'];
      final creation = rawCreation is Map
          ? Map<String, dynamic>.from(rawCreation.cast<String, dynamic>())
          : <String, dynamic>{};
      creation.addAll(values);
      extraData['creation'] = creation;
      return current.copyWith(extraData: extraData);
    });
  }

  Future<void> markCreationComplete({required String mode}) {
    return setCreationExtraData({
      'mode': mode,
      'completedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> setStoryFields({
    String? personalityTraits,
    String? ideals,
    String? bonds,
    String? flaws,
    String? backstory,
    String? appearance,
    String? otherNotes,
    String? height,
    String? eyes,
    String? hair,
  }) {
    return updateManual((current) {
      return current.copyWith(
        traits: Traits(
          personalityTraits:
              personalityTraits ?? current.traits.personalityTraits,
          ideals: ideals ?? current.traits.ideals,
          bonds: bonds ?? current.traits.bonds,
          flaws: flaws ?? current.traits.flaws,
          alliesAndOrganizations: current.traits.alliesAndOrganizations,
        ),
        notes: Notes(
          backstory: backstory ?? current.notes.backstory,
          appearance: appearance ?? current.notes.appearance,
          inventoryNotes: current.notes.inventoryNotes,
          languagesNotes: current.notes.languagesNotes,
          otherNotes: otherNotes ?? current.notes.otherNotes,
        ),
        physicalDescription: PhysicalDescription(
          age: current.physicalDescription.age,
          height: height ?? current.physicalDescription.height,
          weight: current.physicalDescription.weight,
          eyes: eyes ?? current.physicalDescription.eyes,
          skin: current.physicalDescription.skin,
          hair: hair ?? current.physicalDescription.hair,
          deity: current.physicalDescription.deity,
          deityRef: current.physicalDescription.deityRef,
        ),
      );
    });
  }

  Future<void> setAbilityScore(String abilityId, int value) {
    return updateManual((current) {
      return current.copyWith(
        abilityScores: current.abilityScores.copyWithValue(
          abilityId,
          value.clamp(1, 30),
        ),
      );
    });
  }

  Future<void> setCreationAbilityScores(
    CharacterCreationAbilityScores abilityScores,
  ) {
    return updateManual(
      (current) => applyCreationAbilityScoresToCharacter(
        current,
        abilityScores,
        backgroundAbilityOptions:
            backgroundAbilityBonusOptionsForResolvedEntity(
              _resolvedBuild.background,
            ),
      ),
    );
  }

  Future<void> cycleSkillTraining(String skillId) {
    return updateManual((current) {
      final currentLevel = current.proficiencies.skills.proficiencyFor(skillId);
      final nextLevel = switch (currentLevel) {
        SkillTrainingLevel.none => SkillTrainingLevel.proficient,
        SkillTrainingLevel.proficient => SkillTrainingLevel.expertise,
        SkillTrainingLevel.expertise => SkillTrainingLevel.none,
        SkillTrainingLevel.half => SkillTrainingLevel.none,
        _ => SkillTrainingLevel.none,
      };
      final updated = Map<String, String>.from(
        current.proficiencies.skills.proficiencies,
      );
      updated[_normalizedSkillId(skillId)] = nextLevel;
      return current.copyWith(
        proficiencies: current.proficiencies.copyWith(
          skills: current.proficiencies.skills.copyWith(proficiencies: updated),
        ),
      );
    });
  }

  Future<void> toggleSavingThrow(String abilityId) {
    return updateManual((current) {
      final updated = Set<String>.from(
        current.proficiencies.savingThrows.proficientAbilityIds,
      );
      final normalizedAbilityId = canonicalAbilityId(abilityId);
      if (updated.contains(normalizedAbilityId)) {
        updated.remove(normalizedAbilityId);
      } else {
        updated.add(normalizedAbilityId);
      }
      return current.copyWith(
        proficiencies: current.proficiencies.copyWith(
          savingThrows: current.proficiencies.savingThrows.copyWith(
            proficientAbilityIds: updated,
          ),
        ),
      );
    });
  }

  int abilityScoreFor(String abilityId) {
    return _character?.abilityScores.scoreFor(abilityId) ?? 10;
  }

  int abilityModifierFor(String abilityId) {
    return _character?.modifiers.modifierFor(abilityId) ?? 0;
  }

  int skillModifierFor(CharacterSkillDescriptor skill) {
    final current = _character;
    if (current == null) {
      return 0;
    }
    return current.proficiencies.skills.getModifier(
      skill.id,
      abilityId: skill.abilityId,
      modifiers: current.modifiers,
      proficiencyBonus: current.proficiencies.proficiencyBonus,
    );
  }

  int passiveSkillScoreFor(CharacterSkillDescriptor skill) {
    return 10 + skillModifierFor(skill);
  }

  Future<void> setRace(CharacterEntityRef? ref) {
    return updateBuild(
      (current) => current.copyWith(raceRef: ref, clearRaceRef: ref == null),
    );
  }

  Future<void> setBackground(CharacterEntityRef? ref) {
    return updateBuild(
      (current) =>
          current.copyWith(backgroundRef: ref, clearBackgroundRef: ref == null),
    );
  }

  Future<void> addClassEntry() {
    return updateBuild((current) {
      final classes = List<CharacterClassLevel>.from(current.classes)
        ..add(CharacterClassLevel(level: 1));
      return current.copyWith(classes: classes);
    });
  }

  Future<void> removeClassEntry(int index) {
    return updateBuild((current) {
      final classes = List<CharacterClassLevel>.from(current.classes);
      if (index < 0 || index >= classes.length) {
        return current;
      }
      classes.removeAt(index);
      return current.copyWith(classes: classes);
    });
  }

  Future<void> setClassEntry(
    int index, {
    CharacterEntityRef? classRef,
    CharacterEntityRef? subclassRef,
    int? level,
    bool clearSubclass = false,
  }) {
    return updateBuild((current) {
      final classes = List<CharacterClassLevel>.from(current.classes);
      if (index < 0 || index >= classes.length) {
        return current;
      }

      classes[index] = classes[index].copyWith(
        classRef: classRef,
        subclassRef: clearSubclass ? null : subclassRef,
        clearSubclassRef: clearSubclass,
        level: level,
      );
      return current.copyWith(classes: classes);
    });
  }

  Future<void> addSpellSelection(
    CharacterEntityRef ref, {
    required bool prepared,
  }) async {
    final current = _character;
    if (current == null) {
      return;
    }

    final resolved = await _compendium.loadResolvedEntity(ref);
    final detail = resolved?.detail.entity.data ?? const <String, dynamic>{};
    final spell = Spell(
      id: ref.entityId,
      name: ref.displayName,
      level: (detail['level'] as num?)?.toInt() ?? 0,
      school: detail['school']?.toString() ?? '',
      isPrepared: prepared,
      isRitual:
          detail['meta'] is Map && ((detail['meta'] as Map)['ritual'] == true),
      isConcentration: _spellHasConcentration(detail['duration']),
      reference: ref,
    );

    await updateManual((character) {
      final currentSpellcasting =
          character.spellcasting ??
          const SpellcastingInfo(spellSaveDC: 8, spellAttackBonus: 0);
      final preparedSpells = List<Spell>.from(
        currentSpellcasting.preparedSpells,
      );
      final knownSpells = List<Spell>.from(currentSpellcasting.knownSpells);

      void upsert(List<Spell> target) {
        final existingIndex = target.indexWhere(
          (entry) => entry.id == spell.id,
        );
        if (existingIndex >= 0) {
          target[existingIndex] = spell;
        } else {
          target.add(spell);
        }
        target.sort((left, right) {
          final levelOrder = left.level.compareTo(right.level);
          if (levelOrder != 0) {
            return levelOrder;
          }
          return left.name.compareTo(right.name);
        });
      }

      if (prepared) {
        upsert(preparedSpells);
      } else {
        upsert(knownSpells);
      }

      return character.copyWith(
        spellcasting: currentSpellcasting.copyWith(
          preparedSpells: preparedSpells,
          knownSpells: knownSpells,
        ),
      );
    });
  }

  Future<void> addInventoryItem(CharacterEntityRef ref) async {
    final current = _character;
    if (current == null) {
      return;
    }

    final resolved = await _compendium.loadResolvedEntity(ref);
    final detail = resolved?.detail.entity.data ?? const <String, dynamic>{};
    final item = _buildInventoryEntryFromDetail(ref, detail);

    await updateManual((character) {
      final entries = List<CharacterInventoryEntry>.from(
        character.equipment.entries,
      );
      final existingIndex = entries.indexWhere(
        (entry) =>
            entry.reference?.rulesetId == ref.rulesetId &&
            entry.reference?.entityType == ref.entityType &&
            entry.reference?.entityId == ref.entityId,
      );
      if (existingIndex >= 0) {
        final existing = entries[existingIndex];
        entries[existingIndex] = existing.copyWith(
          quantity: existing.quantity + 1,
        );
      } else {
        entries.add(item);
      }
      entries.sort(
        (left, right) => left.displayName.compareTo(right.displayName),
      );
      var loadout = character.equipment.loadout;
      if (existingIndex < 0) {
        if (item.kind == CharacterInventoryKind.armor &&
            loadout.armorEntryId == null) {
          loadout = loadout.copyWith(armorEntryId: item.id);
        } else if (item.kind == CharacterInventoryKind.weapon &&
            loadout.meleeEntryId == null) {
          loadout = loadout.copyWith(meleeEntryId: item.id);
        }
      }
      return character.copyWith(
        equipment: character.equipment.copyWith(
          entries: entries,
          loadout: loadout,
        ),
      );
    });
  }

  Future<void> toggleInventoryItem(String itemId, bool isEquipped) {
    return updateManual((character) {
      var loadout = character.equipment.loadout;
      final entries = character.equipment.entries
          .map(
            (item) =>
                item.id == itemId ? item.copyWith(equipped: isEquipped) : item,
          )
          .toList(growable: false)
          .cast<CharacterInventoryEntry>();
      if (!isEquipped) {
        if (loadout.armorEntryId == itemId) {
          loadout = loadout.copyWith(clearArmorEntry: true);
        }
        if (loadout.meleeEntryId == itemId) {
          loadout = loadout.copyWith(clearMeleeEntry: true);
        }
        if (loadout.rangedEntryId == itemId) {
          loadout = loadout.copyWith(clearRangedEntry: true);
        }
      }
      return character.copyWith(
        equipment: character.equipment.copyWith(
          entries: entries,
          loadout: loadout,
        ),
      );
    });
  }

  Future<void> removeInventoryItem(String itemId) {
    return updateManual((character) {
      var loadout = character.equipment.loadout;
      final entries = character.equipment.entries
          .where((item) => item.id != itemId)
          .toList(growable: false);
      if (loadout.armorEntryId == itemId) {
        loadout = loadout.copyWith(clearArmorEntry: true);
      }
      if (loadout.meleeEntryId == itemId) {
        loadout = loadout.copyWith(clearMeleeEntry: true);
      }
      if (loadout.rangedEntryId == itemId) {
        loadout = loadout.copyWith(clearRangedEntry: true);
      }
      return character.copyWith(
        equipment: character.equipment.copyWith(
          entries: entries,
          loadout: loadout,
        ),
      );
    });
  }

  Future<void> updateInventoryEntryQuantity(String itemId, int quantity) {
    return updateManual((character) {
      final entries = character.equipment.entries
          .map(
            (item) => item.id == itemId
                ? item.copyWith(quantity: quantity.clamp(1, 999))
                : item,
          )
          .toList(growable: false);
      return character.copyWith(
        equipment: character.equipment.copyWith(entries: entries),
      );
    });
  }

  Future<void> setInventoryEntryAttuned(String itemId, bool attuned) {
    return updateManual((character) {
      final entries = character.equipment.entries
          .map(
            (item) =>
                item.id == itemId ? item.copyWith(attuned: attuned) : item,
          )
          .toList(growable: false);
      return character.copyWith(
        equipment: character.equipment.copyWith(entries: entries),
      );
    });
  }

  Future<void> setInventoryEntryNotes(String itemId, String notes) {
    return updateManual((character) {
      final entries = character.equipment.entries
          .map((item) => item.id == itemId ? item.copyWith(notes: notes) : item)
          .toList(growable: false);
      return character.copyWith(
        equipment: character.equipment.copyWith(entries: entries),
      );
    });
  }

  Future<void> setEquipmentLoadout({
    String? armorEntryId,
    bool clearArmor = false,
    String? meleeEntryId,
    bool clearMelee = false,
    String? rangedEntryId,
    bool clearRanged = false,
  }) {
    return updateManual((character) {
      var entries = List<CharacterInventoryEntry>.from(
        character.equipment.entries,
      );
      var loadout = character.equipment.loadout.copyWith(
        armorEntryId: armorEntryId,
        clearArmorEntry: clearArmor,
        meleeEntryId: meleeEntryId,
        clearMeleeEntry: clearMelee,
        rangedEntryId: rangedEntryId,
        clearRangedEntry: clearRanged,
      );

      entries = entries
          .map((entry) {
            final shouldEquip =
                entry.id == loadout.armorEntryId ||
                entry.id == loadout.meleeEntryId ||
                entry.id == loadout.rangedEntryId ||
                entry.equipped;
            return entry.copyWith(equipped: shouldEquip);
          })
          .toList(growable: false);

      return character.copyWith(
        equipment: character.equipment.copyWith(
          entries: entries,
          loadout: loadout,
        ),
      );
    });
  }

  Future<void> removeSpell(String spellId, {required bool prepared}) {
    return updateManual((character) {
      final spellcasting = character.spellcasting;
      if (spellcasting == null) {
        return character;
      }

      final updated = prepared
          ? spellcasting.copyWith(
              preparedSpells: spellcasting.preparedSpells
                  .where((spell) => spell.id != spellId)
                  .toList(growable: false),
            )
          : spellcasting.copyWith(
              knownSpells: spellcasting.knownSpells
                  .where((spell) => spell.id != spellId)
                  .toList(growable: false),
            );
      return character.copyWith(spellcasting: updated);
    });
  }

  Future<void> togglePreparedSpell(Spell spell, bool prepared) {
    return updateManual((character) {
      final spellcasting =
          character.spellcasting ??
          const SpellcastingInfo(spellSaveDC: 8, spellAttackBonus: 0);
      final preparedSpells = List<Spell>.from(spellcasting.preparedSpells);
      final knownSpells = List<Spell>.from(spellcasting.knownSpells);

      if (prepared) {
        if (!preparedSpells.any((entry) => entry.id == spell.id)) {
          preparedSpells.add(spell.copyWith(isPrepared: true));
        }
      } else {
        preparedSpells.removeWhere((entry) => entry.id == spell.id);
      }

      if (!knownSpells.any((entry) => entry.id == spell.id)) {
        knownSpells.add(spell.copyWith(isPrepared: false));
      }

      return character.copyWith(
        spellcasting: spellcasting.copyWith(
          preparedSpells: preparedSpells,
          knownSpells: knownSpells,
        ),
      );
    });
  }

  Future<void> changePrimaryRuleset(String newRulesetId) async {
    final current = _character;
    if (current == null || newRulesetId.trim().isEmpty) {
      return;
    }

    final oldRulesetId = current.primaryRulesetId;
    if (oldRulesetId == newRulesetId) {
      return;
    }

    Future<CharacterEntityRef?> resolveRefForRulesetChange(
      CharacterEntityRef? ref,
    ) async {
      if (ref == null) {
        return null;
      }
      if (ref.rulesetId.trim().isNotEmpty && ref.rulesetId != oldRulesetId) {
        return ref;
      }
      if (!ref.isResolved) {
        return null;
      }
      return _compendium.resolveEntityById(
        rulesetId: newRulesetId,
        entityType: ref.entityType,
        entityId: ref.entityId,
      );
    }

    Future<Spell?> resolveSpellForRulesetChange(Spell spell) async {
      final ref = spell.reference;
      if (ref == null) {
        return spell;
      }
      if (ref.rulesetId.trim().isNotEmpty && ref.rulesetId != oldRulesetId) {
        return spell;
      }
      if (!ref.isResolved) {
        return null;
      }
      final resolved = await _compendium.resolveEntityById(
        rulesetId: newRulesetId,
        entityType: ref.entityType,
        entityId: ref.entityId,
      );
      if (resolved == null) {
        return null;
      }
      return spell.copyWith(
        reference: resolved,
        id: resolved.entityId,
        name: resolved.displayName,
      );
    }

    final retainedRace = await resolveRefForRulesetChange(current.raceRef);
    final retainedBackground = await resolveRefForRulesetChange(
      current.backgroundRef,
    );

    final retainedClasses = <CharacterClassLevel>[];
    for (final entry in current.classes) {
      final retainedClass = await resolveRefForRulesetChange(entry.classRef);
      if (retainedClass == null) {
        continue;
      }
      final retainedSubclass = await resolveRefForRulesetChange(
        entry.subclassRef,
      );
      retainedClasses.add(
        entry.copyWith(
          classRef: retainedClass,
          subclassRef: retainedSubclass,
          clearSubclassRef: retainedSubclass == null,
        ),
      );
    }

    final currentSpellcasting = current.spellcasting;
    final retainedPrepared = currentSpellcasting == null
        ? const <Spell>[]
        : (await Future.wait(
            currentSpellcasting.preparedSpells.map(
              resolveSpellForRulesetChange,
            ),
          )).whereType<Spell>().toList(growable: false);
    final retainedKnown = currentSpellcasting == null
        ? const <Spell>[]
        : (await Future.wait(
            currentSpellcasting.knownSpells.map(resolveSpellForRulesetChange),
          )).whereType<Spell>().toList(growable: false);

    final retainedSpellcasting = currentSpellcasting?.copyWith(
      preparedSpells: retainedPrepared,
      knownSpells: retainedKnown,
    );

    final retainedEntries = <CharacterInventoryEntry>[];
    for (final entry in current.equipment.entries) {
      final reference = entry.reference;
      if (reference == null) {
        retainedEntries.add(entry);
        continue;
      }
      if (reference.rulesetId.trim().isNotEmpty &&
          reference.rulesetId != oldRulesetId) {
        retainedEntries.add(entry);
        continue;
      }
      if (!reference.isResolved) {
        continue;
      }
      final retainedReference = await _compendium.resolveEntityById(
        rulesetId: newRulesetId,
        entityType: reference.entityType,
        entityId: reference.entityId,
      );
      if (retainedReference == null) {
        continue;
      }
      retainedEntries.add(
        entry.copyWith(
          reference: retainedReference,
          name: retainedReference.displayName,
        ),
      );
    }

    final remainingEquipmentIds = retainedEntries
        .map((entry) => entry.id)
        .toSet();
    final retainedLoadout = current.equipment.loadout.copyWith(
      clearArmorEntry:
          current.equipment.loadout.armorEntryId != null &&
          !remainingEquipmentIds.contains(
            current.equipment.loadout.armorEntryId,
          ),
      clearMeleeEntry:
          current.equipment.loadout.meleeEntryId != null &&
          !remainingEquipmentIds.contains(
            current.equipment.loadout.meleeEntryId,
          ),
      clearRangedEntry:
          current.equipment.loadout.rangedEntryId != null &&
          !remainingEquipmentIds.contains(
            current.equipment.loadout.rangedEntryId,
          ),
    );

    CharacterEntityRef? retainedDeity;
    final currentDeityRef = current.physicalDescription.deityRef;
    if (currentDeityRef != null) {
      retainedDeity = await resolveRefForRulesetChange(currentDeityRef);
    }

    _primaryRulesetExtraData = await _loadRulesetExtraData(newRulesetId);
    _sheetSchema = await _sheetSchemaResolver.load(newRulesetId);
    final updated = current.copyWith(
      primaryRulesetId: newRulesetId,
      raceRef: retainedRace,
      clearRaceRef: retainedRace == null,
      backgroundRef: retainedBackground,
      clearBackgroundRef: retainedBackground == null,
      classes: retainedClasses,
      spellcasting: retainedSpellcasting,
      clearSpellcasting:
          retainedSpellcasting == null && current.spellcasting != null,
      equipment: current.equipment.copyWith(
        entries: retainedEntries,
        loadout: retainedLoadout,
      ),
      physicalDescription: current.physicalDescription.copyWith(
        deity:
            retainedDeity?.displayName ??
            (current.physicalDescription.deityRef == null
                ? current.physicalDescription.deity
                : ''),
        deityRef: retainedDeity,
        clearDeityRef:
            retainedDeity == null &&
            current.physicalDescription.deityRef != null,
      ),
      features: const <Feature>[],
      racialTraits: const <Feature>[],
      backgroundTraits: const <Feature>[],
    );

    await updateBuild((_) => _applySheetSchema(updated));
  }

  Future<Map<String, dynamic>> _loadRulesetExtraData(String rulesetId) async {
    if (rulesetId.trim().isEmpty) {
      return const <String, dynamic>{};
    }
    try {
      return await _compendium.browseRepository.loadRulesetExtraData(rulesetId);
    } catch (_) {
      return const <String, dynamic>{};
    }
  }

  Future<CharacterExportResult> exportCharacter() {
    return _repository.exportCharacterFile(characterId);
  }

  Future<void> flushPendingSave() async {
    _saveDebounce?.cancel();
    final current = _character;
    if (current == null) {
      return;
    }
    await _saveNow(current);
  }

  @override
  void dispose() {
    _disposed = true;
    _saveDebounce?.cancel();
    super.dispose();
  }

  Future<void> _refreshResolvedBuild({
    required Character sourceCharacter,
    required bool persistImmediately,
  }) async {
    final revision = ++_refreshRevision;
    _isResolving = true;
    _notifySafely();

    try {
      final resolved = await _resolver.resolve(sourceCharacter);
      if (_disposed || revision != _refreshRevision) {
        return;
      }

      final merged = _applySheetSchema(
        _applyResolvedBuild(sourceCharacter, resolved),
      );
      _resolvedBuild = resolved;
      _character = merged;
      _isResolving = false;
      _notifySafely();

      if (persistImmediately) {
        await _saveNow(merged);
      } else {
        _scheduleSave();
      }
    } catch (error) {
      if (_disposed || revision != _refreshRevision) {
        return;
      }
      _isResolving = false;
      _saveError = error.toString();
      _notifySafely();
    }
  }

  Character _applyResolvedBuild(
    Character character,
    ResolvedCharacterBuild resolved,
  ) {
    final existingSpellcasting = character.spellcasting;
    final hasSelectedSpells =
        (existingSpellcasting?.preparedSpells.isNotEmpty ?? false) ||
        (existingSpellcasting?.knownSpells.isNotEmpty ?? false);

    SpellcastingInfo? updatedSpellcasting;
    if (resolved.hasSpellcasting || hasSelectedSpells) {
      updatedSpellcasting =
          existingSpellcasting ??
          const SpellcastingInfo(spellSaveDC: 8, spellAttackBonus: 0);
      final usedSlots = {
        for (final slot in updatedSpellcasting.spellSlots)
          slot.level: slot.used,
      };
      updatedSpellcasting = updatedSpellcasting.copyWith(
        spellcastingAbility: resolved.spellcastingAbility,
        spellSlots: resolved.spellSlots
            .map(
              (slot) => SpellSlot(
                level: slot.level,
                total: slot.total,
                used: usedSlots[slot.level] ?? 0,
              ),
            )
            .toList(growable: false),
        preparedSpells: existingSpellcasting?.preparedSpells ?? const <Spell>[],
        knownSpells: existingSpellcasting?.knownSpells ?? const <Spell>[],
      );
    }

    return character.copyWith(
      proficiencies: character.proficiencies.copyWith(
        savingThrows: resolved.savingThrowDefaults,
        weapons: resolved.weaponProficiencies,
        armor: resolved.armorProficiencies,
        tools: resolved.toolProficiencies,
      ),
      health: character.health.copyWith(hitDice: resolved.hitDice),
      spellcasting: updatedSpellcasting,
      clearSpellcasting:
          updatedSpellcasting == null && character.spellcasting != null,
    );
  }

  Character _applySheetSchema(Character character) {
    return character.ensureSheetFields(
      abilityIds: _sheetSchema.abilities.map((entry) => entry.id),
      skillIds: _sheetSchema.skills.map((entry) => entry.id),
    );
  }

  CharacterInventoryEntry _buildInventoryEntryFromDetail(
    CharacterEntityRef ref,
    Map<String, dynamic> detail,
  ) {
    final typeCode = detail['type']?.toString().split('|').first.toUpperCase();
    final propertyCodes = (detail['property'] as List<dynamic>? ?? const [])
        .map((entry) => entry.toString().split('|').first.toUpperCase())
        .toSet();
    final enhancementBonus = _parseBonus(
      detail['bonusWeapon']?.toString() ?? detail['bonusAc']?.toString() ?? '',
    );

    if (detail.containsKey('dmg1') || detail.containsKey('weaponCategory')) {
      final isRanged =
          typeCode == 'R' ||
          (detail['range']?.toString().contains('/') ?? false);
      final attackAbility = isRanged || propertyCodes.contains('F')
          ? 'dex'
          : 'str';
      return CharacterInventoryEntry(
        id: 'inventory-entry:${ref.rulesetId}:${ref.entityType}:${ref.entityId}',
        reference: ref,
        name: ref.displayName,
        description: _extractEquipmentDescription(detail),
        weight: (detail['weight'] as num?)?.toDouble() ?? 0,
        kind: CharacterInventoryKind.weapon,
        overrides: CharacterInventoryEntryOverrides(
          damageDice: detail['dmg1']?.toString(),
          damageType: _normalizeDamageType(detail['dmgType']?.toString()),
          attackAbility: attackAbility,
          enhancementBonus: enhancementBonus == 0 ? null : enhancementBonus,
          finesse: propertyCodes.contains('F'),
          weaponCategory: detail['weaponCategory']?.toString() ?? 'simple',
        ),
      );
    }

    if (detail.containsKey('ac') ||
        {'LA', 'MA', 'HA', 'S'}.contains(typeCode)) {
      final armorCategory = switch (typeCode) {
        'LA' => 'light',
        'MA' => 'medium',
        'HA' => 'heavy',
        'S' => 'shield',
        _ => 'light',
      };
      return CharacterInventoryEntry(
        id: 'inventory-entry:${ref.rulesetId}:${ref.entityType}:${ref.entityId}',
        reference: ref,
        name: ref.displayName,
        description: _extractEquipmentDescription(detail),
        weight: (detail['weight'] as num?)?.toDouble() ?? 0,
        kind: CharacterInventoryKind.armor,
        overrides: CharacterInventoryEntryOverrides(
          armorClass: (detail['ac'] as num?)?.toInt(),
          armorCategory: armorCategory,
          usesDexterity: armorCategory != 'heavy' && armorCategory != 'shield',
          maxDexterityBonus: armorCategory == 'medium'
              ? 2
              : armorCategory == 'heavy' || armorCategory == 'shield'
              ? 0
              : 999,
        ),
      );
    }

    return CharacterInventoryEntry(
      id: 'inventory-entry:${ref.rulesetId}:${ref.entityType}:${ref.entityId}',
      reference: ref,
      name: ref.displayName,
      description: _extractEquipmentDescription(detail),
      weight: (detail['weight'] as num?)?.toDouble() ?? 0,
    );
  }

  String _extractEquipmentDescription(Map<String, dynamic> detail) {
    final entries = detail['entries'];
    if (entries is List && entries.isNotEmpty) {
      final first = entries.first;
      if (first is String) {
        return first;
      }
      if (first is Map<String, dynamic> && first['name'] != null) {
        return first['name'].toString();
      }
    }
    if (detail['type'] != null) {
      return detail['type'].toString();
    }
    return '';
  }

  int _parseBonus(String raw) {
    final match = RegExp(r'[-+]?\d+').firstMatch(raw);
    if (match == null) {
      return 0;
    }
    return int.tryParse(match.group(0)!) ?? 0;
  }

  String _normalizeDamageType(String? value) {
    switch (value?.trim().toUpperCase()) {
      case 'B':
        return 'bludgeoning';
      case 'P':
        return 'piercing';
      case 'S':
        return 'slashing';
      default:
        return value?.trim().isNotEmpty == true ? value!.trim() : 'damage';
    }
  }

  String _normalizedSkillId(String value) {
    return value.trim().toLowerCase();
  }

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _isSaving = true;
    _notifySafely();
    _saveDebounce = Timer(const Duration(milliseconds: 450), () {
      final current = _character;
      if (current == null) {
        _isSaving = false;
        _notifySafely();
        return;
      }
      unawaited(_saveNow(current));
    });
  }

  Future<void> _saveNow(Character character) async {
    _saveDebounce?.cancel();
    _isSaving = true;
    _saveError = null;
    _notifySafely();

    try {
      await _repository.saveCharacter(character);
      if (_disposed) {
        return;
      }
      _isSaving = false;
      _lastSavedAt = DateTime.now().toUtc();
      _notifySafely();
    } catch (error) {
      if (_disposed) {
        return;
      }
      _isSaving = false;
      _saveError = error.toString();
      _notifySafely();
    }
  }

  void _notifySafely() {
    if (_disposed) {
      return;
    }
    notifyListeners();
  }

  static bool _spellHasConcentration(dynamic duration) {
    if (duration is! List) {
      return false;
    }
    for (final entry in duration.whereType<Map>()) {
      if (entry['concentration'] == true) {
        return true;
      }
    }
    return false;
  }
}
