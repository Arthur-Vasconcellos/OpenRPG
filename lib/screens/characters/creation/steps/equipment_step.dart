import 'package:flutter/material.dart';
import 'package:openrpg/characters/data/character_editor_controller.dart';
import 'package:openrpg/screens/character_sheet/tabs/equipment_tab.dart';

class EquipmentStep extends StatelessWidget {
  final CharacterEditorController controller;

  const EquipmentStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return EquipmentTab(controller: controller);
  }
}
