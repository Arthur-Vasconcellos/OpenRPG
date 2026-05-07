import 'package:flutter/material.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';

class BuilderStepRail extends StatelessWidget {
  final List<CharacterBuilderStepDescriptor> steps;
  final CharacterBuilderStepId currentStep;
  final CharacterCreationProgress progress;
  final ValueChanged<CharacterBuilderStepId> onStepSelected;
  final Axis axis;

  const BuilderStepRail({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.progress,
    required this.onStepSelected,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal) {
      return SizedBox(
        height: 72,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: steps.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) => _StepRailItem(
            step: steps[index],
            selected: steps[index].id == currentStep,
            status:
                progress.stepStatuses[steps[index].id] ??
                CharacterBuilderStepStatus.notStarted,
            onTap: () => onStepSelected(steps[index].id),
            compact: true,
          ),
        ),
      );
    }

    return Card(
      child: SizedBox(
        width: 230,
        child: ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: steps.length,
          separatorBuilder: (_, _) => const SizedBox(height: 6),
          itemBuilder: (context, index) => _StepRailItem(
            step: steps[index],
            selected: steps[index].id == currentStep,
            status:
                progress.stepStatuses[steps[index].id] ??
                CharacterBuilderStepStatus.notStarted,
            onTap: () => onStepSelected(steps[index].id),
          ),
        ),
      ),
    );
  }
}

class _StepRailItem extends StatelessWidget {
  final CharacterBuilderStepDescriptor step;
  final CharacterBuilderStepStatus status;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  const _StepRailItem({
    required this.step,
    required this.status,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = switch (status) {
      CharacterBuilderStepStatus.complete => colorScheme.primary,
      CharacterBuilderStepStatus.warning => colorScheme.tertiary,
      CharacterBuilderStepStatus.error => colorScheme.error,
      CharacterBuilderStepStatus.notStarted => colorScheme.outline,
      CharacterBuilderStepStatus.skipped => colorScheme.outlineVariant,
    };
    final statusIcon = switch (status) {
      CharacterBuilderStepStatus.complete => Icons.check_circle,
      CharacterBuilderStepStatus.warning => Icons.warning_amber,
      CharacterBuilderStepStatus.error => Icons.error,
      CharacterBuilderStepStatus.notStarted => Icons.radio_button_unchecked,
      CharacterBuilderStepStatus.skipped => Icons.remove_circle_outline,
    };

    return Material(
      color: selected
          ? colorScheme.primaryContainer.withValues(alpha: 0.72)
          : colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: compact ? 150 : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Icon(step.icon, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  compact ? step.shortTitle : step.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(width: 8),
              Icon(statusIcon, size: 18, color: statusColor),
            ],
          ),
        ),
      ),
    );
  }
}
