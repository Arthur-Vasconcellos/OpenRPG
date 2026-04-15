class CompendiumLinkCandidate {
  final String tag;
  final String rawReference;
  final String displayText;
  final String? source;
  final String? targetEntityType;

  const CompendiumLinkCandidate({
    required this.tag,
    required this.rawReference,
    required this.displayText,
    this.source,
    this.targetEntityType,
  });
}

class CompendiumLinkParser {
  static final RegExp _tagExpression = RegExp(r'\{@([a-zA-Z]+)\s+([^}]+)\}');

  static Iterable<CompendiumLinkCandidate> extractAll(String value) sync* {
    for (final match in _tagExpression.allMatches(value)) {
      final tag = match.group(1)?.trim() ?? '';
      final body = match.group(2)?.trim() ?? '';
      if (tag.isEmpty || body.isEmpty) {
        continue;
      }

      final parts = body.split('|');
      final displayText = parts.first.trim();
      final source = parts.length > 1 && parts[1].trim().isNotEmpty
          ? parts[1].trim().toUpperCase()
          : null;

      yield CompendiumLinkCandidate(
        tag: tag,
        rawReference: body,
        displayText: displayText,
        source: source,
        targetEntityType: _normalizeTag(tag),
      );
    }
  }

  static String renderInlineLabel(String token) {
    final values = extractAll(token).toList();
    if (values.isEmpty) {
      return token;
    }

    return token.replaceAllMapped(_tagExpression, (match) {
      final body = match.group(2)?.trim() ?? '';
      final parts = body.split('|');
      return parts.first.trim();
    });
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
      'spell': 'spell',
      'status': 'status',
      'subclass': 'subclass',
      'subclassFeature': 'subclassFeature',
      'table': 'table',
      'trap': 'trap',
      'vehicle': 'vehicle',
      'variantrule': 'variantrule',
    };

    return tagMap[tag] ?? tag;
  }
}
