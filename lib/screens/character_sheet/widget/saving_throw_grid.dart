import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/characters/data/character_sheet_schema.dart';
import 'package:openrpg/models/character.dart';

class SavingThrowGrid extends StatelessWidget {
  final Character character;
  final CharacterEditorController controller;
  final List<CharacterAbilityDescriptor> abilities;

  const SavingThrowGrid({
    super.key,
    required this.character,
    required this.controller,
    required this.abilities,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: abilities.length,
      itemBuilder: (context, index) {
        final ability = abilities[index];
        final proficient = character.proficiencies.savingThrows.isProficient(
          ability.id,
        );
        final modifier = character.proficiencies.savingThrows.getModifier(
          ability.id,
          character.modifiers,
          character.proficiencies.proficiencyBonus,
        );

        return GestureDetector(
          onTap: () => controller.toggleSavingThrow(ability.id),
          child: Container(
            decoration: BoxDecoration(
              color: proficient
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: proficient
                    ? colorScheme.primary
                    : colorScheme.outline.withOpacity(0.3),
                width: proficient ? 2 : 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ability.abbreviation,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: proficient
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    modifier >= 0 ? '+$modifier' : '$modifier',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (proficient)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.check_circle,
                        size: 12,
                        color: colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
