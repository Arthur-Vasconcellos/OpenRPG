import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/character_sheet/tabs/spells_tab.dart';

class SpellsStep extends StatelessWidget {
  final CharacterEditorController controller;

  const SpellsStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SpellsTab(controller: controller);
  }
}
