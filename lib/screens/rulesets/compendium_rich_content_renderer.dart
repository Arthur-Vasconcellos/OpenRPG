import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';

typedef CompendiumLinkTap =
    Future<void> Function(CompendiumLinkCandidate candidate);

class CompendiumRichContentRenderer extends StatelessWidget {
  final dynamic content;
  final CompendiumLinkTap? onLinkTap;

  const CompendiumRichContentRenderer({
    super.key,
    required this.content,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return _buildNode(context, content);
  }

  Widget _buildNode(
    BuildContext context,
    dynamic value, {
    String? hintedFieldKey,
  }) {
    if (value == null) {
      return const SizedBox.shrink();
    }

    if (value is String) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildText(
          context,
          value,
          hintedFieldKey: hintedFieldKey,
        ),
      );
    }

    if (value is List) {
      if (value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value
            .map(
              (entry) => _buildNode(
                context,
                entry,
                hintedFieldKey: hintedFieldKey,
              ),
            )
            .toList(),
      );
    }

    if (value is Map<String, dynamic>) {
      final type = value['type']?.toString();
      switch (type) {
        case 'entries':
          return _buildEntriesBlock(context, value);
        case 'list':
          return _buildListBlock(context, value);
        case 'table':
          return _buildTableBlock(context, value);
        case 'inset':
        case 'quote':
          return _buildInsetBlock(context, value);
        case 'item':
          return _buildItemBlock(context, value);
        default:
          if (value.containsKey('entries')) {
            return _buildEntriesBlock(context, value);
          }
          if (value.containsKey('items')) {
            return _buildListBlock(context, value);
          }
          return _buildFallbackMap(context, value);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(value.toString()),
    );
  }

  Widget _buildEntriesBlock(BuildContext context, Map<String, dynamic> value) {
    final title = value['name']?.toString();
    final entries = value['entries'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          _buildNode(context, entries),
        ],
      ),
    );
  }

  Widget _buildListBlock(BuildContext context, Map<String, dynamic> value) {
    final title = value['name']?.toString();
    final items = value['items'] as List<dynamic>? ?? const [];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(Icons.circle, size: 8),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _buildNode(context, item)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTableBlock(BuildContext context, Map<String, dynamic> value) {
    final title = value['caption']?.toString() ?? value['name']?.toString();
    final columns = (value['colLabels'] as List<dynamic>? ?? const [])
        .map((entry) => entry.toString())
        .toList(growable: false);
    final rows = value['rows'] as List<dynamic>? ?? const [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: columns.isEmpty
                  ? const [DataColumn(label: Text('Value'))]
                  : columns
                        .map((column) => DataColumn(label: Text(column)))
                        .toList(),
              rows: rows.map((row) {
                final cells = row is List ? row : <dynamic>[row];
                return DataRow(
                  cells: cells
                      .map(
                        (cell) => DataCell(
                          SizedBox(
                            width: 220,
                            child: _buildNode(context, cell),
                          ),
                        ),
                      )
                      .toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsetBlock(BuildContext context, Map<String, dynamic> value) {
    final title = value['name']?.toString();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          _buildNode(context, value['entries']),
        ],
      ),
    );
  }

  Widget _buildItemBlock(BuildContext context, Map<String, dynamic> value) {
    final title = value['name']?.toString() ?? '';
    final entry = value['entry'] ?? value['entries'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(title, style: Theme.of(context).textTheme.titleSmall),
            ),
          _buildNode(context, entry),
        ],
      ),
    );
  }

  Widget _buildFallbackMap(BuildContext context, Map<String, dynamic> value) {
    final visibleEntries = value.entries
        .where((entry) => entry.key != 'type')
        .toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: visibleEntries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              _buildNode(
                context,
                entry.value,
                hintedFieldKey: entry.key,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildText(
    BuildContext context,
    String value, {
    String? hintedFieldKey,
  }) {
    final plainReference = CompendiumLinkParser.tryParsePlainReference(
      value,
      hintedFieldKey: hintedFieldKey,
    );
    if (plainReference != null) {
      if (onLinkTap == null) {
        return Text(plainReference.displayText);
      }

      return Align(
        alignment: Alignment.centerLeft,
        child: ActionChip(
          avatar: const Icon(Icons.visibility_outlined, size: 18),
          label: Text(plainReference.displayText),
          onPressed: () => onLinkTap!(plainReference),
        ),
      );
    }

    final regex = RegExp(r'\{@([a-zA-Z]+)\s+([^}]+)\}');
    final matches = regex.allMatches(value).toList();
    if (matches.isEmpty) {
      return Text(CompendiumLinkParser.renderInlineLabel(value));
    }

    final spans = <InlineSpan>[];
    var lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: value.substring(lastEnd, match.start)));
      }

      final token = value.substring(match.start, match.end);
      final candidate = CompendiumLinkParser.extractAll(token).first;
      spans.add(
        TextSpan(
          text: candidate.displayText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
          recognizer: onLinkTap == null
              ? null
              : (TapGestureRecognizer()
                  ..onTap = () {
                    onLinkTap!(candidate);
                  }),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < value.length) {
      spans.add(TextSpan(text: value.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: spans,
      ),
    );
  }
}
