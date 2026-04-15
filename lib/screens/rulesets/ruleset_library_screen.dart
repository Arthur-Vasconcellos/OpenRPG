import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_bootstrap_service.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/models/compendium_browse_asset.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/rulesets/ruleset_detail_screen.dart';

class RulesetLibraryScreen extends StatefulWidget {
  final CompendiumBootstrapService bootstrapService;
  final CompendiumBrowseRepository browseRepository;
  final CompendiumRepository repository;

  RulesetLibraryScreen({
    super.key,
    CompendiumBootstrapService? bootstrapService,
    CompendiumBrowseRepository? browseRepository,
    CompendiumRepository? repository,
  }) : bootstrapService = bootstrapService ?? CompendiumBootstrapService(),
       browseRepository = browseRepository ?? CompendiumBrowseRepository(),
       repository = repository ?? CompendiumRepository();

  @override
  State<RulesetLibraryScreen> createState() => _RulesetLibraryScreenState();
}

enum _RulesetLibraryStartupState { initializing, ready, failed }

class _RulesetLibraryScreenState extends State<RulesetLibraryScreen> {
  late final Stream<List<RulesetSummary>> _rulesetStream;
  Stream<CompendiumBootstrapStatus>? _bootstrapStatusStream;
  _RulesetLibraryStartupState _startupState =
      _RulesetLibraryStartupState.initializing;
  String? _startupErrorMessage;

  @override
  void initState() {
    super.initState();
    _rulesetStream = widget.browseRepository.watchInstalledRulesets();
    unawaited(_initializeBootstrap());
  }

  Future<void> _initializeBootstrap() async {
    if (mounted) {
      setState(() {
        _startupState = _RulesetLibraryStartupState.initializing;
        _startupErrorMessage = null;
      });
    }

    String? bundledRulesetId;
    try {
      final manifest = await widget.bootstrapService.loadManifest();
      bundledRulesetId = _resolveBundledRulesetId(manifest);
      if (!mounted) {
        return;
      }

      setState(() {
        _bootstrapStatusStream = widget.bootstrapService.watchStatus(
          bundledRulesetId!,
        );
        _startupState = _RulesetLibraryStartupState.ready;
        _startupErrorMessage = null;
      });

      await widget.bootstrapService.ensureBootstrappedWithManifest(manifest);
    } catch (error, stackTrace) {
      final trackedFailure = await _hasTrackedBootstrapFailure(
        bundledRulesetId,
      );
      _reportBootstrapError(error, stackTrace);
      if (!mounted || trackedFailure) {
        return;
      }

      setState(() {
        _startupState = _RulesetLibraryStartupState.failed;
        _startupErrorMessage = _formatStartupError(error);
      });
    }
  }

  String _resolveBundledRulesetId(CompendiumBrowseManifest manifest) {
    if (manifest.rulesets.isEmpty) {
      throw const CompendiumBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.manifestValidation,
        message: 'The bundled starter manifest does not list any rulesets.',
      );
    }

    final rulesetId = manifest.rulesets.first.rulesetId.trim();
    if (rulesetId.isEmpty) {
      throw const CompendiumBootstrapFailure(
        stage: CompendiumBootstrapFailureStage.manifestValidation,
        message: 'The bundled starter manifest is missing a ruleset id.',
      );
    }

    return rulesetId;
  }

  Future<bool> _hasTrackedBootstrapFailure(String? rulesetId) async {
    if (rulesetId == null || rulesetId.isEmpty) {
      return false;
    }

    try {
      final status = await widget.bootstrapService.loadStatus(rulesetId);
      return status.isFailed;
    } catch (_) {
      return false;
    }
  }

  String _formatStartupError(Object error) {
    if (error is CompendiumBootstrapFailure) {
      return error.toString();
    }

    return error.toString();
  }

  void _reportBootstrapError(Object error, StackTrace stackTrace) {
    debugPrint(
      'Ruleset library bootstrap error while preparing the bundled starter:\n$error\n$stackTrace',
    );
  }

  Future<void> _retryBootstrap() async {
    await _initializeBootstrap();
  }

  Future<void> _createRuleset() async {
    final result = await showDialog<_CreateRulesetResult>(
      context: context,
      builder: (_) => const _CreateRulesetDialog(),
    );
    if (result == null) {
      return;
    }

    final created = await widget.repository.createRuleset(
      name: result.name,
      description: result.description,
    );
    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RulesetDetailScreen(rulesetId: created.id),
      ),
    );
  }

  Future<void> _importRuleset() async {
    try {
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
      final imported = await widget.repository.importRulesetJson(jsonString);
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imported ${file.name} successfully.')),
      );
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RulesetDetailScreen(rulesetId: imported.id),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Import failed: $error')));
    }
  }

  Future<void> _duplicateRuleset(RulesetSummary summary) async {
    final duplicate = await widget.repository.duplicateRuleset(summary.id);
    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RulesetDetailScreen(rulesetId: duplicate.id),
      ),
    );
  }

  Future<void> _exportRuleset(RulesetSummary summary) async {
    try {
      final export = await widget.repository.exportRulesetFile(summary.id);
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported via ${export.locationDescription}.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $error')));
    }
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

    await widget.repository.deleteRuleset(summary.id);
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
          final isStartupInitializing =
              _startupState == _RulesetLibraryStartupState.initializing;
          final hasStartupFailure =
              _startupState == _RulesetLibraryStartupState.failed &&
              (_startupErrorMessage?.trim().isNotEmpty ?? false);

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
              final showPreparingShell =
                  rulesets.isEmpty &&
                  (isStartupInitializing ||
                      (_startupState == _RulesetLibraryStartupState.ready &&
                          _bootstrapStatusStream != null &&
                          !bootstrapStatus.isReady &&
                          !bootstrapStatus.isFailed));
              final showEmptyLibrary =
                  rulesets.isEmpty &&
                  _startupState == _RulesetLibraryStartupState.ready &&
                  !bootstrapStatus.isRunning &&
                  !bootstrapStatus.isFailed;

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
                          'Built-in 2024 SRD starter ruleset, editable homebrew, portable JSON.',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'The starter compendium indexes in the background so the library stays responsive, and you can still import JSON or create blank rulesets immediately.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bring content in or out',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Import JSON from your device, duplicate the bundled starter into editable homebrew, or export any editable ruleset when you want to share it.',
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              FilledButton.tonalIcon(
                                onPressed: _importRuleset,
                                icon: const Icon(Icons.file_upload_outlined),
                                label: const Text('Import JSON'),
                              ),
                              FilledButton.tonalIcon(
                                onPressed: _createRuleset,
                                icon: const Icon(Icons.add),
                                label: const Text('Blank Ruleset'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isStartupInitializing)
                    const _StartupStatusCard(
                      message:
                          'Preparing the bundled starter and wiring up bootstrap status...',
                    ),
                  if (hasStartupFailure)
                    _StartupFailureCard(
                      message: _startupErrorMessage!,
                      onRetry: _retryBootstrap,
                    ),
                  if (isStartupInitializing || hasStartupFailure)
                    const SizedBox(height: 20),
                  if (!hasStartupFailure && bootstrapStatus.isRunning)
                    _BootstrapStatusCard(
                      label: 'Indexing bundled compendium',
                      progress: bootstrapStatus.progress,
                    ),
                  if (!hasStartupFailure && bootstrapStatus.isFailed)
                    _BootstrapErrorCard(
                      message:
                          bootstrapStatus.lastError ??
                          'The bundled compendium index failed to build.',
                      onRetry: _retryBootstrap,
                    ),
                  if (!hasStartupFailure &&
                      (bootstrapStatus.isRunning || bootstrapStatus.isFailed))
                    const SizedBox(height: 20),
                  if (showPreparingShell)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Preparing the bundled compendium...'),
                      ),
                    )
                  else if (showEmptyLibrary)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            const Text(
                              'No rulesets installed yet.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: _importRuleset,
                                  child: const Text('Import JSON'),
                                ),
                                OutlinedButton(
                                  onPressed: _createRuleset,
                                  child: const Text('Create Blank Ruleset'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (rulesets.isNotEmpty)
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

class _StartupStatusCard extends StatelessWidget {
  final String message;

  const _StartupStatusCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preparing Bundled Starter',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class _StartupFailureCard extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _StartupFailureCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bundled starter startup failed',
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
