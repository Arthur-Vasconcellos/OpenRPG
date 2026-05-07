enum CharacterCreationMode {
  guided,
  expert;

  String get label {
    return switch (this) {
      CharacterCreationMode.guided => 'Guided Builder',
      CharacterCreationMode.expert => 'Expert Builder',
    };
  }

  String get description {
    return switch (this) {
      CharacterCreationMode.guided =>
        'Step through the build with progress, warnings, and a review pass.',
      CharacterCreationMode.expert =>
        'Open the full sheet immediately with a creation checklist nearby.',
    };
  }

  String get storageValue {
    return switch (this) {
      CharacterCreationMode.guided => 'guided',
      CharacterCreationMode.expert => 'expert',
    };
  }
}
