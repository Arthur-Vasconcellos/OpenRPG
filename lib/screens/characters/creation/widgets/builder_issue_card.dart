import 'package:flutter/material.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';

class BuilderIssueCard extends StatelessWidget {
  final CharacterBuilderIssue issue;
  final VoidCallback? onAction;

  const BuilderIssueCard({super.key, required this.issue, this.onAction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (issue.severity) {
      CharacterBuilderIssueSeverity.error => colorScheme.error,
      CharacterBuilderIssueSeverity.warning => colorScheme.tertiary,
      CharacterBuilderIssueSeverity.info => colorScheme.primary,
    };
    final background = switch (issue.severity) {
      CharacterBuilderIssueSeverity.error => colorScheme.errorContainer,
      CharacterBuilderIssueSeverity.warning => colorScheme.tertiaryContainer,
      CharacterBuilderIssueSeverity.info => colorScheme.primaryContainer,
    };
    final icon = switch (issue.severity) {
      CharacterBuilderIssueSeverity.error => Icons.error_outline,
      CharacterBuilderIssueSeverity.warning => Icons.warning_amber_outlined,
      CharacterBuilderIssueSeverity.info => Icons.info_outline,
    };

    return Container(
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(issue.message),
                if (onAction != null) ...[
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: onAction,
                    child: Text(issue.actionLabel),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
