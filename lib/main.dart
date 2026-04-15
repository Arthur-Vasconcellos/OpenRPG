import 'package:flutter/material.dart';
import 'screens/workspace_home_screen.dart';

void main() {
  runApp(const DndSrdApp());
}

class DndSrdApp extends StatelessWidget {
  const DndSrdApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2F6B62),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      fontFamily: 'Georgia',
    );

    return MaterialApp(
      title: 'OpenRPG',
      theme: base.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF4EEE1),
        cardTheme: base.cardTheme.copyWith(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      home: const WorkspaceHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
