import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_compendium_service.dart';
import 'package:openrpg/models/character.dart';
import 'package:openrpg/screens/character_sheet/widget/character_entity_summary_card.dart';

class BuildSelectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final CharacterEntityRef? reference;
  final CharacterCompendiumService service;
  final String emptyLabel;
  final String helperText;
  final VoidCallback? onSelect;
  final VoidCallback? onClear;
  final String selectLabel;

  const BuildSelectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.reference,
    required this.service,
    required this.emptyLabel,
    required this.helperText,
    required this.onSelect,
    this.onClear,
    required this.selectLabel,
  });

  @override
  Widget build(BuildContext context) {
    final reference = this.reference;
    final unresolved = reference != null && !reference.isResolved;
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = unresolved
        ? colorScheme.error
        : reference == null
        ? colorScheme.outlineVariant
        : colorScheme.primary.withValues(alpha: 0.35);
    final backgroundColor = unresolved
        ? colorScheme.errorContainer.withValues(alpha: 0.32)
        : colorScheme.surfaceContainerLow;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reference == null
                            ? emptyLabel
                            : unresolved
                            ? 'This saved choice needs attention. Choose it again from your installed rules.'
                            : helperText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: unresolved
                              ? colorScheme.onErrorContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onSelect,
                  icon: Icon(reference == null ? Icons.add : Icons.swap_horiz),
                  label: Text(selectLabel),
                ),
                if (onClear != null)
                  TextButton.icon(
                    onPressed: onClear,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                  ),
              ],
            ),
            if (reference != null) ...[
              const SizedBox(height: 12),
              CharacterEntitySummaryCard(
                title: title,
                reference: reference,
                service: service,
                embedded: true,
                showTitle: false,
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(helperText, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
