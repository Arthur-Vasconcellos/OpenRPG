import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';

void main() {
  late CompendiumDatabase database;
  late CompendiumBrowseRepository browseRepository;
  late Directory tempDirectory;

  setUp(() async {
    database = CompendiumDatabase(executor: NativeDatabase.memory());
    browseRepository = CompendiumBrowseRepository(database: database);
    tempDirectory = await Directory.systemTemp.createTemp(
      'openrpg_compendium_import_test_',
    );
  });

  tearDown(() async {
    await database.close();
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test(
    'file-backed import indexes the ruleset and preserves a readable file',
    () async {
      final sourceFile = File('${tempDirectory.path}\\source.ruleset.json');
      await sourceFile.writeAsString(_rulesetJson());

      final repository = CompendiumRepository(
        database: database,
        assetLoader: (_) async => '{}',
        documentLoader: (path) => File(path).readAsBytes(),
        documentPersister:
            ({
              required String sourceReference,
              required String fileName,
            }) async {
              final persisted = File('${tempDirectory.path}\\$fileName');
              if (await persisted.exists()) {
                await persisted.delete();
              }
              await File(sourceReference).copy(persisted.path);
              return persisted.path;
            },
      );

      final imported = await repository.importRulesetFile(sourceFile.path);

      expect(imported.id, 'private_bundle');

      final record = await (database.select(
        database.rulesetRecords,
      )..where((tbl) => tbl.rulesetId.equals(imported.id))).getSingle();
      expect(record.payloadJson, '{}');
      expect(
        record.filePath,
        '${tempDirectory.path}\\private_bundle.ruleset.json',
      );
      expect(File(record.filePath).existsSync(), isTrue);

      final summaries = await browseRepository.loadCollectionSummaries(
        imported.id,
      );
      expect(summaries.length, compendiumEntityDescriptors.length);
      expect(
        summaries
            .firstWhere((summary) => summary.entityType == 'spell')
            .entityCount,
        1,
      );
      expect(
        summaries
            .firstWhere((summary) => summary.entityType == 'action')
            .entityCount,
        0,
      );

      final loaded = await repository.loadRuleset(imported.id);
      expect(loaded.totalEntityCount, 1);
      expect(loaded.entitiesForType('spell').single.name, 'Fire Bolt');
    },
  );

  test('string import still stores payload JSON for in-memory flows', () async {
    final repository = CompendiumRepository(
      database: database,
      assetLoader: (_) async => '{}',
    );

    final imported = await repository.importRulesetJson(_rulesetJson());

    final record = await (database.select(
      database.rulesetRecords,
    )..where((tbl) => tbl.rulesetId.equals(imported.id))).getSingle();
    expect(record.payloadJson, isNot('{}'));
    expect(record.entityCount, 1);

    final loaded = await repository.loadRuleset(imported.id);
    expect(loaded.totalEntityCount, 1);
    expect(loaded.entitiesForType('spell').single.name, 'Fire Bolt');
  });

  test(
    'unsupported collections are ignored during import and export',
    () async {
      final sourceFile = File(
        '${tempDirectory.path}\\unsupported_collections.ruleset.json',
      );
      await sourceFile.writeAsString(_duplicateCardRulesetJson());

      final repository = CompendiumRepository(
        database: database,
        assetLoader: (_) async => '{}',
        documentLoader: (path) => File(path).readAsBytes(),
        documentPersister:
            ({
              required String sourceReference,
              required String fileName,
            }) async {
              final persisted = File('${tempDirectory.path}\\$fileName');
              if (await persisted.exists()) {
                await persisted.delete();
              }
              await File(sourceReference).copy(persisted.path);
              return persisted.path;
            },
      );

      final imported = await repository.importRulesetFile(sourceFile.path);
      final rows =
          await (database.select(database.entityRecords)
                ..where((tbl) => tbl.rulesetId.equals(imported.id))
                ..orderBy([
                  (tbl) => drift.OrderingTerm.asc(tbl.entityType),
                  (tbl) => drift.OrderingTerm.asc(tbl.entityId),
                ]))
              .get();

      expect(rows, isEmpty);

      final summaries = await browseRepository.loadCollectionSummaries(
        imported.id,
      );
      expect(summaries.every((summary) => summary.entityCount == 0), isTrue);

      final loaded = await repository.loadRuleset(imported.id);
      expect(loaded.totalEntityCount, 0);

      final exportedJson = await repository.exportRulesetJson(imported.id);
      final exported = jsonDecode(exportedJson) as Map<String, dynamic>;
      expect(exported.containsKey('cardList'), isFalse);
    },
  );

  test('import rejects rulesets without a usable id or name', () async {
    final repository = CompendiumRepository(
      database: database,
      assetLoader: (_) async => '{}',
    );

    await expectLater(
      repository.importRulesetJson(
        jsonEncode({
          'schemaVersion': '1.0.0',
          'description': 'Missing identifiers.',
          'spellList': const <Map<String, Object?>>[],
        }),
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('non-empty "name" or "id"'),
        ),
      ),
    );
  });

  test('import rejects invalid mode values early', () async {
    final repository = CompendiumRepository(
      database: database,
      assetLoader: (_) async => '{}',
    );

    await expectLater(
      repository.importRulesetJson(
        jsonEncode({
          'schemaVersion': '1.0.0',
          'name': 'Broken Mode',
          'mode': 'mystery',
          'spellList': const <Map<String, Object?>>[],
        }),
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('Ruleset "mode"'),
        ),
      ),
    );
  });

  test(
    'import reports malformed collection entries with collection context',
    () async {
      final repository = CompendiumRepository(
        database: database,
        assetLoader: (_) async => '{}',
      );

      await expectLater(
        repository.importRulesetJson(
          jsonEncode({
            'schemaVersion': '1.0.0',
            'name': 'Broken Spell List',
            'spellList': const ['not an object'],
          }),
        ),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            contains('spellList'),
          ),
        ),
      );
    },
  );

  test('import rejects rulesets without an explicit schema version', () async {
    final repository = CompendiumRepository(
      database: database,
      assetLoader: (_) async => '{}',
    );

    await expectLater(
      repository.importRulesetJson(
        jsonEncode({
          'name': 'Schema-less Ruleset',
          'spellList': const <Map<String, Object?>>[],
        }),
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('Unsupported ruleset schema version ""'),
        ),
      ),
    );
  });

  test('import rejects unsupported schema versions', () async {
    final repository = CompendiumRepository(
      database: database,
      assetLoader: (_) async => '{}',
    );

    await expectLater(
      repository.importRulesetJson(
        jsonEncode({
          'schemaVersion': '0.9.0',
          'name': 'Old Ruleset',
          'spellList': const <Map<String, Object?>>[],
        }),
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('Unsupported ruleset schema version "0.9.0"'),
        ),
      ),
    );
  });

  test(
    'loadRuleset rejects imported records without current payload or index data',
    () async {
      final repository = CompendiumRepository(
        database: database,
        assetLoader: (_) async => '{}',
      );

      await database
          .into(database.rulesetRecords)
          .insert(
            RulesetRecordsCompanion.insert(
              rulesetId: 'orphan_ruleset',
              name: 'Orphan Ruleset',
              mode: 'imported',
              schemaVersion: '1.0.0',
              filePath: '${tempDirectory.path}\\orphan.ruleset.json',
              payloadJson: const drift.Value('{}'),
            ),
          );

      await expectLater(
        repository.loadRuleset('orphan_ruleset'),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('could not be loaded'),
          ),
        ),
      );
    },
  );
}

String _rulesetJson() {
  return jsonEncode({
    'schemaVersion': '1.0.0',
    'name': 'Private Bundle',
    'description': 'A private import used for device testing.',
    'author': 'OpenRPG',
    'version': '1.0.0',
    'license': 'Private',
    'spellList': [
      {
        'name': 'Fire Bolt',
        'source': 'SRD',
        'edition': '2024',
        'data': {
          'name': 'Fire Bolt',
          'source': 'SRD',
          'edition': '2024',
          'entries': ['A quick cantrip.'],
          'level': 0,
        },
      },
    ],
  });
}

String _duplicateCardRulesetJson() {
  return jsonEncode({
    'schemaVersion': '1.0.0',
    'name': 'Duplicate Cards',
    'description': 'Two cards that would previously collapse to the same id.',
    'author': 'OpenRPG',
    'version': '1.0.0',
    'license': 'Private',
    'cardList': [
      {
        'name': 'Eight',
        'source': 'ScreenDungeonKit',
        'sourceFile': 'decks/screendungeonkit/decks.json',
        'set': 'Initiative Cards',
        'suit': 'face',
        'data': {
          'name': 'Eight',
          'source': 'ScreenDungeonKit',
          'entries': ['You will go eighth in the initiative order.'],
          'face': {
            'type': 'image',
            'href': {
              'type': 'external',
              'path': 'decks/ScreenDungeonKit/Initiative/8.webp',
            },
          },
        },
      },
      {
        'name': 'Eight',
        'source': 'ScreenDungeonKit',
        'sourceFile': 'decks/screendungeonkit/decks.json',
        'set': 'Initiative Cards',
        'suit': 'text',
        'data': {
          'name': 'Eight',
          'source': 'ScreenDungeonKit',
          'entries': ['Alternative face for the same initiative rank.'],
          'face': {
            'type': 'image',
            'href': {
              'type': 'external',
              'path': 'decks/ScreenDungeonKit/Initiative/8-alt.webp',
            },
          },
        },
      },
    ],
  });
}
