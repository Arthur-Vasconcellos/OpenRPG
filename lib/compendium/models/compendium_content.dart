import 'package:openrpg/compendium/models/compendium_link.dart';

class CompendiumRichContent {
  final List<CompendiumContentNode> nodes;

  const CompendiumRichContent({required this.nodes});

  factory CompendiumRichContent.fromDynamic(dynamic value) {
    if (value is List) {
      return CompendiumRichContent(
        nodes: value.map(CompendiumContentNode.fromDynamic).toList(),
      );
    }

    return CompendiumRichContent(
      nodes: [CompendiumContentNode.fromDynamic(value)],
    );
  }
}

class CompendiumContentNode {
  final String kind;
  final dynamic raw;

  const CompendiumContentNode({required this.kind, required this.raw});

  factory CompendiumContentNode.fromDynamic(dynamic value) {
    if (value is String) {
      return CompendiumContentNode(kind: 'text', raw: value);
    }

    if (value is Map<String, dynamic>) {
      final type = value['type']?.toString();
      return CompendiumContentNode(kind: type ?? 'object', raw: value);
    }

    if (value is List) {
      return CompendiumContentNode(kind: 'list', raw: value);
    }

    return CompendiumContentNode(kind: 'value', raw: value);
  }

  Iterable<CompendiumLinkCandidate> extractLinks() sync* {
    if (raw is String) {
      yield* CompendiumLinkParser.extractAll(raw as String);
      return;
    }

    if (raw is List) {
      for (final item in raw as List<dynamic>) {
        yield* CompendiumContentNode.fromDynamic(item).extractLinks();
      }
      return;
    }

    if (raw is Map<String, dynamic>) {
      for (final value in (raw as Map<String, dynamic>).values) {
        yield* CompendiumContentNode.fromDynamic(value).extractLinks();
      }
    }
  }
}
