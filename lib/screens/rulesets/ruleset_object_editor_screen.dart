import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_relationship_validator.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_editor.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_summary_sections.dart';
import 'package:openrpg/screens/rulesets/compendium_structured_editor.dart';
import 'package:openrpg/screens/rulesets/compendium_structured_support.dart';

class RulesetObjectEditorScreen extends StatefulWidget {
  final String entityType;
  final String? rulesetId;
  final CompendiumEntity? initialEntity;
  final CompendiumEditorDescriptor? descriptorOverride;
  final CompendiumBrowseRepository? browseRepository;

  const RulesetObjectEditorScreen({
    super.key,
    required this.entityType,
    this.rulesetId,
    this.initialEntity,
    this.descriptorOverride,
    this.browseRepository,
  });

  @override
  State<RulesetObjectEditorScreen> createState() =>
      _RulesetObjectEditorScreenState();
}

class _RulesetObjectEditorScreenState extends State<RulesetObjectEditorScreen> {
  late Map<String, dynamic> _draftData;
  late final CompendiumBrowseRepository _fallbackBrowseRepository =
      CompendiumBrowseRepository();
  Future<CompendiumEntityValidationReport?>? _futureValidationReport;
  Timer? _validationDebounce;

  bool get _isEditing => widget.initialEntity != null;

  CompendiumEditorDescriptor? get _descriptor =>
      widget.descriptorOverride ?? editorDescriptorForType(widget.entityType);
  bool get _isReadOnlyType =>
      _descriptor == null || _descriptor!.fields.isEmpty;

  CompendiumBrowseRepository get _browseRepository =>
      widget.browseRepository ?? _fallbackBrowseRepository;

  @override
  void initState() {
    super.initState();
    _draftData = CompendiumJsonUtils.deepCopyMap(
      widget.initialEntity?.data ?? _buildInitialData(),
    );
    _futureValidationReport = _buildValidationFuture();
  }

  Map<String, dynamic> _buildInitialData() {
    final fields = _descriptor?.fields ?? const <CompendiumFieldDescriptor>[];
    final data = <String, dynamic>{};
    for (final field in fields) {
      final defaultValue = compendiumDefaultValue(field);
      if (defaultValue != null) {
        data[field.key] = defaultValue;
      }
    }
    return data;
  }

  @override
  void didUpdateWidget(covariant RulesetObjectEditorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final entityIdentityChanged =
        oldWidget.entityType != widget.entityType ||
        oldWidget.initialEntity?.id != widget.initialEntity?.id ||
        (oldWidget.initialEntity == null) != (widget.initialEntity == null);
    if (entityIdentityChanged) {
      _draftData = CompendiumJsonUtils.deepCopyMap(
        widget.initialEntity?.data ?? _buildInitialData(),
      );
    }

    if (entityIdentityChanged ||
        oldWidget.rulesetId != widget.rulesetId ||
        oldWidget.browseRepository != widget.browseRepository) {
      _futureValidationReport = _buildValidationFuture();
    }
  }

  @override
  void dispose() {
    _validationDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final descriptor = _descriptor;
    final validationMessages = _validationMessages();
    final previewName = _draftName;
    final previewId = _draftEntityId;
    final readOnlyLabel = descriptor?.label ?? widget.entityType;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isReadOnlyType
              ? 'Read-only $readOnlyLabel'
              : _isEditing
              ? 'Edit $readOnlyLabel'
              : 'New $readOnlyLabel',
        ),
        actions: [
          if (!_isReadOnlyType)
            IconButton(onPressed: _save, icon: const Icon(Icons.save_outlined)),
        ],
      ),
      body: descriptor == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No structured editor descriptor is available for "$readOnlyLabel" yet.\n\n'
                  'This entity type is currently read-only, so authoring and save actions are disabled until a descriptor is registered.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Structured authoring',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Edit the structured fields below, keep an eye on live relationship validation, and use the preview surface to confirm how the entry reads before saving it back into the ruleset.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (widget.rulesetId != null) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Inline references are checked against this ruleset as you type. Use tokens like {@spell Magic Missile|SRD} when you want previewable links.',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (validationMessages.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Validation',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer,
                                ),
                          ),
                          const SizedBox(height: 8),
                          ...validationMessages.map(
                            (message) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                message,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onErrorContainer,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                for (final field in descriptor.fields)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CompendiumStructuredFieldEditor(
                      field: field,
                      currentData: _draftData,
                      onMutate: _applyDraftMutation,
                      onEditRawJson: _showJsonEditor,
                    ),
                  ),
                if (descriptor.fields.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      'This entity type is currently read-only. Add an editor descriptor before authoring entries in the app.',
                    ),
                  ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          previewId,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Live Preview',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          previewName.isEmpty ? 'Untitled' : previewName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        CompendiumEntitySummarySections(
                          entityType: widget.entityType,
                          data: _draftData,
                          compact: false,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_futureValidationReport != null) ...[
                  const SizedBox(height: 16),
                  FutureBuilder<CompendiumEntityValidationReport?>(
                    future: _futureValidationReport,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Checking duplicate ids, unresolved references, and inline link tokens...',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Card(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Relationship validation failed.\n${snapshot.error}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onErrorContainer,
                                  ),
                            ),
                          ),
                        );
                      }

                      final report = snapshot.data;
                      if (report == null) {
                        return const SizedBox.shrink();
                      }

                      return _EditorReferenceValidationCard(
                        report: report,
                        onPreviewReference: (reference) {
                          showCompendiumEntityPreviewSurface(
                            context,
                            rulesetId: reference.preview.rulesetId,
                            entityType: reference.preview.entityType,
                            entityId: reference.preview.entityId,
                            entityName: reference.preview.displayName,
                            browseRepository: _browseRepository,
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
    );
  }

  String get _draftName => _draftData['name']?.toString().trim() ?? '';

  String get _draftEntityId =>
      widget.initialEntity?.id ??
      CompendiumJsonUtils.stableEntityId(
        entityType: widget.entityType,
        payload: <String, dynamic>{'name': _draftName, 'data': _draftData},
      );

  List<String> _validationMessages() {
    final messages = <String>[];
    if (_draftName.isEmpty) {
      messages.add('Name is required before this entry can be saved.');
    }
    return messages;
  }

  void _applyDraftMutation(VoidCallback mutation) {
    setState(mutation);
    _scheduleValidation();
  }

  void _scheduleValidation() {
    if (widget.rulesetId == null) {
      return;
    }

    _validationDebounce?.cancel();
    _validationDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _futureValidationReport = _buildValidationFuture();
      });
    });
  }

  Future<CompendiumEntityValidationReport?> _buildValidationFuture() async {
    final rulesetId = widget.rulesetId;
    if (rulesetId == null) {
      return null;
    }

    final page = await _browseRepository.loadCollectionPage(
      rulesetId: rulesetId,
      entityType: widget.entityType,
      page: 0,
      pageSize: 5000,
    );

    return validateCompendiumEntityData(
      browseRepository: _browseRepository,
      rulesetId: rulesetId,
      entityType: widget.entityType,
      entityId: _draftEntityId,
      displayName: _draftName.isEmpty ? 'Untitled' : _draftName,
      data: _draftData,
      existingEntityIds: page.items.map((item) => item.entityId),
      currentEntityId: widget.initialEntity?.id,
    );
  }

  Future<dynamic> _showJsonEditor({
    required String title,
    required dynamic initialValue,
  }) async {
    final controller = TextEditingController(
      text: initialValue == null
          ? ''
          : CompendiumJsonUtils.prettyJson(initialValue),
    );
    return showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 520,
            child: TextField(
              controller: controller,
              minLines: 8,
              maxLines: 18,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter valid JSON',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final raw = controller.text.trim();
                if (raw.isEmpty) {
                  Navigator.of(context).pop(null);
                  return;
                }

                try {
                  Navigator.of(context).pop(jsonDecode(raw));
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid JSON.')),
                  );
                }
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save() async {
    if (_isReadOnlyType) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This entity type is read-only in the current editor.'),
        ),
      );
      return;
    }

    final name = _draftName;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required before saving.')),
      );
      return;
    }

    final validationReport = await _buildValidationFuture();
    if (!mounted) {
      return;
    }

    final duplicateId = validationReport?.issues.any(
      (issue) => issue.kind == CompendiumValidationIssueKind.duplicateId,
    );
    if (duplicateId == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Another entry already uses this id. Rename the entry or adjust the data before saving.',
          ),
        ),
      );
      setState(() {
        _futureValidationReport =
            Future<CompendiumEntityValidationReport?>.value(validationReport);
      });
      return;
    }

    final json = <String, dynamic>{
      'id': _draftEntityId,
      'name': name,
      'data': _draftData,
    };

    final entity = parseEntityJson(widget.entityType, json);
    if (entity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to create entity for this type.')),
      );
      return;
    }

    Navigator.of(context).pop(entity);
  }
}

class _EditorReferenceValidationCard extends StatelessWidget {
  final CompendiumEntityValidationReport report;
  final ValueChanged<CompendiumResolvedReference> onPreviewReference;

  const _EditorReferenceValidationCard({
    required this.report,
    required this.onPreviewReference,
  });

  @override
  Widget build(BuildContext context) {
    final issues = report.issues;
    final resolvedReferences = report.resolvedReferences;
    final hasIssues = issues.isNotEmpty;

    return Card(
      color: hasIssues ? Theme.of(context).colorScheme.errorContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Relationship Validation',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: hasIssues
                    ? Theme.of(context).colorScheme.onErrorContainer
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasIssues
                  ? 'Fix the issues below or save with the warnings you intend to keep.'
                  : 'No duplicate ids or broken references were detected in this draft.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: hasIssues
                    ? Theme.of(context).colorScheme.onErrorContainer
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Chip(
                  label: Text(
                    '${report.detectedReferences.length} detected refs',
                  ),
                ),
                Chip(
                  label: Text('${resolvedReferences.length} resolved previews'),
                ),
                Chip(
                  label: Text(
                    '${report.unresolvedReferenceCount} unresolved refs',
                  ),
                ),
                Chip(
                  label: Text('${report.malformedTokenCount} malformed tokens'),
                ),
              ],
            ),
            if (issues.isNotEmpty) ...[
              const SizedBox(height: 14),
              ...issues.map(
                (issue) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    issue.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: hasIssues
                          ? Theme.of(context).colorScheme.onErrorContainer
                          : null,
                    ),
                  ),
                ),
              ),
            ],
            if (resolvedReferences.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                'Reference Preview',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: hasIssues
                      ? Theme.of(context).colorScheme.onErrorContainer
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: resolvedReferences
                    .map(
                      (reference) => ActionChip(
                        avatar: const Icon(Icons.visibility_outlined, size: 18),
                        label: Text(reference.preview.displayName),
                        onPressed: () => onPreviewReference(reference),
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
