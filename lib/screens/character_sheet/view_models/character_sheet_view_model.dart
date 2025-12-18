import 'package:openrpg/models/character.dart';

class CharacterSheetViewModel {
  Character updateCharacterAttribute(
      Character character,
      String attribute,
      int value,
      ) {
    // Centralize attribute update logic here
    final newValue = value.clamp(1, 30);
    final newAbilityScores = _updateAbilityScore(
      character.abilityScores,
      attribute,
      newValue,
    );

    return character.copyWith(
      abilityScores: newAbilityScores,
    ).copyWithCalculatedValues();
  }

  AbilityScores _updateAbilityScore(
      AbilityScores abilityScores,
      String attribute,
      int value,
      ) {
    switch (attribute) {
      case 'strength':
        return abilityScores.copyWith(strength: value);
      case 'dexterity':
        return abilityScores.copyWith(dexterity: value);
    // ... other attributes
      default:
        return abilityScores;
    }
  }

  Character updateSkillProficiency(
      Character character,
      Skill skill,
      ) {
    // Centralize skill proficiency update logic
    // ...
  }

  Character levelUpCharacter(Character character) {
    // Level up logic
    // ...
  }
}