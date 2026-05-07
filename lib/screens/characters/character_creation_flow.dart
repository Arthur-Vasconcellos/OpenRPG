import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_repository.dart';
import 'package:openrpg/compendium/data/compendium_bootstrap_service.dart';
import 'package:openrpg/compendium/data/compendium_import_controller.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/character_sheet/character_sheet_screen.dart';
import 'package:openrpg/screens/characters/creation/character_builder_screen.dart';
import 'package:openrpg/screens/characters/creation/character_creation_mode.dart';
import 'package:openrpg/screens/characters/creation/character_creation_setup_screen.dart';
import 'package:openrpg/screens/rulesets/ruleset_library_screen.dart';

Future<String?> createCharacterFromRulesetFlow(
  BuildContext context, {
  CharacterRepository? repository,
  CompendiumBootstrapService? bootstrapService,
  String? preselectedRulesetId,
}) async {
  final characterRepository = repository ?? CharacterRepository();
  var rulesets = await characterRepository.loadInstalledRulesets();
  if (!context.mounted) {
    return null;
  }

  if (rulesets.isEmpty) {
    rulesets = await showCharacterRulesetRecovery(
      context,
      repository: characterRepository,
      bootstrapService: bootstrapService ?? CompendiumBootstrapService(),
    );
    if (rulesets.isEmpty || !context.mounted) {
      return null;
    }
  }

  final initialRulesetId =
      (preselectedRulesetId != null &&
          rulesets.any((ruleset) => ruleset.id == preselectedRulesetId))
      ? preselectedRulesetId
      : rulesets.first.id;

  final request = await Navigator.of(context).push<CreateCharacterRequest>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => CharacterCreationSetupScreen(
        rulesets: rulesets,
        initialRulesetId: initialRulesetId,
      ),
    ),
  );
  if (request == null || !context.mounted) {
    return null;
  }

  final created = await characterRepository.createCharacter(
    name: request.name,
    primaryRulesetId: request.primaryRulesetId,
    playerName: request.playerName,
    creationExtraData: {
      'mode': request.mode.storageValue,
      if (request.campaignName.trim().isNotEmpty)
        'campaignName': request.campaignName.trim(),
    },
  );
  if (!context.mounted) {
    return created.id;
  }

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => characterCreationDestination(
        characterId: created.id,
        mode: request.mode,
      ),
    ),
  );
  return created.id;
}

@visibleForTesting
Widget characterCreationDestination({
  required String characterId,
  required CharacterCreationMode mode,
}) {
  return mode == CharacterCreationMode.guided
      ? CharacterBuilderScreen(characterId: characterId)
      : CharacterSheetScreen(characterId: characterId);
}

enum CharacterRulesetRecoveryAction {
  restoreBundled,
  openLibrary,
  importJson,
  cancel,
}

@visibleForTesting
class CharacterRulesetRecoveryDialog extends StatelessWidget {
  final bool canImportRuleset;

  const CharacterRulesetRecoveryDialog({
    super.key,
    required this.canImportRuleset,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ruleset Needed'),
      content: const Text(
        'Characters need a ruleset to calculate classes, features, spells, items, and stats.',
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(CharacterRulesetRecoveryAction.cancel),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(CharacterRulesetRecoveryAction.openLibrary),
          child: const Text('Open Ruleset Library'),
        ),
        if (canImportRuleset)
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(CharacterRulesetRecoveryAction.importJson),
            child: const Text('Import Ruleset JSON'),
          ),
        FilledButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(CharacterRulesetRecoveryAction.restoreBundled),
          child: const Text('Restore Bundled Ruleset'),
        ),
      ],
    );
  }
}

@visibleForTesting
Future<List<RulesetSummary>> showCharacterRulesetRecovery(
  BuildContext context, {
  required CharacterRepository repository,
  required CompendiumBootstrapService bootstrapService,
}) async {
  var rulesets = await repository.loadInstalledRulesets();
  if (!context.mounted) {
    return const <RulesetSummary>[];
  }
  while (context.mounted && rulesets.isEmpty) {
    // ignore: use_build_context_synchronously
    final importController = CompendiumImportControllerScope.maybeOf(context);
    final action = await showDialog<CharacterRulesetRecoveryAction>(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (_) => CharacterRulesetRecoveryDialog(
        canImportRuleset: importController != null,
      ),
    );

    if (!context.mounted ||
        action == null ||
        action == CharacterRulesetRecoveryAction.cancel) {
      return const <RulesetSummary>[];
    }

    switch (action) {
      case CharacterRulesetRecoveryAction.restoreBundled:
        final restored = await _restoreBundledRuleset(
          context,
          bootstrapService,
        );
        if (!restored || !context.mounted) {
          continue;
        }
        rulesets = await repository.loadInstalledRulesets();
        if (context.mounted && rulesets.isEmpty) {
          _showRecoveryMessage(
            context,
            'The bundled ruleset was prepared, but no installed rulesets were found yet.',
          );
        }
      case CharacterRulesetRecoveryAction.openLibrary:
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => RulesetLibraryScreen()));
        if (!context.mounted) {
          return const <RulesetSummary>[];
        }
        rulesets = await repository.loadInstalledRulesets();
      case CharacterRulesetRecoveryAction.importJson:
        if (importController == null) {
          _showRecoveryMessage(
            context,
            'Ruleset import is unavailable until the app is ready.',
          );
          continue;
        }
        await importController.startImportFromPicker();
        if (!context.mounted) {
          return const <RulesetSummary>[];
        }
        rulesets = await repository.loadInstalledRulesets();
      case CharacterRulesetRecoveryAction.cancel:
        return const <RulesetSummary>[];
    }
  }

  return rulesets;
}

Future<bool> _restoreBundledRuleset(
  BuildContext context,
  CompendiumBootstrapService bootstrapService,
) async {
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        title: Text('Preparing Bundled Ruleset'),
        content: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 14),
            Expanded(child: Text('Restoring the included rules reference...')),
          ],
        ),
      ),
    ),
  );

  try {
    await bootstrapService.ensureBootstrapped();
    return true;
  } catch (error) {
    if (context.mounted) {
      _showRecoveryMessage(
        context,
        'Unable to restore bundled ruleset: $error',
      );
    }
    return false;
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

void _showRecoveryMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
