import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_bootstrap_service.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_import_controller.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/models/compendium_browse_asset.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/screens/characters/character_creation_flow.dart';
import 'package:openrpg/screens/rulesets/ruleset_detail_screen.dart';

class RulesetLibraryScreen extends StatefulWidget {
  final CompendiumBootstrapService bootstrapService;
  final CompendiumBrowseRepository browseRepository;
  final CompendiumRepository repository;
  final CompendiumImportController? importController;

  RulesetLibraryScreen({
    super.key,
    CompendiumBootstrapService? bootstrapService,
    CompendiumBrowseRepository? browseRepository,
    CompendiumRepository? repository,
    this.importController,
  }) : bootstrapService = bootstrapService ?? CompendiumBootstrapService(),
       browseRepository = browseRepository ?? CompendiumBrowseRepository(),
       repository = repository ?? CompendiumRepository();

  @override
  State<RulesetLibraryScreen> createState() => _RulesetLibraryScreenState();
}

enum _RulesetLibraryStartupState { idle, bootstrapping, ready, failed }

class _RulesetLibraryScreenState extends State<RulesetLibraryScreen> {
  late final Stream<List<RulesetSummary>> _rulesetStream;
  Stream<CompendiumBootstrapStatus>? _bootstrapStatusStream;
  _RulesetLibraryStartupState _startupState = _RulesetLibraryStartupState.idle;
  String? _startupErrorMessage;
  String _modeFilter = 'all';
  final TextEditingController _authorFilterController = TextEditingController();

  CompendiumImportController? get _importController =>
      widget.importController ??
      CompendiumImportControllerScope.maybeOf(context);

  @override
  void initState() {
    super.initState();
    _rulesetStream = widget.browseRepository.watchInstalledRulesets();
    unawaited(_initializeBootstrap());
  }

  @override
  void dispose() {
    _authorFilterController.dispose();
    super.dispose();
  }

  Future<void> _initializeBootstrap() async {
    _commitStartupState(
      _RulesetLibraryStartupState.bootstrapping,
      errorMessage: null,
    );

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
      });

      await widget.bootstrapService.ensureBootstrappedWithManifest(manifest);
      _commitStartupState(
        _RulesetLibraryStartupState.ready,
        errorMessage: null,
      );
    } catch (error, stackTrace) {
      _reportBootstrapError(error, stackTrace);
      _commitStartupState(
        _RulesetLibraryStartupState.failed,
        errorMessage: _formatStartupError(error),
      );
    }
  }

  void _commitStartupState(
    _RulesetLibraryStartupState state, {
    required String? errorMessage,
  }) {
    if (!mounted) {
      _startupState = state;
      _startupErrorMessage = errorMessage;
      return;
    }

    setState(() {
      _startupState = state;
      _startupErrorMessage = errorMessage;
    });
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
    final controller = _importController;
    if (controller == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Import is unavailable until the app scope is ready.'),
        ),
      );
      return;
    }

    await controller.startImportFromPicker();
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

  Future<void> _useRulesetForCharacter(RulesetSummary summary) async {
    await createCharacterFromRulesetFlow(
      context,
      preselectedRulesetId: summary.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final importController = _importController;
    final importTask =
        importController?.currentTask ?? const CompendiumImportTask.idle();
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
              _startupState == _RulesetLibraryStartupState.bootstrapping;
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
              final filteredRulesets = _filterRulesets(rulesets);
              final showPreparingShell =
                  rulesets.isEmpty &&
                  (isStartupInitializing || bootstrapStatus.isRunning);
              final showEmptyLibrary =
                  rulesets.isEmpty &&
                  _startupState == _RulesetLibraryStartupState.ready &&
                  !importTask.isRunning &&
                  !importTask.isFailed &&
                  !bootstrapStatus.isRunning &&
                  !bootstrapStatus.isFailed;

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
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
                      title: 'Indexing bundled compendium',
                      message: 'Preparing the built-in starter for browsing.',
                      progress: bootstrapStatus.progress,
                    ),
                  if (!hasStartupFailure && bootstrapStatus.isFailed)
                    _BootstrapErrorCard(
                      title: 'Bundled compendium indexing failed',
                      message:
                          bootstrapStatus.lastError ??
                          'The bundled compendium index failed to build.',
                      onRetry: _retryBootstrap,
                    ),
                  if (!hasStartupFailure &&
                      (bootstrapStatus.isRunning || bootstrapStatus.isFailed))
                    const SizedBox(height: 20),
                  if (importTask.isRunning)
                    _BootstrapStatusCard(
                      title:
                          'Importing ${importTask.fileName ?? 'ruleset.json'}',
                      message: importTask.statusMessage,
                      progress: importTask.progress,
                    ),
                  if (importTask.isFailed)
                    _BootstrapErrorCard(
                      title: 'Ruleset import failed',
                      message:
                          importTask.errorMessage ??
                          'The selected ruleset could not be imported.',
                      onRetry: () async {
                        await importController?.retryLastImport();
                      },
                    ),
                  if (importTask.isRunning || importTask.isFailed)
                    const SizedBox(height: 20),
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
                          'Built-in starter ruleset, editable homebrew, portable JSON.',
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
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filter library',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _modeFilter,
                            decoration: const InputDecoration(
                              labelText: 'Ruleset mode',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'all',
                                child: Text('All modes'),
                              ),
                              DropdownMenuItem(
                                value: 'bundled',
                                child: Text('Bundled'),
                              ),
                              DropdownMenuItem(
                                value: 'editable',
                                child: Text('Editable'),
                              ),
                              DropdownMenuItem(
                                value: 'imported',
                                child: Text('Imported'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _modeFilter = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _authorFilterController,
                            decoration: const InputDecoration(
                              labelText: 'Author filter',
                              hintText: 'Filter by author name',
                              prefixIcon: Icon(Icons.person_search_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  else if (filteredRulesets.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No rulesets matched the current filters.'),
                      ),
                    )
                  else if (filteredRulesets.isNotEmpty)
                    ...filteredRulesets.map((summary) {
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
                                  const SizedBox(height: 14),
                                  _RulesetCoverageRow(
                                    rulesetId: summary.id,
                                    browseRepository: widget.browseRepository,
                                  ),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      FilledButton.tonalIcon(
                                        onPressed: () =>
                                            _useRulesetForCharacter(summary),
                                        icon: const Icon(
                                          Icons.auto_awesome_outlined,
                                        ),
                                        label: const Text('Use for Character'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  RulesetDetailScreen(
                                                    rulesetId: summary.id,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: const Text('Open Ruleset'),
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

  List<RulesetSummary> _filterRulesets(List<RulesetSummary> rulesets) {
    final authorQuery = _authorFilterController.text.trim().toLowerCase();
    return rulesets
        .where((ruleset) {
          final modeMatches =
              _modeFilter == 'all' || ruleset.mode.toLowerCase() == _modeFilter;
          final authorMatches =
              authorQuery.isEmpty ||
              ruleset.author.toLowerCase().contains(authorQuery) ||
              ruleset.name.toLowerCase().contains(authorQuery);
          return modeMatches && authorMatches;
        })
        .toList(growable: false);
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
  final String title;
  final String message;
  final double progress;

  const _BootstrapStatusCard({
    required this.title,
    required this.message,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).clamp(0, 100).round();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message),
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
  final String title;
  final String message;
  final Future<void> Function() onRetry;

  const _BootstrapErrorCard({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
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

class _RulesetCoverageRow extends StatelessWidget {
  final String rulesetId;
  final CompendiumBrowseRepository browseRepository;

  const _RulesetCoverageRow({
    required this.rulesetId,
    required this.browseRepository,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RulesetCollectionSummary>>(
      future: browseRepository.loadCollectionSummaries(rulesetId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        final collections = snapshot.data ?? const <RulesetCollectionSummary>[];
        final metrics = <({String label, int count})>[
          (
            label: 'Classes',
            count: _countFor(collections, const [
              'class',
              'subclass',
              'classFeature',
              'subclassFeature',
            ]),
          ),
          (
            label: 'Races',
            count: _countFor(collections, const ['race', 'subrace']),
          ),
          (
            label: 'Backgrounds',
            count: _countFor(collections, const ['background']),
          ),
          (label: 'Spells', count: _countFor(collections, const ['spell'])),
          (label: 'Items', count: _countFor(collections, const ['item'])),
        ];

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: metrics
              .map(
                (metric) =>
                    Chip(label: Text('${metric.label}: ${metric.count}')),
              )
              .toList(growable: false),
        );
      },
    );
  }

  int _countFor(
    List<RulesetCollectionSummary> collections,
    List<String> entityTypes,
  ) {
    return collections
        .where((collection) => entityTypes.contains(collection.entityType))
        .fold<int>(0, (sum, collection) => sum + collection.entityCount);
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
