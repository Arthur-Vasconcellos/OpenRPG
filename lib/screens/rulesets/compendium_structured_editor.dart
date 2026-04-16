import 'package:flutter/material.dart';
import 'package:openrpg/compendium/models/compendium_editor.dart';
import 'package:openrpg/screens/rulesets/compendium_structured_support.dart';

typedef CompendiumFieldMutationRunner = void Function(VoidCallback mutation);
typedef CompendiumJsonEditorLauncher =
    Future<dynamic> Function({
      required String title,
      required dynamic initialValue,
    });

class CompendiumStructuredFieldEditor extends StatelessWidget {
  final CompendiumFieldDescriptor field;
  final Map<String, dynamic> currentData;
  final CompendiumFieldMutationRunner onMutate;
  final CompendiumJsonEditorLauncher onEditRawJson;
  final VoidCallback? onRemove;

  const CompendiumStructuredFieldEditor({
    super.key,
    required this.field,
    required this.currentData,
    required this.onMutate,
    required this.onEditRawJson,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final value = currentData[field.key];

    if (field.isArray ||
        field.kind == CompendiumFieldKind.list ||
        value is List<dynamic>) {
      return _buildListField(context, value);
    }

    if (field.kind == CompendiumFieldKind.dynamic) {
      return _buildDynamicField(context, value);
    }

    if (field.kind == CompendiumFieldKind.object || value is Map) {
      return _buildObjectField(context, value, allowAddFields: false);
    }

    if (field.choices.isNotEmpty) {
      return _buildChoiceField(context, value);
    }

    switch (field.kind) {
      case CompendiumFieldKind.boolean:
        return _buildBooleanField(context, value);
      case CompendiumFieldKind.integer:
      case CompendiumFieldKind.number:
      case CompendiumFieldKind.string:
        return _buildPrimitiveField(context, value);
      case CompendiumFieldKind.object:
      case CompendiumFieldKind.list:
      case CompendiumFieldKind.dynamic:
        return _buildRawJsonField(context, value);
    }
  }

  Widget _buildChoiceField(BuildContext context, dynamic value) {
    final selected = field.choices.contains(value?.toString())
        ? value?.toString()
        : null;

    return _EditorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditorHeading(field: field),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('${field.key}:dropdown'),
            initialValue: selected,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select a value',
            ),
            items: field.choices
                .map(
                  (choice) => DropdownMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  ),
                )
                .toList(growable: false),
            onChanged: (next) {
              onMutate(() {
                _setFieldValue(next);
              });
            },
          ),
          _buildFooterActions(context, allowRawJson: false),
        ],
      ),
    );
  }

  Widget _buildBooleanField(BuildContext context, dynamic value) {
    final enabled = value == true;
    return _EditorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _EditorHeading(field: field)),
              Switch(
                value: enabled,
                onChanged: (next) {
                  onMutate(() {
                    _setFieldValue(next);
                  });
                },
              ),
            ],
          ),
          _buildFooterActions(context, allowRawJson: false),
        ],
      ),
    );
  }

  Widget _buildPrimitiveField(BuildContext context, dynamic value) {
    final inputType = field.kind == CompendiumFieldKind.string
        ? TextInputType.text
        : const TextInputType.numberWithOptions(decimal: true);

    return _EditorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditorHeading(field: field),
          const SizedBox(height: 12),
          TextFormField(
            key: ValueKey('${field.key}:${value ?? ''}'),
            initialValue: value?.toString() ?? '',
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: inputType,
            minLines: field.kind == CompendiumFieldKind.string ? 1 : null,
            maxLines: field.kind == CompendiumFieldKind.string ? null : 1,
            onChanged: (raw) {
              onMutate(() {
                final parsed = _parsePrimitive(field.kind, raw);
                if (parsed == null && raw.trim().isEmpty) {
                  currentData.remove(field.key);
                } else {
                  currentData[field.key] = parsed;
                }
              });
            },
          ),
          _buildFooterActions(context, allowRawJson: false),
        ],
      ),
    );
  }

  Widget _buildObjectField(
    BuildContext context,
    dynamic value, {
    required bool allowAddFields,
  }) {
    if (value == null && field.fields.isNotEmpty) {
      return _buildCreateSectionCard(
        context,
        message:
            'This section is empty. Create the structured section or edit raw JSON.',
        onCreate: () {
          onMutate(() {
            currentData[field.key] = _defaultMapForFields(field.fields);
          });
        },
      );
    }

    if (value != null && value is! Map) {
      return _buildRawJsonField(context, value);
    }

    final mapValue = value is Map<String, dynamic>
        ? value
        : compendiumAsMap(value);
    final mergedFields = compendiumMergeKnownAndInferredFields(
      field.fields,
      mapValue,
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(field.label),
        subtitle: Text(field.key),
        initiallyExpanded: mapValue.isNotEmpty,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          if (mergedFields.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('No fields are available in this section yet.'),
            ),
          for (final nestedField in mergedFields)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CompendiumStructuredFieldEditor(
                field: nestedField,
                currentData: mapValue,
                onMutate: (mutation) {
                  onMutate(() {
                    currentData[field.key] = mapValue;
                    mutation();
                  });
                },
                onEditRawJson: onEditRawJson,
                onRemove:
                    field.fields.any((known) => known.key == nestedField.key)
                    ? null
                    : () {
                        onMutate(() {
                          mapValue.remove(nestedField.key);
                          currentData[field.key] = mapValue;
                        });
                      },
              ),
            ),
          _buildFooterActions(
            context,
            allowRawJson: true,
            rawJsonValue: mapValue,
            allowAddField: allowAddFields,
            onAddField: () => _showAddMapEntryDialog(context, mapValue),
          ),
        ],
      ),
    );
  }

  Widget _buildListField(BuildContext context, dynamic value) {
    final values = value is List<dynamic> ? value : compendiumAsList(value);

    return _EditorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _EditorHeading(field: field)),
              const SizedBox(width: 12),
              _buildListAddButton(context, values),
            ],
          ),
          const SizedBox(height: 12),
          if (values.isEmpty)
            const Text('No items yet. Add the first entry to start authoring.'),
          for (var index = 0; index < values.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildListItemField(values: values, index: index),
            ),
          _buildFooterActions(
            context,
            allowRawJson: true,
            rawJsonValue: values,
          ),
        ],
      ),
    );
  }

  Widget _buildListItemField({
    required List<dynamic> values,
    required int index,
  }) {
    final itemValue = values[index];
    final itemDescriptor = _resolveListItemDescriptor(
      itemValue,
    ).copyWith(key: 'item', label: '${field.label} #${index + 1}');
    final wrapper = <String, dynamic>{'item': itemValue};

    return CompendiumStructuredFieldEditor(
      field: itemDescriptor,
      currentData: wrapper,
      onMutate: (mutation) {
        onMutate(() {
          mutation();
          final storedValues = _ensureStoredList(values);
          storedValues[index] = wrapper['item'];
        });
      },
      onEditRawJson: onEditRawJson,
      onRemove: () {
        onMutate(() {
          final storedValues = _ensureStoredList(values);
          if (index < storedValues.length) {
            storedValues.removeAt(index);
          }
        });
      },
    );
  }

  Widget _buildDynamicField(BuildContext context, dynamic value) {
    if (value is Map || (value == null && field.fields.isNotEmpty)) {
      final resolvedField = field.copyWith(
        kind: CompendiumFieldKind.object,
        fields: value is Map
            ? compendiumMergeKnownAndInferredFields(
                field.fields,
                compendiumAsMap(value),
              )
            : field.fields,
      );
      return CompendiumStructuredFieldEditor(
        field: resolvedField,
        currentData: currentData,
        onMutate: onMutate,
        onEditRawJson: onEditRawJson,
        onRemove: onRemove,
      );
    }

    if (value is List) {
      final inferredItemDescriptor = _resolveListItemDescriptor(
        value.isEmpty ? null : value.first,
      );
      final resolvedField = field.copyWith(
        kind: CompendiumFieldKind.list,
        isArray: true,
        itemDescriptor: inferredItemDescriptor,
      );
      return CompendiumStructuredFieldEditor(
        field: resolvedField,
        currentData: currentData,
        onMutate: onMutate,
        onEditRawJson: onEditRawJson,
        onRemove: onRemove,
      );
    }

    if (value is bool || value is num || value is String) {
      final inferredField = compendiumInferDescriptor(
        field.key,
        value,
        label: field.label,
      );
      return CompendiumStructuredFieldEditor(
        field: inferredField,
        currentData: currentData,
        onMutate: onMutate,
        onEditRawJson: onEditRawJson,
        onRemove: onRemove,
      );
    }

    return _EditorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditorHeading(field: field),
          const SizedBox(height: 12),
          const Text(
            'Choose a structured value type or fall back to raw JSON for advanced editing.',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  onMutate(() {
                    currentData[field.key] = '';
                  });
                },
                icon: const Icon(Icons.text_fields_outlined),
                label: const Text('Text'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  onMutate(() {
                    currentData[field.key] = 0;
                  });
                },
                icon: const Icon(Icons.pin_outlined),
                label: const Text('Number'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  onMutate(() {
                    currentData[field.key] = false;
                  });
                },
                icon: const Icon(Icons.toggle_on_outlined),
                label: const Text('Boolean'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  onMutate(() {
                    currentData[field.key] = <String, dynamic>{};
                  });
                },
                icon: const Icon(Icons.account_tree_outlined),
                label: const Text('Object'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  onMutate(() {
                    currentData[field.key] = <dynamic>[];
                  });
                },
                icon: const Icon(Icons.view_list_outlined),
                label: const Text('List'),
              ),
            ],
          ),
          _buildFooterActions(context, allowRawJson: true, rawJsonValue: value),
        ],
      ),
    );
  }

  Widget _buildRawJsonField(BuildContext context, dynamic value) {
    return _EditorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditorHeading(field: field),
          const SizedBox(height: 12),
          Text(
            value == null
                ? 'No structured value is set yet.'
                : value.toString().length > 240
                ? '${value.toString().substring(0, 240)}...'
                : value.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          _buildFooterActions(context, allowRawJson: true, rawJsonValue: value),
        ],
      ),
    );
  }

  Widget _buildCreateSectionCard(
    BuildContext context, {
    required String message,
    required VoidCallback onCreate,
  }) {
    return _EditorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditorHeading(field: field),
          const SizedBox(height: 12),
          Text(message),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: onCreate,
                icon: const Icon(Icons.add_box_outlined),
                label: const Text('Create Section'),
              ),
            ],
          ),
          _buildFooterActions(context, allowRawJson: true, rawJsonValue: null),
        ],
      ),
    );
  }

  Widget _buildListAddButton(
    BuildContext context,
    List<dynamic> currentValues,
  ) {
    final itemDescriptor = field.itemDescriptor;
    final needsTypedCreate =
        itemDescriptor == null ||
        itemDescriptor.kind == CompendiumFieldKind.dynamic ||
        itemDescriptor.kind == CompendiumFieldKind.list;

    if (!needsTypedCreate) {
      return FilledButton.tonalIcon(
        onPressed: () {
          onMutate(() {
            final storedValues = _ensureStoredList(currentValues);
            storedValues.add(compendiumNewListItem(itemDescriptor));
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      );
    }

    return PopupMenuButton<_StructuredCreateKind>(
      tooltip: 'Add item',
      onSelected: (kind) {
        onMutate(() {
          final storedValues = _ensureStoredList(currentValues);
          storedValues.add(_defaultValueForCreateKind(kind));
        });
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _StructuredCreateKind.text,
          child: Text('Add text'),
        ),
        PopupMenuItem(
          value: _StructuredCreateKind.number,
          child: Text('Add number'),
        ),
        PopupMenuItem(
          value: _StructuredCreateKind.boolean,
          child: Text('Add boolean'),
        ),
        PopupMenuItem(
          value: _StructuredCreateKind.object,
          child: Text('Add object'),
        ),
        PopupMenuItem(
          value: _StructuredCreateKind.list,
          child: Text('Add list'),
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline),
            SizedBox(width: 6),
            Text('Add'),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterActions(
    BuildContext context, {
    required bool allowRawJson,
    dynamic rawJsonValue,
    bool allowAddField = false,
    VoidCallback? onAddField,
  }) {
    if (!allowRawJson && !allowAddField && onRemove == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (allowAddField && onAddField != null)
            OutlinedButton.icon(
              onPressed: onAddField,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Field'),
            ),
          if (allowRawJson)
            TextButton.icon(
              onPressed: () async {
                final updated = await onEditRawJson(
                  title: field.label,
                  initialValue: rawJsonValue,
                );
                if (updated == null) {
                  return;
                }

                onMutate(() {
                  _setFieldValue(updated);
                });
              },
              icon: const Icon(Icons.code_outlined),
              label: const Text('Edit Raw JSON'),
            ),
          if (onRemove != null)
            TextButton.icon(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove'),
            ),
        ],
      ),
    );
  }

  Future<void> _showAddMapEntryDialog(
    BuildContext context,
    Map<String, dynamic> mapValue,
  ) async {
    final entry = await showDialog<_DynamicMapEntry>(
      context: context,
      builder: (dialogContext) {
        final keyController = TextEditingController();
        var selectedKind = _StructuredCreateKind.text;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add Field to ${field.label}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: keyController,
                    decoration: const InputDecoration(
                      labelText: 'Field key',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<_StructuredCreateKind>(
                    initialValue: selectedKind,
                    decoration: const InputDecoration(
                      labelText: 'Value type',
                      border: OutlineInputBorder(),
                    ),
                    items: _StructuredCreateKind.values
                        .map(
                          (kind) => DropdownMenuItem<_StructuredCreateKind>(
                            value: kind,
                            child: Text(kind.label),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (next) {
                      if (next == null) {
                        return;
                      }
                      setDialogState(() {
                        selectedKind = next;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final rawKey = keyController.text.trim();
                    if (rawKey.isEmpty) {
                      return;
                    }

                    Navigator.of(dialogContext).pop(
                      _DynamicMapEntry(
                        key: rawKey,
                        value: _defaultValueForCreateKind(selectedKind),
                      ),
                    );
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (entry == null) {
      return;
    }

    onMutate(() {
      mapValue[entry.key] = entry.value;
      currentData[field.key] = mapValue;
    });
  }

  List<dynamic> _ensureStoredList(List<dynamic> fallback) {
    final existing = currentData[field.key];
    if (existing is List<dynamic>) {
      return existing;
    }

    currentData[field.key] = fallback;
    return fallback;
  }

  void _setFieldValue(dynamic next) {
    if (next == null && !field.required) {
      currentData.remove(field.key);
      return;
    }

    currentData[field.key] = next;
  }

  Map<String, dynamic> _defaultMapForFields(
    List<CompendiumFieldDescriptor> fields,
  ) {
    final map = <String, dynamic>{};
    for (final nestedField in fields) {
      final defaultValue = compendiumDefaultValue(nestedField);
      if (defaultValue != null) {
        map[nestedField.key] = defaultValue;
      }
    }
    return map;
  }

  CompendiumFieldDescriptor _resolveListItemDescriptor(dynamic itemValue) {
    final itemDescriptor = field.itemDescriptor;
    if (itemDescriptor == null) {
      return compendiumInferDescriptor('item', itemValue, label: 'Item');
    }

    if (itemDescriptor.kind == CompendiumFieldKind.dynamic) {
      if (itemValue is Map) {
        return itemDescriptor.copyWith(
          kind: CompendiumFieldKind.object,
          fields: compendiumMergeKnownAndInferredFields(
            itemDescriptor.fields,
            compendiumAsMap(itemValue),
          ),
        );
      }

      if (itemValue is List) {
        return itemDescriptor.copyWith(
          kind: CompendiumFieldKind.list,
          isArray: true,
          itemDescriptor: itemValue.isEmpty
              ? const CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                )
              : compendiumInferDescriptor(
                  'item',
                  itemValue.first,
                  label: 'Item',
                ),
        );
      }

      if (itemValue != null) {
        return compendiumInferDescriptor('item', itemValue, label: 'Item');
      }
    }

    if (itemDescriptor.kind == CompendiumFieldKind.object && itemValue is Map) {
      return itemDescriptor.copyWith(
        fields: compendiumMergeKnownAndInferredFields(
          itemDescriptor.fields,
          compendiumAsMap(itemValue),
        ),
      );
    }

    return itemDescriptor;
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
}

class _EditorCard extends StatelessWidget {
  final Widget child;

  const _EditorCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class _EditorHeading extends StatelessWidget {
  final CompendiumFieldDescriptor field;

  const _EditorHeading({required this.field});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(field.key, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

enum _StructuredCreateKind { text, number, boolean, object, list }

extension on _StructuredCreateKind {
  String get label => switch (this) {
    _StructuredCreateKind.text => 'Text',
    _StructuredCreateKind.number => 'Number',
    _StructuredCreateKind.boolean => 'Boolean',
    _StructuredCreateKind.object => 'Object',
    _StructuredCreateKind.list => 'List',
  };
}

class _DynamicMapEntry {
  final String key;
  final dynamic value;

  const _DynamicMapEntry({required this.key, required this.value});
}

dynamic _defaultValueForCreateKind(_StructuredCreateKind kind) {
  return switch (kind) {
    _StructuredCreateKind.text => '',
    _StructuredCreateKind.number => 0,
    _StructuredCreateKind.boolean => false,
    _StructuredCreateKind.object => <String, dynamic>{},
    _StructuredCreateKind.list => <dynamic>[],
  };
}
