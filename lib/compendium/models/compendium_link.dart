class CompendiumLinkCandidate {
  final String tag;
  final String rawReference;
  final String displayText;
  final String lookupName;
  final String? targetEntityType;
  final List<String> parts;

  const CompendiumLinkCandidate({
    required this.tag,
    required this.rawReference,
    required this.displayText,
    required this.lookupName,
    required this.targetEntityType,
    this.parts = const <String>[],
  });
}

class CompendiumLinkParser {
  static final RegExp _tagExpression = RegExp(r'\{@([a-zA-Z]+)\s+([^}]+)\}');

  static const Map<String, String> _fieldTagHints = <String, String>{
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

  static Iterable<CompendiumLinkCandidate> extractAll(String value) sync* {
    for (final match in _tagExpression.allMatches(value)) {
      final tag = match.group(1)?.trim() ?? '';
      final body = match.group(2)?.trim() ?? '';
      final candidate = _buildCandidate(tag: tag, rawReference: body);
      if (candidate != null) {
        yield candidate;
      }
    }
  }

  static CompendiumLinkCandidate? tryParsePlainReference(
    String value, {
    String? hintedFieldKey,
    String? hintedTag,
  }) {
    final resolvedTag =
        hintedTag ??
        (hintedFieldKey == null ? null : _fieldTagHints[hintedFieldKey]);
    if (resolvedTag == null) {
      return null;
    }

    return _buildCandidate(
      tag: resolvedTag,
      rawReference: value.trim(),
      isInlineTag: false,
    );
  }

  static CompendiumLinkCandidate? extractReferenceFromMap(
    Map<String, dynamic> value,
  ) {
    for (final entry in value.entries) {
      final candidate = tryParsePlainReference(
        entry.value?.toString() ?? '',
        hintedFieldKey: entry.key,
      );
      if (candidate != null) {
        return candidate;
      }
    }
    return null;
  }

  static bool looksLikeReferenceString(
    String value, {
    String? hintedFieldKey,
    String? hintedTag,
  }) {
    return tryParsePlainReference(
          value,
          hintedFieldKey: hintedFieldKey,
          hintedTag: hintedTag,
        ) !=
        null;
  }

  static String renderInlineLabel(String token) {
    final values = extractAll(token).toList();
    if (values.isEmpty) {
      return token;
    }

    return token.replaceAllMapped(_tagExpression, (match) {
      final tag = match.group(1)?.trim() ?? '';
      final body = match.group(2)?.trim() ?? '';
      final candidate = _buildCandidate(tag: tag, rawReference: body);
      return candidate?.displayText ?? body;
    });
  }

  static CompendiumLinkCandidate? _buildCandidate({
    required String tag,
    required String rawReference,
    bool isInlineTag = true,
  }) {
    final normalizedTag = tag.trim();
    final trimmedReference = rawReference.trim();
    if (normalizedTag.isEmpty || trimmedReference.isEmpty) {
      return null;
    }

    final parts = trimmedReference
        .split('|')
        .map((part) => part.trim())
        .toList(growable: false);
    if (parts.isEmpty || parts.first.isEmpty) {
      return null;
    }

    final targetEntityType = _normalizeTag(normalizedTag);
    final displayText = _displayTextFor(
      normalizedTag,
      parts,
      isInlineTag: isInlineTag,
    );

    return CompendiumLinkCandidate(
      tag: normalizedTag,
      rawReference: trimmedReference,
      displayText: displayText,
      lookupName: parts.first,
      targetEntityType: targetEntityType,
      parts: parts,
    );
  }

  static String _displayTextFor(
    String tag,
    List<String> parts, {
    required bool isInlineTag,
  }) {
    if (parts.length <= 1) {
      return parts.first;
    }

    switch (tag) {
      case 'classFeature':
        if (parts.length >= 4) {
          return _fallbackDisplay(parts[3], parts.first);
        }
        return parts.first;
      case 'subclass':
        return parts.length >= 3
            ? _fallbackDisplay(parts.last, parts.first)
            : parts.first;
      case 'subclassFeature':
        if (parts.length >= 5) {
          return _fallbackDisplay(parts[4], parts.first);
        }
        return parts.first;
      case 'subrace':
        return parts.length >= 3
            ? _fallbackDisplay(parts.last, parts.first)
            : parts.first;
      default:
        if (parts.length >= 3) {
          return _fallbackDisplay(parts[2], parts.first);
        }
        if (!isInlineTag &&
            parts.length == 2 &&
            !_looksLikeSourceToken(parts[1])) {
          return parts[1];
        }
        return parts.first;
    }
  }

  static String _fallbackDisplay(String candidate, String fallback) {
    final trimmed = candidate.trim();
    if (trimmed.isEmpty || _looksLikeSourceToken(trimmed)) {
      return fallback;
    }
    return trimmed;
  }

  static bool _looksLikeSourceToken(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.contains(' ')) {
      return false;
    }
    return RegExp(r'^[A-Za-z0-9_-]{2,12}$').hasMatch(trimmed);
  }

  static String? _normalizeTag(String tag) {
    const tagMap = <String, String>{
      'action': 'action',
      'background': 'background',
      'book': 'book',
      'class': 'class',
      'classFeature': 'classFeature',
      'condition': 'condition',
      'creature': 'monster',
      'deity': 'deity',
      'feat': 'feat',
      'item': 'item',
      'object': 'object',
      'optfeature': 'optionalfeature',
      'optionalfeature': 'optionalfeature',
      'race': 'race',
      'reward': 'reward',
      'sense': 'sense',
      'skill': 'skill',
      'spell': 'spell',
      'status': 'status',
      'subclass': 'subclass',
      'subclassFeature': 'subclassFeature',
      'subrace': 'subrace',
      'table': 'table',
      'trap': 'trap',
      'vehicle': 'vehicle',
      'variantrule': 'variantrule',
    };

    return tagMap[tag] ?? tag;
  }
}
