import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/characters/creation/character_creation_mode.dart';

class BasicsRulesetStep extends StatelessWidget {
  final CharacterEditorController controller;

  const BasicsRulesetStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final character = controller.character!;
    final rulesets = controller.installedRulesets;
    final creation = _creationData(character.extraData);
    final mode = switch (creation['mode']?.toString()) {
      'expert' => CharacterCreationMode.expert,
      _ => CharacterCreationMode.guided,
    };
    final campaignName = creation['campaignName']?.toString() ?? '';
    final selectedRulesetId =
        rulesets.any((ruleset) => ruleset.id == character.primaryRulesetId)
        ? character.primaryRulesetId
        : null;
    String? selectedRulesetName;
    for (final ruleset in rulesets) {
      if (ruleset.id == character.primaryRulesetId) {
        selectedRulesetName = ruleset.name;
        break;
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basics & Ruleset',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Confirm the character identity and the installed local ruleset used for rules.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.route_outlined),
                      label: Text(mode.label),
                    ),
                    Chip(
                      avatar: const Icon(Icons.cloud_off_outlined),
                      label: Text(
                        selectedRulesetName == null
                            ? 'Ruleset needs attention'
                            : 'Using installed local ruleset: $selectedRulesetName',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: character.name,
                  decoration: const InputDecoration(
                    labelText: 'Character name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: controller.setName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: character.playerName,
                  decoration: const InputDecoration(
                    labelText: 'Player name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: controller.setPlayerName,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedRulesetId,
                  decoration: const InputDecoration(
                    labelText: 'Primary ruleset',
                    border: OutlineInputBorder(),
                  ),
                  items: rulesets
                      .map(
                        (ruleset) => DropdownMenuItem<String>(
                          value: ruleset.id,
                          child: Text(ruleset.name),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: rulesets.isEmpty
                      ? null
                      : (value) => _changeRuleset(context, value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: character.alignment,
                  decoration: const InputDecoration(
                    labelText: 'Alignment',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: controller.setAlignment,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: campaignName,
                  decoration: const InputDecoration(
                    labelText: 'Campaign / table',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      controller.setCreationExtraValue('campaignName', value),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _changeRuleset(BuildContext context, String? value) async {
    final character = controller.character!;
    if (value == null || value == character.primaryRulesetId) {
      return;
    }
    var confirmed = true;
    if (character.hasBuildSelections) {
      confirmed =
          await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Change Primary Ruleset'),
              content: const Text(
                'Changing the primary ruleset keeps manual notes and stats, but selections that no longer resolve will be cleared.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Change'),
                ),
              ],
            ),
          ) ??
          false;
    }
    if (confirmed) {
      await controller.changePrimaryRuleset(value);
    }
  }

  Map<String, dynamic> _creationData(Map<String, dynamic> extraData) {
    final creation = extraData['creation'];
    if (creation is Map) {
      return Map<String, dynamic>.from(creation.cast<String, dynamic>());
    }
    return const <String, dynamic>{};
  }
}
