import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/ruleset.dart';

void main() {
  test('ruleset JSON round-trips and preserves unknown collections', () {
    final entity = parseEntityJson('action', {
      'id': 'action:test:attack',
      'name': 'Attack',
      'source': 'HB',
      'sourceFile': 'custom/action.json',
      'data': {
        'name': 'Attack',
        'source': 'HB',
        'entries': ['Strike once.'],
      },
    })!;

    final ruleset =
        Ruleset.createBlank(
              id: 'test_ruleset',
              name: 'Test Ruleset',
              description: 'Codec coverage',
            )
            .copyWith(
              extra: const {'customMeta': 'kept'},
              extraCollections: const {
                'reference': [
                  {'name': 'Cross-link hint'},
                ],
              },
            )
            .upsertEntity(entity);

    final decoded = Ruleset.fromJson(ruleset.toJson());

    expect(decoded.id, ruleset.id);
    expect(decoded.name, ruleset.name);
    expect(decoded.totalEntityCount, 1);
    expect(decoded.entitiesForType('action').single.displayName, 'Attack');
    expect(decoded.extra['customMeta'], 'kept');
    expect(
      decoded.extraCollections['reference']?.single['name'],
      'Cross-link hint',
    );
  });
}
