import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class LevelUpDialog extends StatelessWidget {
  final Character character;
  final VoidCallback onLevelUp;

  const LevelUpDialog({
    super.key,
    required this.character,
    required this.onLevelUp,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Level Up!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Advancing to level ${character.level + 1}'),
          const SizedBox(height: 16),
          const Text('New Hit Points:'),
          Text('+? HP (+${character.modifiers.constitution} from CON)'),
          const SizedBox(height: 16),
          const Text('New class features available!'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onLevelUp();
            Navigator.pop(context);
          },
          child: const Text('Level Up'),
        ),
      ],
    );
  }
}