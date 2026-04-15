import 'dart:convert';

abstract class CompendiumEntity {
  const CompendiumEntity();

  String get entityType;
  String get collectionKey;
  String get id;
  String get name;
  String get source;
  String get sourceFile;
  String? get edition;
  Map<String, dynamic> get data;
  Map<String, dynamic> get extra;

  String get displayName => name.trim().isEmpty ? id : name.trim();

  Map<String, dynamic> toJson();
}

abstract class GeneratedCompendiumEntityBase extends CompendiumEntity {
  @override
  final String id;
  @override
  final String name;
  @override
  final String source;
  @override
  final String sourceFile;
  @override
  final String? edition;
  @override
  final Map<String, dynamic> data;
  @override
  final Map<String, dynamic> extra;

  const GeneratedCompendiumEntityBase({
    required this.id,
    required this.name,
    required this.source,
    required this.sourceFile,
    required this.edition,
    required this.data,
    this.extra = const {},
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'source': source,
      'sourceFile': sourceFile,
      if (edition != null) 'edition': edition,
      'data': CompendiumJsonUtils.deepCopyMap(data),
      ...CompendiumJsonUtils.deepCopyMap(extra),
    };
  }
}

class CompendiumCollectionDefinition {
  final String entityType;
  final String collectionKey;
  final String label;

  const CompendiumCollectionDefinition({
    required this.entityType,
    required this.collectionKey,
    required this.label,
  });
}

class CompendiumEntityDescriptor<T extends CompendiumEntity> {
  final CompendiumCollectionDefinition collection;
  final T Function(Map<String, dynamic> json) fromJson;

  const CompendiumEntityDescriptor({
    required this.collection,
    required this.fromJson,
  });
}

class CompendiumJsonUtils {
  static Map<String, dynamic> deepCopyMap(Map<String, dynamic> value) {
    return value.map((key, entryValue) {
      return MapEntry(key, deepCopy(entryValue));
    });
  }

  static List<dynamic> deepCopyList(List<dynamic> value) {
    return value.map(deepCopy).toList();
  }

  static dynamic deepCopy(dynamic value) {
    if (value is Map<String, dynamic>) {
      return deepCopyMap(value);
    }

    if (value is List<dynamic>) {
      return deepCopyList(value);
    }

    return value;
  }

  static Map<String, dynamic> jsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return deepCopyMap(value);
    }

    if (value is Map) {
      return value.map<String, dynamic>((key, entryValue) {
        return MapEntry(key.toString(), deepCopy(entryValue));
      });
    }

    return <String, dynamic>{};
  }

  static List<Map<String, dynamic>> listOfMaps(dynamic value) {
    if (value is! List) {
      return const <Map<String, dynamic>>[];
    }

    return value.map((entry) => jsonMap(entry)).toList();
  }

  static String slugify(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  static String stableEntityId({
    required String entityType,
    required String source,
    required String name,
    String? page,
  }) {
    final normalizedType = slugify(entityType);
    final normalizedSource = slugify(source.isEmpty ? 'custom' : source);
    final normalizedName = slugify(name.isEmpty ? 'untitled' : name);
    final normalizedPage = page == null || page.isEmpty
        ? ''
        : ':${slugify(page)}';
    return '$normalizedType:$normalizedSource:$normalizedName$normalizedPage';
  }

  static String extractName(Map<String, dynamic> payload) {
    final direct = payload['name'];
    if (direct is String && direct.trim().isNotEmpty) {
      return direct.trim();
    }

    final data = payload['data'];
    if (data is Map) {
      final nested = data['name'];
      if (nested is String && nested.trim().isNotEmpty) {
        return nested.trim();
      }
    }

    return payload['id']?.toString() ?? 'untitled';
  }

  static String extractSource(Map<String, dynamic> payload) {
    final direct = payload['source'];
    if (direct is String && direct.trim().isNotEmpty) {
      return direct.trim();
    }

    final data = payload['data'];
    if (data is Map) {
      final nested = data['source'];
      if (nested is String && nested.trim().isNotEmpty) {
        return nested.trim();
      }
    }

    return '';
  }

  static String? extractEdition(Map<String, dynamic> payload) {
    final direct = payload['edition'];
    if (direct is String && direct.trim().isNotEmpty) {
      return direct.trim();
    }

    final data = payload['data'];
    if (data is Map) {
      final nested = data['edition'];
      if (nested is String && nested.trim().isNotEmpty) {
        return nested.trim();
      }
    }

    return null;
  }

  static String prettyJson(dynamic value) {
    return const JsonEncoder.withIndent('  ').convert(value);
  }

  static String flattenedSearchText(dynamic value) {
    final buffer = StringBuffer();
    _appendFlattened(buffer, value);
    return buffer.toString().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static void _appendFlattened(StringBuffer buffer, dynamic value) {
    if (value == null) {
      return;
    }

    if (value is String) {
      buffer.write(' ');
      buffer.write(value);
      return;
    }

    if (value is num || value is bool) {
      buffer.write(' ');
      buffer.write(value.toString());
      return;
    }

    if (value is List) {
      for (final item in value) {
        _appendFlattened(buffer, item);
      }
      return;
    }

    if (value is Map) {
      for (final entry in value.values) {
        _appendFlattened(buffer, entry);
      }
    }
  }

  static String sortName(String value) {
    return value.trim().toLowerCase();
  }
}
