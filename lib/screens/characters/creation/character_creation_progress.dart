import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/characters/creation/ability_score_generation.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/species_race_terms.dart';

enum CharacterBuilderIssueSeverity { error, warning, info }

class CharacterBuilderIssue {
  final CharacterBuilderIssueSeverity severity;
  final CharacterBuilderStepId stepId;
  final String title;
  final String message;
  final String actionLabel;

  const CharacterBuilderIssue({
    required this.severity,
    required this.stepId,
    required this.title,
    required this.message,
    required this.actionLabel,
  });
}

class CharacterCreationProgress {
  final Map<CharacterBuilderStepId, CharacterBuilderStepStatus> stepStatuses;
  final List<CharacterBuilderIssue> issues;
  final int completedVisibleSteps;
  final int totalVisibleSteps;
  final double completionRatio;

  const CharacterCreationProgress({
    required this.stepStatuses,
    required this.issues,
    required this.completedVisibleSteps,
    required this.totalVisibleSteps,
    required this.completionRatio,
  });

  bool get hasBlockingIssues => issues.any(
    (issue) => issue.severity == CharacterBuilderIssueSeverity.error,
  );

  int get warningCount => issues
      .where((issue) => issue.severity == CharacterBuilderIssueSeverity.warning)
      .length;

  int get errorCount => issues
      .where((issue) => issue.severity == CharacterBuilderIssueSeverity.error)
      .length;

  CharacterBuilderIssue? get nextBlockingIssue {
    for (final issue in issues) {
      if (issue.severity == CharacterBuilderIssueSeverity.error) {
        return issue;
      }
    }
    return null;
  }

  List<CharacterBuilderIssue> issuesFor(CharacterBuilderStepId stepId) {
    return issues
        .where((issue) => issue.stepId == stepId)
        .toList(growable: false);
  }
}

class CharacterCreationProgressResolver {
  final CharacterEditorController controller;

  const CharacterCreationProgressResolver(this.controller);

  CharacterCreationProgress resolve() {
    final character = controller.character;
    if (character == null) {
      return const CharacterCreationProgress(
        stepStatuses: <CharacterBuilderStepId, CharacterBuilderStepStatus>{},
        issues: <CharacterBuilderIssue>[],
        completedVisibleSteps: 0,
        totalVisibleSteps: 0,
        completionRatio: 0,
      );
    }

    final issues = <CharacterBuilderIssue>[
      ..._basicsIssues(character),
      ..._classLevelIssues(character),
      ..._speciesRaceIssues(character),
      ..._backgroundIssues(character),
      ..._abilityScoreIssues(character),
      ..._proficiencyIssues(character),
      ..._spellIssues(character),
      ..._equipmentIssues(character),
      ..._storyIssues(character),
    ];
    final visibleDescriptors = characterBuilderStepDescriptors
        .where((descriptor) => descriptor.isVisible(controller))
        .toList(growable: false);
    final statuses = <CharacterBuilderStepId, CharacterBuilderStepStatus>{};

    for (final descriptor in characterBuilderStepDescriptors) {
      if (!descriptor.isVisible(controller)) {
        statuses[descriptor.id] = CharacterBuilderStepStatus.skipped;
        continue;
      }
      if (descriptor.id == CharacterBuilderStepId.review) {
        statuses[descriptor.id] = _reviewStatus(issues);
        continue;
      }
      statuses[descriptor.id] = _statusForStep(descriptor.id, issues);
    }

    final completed = visibleDescriptors
        .where(
          (descriptor) =>
              statuses[descriptor.id] == CharacterBuilderStepStatus.complete,
        )
        .length;
    final total = visibleDescriptors.length;
    return CharacterCreationProgress(
      stepStatuses: statuses,
      issues: issues,
      completedVisibleSteps: completed,
      totalVisibleSteps: total,
      completionRatio: total == 0 ? 0 : completed / total,
    );
  }

  Iterable<CharacterBuilderIssue> _basicsIssues(Character character) sync* {
    if (character.name.trim().isEmpty) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.basics,
        title: 'No character name',
        message: 'Enter a character name before calling the build ready.',
        actionLabel: 'Go to Basics',
      );
    }
    if (character.primaryRulesetId.trim().isEmpty) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.basics,
        title: 'No primary ruleset',
        message:
            'Choose an installed ruleset so classes, features, spells, items, and stats can be calculated.',
        actionLabel: 'Choose Ruleset',
      );
    } else if (!controller.installedRulesets.any(
      (ruleset) => ruleset.id == character.primaryRulesetId,
    )) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.basics,
        title: 'Primary ruleset missing',
        message:
            'This character references a ruleset that is not installed on this device.',
        actionLabel: 'Choose Ruleset',
      );
    }
    if (controller.unresolvedSelectionCount > 0) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.basics,
        title: 'Choices need attention',
        message:
            '${controller.unresolvedSelectionCount} saved choice${controller.unresolvedSelectionCount == 1 ? '' : 's'} need attention after ruleset changes.',
        actionLabel: 'Review Choices',
      );
    }
  }

  Iterable<CharacterBuilderIssue> _classLevelIssues(Character character) sync* {
    if (character.classes.isEmpty) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.classLevel,
        title: 'No class selected',
        message:
            'Choose at least one class to define level, features, and hit dice.',
        actionLabel: 'Choose Class',
      );
      return;
    }
    for (final entry in character.classes) {
      if (entry.classRef == null) {
        yield const CharacterBuilderIssue(
          severity: CharacterBuilderIssueSeverity.error,
          stepId: CharacterBuilderStepId.classLevel,
          title: 'Class slot is empty',
          message: 'Every class entry needs a class from your installed rules.',
          actionLabel: 'Choose Class',
        );
      } else if (!entry.classRef!.isResolved) {
        yield CharacterBuilderIssue(
          severity: CharacterBuilderIssueSeverity.error,
          stepId: CharacterBuilderStepId.classLevel,
          title: 'Class needs attention',
          message:
              '${entry.classRef!.displayName} is not available in your installed rules.',
          actionLabel: 'Replace Class',
        );
      }
      if (entry.subclassRef != null && !entry.subclassRef!.isResolved) {
        yield CharacterBuilderIssue(
          severity: CharacterBuilderIssueSeverity.warning,
          stepId: CharacterBuilderStepId.classLevel,
          title: 'Subclass needs attention',
          message:
              '${entry.subclassRef!.displayName} is not available in your installed rules.',
          actionLabel: 'Replace Subclass',
        );
      }
    }
    if (character.totalLevel < 1) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.classLevel,
        title: 'Total level is below 1',
        message: 'Set class levels to at least 1.',
        actionLabel: 'Adjust Level',
      );
    }
    if (character.totalLevel > 20) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.classLevel,
        title: 'Total level is above 20',
        message:
            'Reduce class levels to 20 or lower for the standard rules profile.',
        actionLabel: 'Adjust Level',
      );
    }
    if (character.classes.length > 1) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.classLevel,
        title: 'Multiclass build',
        message:
            'Multiple class entries are supported, but some multiclass requirements still need table review.',
        actionLabel: 'Review Classes',
      );
    }
  }

  Iterable<CharacterBuilderIssue> _speciesRaceIssues(
    Character character,
  ) sync* {
    final terminology = speciesRaceTerminologyForController(controller);
    final ref = character.raceRef;
    if (ref == null) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.speciesRace,
        title: 'No ${terminology.lowerLabel} selected',
        message:
            'Choose ${terminology.articleLabel} so traits and movement can be added.',
        actionLabel: terminology.chooseActionLabel,
      );
    } else if (!ref.isResolved) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.speciesRace,
        title: '${terminology.displayLabel} needs attention',
        message: '${ref.displayName} is not available in your installed rules.',
        actionLabel: terminology.replaceActionLabel,
      );
    } else if (ref.rulesetId != character.primaryRulesetId) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.speciesRace,
        title: '${terminology.displayLabel} from another ruleset',
        message: '${ref.displayName} comes from a non-primary ruleset.',
        actionLabel: terminology.reviewActionLabel,
      );
    }
  }

  Iterable<CharacterBuilderIssue> _backgroundIssues(Character character) sync* {
    final ref = character.backgroundRef;
    if (ref == null) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.background,
        title: 'No background selected',
        message:
            'Choose a background so features and proficiencies can be added.',
        actionLabel: 'Choose Background',
      );
    } else if (!ref.isResolved) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.error,
        stepId: CharacterBuilderStepId.background,
        title: 'Background needs attention',
        message: '${ref.displayName} is not available in your installed rules.',
        actionLabel: 'Replace Background',
      );
    }
    if (ref != null &&
        ref.isResolved &&
        controller.resolvedBuild.backgroundFeatures.isEmpty) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.background,
        title: 'No background features found',
        message:
            'The selected background did not add features the sheet can show yet.',
        actionLabel: 'Review Background',
      );
    }
  }

  Iterable<CharacterBuilderIssue> _abilityScoreIssues(
    Character character,
  ) sync* {
    final abilities = controller.sheetSchema.abilities;
    final creation = characterCreationData(character.extraData);
    final backgroundOptions = backgroundAbilityBonusOptionsForResolvedEntity(
      controller.resolvedBuild.background,
    );
    final validation = validateAbilityScoreGeneration(
      character: character,
      abilities: abilities,
      creation: creation,
      pointBuyRules: PointBuyRules.fromRulesetExtra(
        controller.primaryRulesetExtraData,
      ),
      backgroundAbilityOptions: backgroundOptions,
    );
    if (validation.status == AbilityScoreValidationStatus.ready) {
      return;
    }
    yield CharacterBuilderIssue(
      severity: validation.blocksProgress
          ? CharacterBuilderIssueSeverity.error
          : CharacterBuilderIssueSeverity.warning,
      stepId: CharacterBuilderStepId.abilityScores,
      title: validation.title,
      message: validation.message,
      actionLabel: 'Review Scores',
    );
  }

  Iterable<CharacterBuilderIssue> _proficiencyIssues(
    Character character,
  ) sync* {
    final trainedSkills = character.proficiencies.skills.proficiencies.values
        .where(
          (value) =>
              SkillTrainingLevel.normalize(value) != SkillTrainingLevel.none,
        )
        .length;
    if (trainedSkills == 0 && controller.sheetSchema.skills.isNotEmpty) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.proficiencies,
        title: 'No trained skills',
        message:
            'No skill proficiencies are marked yet. Guided skill choices can be expanded in a later pass.',
        actionLabel: 'Review Skills',
      );
    }
    final currentSaves =
        character.proficiencies.savingThrows.proficientAbilityIds;
    final defaultSaves =
        controller.resolvedBuild.savingThrowDefaults.proficientAbilityIds;
    if (defaultSaves.isNotEmpty &&
        (currentSaves.length != defaultSaves.length ||
            !currentSaves.containsAll(defaultSaves))) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.proficiencies,
        title: 'Saving throws differ from class defaults',
        message:
            'Manual saving throw overrides do not match the resolver defaults for the selected class.',
        actionLabel: 'Review Saves',
      );
    }
  }

  Iterable<CharacterBuilderIssue> _spellIssues(Character character) sync* {
    final spellcasting = character.spellcasting;
    if (spellcasting == null) {
      return;
    }
    final preparedCount = spellcasting.preparedSpells
        .where((spell) => spell.level > 0)
        .length;
    final knownCount = spellcasting.knownSpells
        .where((spell) => spell.level > 0)
        .length;
    final cantripCount = spellcasting.allSpells
        .where((spell) => spell.level == 0)
        .length;
    final preparedCapacity = controller.resolvedBuild.preparedSpellCapacity;
    final knownCapacity = controller.resolvedBuild.knownSpellCapacity;
    final cantripCapacity = controller.resolvedBuild.cantripCapacity;

    if (preparedCapacity != null && preparedCount > preparedCapacity) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.spells,
        title: 'Prepared spells exceed capacity',
        message: 'Prepared $preparedCount / $preparedCapacity spells.',
        actionLabel: 'Review Spells',
      );
    }
    if (knownCapacity != null && knownCount > knownCapacity) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.spells,
        title: 'Known spells exceed capacity',
        message: 'Known $knownCount / $knownCapacity spells.',
        actionLabel: 'Review Spells',
      );
    }
    if (cantripCapacity != null && cantripCount > cantripCapacity) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.spells,
        title: 'Cantrips exceed capacity',
        message: 'Selected $cantripCount / $cantripCapacity cantrips.',
        actionLabel: 'Review Cantrips',
      );
    }
    final concentrationCount = spellcasting.allSpells
        .where((spell) => spell.isConcentration)
        .length;
    if (concentrationCount >= 4) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.spells,
        title: 'Many concentration spells',
        message:
            'You selected $concentrationCount concentration spells. That is allowed, but only one can usually be active at a time.',
        actionLabel: 'Review Spells',
      );
    }
    final unresolved = spellcasting.allSpells
        .where(
          (spell) => spell.reference != null && !spell.reference!.isResolved,
        )
        .length;
    if (unresolved > 0) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.spells,
        title: 'Spell choices need attention',
        message:
            '$unresolved selected spell${unresolved == 1 ? '' : 's'} need attention.',
        actionLabel: 'Review Spells',
      );
    }
  }

  Iterable<CharacterBuilderIssue> _equipmentIssues(Character character) sync* {
    final entries = character.equipment.entries;
    final loadout = character.equipment.loadout;
    if (entries.isEmpty) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.equipment,
        title: 'No equipment selected',
        message:
            'Add inventory from the rules reference or keep this as a deliberate blank slate.',
        actionLabel: 'Add Equipment',
      );
      return;
    }
    if (loadout.armorEntryId == null &&
        loadout.meleeEntryId == null &&
        loadout.rangedEntryId == null) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.equipment,
        title: 'No equipped loadout',
        message: 'Inventory exists, but no armor or weapon slots are assigned.',
        actionLabel: 'Review Loadout',
      );
    }
    final entryIds = entries.map((entry) => entry.id).toSet();
    final missingSlots = <String>[
      if (loadout.armorEntryId != null &&
          !entryIds.contains(loadout.armorEntryId))
        'armor',
      if (loadout.meleeEntryId != null &&
          !entryIds.contains(loadout.meleeEntryId))
        'melee',
      if (loadout.rangedEntryId != null &&
          !entryIds.contains(loadout.rangedEntryId))
        'ranged',
    ];
    if (missingSlots.isNotEmpty) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.equipment,
        title: 'Loadout references removed items',
        message: 'Missing loadout slots: ${missingSlots.join(', ')}.',
        actionLabel: 'Fix Loadout',
      );
    }
    final unresolved = entries
        .where(
          (entry) => entry.reference != null && !entry.reference!.isResolved,
        )
        .length;
    if (unresolved > 0) {
      yield CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.warning,
        stepId: CharacterBuilderStepId.equipment,
        title: 'Equipment choices need attention',
        message:
            '$unresolved inventory item${unresolved == 1 ? '' : 's'} need attention.',
        actionLabel: 'Review Equipment',
      );
    }
  }

  Iterable<CharacterBuilderIssue> _storyIssues(Character character) sync* {
    final hasStory =
        character.alignment.trim().isNotEmpty ||
        character.traits.personalityTraits.trim().isNotEmpty ||
        character.traits.ideals.trim().isNotEmpty ||
        character.traits.bonds.trim().isNotEmpty ||
        character.traits.flaws.trim().isNotEmpty ||
        character.notes.backstory.trim().isNotEmpty ||
        character.notes.appearance.trim().isNotEmpty ||
        character.notes.otherNotes.trim().isNotEmpty ||
        character.physicalDescription.height.trim().isNotEmpty ||
        character.physicalDescription.eyes.trim().isNotEmpty ||
        character.physicalDescription.hair.trim().isNotEmpty;
    if (!hasStory) {
      yield const CharacterBuilderIssue(
        severity: CharacterBuilderIssueSeverity.info,
        stepId: CharacterBuilderStepId.story,
        title: 'Story fields are blank',
        message:
            'This does not block play, but roleplay prompts are ready when useful.',
        actionLabel: 'Add Notes',
      );
    }
  }

  CharacterBuilderStepStatus _statusForStep(
    CharacterBuilderStepId stepId,
    List<CharacterBuilderIssue> issues,
  ) {
    final stepIssues = issues.where((issue) => issue.stepId == stepId);
    if (stepIssues.any(
      (issue) => issue.severity == CharacterBuilderIssueSeverity.error,
    )) {
      return CharacterBuilderStepStatus.error;
    }
    if (stepIssues.any(
      (issue) => issue.severity == CharacterBuilderIssueSeverity.warning,
    )) {
      return CharacterBuilderStepStatus.warning;
    }
    if (stepId == CharacterBuilderStepId.story &&
        stepIssues.any(
          (issue) => issue.severity == CharacterBuilderIssueSeverity.info,
        )) {
      return CharacterBuilderStepStatus.notStarted;
    }
    return CharacterBuilderStepStatus.complete;
  }

  CharacterBuilderStepStatus _reviewStatus(List<CharacterBuilderIssue> issues) {
    if (issues.any(
      (issue) => issue.severity == CharacterBuilderIssueSeverity.error,
    )) {
      return CharacterBuilderStepStatus.error;
    }
    if (issues.any(
      (issue) => issue.severity == CharacterBuilderIssueSeverity.warning,
    )) {
      return CharacterBuilderStepStatus.warning;
    }
    return CharacterBuilderStepStatus.complete;
  }
}
