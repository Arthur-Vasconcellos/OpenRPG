import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/screens/character_sheet/widget/attribute_card.dart';

class AbilityScoreGrid extends StatelessWidget {
  final CharacterEditorController controller;
  final List<CharacterAbilityDescriptor> abilities;

  const AbilityScoreGrid({
    super.key,
    required this.controller,
    required this.abilities,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 520 ? 2 : 3;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.86,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: abilities.length,
          itemBuilder: (context, index) {
            final ability = abilities[index];
            return AttributeCard(
              abbreviation: ability.abbreviation,
              name: ability.label,
              value: controller.abilityScoreFor(ability.id),
              modifier: controller.abilityModifierFor(ability.id),
              onDecrement: () => _adjustAbility(ability.id, -1),
              onIncrement: () => _adjustAbility(ability.id, 1),
            );
          },
        );
      },
    );
  }

  void _adjustAbility(String ability, int delta) {
    final currentScore = controller.abilityScoreFor(ability);
    controller.setAbilityScore(ability, currentScore + delta);
  }
}
