import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_library_controller.dart';
import 'package:openrpg/characters/data/character_repository.dart';
import 'package:openrpg/screens/character_sheet/character_sheet_screen.dart';
import 'package:openrpg/screens/characters/character_creation_flow.dart';
import 'package:openrpg/screens/rulesets/ruleset_detail_screen.dart';

class CharacterLibraryScreen extends StatefulWidget {
  const CharacterLibraryScreen({super.key});

  @override
  State<CharacterLibraryScreen> createState() => _CharacterLibraryScreenState();
}

class _CharacterLibraryScreenState extends State<CharacterLibraryScreen> {
  late final CharacterLibraryController _controller =
      CharacterLibraryController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _createCharacter() async {
    try {
      await createCharacterFromRulesetFlow(
        context,
        repository: _controller.repository,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _openCharacter(String characterId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CharacterSheetScreen(characterId: characterId),
      ),
    );
  }

  Future<void> _openRuleset(String rulesetId) async {
    if (rulesetId.trim().isEmpty) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RulesetDetailScreen(rulesetId: rulesetId),
      ),
    );
  }

  Future<void> _importCharacter() async {
    try {
      final summary = await _controller.importCharacterFromPicker();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imported ${summary.name}.'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () => _openCharacter(summary.id),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _renameCharacter(CharacterSummary summary) async {
    final controller = TextEditingController(text: summary.name);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rename Character'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Character name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
    if (result == null || result.trim().isEmpty || !mounted) {
      return;
    }

    try {
      await _controller.renameCharacter(summary.id, result);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _duplicateCharacter(CharacterSummary summary) async {
    try {
      final duplicated = await _controller.duplicateCharacter(summary.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Duplicated ${summary.name}.'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () => _openCharacter(duplicated.id),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _exportCharacter(CharacterSummary summary) async {
    try {
      final result = await _controller.exportCharacter(summary.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to ${result.locationDescription}.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _deleteCharacter(CharacterSummary summary) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Character'),
        content: Text('Delete ${summary.name}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }

    try {
      await _controller.deleteCharacter(summary.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted ${summary.name}.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Library'),
        actions: [
          IconButton(
            tooltip: 'Import character JSON',
            onPressed: _importCharacter,
            icon: const Icon(Icons.file_upload_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createCharacter,
        icon: const Icon(Icons.add),
        label: const Text('New Character'),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return StreamBuilder<List<CharacterSummary>>(
            stream: _controller.watchCharacters(),
            builder: (context, snapshot) {
              final characters = snapshot.data ?? const <CharacterSummary>[];
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primaryContainer,
                          colorScheme.secondaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved characters, compendium-backed builds, portable JSON.',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Create from an installed ruleset, keep editing across sessions, and export one character per file when you need it somewhere else.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_controller.isBusy)
                    Card(
                      child: ListTile(
                        leading: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        title: Text(_controller.statusMessage ?? 'Working...'),
                      ),
                    ),
                  if (snapshot.hasError)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Failed to load characters.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (characters.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No characters yet.',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Create a character from an installed ruleset, or import a `.character.json` file from the top-right action.',
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...characters.map(
                      (summary) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _CharacterSummaryCard(
                          summary: summary,
                          onOpen: () => _openCharacter(summary.id),
                          onOpenRuleset: summary.primaryRulesetId.trim().isEmpty
                              ? null
                              : () => _openRuleset(summary.primaryRulesetId),
                          onRename: () => _renameCharacter(summary),
                          onDuplicate: () => _duplicateCharacter(summary),
                          onExport: () => _exportCharacter(summary),
                          onDelete: () => _deleteCharacter(summary),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _CharacterSummaryCard extends StatelessWidget {
  final CharacterSummary summary;
  final VoidCallback onOpen;
  final VoidCallback? onOpenRuleset;
  final VoidCallback onRename;
  final VoidCallback onDuplicate;
  final VoidCallback onExport;
  final VoidCallback onDelete;

  const _CharacterSummaryCard({
    required this.summary,
    required this.onOpen,
    required this.onOpenRuleset,
    required this.onRename,
    required this.onDuplicate,
    required this.onExport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: scheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.badge_outlined),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          label: Text(
                            summary.totalLevel == 0
                                ? 'Level 0'
                                : 'Level ${summary.totalLevel}',
                          ),
                        ),
                        Tooltip(
                          message: summary.primaryRulesetMissing
                              ? 'This character points at a ruleset that is not currently installed.'
                              : 'Open the primary ruleset backing this character build.',
                          child: ActionChip(
                            label: Text(
                              summary.primaryRulesetName ??
                                  summary.primaryRulesetId,
                            ),
                            onPressed: onOpenRuleset,
                          ),
                        ),
                        if (summary.primaryRulesetMissing)
                          const Chip(label: Text('Ruleset missing')),
                        Tooltip(
                          message: summary.unresolvedSelectionCount == 0
                              ? 'All saved race, background, class, subclass, and spell references currently resolve.'
                              : 'Some saved selections no longer resolve cleanly. Open the sheet to repair them.',
                          child: Chip(
                            label: Text(
                              summary.unresolvedSelectionCount == 0
                                  ? 'Build healthy'
                                  : '${summary.unresolvedSelectionCount} unresolved',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      summary.classSummary,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Updated ${_formatTimestamp(summary.updatedAt)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (onOpenRuleset != null)
                          OutlinedButton(
                            onPressed: onOpenRuleset,
                            child: const Text('Open Ruleset'),
                          ),
                        OutlinedButton(
                          onPressed: onOpen,
                          child: const Text('Open Sheet'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'rename':
                      onRename();
                      break;
                    case 'duplicate':
                      onDuplicate();
                      break;
                    case 'export':
                      onExport();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'rename', child: Text('Rename')),
                  PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                  PopupMenuItem(value: 'export', child: Text('Export JSON')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatTimestamp(DateTime value) {
    final local = value.toLocal();
    final date =
        '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    final time =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }
}
