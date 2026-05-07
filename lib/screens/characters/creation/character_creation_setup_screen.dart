import 'package:flutter/material.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/characters/creation/character_creation_mode.dart';

class CreateCharacterRequest {
  final String name;
  final String primaryRulesetId;
  final CharacterCreationMode mode;
  final String playerName;
  final String campaignName;

  const CreateCharacterRequest({
    required this.name,
    required this.primaryRulesetId,
    required this.mode,
    this.playerName = '',
    this.campaignName = '',
  });
}

class CharacterCreationSetupScreen extends StatefulWidget {
  final List<RulesetSummary> rulesets;
  final String initialRulesetId;

  const CharacterCreationSetupScreen({
    super.key,
    required this.rulesets,
    required this.initialRulesetId,
  });

  @override
  State<CharacterCreationSetupScreen> createState() =>
      _CharacterCreationSetupScreenState();
}

class _CharacterCreationSetupScreenState
    extends State<CharacterCreationSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _playerController = TextEditingController();
  final _campaignController = TextEditingController();
  late String _selectedRulesetId = widget.initialRulesetId;
  CharacterCreationMode _mode = CharacterCreationMode.guided;

  @override
  void dispose() {
    _nameController.dispose();
    _playerController.dispose();
    _campaignController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    RulesetSummary? selectedRuleset;
    for (final ruleset in widget.rulesets) {
      if (ruleset.id == _selectedRulesetId) {
        selectedRuleset = ruleset;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Character'),
        leading: IconButton(
          tooltip: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.offline_bolt_outlined,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Offline-first character setup',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create a saved character from an installed local ruleset, then keep classes, features, spells, and items linked to their rules reference.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 12),
                        Chip(
                          avatar: const Icon(Icons.cloud_off_outlined),
                          label: Text(
                            selectedRuleset == null
                                ? 'Choose an installed local ruleset'
                                : 'Using installed local ruleset: ${selectedRuleset.name}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Character Identity',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              labelText: 'Character name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Enter a character name.'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _playerController,
                            decoration: const InputDecoration(
                              labelText: 'Player name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _campaignController,
                            decoration: const InputDecoration(
                              labelText: 'Campaign / table',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedRulesetId,
                            decoration: const InputDecoration(
                              labelText: 'Primary ruleset',
                              border: OutlineInputBorder(),
                            ),
                            items: widget.rulesets
                                .map(
                                  (ruleset) => DropdownMenuItem<String>(
                                    value: ruleset.id,
                                    child: Text(ruleset.name),
                                  ),
                                )
                                .toList(growable: false),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Choose a ruleset.'
                                : null,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedRulesetId = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Builder Mode',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<CharacterCreationMode>(
                          segments: CharacterCreationMode.values
                              .map(
                                (mode) => ButtonSegment(
                                  value: mode,
                                  icon: Icon(
                                    mode == CharacterCreationMode.guided
                                        ? Icons.route_outlined
                                        : Icons.dashboard_customize_outlined,
                                  ),
                                  label: Text(mode.label),
                                ),
                              )
                              .toList(growable: false),
                          selected: {_mode},
                          onSelectionChanged: (selection) {
                            setState(() {
                              _mode = selection.first;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _mode.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('Create Character'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    Navigator.of(context).pop(
      CreateCharacterRequest(
        name: _nameController.text.trim(),
        primaryRulesetId: _selectedRulesetId,
        mode: _mode,
        playerName: _playerController.text.trim(),
        campaignName: _campaignController.text.trim(),
      ),
    );
  }
}
