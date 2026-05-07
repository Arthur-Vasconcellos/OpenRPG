import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';

enum SpeciesRaceTermKind { species, race, mixed }

class SpeciesRaceTerminology {
  final SpeciesRaceTermKind kind;

  const SpeciesRaceTerminology(this.kind);

  String get displayLabel => switch (kind) {
    SpeciesRaceTermKind.species => 'Species',
    SpeciesRaceTermKind.race => 'Race',
    SpeciesRaceTermKind.mixed => 'Species / Race',
  };

  String get lowerLabel => switch (kind) {
    SpeciesRaceTermKind.species => 'species',
    SpeciesRaceTermKind.race => 'race',
    SpeciesRaceTermKind.mixed => 'species/race',
  };

  String get articleLabel => switch (kind) {
    SpeciesRaceTermKind.species => 'a species',
    SpeciesRaceTermKind.race => 'a race',
    SpeciesRaceTermKind.mixed => 'a species or race',
  };

  String get choiceSourceLabel => switch (kind) {
    SpeciesRaceTermKind.species => 'from your species',
    SpeciesRaceTermKind.race => 'from your race',
    SpeciesRaceTermKind.mixed => 'from your species/race',
  };

  String get chooseActionLabel => 'Choose $displayLabel';
  String get changeActionLabel => 'Change $displayLabel';
  String get replaceActionLabel => 'Replace $displayLabel';
  String get reviewActionLabel => 'Review $displayLabel';
}

SpeciesRaceTerminology speciesRaceTerminologyForController(
  CharacterEditorController controller,
) {
  return speciesRaceTerminologyForRuleset(
    primaryRulesetId: controller.character?.primaryRulesetId ?? '',
    installedRulesets: controller.installedRulesets,
    primaryRulesetExtraData: controller.primaryRulesetExtraData,
  );
}

SpeciesRaceTerminology speciesRaceTerminologyForRuleset({
  required String primaryRulesetId,
  required List<RulesetSummary> installedRulesets,
  required Map<String, dynamic> primaryRulesetExtraData,
}) {
  RulesetSummary? primaryRuleset;
  for (final ruleset in installedRulesets) {
    if (ruleset.id == primaryRulesetId) {
      primaryRuleset = ruleset;
      break;
    }
  }
  final metadata = <String>[
    primaryRulesetId,
    if (primaryRuleset != null) ...[
      primaryRuleset.name,
      primaryRuleset.description,
      primaryRuleset.schemaVersion,
      primaryRuleset.version,
      primaryRuleset.filePath,
    ],
    for (final key in const [
      'edition',
      'rulesEdition',
      'rulesVersion',
      'dndEdition',
      'sourceEdition',
      'contentVersion',
    ])
      primaryRulesetExtraData[key]?.toString() ?? '',
  ].join(' ').toLowerCase();

  if (metadata.contains('2024') ||
      metadata.contains('xphb') ||
      metadata.contains('srd52') ||
      metadata.contains('5.2')) {
    return const SpeciesRaceTerminology(SpeciesRaceTermKind.species);
  }
  if (metadata.contains('2014') ||
      metadata.contains('srd51') ||
      metadata.contains('5.1') ||
      metadata.contains('default_srd')) {
    return const SpeciesRaceTerminology(SpeciesRaceTermKind.race);
  }
  return const SpeciesRaceTerminology(SpeciesRaceTermKind.mixed);
}
