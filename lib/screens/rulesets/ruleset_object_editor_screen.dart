import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_editor.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/screens/rulesets/compendium_structured_editor.dart';
import 'package:openrpg/screens/rulesets/compendium_structured_support.dart';

class RulesetObjectEditorScreen extends StatefulWidget {
  final String entityType;
  final CompendiumEntity? initialEntity;
  final CompendiumEditorDescriptor? descriptorOverride;

  const RulesetObjectEditorScreen({
    super.key,
    required this.entityType,
    this.initialEntity,
    this.descriptorOverride,
  });

  @override
  State<RulesetObjectEditorScreen> createState() =>
      _RulesetObjectEditorScreenState();
}

class _RulesetObjectEditorScreenState extends State<RulesetObjectEditorScreen> {
  late Map<String, dynamic> _draftData;

  bool get _isEditing => widget.initialEntity != null;

  CompendiumEditorDescriptor? get _descriptor =>
      widget.descriptorOverride ?? editorDescriptorForType(widget.entityType);

  @override
  void initState() {
    super.initState();
    _draftData = CompendiumJsonUtils.deepCopyMap(
      widget.initialEntity?.data ?? _buildInitialData(),
    );
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
  Widget build(BuildContext context) {
    final descriptor = _descriptor;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? 'Edit ${descriptor?.label ?? widget.entityType}'
              : 'New ${descriptor?.label ?? widget.entityType}',
        ),
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.save_outlined)),
        ],
      ),
      body: descriptor == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No editor descriptor is available for this entity type yet.',
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final field in descriptor.fields)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CompendiumStructuredFieldEditor(
                      field: field,
                      currentData: _draftData,
                      onMutate: (mutation) => setState(mutation),
                      onEditRawJson: _showJsonEditor,
                    ),
                  ),
                if (descriptor.fields.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      'No editable fields are available for this entity type.',
                    ),
                  ),
              ],
            ),
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

  void _save() {
    final name = _draftData['name']?.toString().trim() ?? '';
    final source =
        _draftData['source']?.toString().trim() ??
        widget.initialEntity?.source ??
        'HB';
    final page = _draftData['page']?.toString();
    final json = <String, dynamic>{
      'id':
          widget.initialEntity?.id ??
          CompendiumJsonUtils.stableEntityId(
            entityType: widget.entityType,
            source: source,
            name: name,
            page: page,
          ),
      'name': name.isEmpty
          ? widget.initialEntity?.displayName ?? 'Untitled'
          : name,
      'source': source,
      'sourceFile':
          widget.initialEntity?.sourceFile ??
          'custom/${widget.entityType}.json',
      if (_draftData['edition'] != null)
        'edition': _draftData['edition'].toString(),
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
