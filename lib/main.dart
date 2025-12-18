import 'package:flutter/material.dart';
import 'screens/character_sheet/character_sheet_screen.dart';
import 'screens/magic_item_list_screen.dart';

void main() {
  runApp(const DndSrdApp());
}

class DndSrdApp extends StatelessWidget {
  const DndSrdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D&D SRD Compendium',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CharacterSheetScreen(), // Changed to character sheet
      debugShowCheckedModeBanner: false,
    );
  }
}