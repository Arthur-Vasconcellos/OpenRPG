import 'package:flutter/material.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_editor.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/screens/rulesets/compendium_rich_content_renderer.dart';
import 'package:openrpg/screens/rulesets/compendium_structured_support.dart';

const _globallyHiddenStructuredKeys = <String>{'additionalSources'};

class CompendiumStructuredAttributesView extends StatelessWidget {
  final String? entityType;
  final List<CompendiumFieldDescriptor>? fields;
  final Map<String, dynamic> data;
  final CompendiumLinkTap? onLinkTap;
  final Set<String> hiddenKeys;
  final bool compact;
  final String emptyText;
  final bool showAdditionalData;
  final String additionalDataTitle;

  const CompendiumStructuredAttributesView({
    super.key,
    this.entityType,
    this.fields,
    required this.data,
    this.onLinkTap,
    this.hiddenKeys = const <String>{},
    this.compact = false,
    this.emptyText = 'No additional attributes.',
    this.showAdditionalData = true,
    this.additionalDataTitle = 'Additional Data',
  }) : assert(entityType != null || fields != null);

  @override
  Widget build(BuildContext context) {
    final effectiveHiddenKeys = {
      ...CompendiumJsonUtils.hiddenProvenanceKeys,
      ..._globallyHiddenStructuredKeys,
      ...hiddenKeys,
    };
    final descriptorFields =
        fields ??
        editorDescriptorForType(entityType ?? '')?.fields ??
        const <CompendiumFieldDescriptor>[];
    final renderedKeys = <String>{};
    final children = <Widget>[];

    for (final field in descriptorFields) {
      if (effectiveHiddenKeys.contains(field.key)) {
        continue;
      }

      final value = data[field.key];
      if (!data.containsKey(field.key) ||
          !compendiumHasMeaningfulValue(value)) {
        continue;
      }

      renderedKeys.add(field.key);
      children.add(
        Padding(
          padding: EdgeInsets.only(bottom: compact ? 10 : 14),
          child: CompendiumStructuredFieldView(
            field: field,
            value: value,
            onLinkTap: onLinkTap,
            compact: compact,
          ),
        ),
      );
    }

    final additionalEntries = data.entries
        .where((entry) => !effectiveHiddenKeys.contains(entry.key))
        .where((entry) => !renderedKeys.contains(entry.key))
        .where((entry) => compendiumHasMeaningfulValue(entry.value))
        .toList(growable: false);

    if (showAdditionalData && additionalEntries.isNotEmpty) {
      children.add(
        Padding(
          padding: EdgeInsets.only(bottom: compact ? 10 : 14),
          child: _CompendiumAdditionalDataSection(
            title: additionalDataTitle,
            entries: additionalEntries,
            compact: compact,
            onLinkTap: onLinkTap,
          ),
        ),
      );
    }

    if (children.isEmpty) {
      return Text(emptyText);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class CompendiumStructuredFieldView extends StatelessWidget {
  final CompendiumFieldDescriptor field;
  final dynamic value;
  final CompendiumLinkTap? onLinkTap;
  final bool compact;

  const CompendiumStructuredFieldView({
    super.key,
    required this.field,
    required this.value,
    this.onLinkTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (field.isArray || value is List) {
      return _buildListField(context);
    }

    if (field.kind == CompendiumFieldKind.object || value is Map) {
      return _buildObjectField(context);
    }

    return _StructuredSectionCard(
      compact: compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldHeading(field: field, compact: compact),
          SizedBox(height: compact ? 8 : 10),
          CompendiumStructuredValueView(
            field: field,
            value: value,
            onLinkTap: onLinkTap,
            compact: compact,
          ),
        ],
      ),
    );
  }

  Widget _buildListField(BuildContext context) {
    final values = compendiumAsList(value);
    if (values.isEmpty) {
      return const SizedBox.shrink();
    }

    final itemDescriptor =
        field.itemDescriptor ??
        compendiumInferDescriptor('item', values.first, label: 'Item');
    final allPrimitive = values.every(_isPrimitiveValue);

    if (allPrimitive && !values.any(compendiumLooksLikeRichContent)) {
      return _StructuredSectionCard(
        compact: compact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldHeading(field: field, compact: compact),
            SizedBox(height: compact ? 8 : 10),
            CompendiumStructuredValueView(
              field: field,
              value: values,
              onLinkTap: onLinkTap,
              compact: compact,
            ),
          ],
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(field.label),
        subtitle: compact ? null : Text(field.key),
        initiallyExpanded: compact,
        childrenPadding: EdgeInsets.fromLTRB(
          compact ? 12 : 16,
          0,
          compact ? 12 : 16,
          compact ? 12 : 16,
        ),
        children: [
          for (var index = 0; index < values.length; index++)
            Padding(
              padding: EdgeInsets.only(bottom: compact ? 10 : 12),
              child: _buildListItemView(
                context,
                index: index,
                itemValue: values[index],
                itemDescriptor: itemDescriptor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListItemView(
    BuildContext context, {
    required int index,
    required dynamic itemValue,
    required CompendiumFieldDescriptor itemDescriptor,
  }) {
    final referenceCandidate = itemValue is String
        ? CompendiumLinkParser.tryParsePlainReference(
            itemValue,
            hintedFieldKey: field.key,
          )
        : null;
    if (referenceCandidate != null) {
      return _StructuredSectionCard(
        compact: compact,
        child: _CompendiumReferenceAction(
          candidate: referenceCandidate,
          onLinkTap: onLinkTap,
          compact: compact,
          label: '${field.label} #${index + 1}',
        ),
      );
    }

    if (_isPrimitiveValue(itemValue) &&
        !compendiumLooksLikeRichContent(itemValue)) {
      return _StructuredSectionCard(
        compact: compact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${field.label} #${index + 1}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: compact ? 8 : 10),
            CompendiumStructuredValueView(
              field: itemDescriptor.copyWith(
                label: '${field.label} #${index + 1}',
              ),
              value: itemValue,
              onLinkTap: onLinkTap,
              compact: compact,
            ),
          ],
        ),
      );
    }

    if (itemValue is Map || itemDescriptor.kind == CompendiumFieldKind.object) {
      final mapValue = compendiumAsMap(itemValue);
      final mapReference = CompendiumLinkParser.extractReferenceFromMap(
        mapValue,
      );
      if (mapReference != null) {
        final remainingEntries = Map<String, dynamic>.from(mapValue)
          ..removeWhere(
            (key, value) =>
                CompendiumLinkParser.tryParsePlainReference(
                  value?.toString() ?? '',
                  hintedFieldKey: key,
                ) !=
                null,
          );
        return _StructuredSectionCard(
          compact: compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CompendiumReferenceAction(
                candidate: mapReference,
                onLinkTap: onLinkTap,
                compact: compact,
                label: '${field.label} #${index + 1}',
              ),
              if (remainingEntries.isNotEmpty) ...[
                SizedBox(height: compact ? 10 : 12),
                CompendiumStructuredAttributesView(
                  fields: compendiumMergeKnownAndInferredFields(
                    itemDescriptor.fields,
                    remainingEntries,
                  ),
                  data: remainingEntries,
                  onLinkTap: onLinkTap,
                  compact: compact,
                  emptyText: 'No additional values.',
                ),
              ],
            ],
          ),
        );
      }

      final mergedFields = compendiumMergeKnownAndInferredFields(
        itemDescriptor.fields,
        mapValue,
      );
      return Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          title: Text('${field.label} #${index + 1}'),
          initiallyExpanded: compact,
          childrenPadding: EdgeInsets.fromLTRB(
            compact ? 12 : 16,
            0,
            compact ? 12 : 16,
            compact ? 12 : 16,
          ),
          children: [
            CompendiumStructuredAttributesView(
              fields: mergedFields,
              data: mapValue,
              onLinkTap: onLinkTap,
              compact: compact,
              emptyText: 'No nested values.',
            ),
          ],
        ),
      );
    }

    return _StructuredSectionCard(
      compact: compact,
      child: CompendiumRichContentRenderer(
        content: itemValue,
        onLinkTap: onLinkTap,
      ),
    );
  }

  Widget _buildObjectField(BuildContext context) {
    final mapValue = compendiumAsMap(value);
    if (mapValue.isEmpty) {
      return const SizedBox.shrink();
    }

    final mergedFields = compendiumMergeKnownAndInferredFields(
      field.fields,
      mapValue,
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(field.label),
        subtitle: compact ? null : Text(field.key),
        initiallyExpanded: compact,
        childrenPadding: EdgeInsets.fromLTRB(
          compact ? 12 : 16,
          0,
          compact ? 12 : 16,
          compact ? 12 : 16,
        ),
        children: [
          CompendiumStructuredAttributesView(
            fields: mergedFields,
            data: mapValue,
            onLinkTap: onLinkTap,
            compact: compact,
            emptyText: 'No nested values.',
          ),
        ],
      ),
    );
  }

  bool _isPrimitiveValue(dynamic itemValue) {
    return itemValue == null ||
        itemValue is String ||
        itemValue is num ||
        itemValue is bool;
  }
}

class CompendiumStructuredValueView extends StatelessWidget {
  final CompendiumFieldDescriptor field;
  final dynamic value;
  final CompendiumLinkTap? onLinkTap;
  final bool compact;

  const CompendiumStructuredValueView({
    super.key,
    required this.field,
    required this.value,
    this.onLinkTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return const Text('None');
    }

    if (value is String) {
      final referenceCandidate = CompendiumLinkParser.tryParsePlainReference(
        value,
        hintedFieldKey: field.key,
      );
      if (referenceCandidate != null) {
        return _CompendiumReferenceAction(
          candidate: referenceCandidate,
          onLinkTap: onLinkTap,
          compact: compact,
          label: field.label,
        );
      }
    }

    if (field.kind == CompendiumFieldKind.boolean || value is bool) {
      final enabled = value == true;
      return Chip(
        label: Text(enabled ? 'Yes' : 'No'),
        avatar: Icon(
          enabled ? Icons.check_circle_outline : Icons.remove_circle_outline,
          size: 18,
        ),
      );
    }

    if (field.choices.isNotEmpty) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [Chip(label: Text(value.toString()))],
      );
    }

    if (value is List) {
      final values = compendiumAsList(value);
      final referenceCandidates = values
          .map(
            (item) => item is String
                ? CompendiumLinkParser.tryParsePlainReference(
                    item,
                    hintedFieldKey: field.key,
                  )
                : null,
          )
          .toList(growable: false);
      final allReferences =
          values.isNotEmpty &&
          referenceCandidates.every((candidate) => candidate != null);
      if (allReferences) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final candidate
                in referenceCandidates.whereType<CompendiumLinkCandidate>())
              _CompendiumReferenceChip(
                candidate: candidate,
                onLinkTap: onLinkTap,
              ),
          ],
        );
      }

      final allShort = values.every(
        (item) => item is String && item.trim().isNotEmpty && item.length <= 30,
      );

      if (allShort) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values
              .map((item) => Chip(label: Text(item.toString())))
              .toList(growable: false),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: values
            .map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.circle, size: 8),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: _renderLeafValue(context, item)),
                  ],
                ),
              );
            })
            .toList(growable: false),
      );
    }

    return _renderLeafValue(context, value);
  }

  Widget _renderLeafValue(BuildContext context, dynamic leafValue) {
    if (compendiumLooksLikeRichContent(leafValue)) {
      return CompendiumRichContentRenderer(
        content: leafValue,
        onLinkTap: onLinkTap,
      );
    }

    if (leafValue is String) {
      final referenceCandidate = CompendiumLinkParser.tryParsePlainReference(
        leafValue,
        hintedFieldKey: field.key,
      );
      if (referenceCandidate != null) {
        return _CompendiumReferenceAction(
          candidate: referenceCandidate,
          onLinkTap: onLinkTap,
          compact: compact,
          label: field.label,
        );
      }
      return SelectableText(leafValue);
    }

    return SelectableText(leafValue.toString());
  }
}

class _CompendiumAdditionalDataSection extends StatelessWidget {
  final String title;
  final List<MapEntry<String, dynamic>> entries;
  final bool compact;
  final CompendiumLinkTap? onLinkTap;

  const _CompendiumAdditionalDataSection({
    required this.title,
    required this.entries,
    required this.compact,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('compendium-additional-data'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(title),
        subtitle: const Text('Advanced fields and raw payloads'),
        childrenPadding: EdgeInsets.fromLTRB(
          compact ? 12 : 16,
          0,
          compact ? 12 : 16,
          compact ? 12 : 16,
        ),
        children: entries
            .map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: compact ? 10 : 12),
                child: _StructuredSectionCard(
                  compact: compact,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        compendiumLabelForKey(entry.key),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: compact ? 8 : 10),
                      _buildAdditionalValue(context, entry),
                    ],
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }

  Widget _buildAdditionalValue(
    BuildContext context,
    MapEntry<String, dynamic> entry,
  ) {
    if (entry.value is String || entry.value is num || entry.value is bool) {
      return CompendiumStructuredValueView(
        field: compendiumInferDescriptor(entry.key, entry.value),
        value: entry.value,
        compact: compact,
        onLinkTap: onLinkTap,
      );
    }

    if (compendiumLooksLikeRichContent(entry.value)) {
      return CompendiumRichContentRenderer(
        content: entry.value,
        onLinkTap: onLinkTap,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(
          CompendiumJsonUtils.prettyJson(entry.value),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
        ),
      ),
    );
  }
}

class _StructuredSectionCard extends StatelessWidget {
  final Widget child;
  final bool compact;

  const _StructuredSectionCard({required this.child, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(compact ? 16 : 20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _CompendiumReferenceAction extends StatelessWidget {
  final CompendiumLinkCandidate candidate;
  final CompendiumLinkTap? onLinkTap;
  final bool compact;
  final String label;

  const _CompendiumReferenceAction({
    required this.candidate,
    required this.onLinkTap,
    required this.compact,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.tonalIcon(
      onPressed: onLinkTap == null ? null : () => onLinkTap!(candidate),
      icon: const Icon(Icons.open_in_new, size: 18),
      label: Text(candidate.displayText),
    );

    if (compact) {
      return button;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        button,
      ],
    );
  }
}

class _CompendiumReferenceChip extends StatelessWidget {
  final CompendiumLinkCandidate candidate;
  final CompendiumLinkTap? onLinkTap;

  const _CompendiumReferenceChip({
    required this.candidate,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.visibility_outlined, size: 18),
      label: Text(candidate.displayText),
      onPressed: onLinkTap == null ? null : () => onLinkTap!(candidate),
    );
  }
}

class _FieldHeading extends StatelessWidget {
  final CompendiumFieldDescriptor field;
  final bool compact;

  const _FieldHeading({required this.field, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: Theme.of(context).textTheme.titleSmall),
        if (!compact)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              field.key,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
