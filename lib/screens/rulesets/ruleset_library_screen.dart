import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openrpg/compendium/data/compendium_bootstrap_service.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/rulesets/ruleset_detail_screen.dart';

class RulesetLibraryScreen extends StatefulWidget {
  const RulesetLibraryScreen({super.key});

  @override
  State<RulesetLibraryScreen> createState() => _RulesetLibraryScreenState();
}

class _RulesetLibraryScreenState extends State<RulesetLibraryScreen> {
  final CompendiumBootstrapService _bootstrapService =
      CompendiumBootstrapService();
  final CompendiumBrowseRepository _browseRepository =
      CompendiumBrowseRepository();
  final CompendiumRepository _repository = CompendiumRepository();
  late final Stream<List<RulesetSummary>> _rulesetStream;
  Stream<CompendiumBootstrapStatus>? _bootstrapStatusStream;

  @override
  void initState() {
    super.initState();
    _rulesetStream = _browseRepository.watchInstalledRulesets();
    unawaited(_initializeBootstrap());
  }

  Future<void> _initializeBootstrap() async {
    final manifest = await _bootstrapService.loadManifest();
    final bundledRulesetId = manifest.rulesets.isEmpty
        ? null
        : manifest.rulesets.first.rulesetId;
    if (!mounted) {
      return;
    }

    setState(() {
      _bootstrapStatusStream = bundledRulesetId == null
          ? null
          : _bootstrapService.watchStatus(bundledRulesetId);
    });
    unawaited(_bootstrapService.ensureBootstrapped());
  }

  Future<void> _retryBootstrap() async {
    await _bootstrapService.ensureBootstrapped();
  }

  Future<void> _createRuleset() async {
    final result = await showDialog<_CreateRulesetResult>(
      context: context,
      builder: (_) => const _CreateRulesetDialog(),
    );
    if (result == null) {
      return;
    }

    await _repository.createRuleset(
      name: result.name,
      description: result.description,
    );
  }

  Future<void> _importRuleset() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (picked == null) {
      return;
    }

    final file = picked.files.single;
    final bytes = file.bytes;
    if (bytes == null) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to read the selected file on this platform.'),
        ),
      );
      return;
    }

    final jsonString = utf8.decode(bytes);
    await _repository.importRulesetJson(jsonString);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Imported ${file.name}')));
  }

  Future<void> _duplicateRuleset(RulesetSummary summary) async {
    await _repository.duplicateRuleset(summary.id);
  }

  Future<void> _exportRuleset(RulesetSummary summary) async {
    final json = await _repository.exportRulesetJson(summary.id);
    final export = await _repository.exportRulesetFile(summary.id);
    await Clipboard.setData(ClipboardData(text: json));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Exported to ${export.locationDescription} and copied JSON to the clipboard.',
        ),
      ),
    );
  }

  Future<void> _deleteRuleset(RulesetSummary summary) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Ruleset'),
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
    if (confirmed != true) {
      return;
    }

    await _repository.deleteRuleset(summary.id);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruleset Library'),
        actions: [
          IconButton(
            onPressed: _importRuleset,
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: 'Import JSON',
          ),
          IconButton(
            onPressed: _retryBootstrap,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createRuleset,
        icon: const Icon(Icons.add),
        label: const Text('New Ruleset'),
      ),
      body: StreamBuilder<CompendiumBootstrapStatus>(
        stream: _bootstrapStatusStream,
        initialData: const CompendiumBootstrapStatus.idle(),
        builder: (context, bootstrapSnapshot) {
          final bootstrapStatus =
              bootstrapSnapshot.data ?? const CompendiumBootstrapStatus.idle();

          return StreamBuilder<List<RulesetSummary>>(
            stream: _rulesetStream,
            builder: (context, rulesetSnapshot) {
              if (rulesetSnapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Failed to load rulesets.\n${rulesetSnapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final rulesets = rulesetSnapshot.data ?? const <RulesetSummary>[];
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
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
                          'Offline rulesets, editable homebrew, portable JSON.',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Bundled data now indexes in the background, so the library stays responsive while browse data becomes available.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (bootstrapStatus.isRunning)
                    _BootstrapStatusCard(
                      label: 'Indexing bundled compendium',
                      progress: bootstrapStatus.progress,
                    ),
                  if (bootstrapStatus.isFailed)
                    _BootstrapErrorCard(
                      message:
                          bootstrapStatus.lastError ??
                          'The bundled compendium index failed to build.',
                      onRetry: _retryBootstrap,
                    ),
                  if (bootstrapStatus.isRunning || bootstrapStatus.isFailed)
                    const SizedBox(height: 20),
                  if (rulesets.isEmpty && bootstrapStatus.isRunning)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Preparing the bundled compendium...'),
                      ),
                    )
                  else if (rulesets.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No rulesets installed yet.'),
                      ),
                    )
                  else
                    ...rulesets.map((summary) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RulesetDetailScreen(
                                    rulesetId: summary.id,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          summary.name,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                        ),
                                      ),
                                      _ModeChip(mode: summary.mode),
                                      const SizedBox(width: 8),
                                      PopupMenuButton<String>(
                                        onSelected: (value) async {
                                          switch (value) {
                                            case 'duplicate':
                                              await _duplicateRuleset(summary);
                                              break;
                                            case 'export':
                                              await _exportRuleset(summary);
                                              break;
                                            case 'delete':
                                              await _deleteRuleset(summary);
                                              break;
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'duplicate',
                                            child: Text('Duplicate'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'export',
                                            child: Text('Export'),
                                          ),
                                          if (summary.mode != 'bundled')
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (summary.description
                                      .trim()
                                      .isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(summary.description),
                                  ],
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      _MetricChip(
                                        label: 'Entities',
                                        value: '${summary.entityCount}',
                                      ),
                                      _MetricChip(
                                        label: 'Schema',
                                        value: summary.schemaVersion,
                                      ),
                                      if (summary.author.trim().isNotEmpty)
                                        _MetricChip(
                                          label: 'Author',
                                          value: summary.author,
                                        ),
                                      _MetricChip(
                                        label: 'Version',
                                        value: summary.version,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _BootstrapStatusCard extends StatelessWidget {
  final String label;
  final double progress;

  const _BootstrapStatusCard({required this.label, required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).clamp(0, 100).round();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress == 0 ? null : progress),
            const SizedBox(height: 10),
            Text('$percent% complete'),
          ],
        ),
      ),
    );
  }
}

class _BootstrapErrorCard extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _BootstrapErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bundled compendium indexing failed',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(message),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String mode;

  const _ModeChip({required this.mode});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final config = switch (mode) {
      'bundled' => (label: 'Bundled', color: colorScheme.primary),
      'editable' => (label: 'Editable', color: colorScheme.tertiary),
      _ => (label: 'Imported', color: colorScheme.secondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        config.label,
        style: TextStyle(color: config.color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;

  const _MetricChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}

class _CreateRulesetResult {
  final String name;
  final String description;

  const _CreateRulesetResult({required this.name, required this.description});
}

class _CreateRulesetDialog extends StatefulWidget {
  const _CreateRulesetDialog();

  @override
  State<_CreateRulesetDialog> createState() => _CreateRulesetDialogState();
}

class _CreateRulesetDialogState extends State<_CreateRulesetDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Ruleset'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) {
              return;
            }
            Navigator.of(context).pop(
              _CreateRulesetResult(
                name: name,
                description: _descriptionController.text.trim(),
              ),
            );
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
