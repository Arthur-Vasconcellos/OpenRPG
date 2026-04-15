import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_editor.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';

class RulesetObjectEditorScreen extends StatefulWidget {
  final String entityType;
  final CompendiumEntity? initialEntity;

  const RulesetObjectEditorScreen({
    super.key,
    required this.entityType,
    this.initialEntity,
  });

  @override
  State<RulesetObjectEditorScreen> createState() =>
      _RulesetObjectEditorScreenState();
}

class _RulesetObjectEditorScreenState extends State<RulesetObjectEditorScreen> {
  late Map<String, dynamic> _draftData;

  bool get _isEditing => widget.initialEntity != null;

  CompendiumEditorDescriptor? get _descriptor =>
      editorDescriptorForType(widget.entityType);

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
      final defaultValue = _defaultValue(field);
      if (defaultValue != null) {
        data[field.key] = defaultValue;
      }
    }
    return data;
  }

  dynamic _defaultValue(CompendiumFieldDescriptor field) {
    if (field.isArray) {
      return <dynamic>[];
    }

    switch (field.kind) {
      case CompendiumFieldKind.boolean:
        return false;
      case CompendiumFieldKind.object:
        return <String, dynamic>{};
      case CompendiumFieldKind.dynamic:
      case CompendiumFieldKind.integer:
      case CompendiumFieldKind.number:
      case CompendiumFieldKind.string:
      case CompendiumFieldKind.list:
        return null;
    }
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
              children: _buildFields(descriptor.fields, _draftData),
            ),
    );
  }

  List<Widget> _buildFields(
    List<CompendiumFieldDescriptor> fields,
    Map<String, dynamic> currentData,
  ) {
    final widgets = <Widget>[];
    for (final field in fields) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildField(field, currentData),
        ),
      );
    }

    if (widgets.isEmpty) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text('No editable fields are available for this entity type.'),
        ),
      );
    }

    return widgets;
  }

  Widget _buildField(
    CompendiumFieldDescriptor field,
    Map<String, dynamic> currentData,
  ) {
    if (field.isArray) {
      return _buildListField(field, currentData);
    }

    switch (field.kind) {
      case CompendiumFieldKind.boolean:
        return SwitchListTile(
          title: Text(field.label),
          subtitle: Text(field.key),
          value: currentData[field.key] == true,
          onChanged: (value) {
            setState(() {
              currentData[field.key] = value;
            });
          },
        );
      case CompendiumFieldKind.object:
        if (field.fields.isEmpty) {
          return _buildRawJsonField(field, currentData);
        }
        final nested = _ensureMap(currentData, field.key);
        return Card(
          child: ExpansionTile(
            title: Text(field.label),
            subtitle: Text(field.key),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: _buildFields(field.fields, nested),
          ),
        );
      case CompendiumFieldKind.dynamic:
      case CompendiumFieldKind.list:
        return _buildRawJsonField(field, currentData);
      case CompendiumFieldKind.integer:
      case CompendiumFieldKind.number:
      case CompendiumFieldKind.string:
        return TextFormField(
          key: ValueKey('${field.key}:${currentData[field.key]}'),
          initialValue: currentData[field.key]?.toString() ?? '',
          decoration: InputDecoration(
            labelText: field.label,
            helperText: field.key,
            border: const OutlineInputBorder(),
          ),
          keyboardType: field.kind == CompendiumFieldKind.string
              ? TextInputType.text
              : const TextInputType.numberWithOptions(decimal: true),
          minLines: field.kind == CompendiumFieldKind.string ? 1 : null,
          maxLines: field.kind == CompendiumFieldKind.string ? null : 1,
          onChanged: (value) {
            setState(() {
              final parsed = _parsePrimitive(field.kind, value);
              if (parsed == null && value.trim().isEmpty) {
                currentData.remove(field.key);
              } else {
                currentData[field.key] = parsed;
              }
            });
          },
        );
    }
  }

  Widget _buildListField(
    CompendiumFieldDescriptor field,
    Map<String, dynamic> currentData,
  ) {
    final values = _ensureList(currentData, field.key);
    final itemDescriptor = field.itemDescriptor;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    field.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      values.add(_newListItem(itemDescriptor));
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (values.isEmpty) const Text('No items yet.'),
            for (var index = 0; index < values.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildListItem(field, values, index, itemDescriptor),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
    CompendiumFieldDescriptor field,
    List<dynamic> values,
    int index,
    CompendiumFieldDescriptor? itemDescriptor,
  ) {
    final itemValue = values[index];
    if (itemDescriptor == null ||
        itemDescriptor.kind == CompendiumFieldKind.dynamic ||
        itemDescriptor.kind == CompendiumFieldKind.list) {
      return _buildRawListItem(field, values, index);
    }

    if (itemDescriptor.kind == CompendiumFieldKind.object &&
        itemDescriptor.fields.isNotEmpty) {
      final itemData = itemValue is Map<String, dynamic>
          ? itemValue
          : <String, dynamic>{};
      values[index] = itemData;
      return Card(
        color: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withValues(alpha: 0.24),
        child: ExpansionTile(
          title: Text('${field.label} #${index + 1}'),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                values.removeAt(index);
              });
            },
            icon: const Icon(Icons.delete_outline),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: _buildFields(itemDescriptor.fields, itemData),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            key: ValueKey('${field.key}:$index:${values[index]}'),
            initialValue: itemValue?.toString() ?? '',
            decoration: InputDecoration(
              labelText: '${field.label} #${index + 1}',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                values[index] = _parsePrimitive(itemDescriptor.kind, value);
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            setState(() {
              values.removeAt(index);
            });
          },
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }

  Widget _buildRawJsonField(
    CompendiumFieldDescriptor field,
    Map<String, dynamic> currentData,
  ) {
    final currentValue = currentData[field.key];
    return Card(
      child: ListTile(
        title: Text(field.label),
        subtitle: Text(
          currentValue == null
              ? 'Edit JSON'
              : CompendiumJsonUtils.prettyJson(currentValue),
        ),
        trailing: const Icon(Icons.edit_outlined),
        onTap: () async {
          final updated = await _showJsonEditor(
            title: field.label,
            initialValue: currentValue,
          );
          if (updated == null) {
            return;
          }

          setState(() {
            currentData[field.key] = updated;
          });
        },
      ),
    );
  }

  Widget _buildRawListItem(
    CompendiumFieldDescriptor field,
    List<dynamic> values,
    int index,
  ) {
    return Card(
      color: Theme.of(
        context,
      ).colorScheme.secondaryContainer.withValues(alpha: 0.24),
      child: ListTile(
        title: Text('${field.label} #${index + 1}'),
        subtitle: Text(CompendiumJsonUtils.prettyJson(values[index])),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              onPressed: () async {
                final updated = await _showJsonEditor(
                  title: '${field.label} #${index + 1}',
                  initialValue: values[index],
                );
                if (updated == null) {
                  return;
                }

                setState(() {
                  values[index] = updated;
                });
              },
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  values.removeAt(index);
                });
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
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

  Map<String, dynamic> _ensureMap(
    Map<String, dynamic> currentData,
    String key,
  ) {
    final existing = currentData[key];
    if (existing is Map<String, dynamic>) {
      return existing;
    }

    final created = <String, dynamic>{};
    currentData[key] = created;
    return created;
  }

  List<dynamic> _ensureList(Map<String, dynamic> currentData, String key) {
    final existing = currentData[key];
    if (existing is List<dynamic>) {
      return existing;
    }

    final created = <dynamic>[];
    currentData[key] = created;
    return created;
  }

  dynamic _newListItem(CompendiumFieldDescriptor? descriptor) {
    if (descriptor == null) {
      return <String, dynamic>{};
    }

    if (descriptor.isArray) {
      return <dynamic>[];
    }

    switch (descriptor.kind) {
      case CompendiumFieldKind.boolean:
        return false;
      case CompendiumFieldKind.object:
        final map = <String, dynamic>{};
        for (final field in descriptor.fields) {
          final defaultValue = _defaultValue(field);
          if (defaultValue != null) {
            map[field.key] = defaultValue;
          }
        }
        return map;
      case CompendiumFieldKind.dynamic:
      case CompendiumFieldKind.list:
        return <String, dynamic>{};
      case CompendiumFieldKind.integer:
      case CompendiumFieldKind.number:
      case CompendiumFieldKind.string:
        return null;
    }
  }

  dynamic _parsePrimitive(CompendiumFieldKind kind, String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    switch (kind) {
      case CompendiumFieldKind.integer:
        return int.tryParse(trimmed);
      case CompendiumFieldKind.number:
        return num.tryParse(trimmed);
      case CompendiumFieldKind.boolean:
        return trimmed.toLowerCase() == 'true';
      case CompendiumFieldKind.object:
      case CompendiumFieldKind.dynamic:
      case CompendiumFieldKind.list:
      case CompendiumFieldKind.string:
        return trimmed;
    }
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
