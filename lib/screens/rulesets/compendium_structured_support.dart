import 'package:openrpg/compendium/models/compendium_editor.dart';

bool compendiumHasMeaningfulValue(dynamic value) {
  if (value == null) {
    return false;
  }

  if (value is String) {
    return value.trim().isNotEmpty;
  }

  if (value is Iterable) {
    return value.isNotEmpty;
  }

  if (value is Map) {
    return value.isNotEmpty;
  }

  return true;
}

bool compendiumLooksLikeRichContent(dynamic value) {
  if (value is String) {
    return value.contains('{@') ||
        value.contains('\n') ||
        value.trimLeft().startsWith('*') ||
        value.length > 120;
  }

  if (value is List) {
    if (value.isEmpty) {
      return false;
    }

    return value.any(compendiumLooksLikeRichContent);
  }

  if (value is Map) {
    return _mapLooksLikeRichContent(compendiumAsMap(value));
  }

  return false;
}

Map<String, dynamic> compendiumAsMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map<String, dynamic>((key, entryValue) {
      return MapEntry(key.toString(), entryValue);
    });
  }

  return <String, dynamic>{};
}

List<dynamic> compendiumAsList(dynamic value) {
  if (value is List<dynamic>) {
    return value;
  }

  if (value is List) {
    return List<dynamic>.from(value);
  }

  return <dynamic>[];
}

String compendiumLabelForKey(String key) {
  final spaced = key
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)} ${match.group(2)}',
      )
      .replaceAll('_', ' ')
      .trim();

  if (spaced.isEmpty) {
    return key;
  }

  return spaced
      .split(RegExp(r'\s+'))
      .map((word) {
        if (word.isEmpty) {
          return word;
        }
        return '${word[0].toUpperCase()}${word.substring(1)}';
      })
      .join(' ');
}

CompendiumFieldDescriptor compendiumInferDescriptor(
  String key,
  dynamic value, {
  String? label,
}) {
  final resolvedLabel = label ?? compendiumLabelForKey(key);

  if (value is bool) {
    return CompendiumFieldDescriptor(
      key: key,
      label: resolvedLabel,
      kind: CompendiumFieldKind.boolean,
    );
  }

  if (value is int) {
    return CompendiumFieldDescriptor(
      key: key,
      label: resolvedLabel,
      kind: CompendiumFieldKind.integer,
    );
  }

  if (value is num) {
    return CompendiumFieldDescriptor(
      key: key,
      label: resolvedLabel,
      kind: CompendiumFieldKind.number,
    );
  }

  if (value is String || value == null) {
    return CompendiumFieldDescriptor(
      key: key,
      label: resolvedLabel,
      kind: CompendiumFieldKind.string,
    );
  }

  if (value is List) {
    final values = compendiumAsList(value);
    final firstMeaningful = values.cast<dynamic>().firstWhere(
      compendiumHasMeaningfulValue,
      orElse: () => null,
    );
    return CompendiumFieldDescriptor(
      key: key,
      label: resolvedLabel,
      kind: CompendiumFieldKind.list,
      isArray: true,
      itemDescriptor: firstMeaningful == null
          ? const CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
            )
          : compendiumInferDescriptor('item', firstMeaningful, label: 'Item'),
    );
  }

  if (value is Map) {
    final mapValue = compendiumAsMap(value);
    return CompendiumFieldDescriptor(
      key: key,
      label: resolvedLabel,
      kind: CompendiumFieldKind.object,
      fields: mapValue.entries
          .where((entry) => compendiumHasMeaningfulValue(entry.value))
          .map(
            (entry) => compendiumInferDescriptor(
              entry.key,
              entry.value,
              label: compendiumLabelForKey(entry.key),
            ),
          )
          .toList(growable: false),
    );
  }

  return CompendiumFieldDescriptor(
    key: key,
    label: resolvedLabel,
    kind: CompendiumFieldKind.dynamic,
  );
}

List<CompendiumFieldDescriptor> compendiumMergeKnownAndInferredFields(
  List<CompendiumFieldDescriptor> knownFields,
  Map<String, dynamic> value,
) {
  final fields = <CompendiumFieldDescriptor>[...knownFields];
  final knownKeys = knownFields.map((field) => field.key).toSet();

  for (final entry in value.entries) {
    if (knownKeys.contains(entry.key)) {
      continue;
    }

    if (!compendiumHasMeaningfulValue(entry.value)) {
      continue;
    }

    fields.add(
      compendiumInferDescriptor(
        entry.key,
        entry.value,
        label: compendiumLabelForKey(entry.key),
      ),
    );
  }

  return fields;
}

dynamic compendiumDefaultValue(CompendiumFieldDescriptor field) {
  if (field.isArray) {
    return <dynamic>[];
  }

  if (field.choices.isNotEmpty) {
    return field.choices.first;
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

dynamic compendiumNewListItem(CompendiumFieldDescriptor? descriptor) {
  if (descriptor == null) {
    return '';
  }

  if (descriptor.isArray) {
    return <dynamic>[];
  }

  if (descriptor.choices.isNotEmpty) {
    return descriptor.choices.first;
  }

  switch (descriptor.kind) {
    case CompendiumFieldKind.boolean:
      return false;
    case CompendiumFieldKind.object:
      final map = <String, dynamic>{};
      for (final field in descriptor.fields) {
        final defaultValue = compendiumDefaultValue(field);
        if (defaultValue != null) {
          map[field.key] = defaultValue;
        }
      }
      return map;
    case CompendiumFieldKind.dynamic:
      return <String, dynamic>{};
    case CompendiumFieldKind.list:
      return <dynamic>[];
    case CompendiumFieldKind.integer:
    case CompendiumFieldKind.number:
    case CompendiumFieldKind.string:
      return null;
  }
}

bool _mapLooksLikeRichContent(Map<String, dynamic> value) {
  final type = value['type']?.toString();
  if (type != null &&
      {'entries', 'list', 'table', 'inset', 'quote', 'item'}.contains(type)) {
    return true;
  }

  return value.containsKey('entries') ||
      value.containsKey('entry') ||
      value.containsKey('items') ||
      value.containsKey('rows') ||
      value.containsKey('caption') ||
      value.containsKey('colLabels');
}
