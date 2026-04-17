import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';

void main() {
  late CompendiumDatabase database;
  late CompendiumBrowseRepository browseRepository;
  late CompendiumRepository repository;
  late String bundledAssetJson;

  setUp(() async {
    database = CompendiumDatabase(executor: NativeDatabase.memory());
    browseRepository = CompendiumBrowseRepository(database: database);
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

    final emptyCollections = await browseRepository.loadCollectionSummaries(
      created.id,
    );
    expect(emptyCollections, isNotEmpty);
    expect(
      emptyCollections.any(
        (summary) => summary.entityType == 'spell' && summary.entityCount == 0,
      ),
      isTrue,
    );

    final entity = parseEntityJson('spell', {
      'id': 'spell:hb:ember_bolt',
      'name': 'Ember Bolt',
      'data': {
        'name': 'Ember Bolt',
        'entries': ['A bolt of harmless practice fire.'],
        'level': 0,
      },
    })!;

    final entity2024 = parseEntityJson('spell', {
      'id': 'spell:hb2:lantern_spark',
      'name': 'Lantern Spark',
      'data': {
        'name': 'Lantern Spark',
        'entries': ['A brighter ember tuned for the 2024 starter rules.'],
        'level': 0,
      },
    })!;

    await repository.saveEntity(rulesetId: created.id, entity: entity);
    await repository.saveEntity(rulesetId: created.id, entity: entity2024);

    final summaries = await repository.loadInstalledRulesets();
    final createdSummary = summaries.firstWhere(
      (summary) => summary.id == created.id,
    );
    expect(createdSummary.entityCount, 2);

    final results = await repository.searchEntities(
      CompendiumSearchQuery(text: 'ember', rulesetIds: [created.id]),
    );
    expect(
      results.any((result) => result.preview.displayName == 'Ember Bolt'),
      isTrue,
    );
    expect(
      results.every((result) => result.preview.entityType == 'spell'),
      isTrue,
    );
    expect(
      results.every((result) => result.preview.rulesetId == created.id),
      isTrue,
    );

    final page = await repository.getCollectionPage(
      rulesetId: created.id,
      entityType: 'spell',
    );
    expect(page.items, hasLength(2));
    expect(
      page.items.map((item) => item.displayName),
      containsAll(<String>['Ember Bolt', 'Lantern Spark']),
    );

    final exported = await repository.exportRulesetJson(created.id);
    expect(exported, contains('Ember Bolt'));
    expect(exported, contains('Lantern Spark'));
    expect(exported, contains('"schemaVersion"'));
    expect(exported, isNot(contains('"source"')));
    expect(exported, isNot(contains('"edition"')));
  });
}
