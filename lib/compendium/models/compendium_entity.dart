import 'dart:convert';

abstract class CompendiumEntity {
  const CompendiumEntity();

  String get entityType;
  String get collectionKey;
  String get id;
  String get name;
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
  final Map<String, dynamic> data;
  @override
  final Map<String, dynamic> extra;

  const GeneratedCompendiumEntityBase({
    required this.id,
    required this.name,
    required this.data,
    this.extra = const {},
  });

  @override
  Map<String, dynamic> toJson() {
    return CompendiumJsonUtils.sanitizeEntityJson(<String, dynamic>{
      'id': id,
      'name': name,
      'data': CompendiumJsonUtils.deepCopyMap(data),
      ...CompendiumJsonUtils.deepCopyMap(extra),
    });
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
  static const Set<String> legacyProvenanceKeys = <String>{
    'source',
    'sourceFile',
    'edition',
    'page',
    'basicRules',
    'basicRules2024',
    'srd',
    'srd52',
    'referenceSources',
    'otherSources',
    'additionalSources',
    'parentSource',
    'fauxGroupSource',
    'classSource',
    'subclassSource',
    'raceSource',
  };

  static const Map<String, String> _referenceFieldTagHints = <String, String>{
    'action': 'action',
    'actions': 'action',
    'background': 'background',
    'backgrounds': 'background',
    'class': 'class',
    'classes': 'class',
    'classFeature': 'classFeature',
    'classFeatures': 'classFeature',
    'condition': 'condition',
    'conditions': 'condition',
    'deity': 'deity',
    'deities': 'deity',
    'disease': 'disease',
    'diseases': 'disease',
    'feat': 'feat',
    'feats': 'feat',
    'hazard': 'hazard',
    'hazards': 'hazard',
    'item': 'item',
    'items': 'item',
    'language': 'language',
    'languages': 'language',
    'monster': 'monster',
    'monsters': 'monster',
    'monsterFeature': 'monsterfeatures',
    'monsterFeatures': 'monsterfeatures',
    'object': 'object',
    'objects': 'object',
    'race': 'race',
    'races': 'race',
    'reward': 'reward',
    'rewards': 'reward',
    'sense': 'sense',
    'senses': 'sense',
    'skill': 'skill',
    'skills': 'skill',
    'spell': 'spell',
    'spells': 'spell',
    'status': 'status',
    'statuses': 'status',
    'subclass': 'subclass',
    'subclasses': 'subclass',
    'subclassFeature': 'subclassFeature',
    'subclassFeatures': 'subclassFeature',
    'subrace': 'subrace',
    'subraces': 'subrace',
    'trap': 'trap',
    'traps': 'trap',
    'variantRule': 'variantrule',
    'variantRules': 'variantrule',
    'vehicle': 'vehicle',
    'vehicles': 'vehicle',
  };

  static final RegExp _richReferenceExpression = RegExp(
    r'\{@([a-zA-Z]+)\s+([^}]+)\}',
  );

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
    required Map<String, dynamic> payload,
  }) {
    final normalizedPayload = sanitizeEntityJson(payload);
    final normalizedType = slugify(entityType.isEmpty ? 'entity' : entityType);
    final identitySegments = _identitySegmentsFor(
      entityType,
      normalizedPayload,
    ).map(slugify).where((segment) => segment.isNotEmpty);
    final joinedIdentity = identitySegments.join(':');
    if (joinedIdentity.isNotEmpty) {
      return '$normalizedType:$joinedIdentity';
    }

    final fallbackName = slugify(
      extractName(normalizedPayload).isEmpty
          ? normalizedPayload['id']?.toString() ?? 'untitled'
          : extractName(normalizedPayload),
    );
    if (fallbackName.isNotEmpty) {
      return '$normalizedType:$fallbackName';
    }

    final fingerprint = stableDisambiguator(normalizedPayload);
    return '$normalizedType:$fingerprint';
  }

  static String stableDisambiguator(
    Map<String, dynamic> payload, {
    String? legacyId,
  }) {
    final normalized = sanitizeEntityJson(payload);
    final encoded = jsonEncode(<String, dynamic>{
      if (legacyId != null && legacyId.trim().isNotEmpty) 'legacyId': legacyId,
      ...normalized..remove('id'),
    });
    var hash = 0x811C9DC5;
    for (final codeUnit in encoded.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16).padLeft(8, '0');
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

  static Map<String, dynamic> sanitizeEntityJson(Map<String, dynamic> json) {
    final sanitizedInput = deepCopyMap(json);
    final hasExplicitData =
        sanitizedInput.containsKey('data') && sanitizedInput['data'] != null;
    final rawData = hasExplicitData
        ? jsonMap(sanitizedInput['data'])
        : _inlineEntityData(sanitizedInput);
    final sanitizedData = sanitizePayloadMap(rawData);
    final extra = <String, dynamic>{};

    if (hasExplicitData) {
      for (final entry in sanitizedInput.entries) {
        if (_isEntityEnvelopeKey(entry.key) || entry.key == 'data') {
          continue;
        }

        final sanitizedValue = sanitizePayloadValue(
          entry.value,
          currentKey: entry.key,
        );
        extra[entry.key] = sanitizedValue;
      }
    }

    final provisional = <String, dynamic>{
      if (sanitizedInput['id']?.toString().trim().isNotEmpty == true)
        'id': sanitizedInput['id']?.toString(),
      'name':
          sanitizedInput['name']?.toString().trim().isNotEmpty == true
              ? sanitizedInput['name']?.toString().trim()
              : extractName(<String, dynamic>{'data': sanitizedData}),
      'data': sanitizedData,
      ...extra,
    };

    return provisional;
  }

  static Map<String, dynamic> sanitizePayloadMap(Map<String, dynamic> value) {
    final sanitized = <String, dynamic>{};
    for (final entry in value.entries) {
      if (_isLegacyProvenanceKey(entry.key)) {
        continue;
      }
      sanitized[entry.key] = sanitizePayloadValue(
        entry.value,
        currentKey: entry.key,
      );
    }
    return sanitized;
  }

  static List<dynamic> sanitizePayloadList(
    List<dynamic> value, {
    String? currentKey,
  }) {
    return value
        .map((item) => sanitizePayloadValue(item, currentKey: currentKey))
        .toList(growable: false);
  }

  static dynamic sanitizePayloadValue(dynamic value, {String? currentKey}) {
    if (value is Map<String, dynamic>) {
      return sanitizePayloadMap(value);
    }

    if (value is Map) {
      return sanitizePayloadMap(value.map<String, dynamic>((key, entryValue) {
        return MapEntry(key.toString(), entryValue);
      }));
    }

    if (value is List<dynamic>) {
      return sanitizePayloadList(value, currentKey: currentKey);
    }

    if (value is List) {
      return sanitizePayloadList(List<dynamic>.from(value), currentKey: currentKey);
    }

    if (value is String) {
      return sanitizeString(value, currentKey: currentKey);
    }

    return value;
  }

  static String sanitizeString(String value, {String? currentKey}) {
    if (value.isEmpty) {
      return value;
    }

    var sanitized = value;
    if (sanitized.contains('{@')) {
      sanitized = sanitized.replaceAllMapped(_richReferenceExpression, (match) {
        final tag = match.group(1)?.trim() ?? '';
        final body = match.group(2)?.trim() ?? '';
        return _sanitizeRichReference(tag, body);
      });
    }

    final referenceHint = currentKey == null
        ? null
        : _referenceFieldTagHints[currentKey];
    final maybeCanonicalRef = _sanitizePlainReference(
      sanitized,
      hintedTag: referenceHint,
    );
    if (maybeCanonicalRef != null) {
      return maybeCanonicalRef;
    }

    final simpleSegments = sanitized.split('|');
    if (simpleSegments.length == 2 && _looksLikeSourceToken(simpleSegments[1])) {
      return simpleSegments.first.trim();
    }

    return sanitized;
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

  static bool _isEntityEnvelopeKey(String key) {
    return key == 'id' ||
        key == 'name' ||
        key == 'data' ||
        key == 'source' ||
        key == 'sourceFile' ||
        key == 'edition' ||
        _isLegacyProvenanceKey(key);
  }

  static bool _isLegacyProvenanceKey(String key) {
    return legacyProvenanceKeys.contains(key);
  }

  static Map<String, dynamic> _inlineEntityData(Map<String, dynamic> value) {
    final data = <String, dynamic>{};
    for (final entry in value.entries) {
      if (_isEntityEnvelopeKey(entry.key)) {
        continue;
      }
      data[entry.key] = entry.value;
    }
    return data;
  }

  static Iterable<String> _identitySegmentsFor(
    String entityType,
    Map<String, dynamic> payload,
  ) sync* {
    final name = extractName(payload);
    final className = _payloadValue(payload, 'className');
    final subclassShortName = _payloadValue(payload, 'subclassShortName');
    final level = _payloadValue(payload, 'level');
    final raceName = _payloadValue(payload, 'raceName');

    switch (entityType) {
      case 'classFeature':
        yield name;
        yield className;
        yield level;
        return;
      case 'subclass':
        yield name;
        yield className;
        return;
      case 'subclassFeature':
        yield name;
        yield className;
        yield subclassShortName;
        yield level;
        return;
      case 'subrace':
        yield name;
        yield raceName;
        return;
      default:
        yield name;
    }
  }

  static String _payloadValue(Map<String, dynamic> payload, String key) {
    final direct = payload[key];
    if (direct is String && direct.trim().isNotEmpty) {
      return direct.trim();
    }
    if (direct is num) {
      return direct.toString();
    }

    final data = payload['data'];
    if (data is Map) {
      final nested = data[key];
      if (nested is String && nested.trim().isNotEmpty) {
        return nested.trim();
      }
      if (nested is num) {
        return nested.toString();
      }
    }

    return '';
  }

  static String _sanitizeRichReference(String tag, String body) {
    final normalizedTag = tag.trim();
    final parts = body.split('|').map((part) => part.trim()).toList();
    if (parts.isEmpty || parts.first.isEmpty) {
      return body;
    }

    switch (normalizedTag) {
      case 'book':
      case 'adventure':
      case 'quickref':
        return parts.length > 2 && parts[2].isNotEmpty ? parts[2] : parts[0];
      default:
        final canonicalBody = _canonicalizeReferenceParts(
          normalizedTag,
          parts,
        );
        return '{@$normalizedTag $canonicalBody}';
    }
  }

  static String? _sanitizePlainReference(
    String value, {
    required String? hintedTag,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || !trimmed.contains('|')) {
      return null;
    }

    if (hintedTag == null) {
      return null;
    }

    final parts = trimmed.split('|').map((part) => part.trim()).toList();
    if (parts.isEmpty || parts.first.isEmpty) {
      return null;
    }

    return _canonicalizeReferenceParts(hintedTag, parts);
  }

  static String _canonicalizeReferenceParts(
    String tag,
    List<String> parts,
  ) {
    final name = parts.first.trim();
    switch (tag) {
      case 'classFeature':
        return _canonicalizeClassFeatureReference(parts, name);
      case 'subclass':
        return _canonicalizeSubclassReference(parts, name);
      case 'subclassFeature':
        return _canonicalizeSubclassFeatureReference(parts, name);
      case 'subrace':
        return _canonicalizeSubraceReference(parts, name);
      default:
        final alias = parts.length > 2 ? _displayAlias(parts[2], name) : null;
        return alias == null ? name : '$name||$alias';
    }
  }

  static String _canonicalizeClassFeatureReference(
    List<String> parts,
    String name,
  ) {
    final className = parts.length > 1 ? parts[1].trim() : '';
    late final String level;
    String? alias;
    if (parts.length >= 4 && !_looksLikeLevel(parts[2])) {
      level = parts[3].trim();
      alias = parts.length > 4 ? _displayAlias(parts[4], name) : null;
    } else {
      level = parts.length > 2 ? parts[2].trim() : '';
      alias = parts.length > 3 ? _displayAlias(parts[3], name) : null;
    }

    return _joinReferenceParts(<String?>[name, className, level, alias]);
  }

  static String _canonicalizeSubclassReference(
    List<String> parts,
    String name,
  ) {
    final className = parts.length > 1 ? parts[1].trim() : '';
    String? alias;
    if (parts.length > 2) {
      final tail = parts.last.trim();
      alias = _looksLikeSourceToken(tail) ? null : _displayAlias(tail, name);
    }

    return _joinReferenceParts(<String?>[name, className, alias]);
  }

  static String _canonicalizeSubclassFeatureReference(
    List<String> parts,
    String name,
  ) {
    final className = parts.length > 1 ? parts[1].trim() : '';
    late final String subclassShortName;
    late final String level;
    String? alias;

    if (parts.length >= 6 && !_looksLikeLevel(parts[2])) {
      subclassShortName = parts[3].trim();
      level = parts[5].trim();
      alias = parts.length > 6 ? _displayAlias(parts[6], name) : null;
    } else {
      subclassShortName = parts.length > 2 ? parts[2].trim() : '';
      level = parts.length > 3 ? parts[3].trim() : '';
      alias = parts.length > 4 ? _displayAlias(parts[4], name) : null;
    }

    return _joinReferenceParts(<String?>[
      name,
      className,
      subclassShortName,
      level,
      alias,
    ]);
  }

  static String _canonicalizeSubraceReference(
    List<String> parts,
    String name,
  ) {
    final raceName = parts.length > 1 ? parts[1].trim() : '';
    String? alias;
    if (parts.length > 2) {
      final tail = parts.last.trim();
      alias = _looksLikeSourceToken(tail) ? null : _displayAlias(tail, name);
    }

    return _joinReferenceParts(<String?>[name, raceName, alias]);
  }

  static String _joinReferenceParts(List<String?> parts) {
    final normalized = parts
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    return normalized.join('|');
  }

  static String? _displayAlias(String rawAlias, String fallbackName) {
    final alias = rawAlias.trim();
    if (alias.isEmpty || alias == fallbackName || _looksLikeSourceToken(alias)) {
      return null;
    }
    return alias;
  }

  static bool _looksLikeLevel(String value) {
    return int.tryParse(value.trim()) != null;
  }

  static bool _looksLikeSourceToken(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.contains(' ')) {
      return false;
    }
    return RegExp(r'^[A-Za-z0-9_-]{2,12}$').hasMatch(trimmed);
  }
}
