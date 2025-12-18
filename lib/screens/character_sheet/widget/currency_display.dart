import 'package:flutter/material.dart';
import 'package:openrpg/models/character.dart';

class CurrencyDisplay extends StatelessWidget {
  final Wealth wealth;

  const CurrencyDisplay({
    super.key,
    required this.wealth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCurrencyItem('CP', wealth.copper, Colors.orange.shade700, colorScheme),
        _buildCurrencyItem('SP', wealth.silver, Colors.grey.shade600, colorScheme),
        _buildCurrencyItem('EP', wealth.electrum, Colors.yellow.shade800, colorScheme),
        _buildCurrencyItem('GP', wealth.gold, Colors.yellow.shade600, colorScheme),
        _buildCurrencyItem('PP', wealth.platinum, Colors.blue.shade300, colorScheme),
      ],
    );
  }

  Widget _buildCurrencyItem(String label, int amount, Color color, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$amount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}