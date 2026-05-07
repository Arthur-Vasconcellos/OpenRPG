import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/characters/creation/character_builder_step.dart';
import 'package:openrpg/screens/characters/creation/character_creation_progress.dart';
import 'package:openrpg/screens/characters/creation/widgets/builder_live_preview.dart';
import 'package:openrpg/screens/characters/creation/widgets/builder_step_rail.dart';

class CharacterBuilderShell extends StatelessWidget {
  final CharacterEditorController controller;
  final List<CharacterBuilderStepDescriptor> visibleSteps;
  final CharacterBuilderStepId currentStep;
  final CharacterCreationProgress progress;
  final ValueChanged<CharacterBuilderStepId> onStepSelected;
  final Widget child;

  const CharacterBuilderShell({
    super.key,
    required this.controller,
    required this.visibleSteps,
    required this.currentStep,
    required this.progress,
    required this.onStepSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 960;
        if (wide) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BuilderStepRail(
                  steps: visibleSteps,
                  currentStep: currentStep,
                  progress: progress,
                  onStepSelected: onStepSelected,
                ),
                const SizedBox(width: 12),
                Expanded(child: child),
                const SizedBox(width: 12),
                BuilderLivePreview(controller: controller),
              ],
            ),
          );
        }

        return Column(
          children: [
            BuilderStepRail(
              steps: visibleSteps,
              currentStep: currentStep,
              progress: progress,
              onStepSelected: onStepSelected,
              axis: Axis.horizontal,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(value: progress.completionRatio),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
