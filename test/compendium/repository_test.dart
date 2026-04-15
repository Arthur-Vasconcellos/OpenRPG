import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';

void main() {
  late CompendiumDatabase database;
  late CompendiumRepository repository;
  late String bundledAssetJson;

  setUp(() async {
    database = CompendiumDatabase(executor: NativeDatabase.memory());
    bundledAssetJson = '''
{
  "schemaVersion": "1.0.0",
  "id": "bundled_test",
  "name": "Bundled Test",
  "description": "",
  "author": "Test",
  "version": "1.0.0",
  "license": "",
  "mode": "bundled",
  "actionList": [],
  "spellList": []
}
''';
    repository = CompendiumRepository(
      database: database,
      assetLoader: (_) async => bundledAssetJson,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('repository saves, searches, and exports editable rulesets', () async {
    final created = await repository.createRuleset(
      name: 'Homebrew Lab',
      description: 'Editable playground',
    );

    final entity = parseEntityJson('spell', {
      'id': 'spell:hb:ember_bolt',
      'name': 'Ember Bolt',
      'source': 'HB',
      'sourceFile': 'custom/spell.json',
      'data': {
        'name': 'Ember Bolt',
        'source': 'HB',
        'entries': ['A bolt of harmless practice fire.'],
        'level': 0,
      },
    })!;

    await repository.saveEntity(rulesetId: created.id, entity: entity);

    final summaries = await repository.loadInstalledRulesets();
    final createdSummary = summaries.firstWhere(
      (summary) => summary.id == created.id,
    );
    expect(createdSummary.entityCount, 1);

    final results = await repository.searchEntities(
      CompendiumSearchQuery(text: 'ember', rulesetIds: [created.id]),
    );
    expect(results.single.entity.displayName, 'Ember Bolt');

    final exported = await repository.exportRulesetJson(created.id);
    expect(exported, contains('Ember Bolt'));
    expect(exported, contains('"schemaVersion"'));
  });
}
