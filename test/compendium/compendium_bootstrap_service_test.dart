import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/data/compendium_bootstrap_service.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/models/compendium_browse_asset.dart';

void main() {
  late CompendiumDatabase database;

  setUp(() async {
    database = CompendiumDatabase(executor: NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('manifest-driven bootstrap imports the starter ruleset', () async {
    final service = CompendiumBootstrapService(
      database: database,
      binaryReader: (_) async => _byteDataFromString(_starterShardJson()),
    );

    await service.ensureBootstrappedWithManifest(_starterManifest());

    final rulesets = await (database.select(database.rulesetRecords)).get();
    expect(rulesets, hasLength(1));
    expect(rulesets.single.rulesetId, 'starter_2024_srd');
    expect(rulesets.single.name, 'Starter SRD');

    final status = await service.loadStatus('starter_2024_srd');
    expect(status.isReady, isTrue);
    expect(status.lastError, isNull);
  });

  test(
    'manifest load failures are tagged with the manifest load stage',
    () async {
      final service = CompendiumBootstrapService(
        database: database,
        stringReader: (_) async => throw StateError('asset missing'),
      );

      expect(
        service.loadManifest(),
        throwsA(
          isA<CompendiumBootstrapFailure>().having(
            (error) => error.stage,
            'stage',
            CompendiumBootstrapFailureStage.manifestLoad,
          ),
        ),
      );
    },
  );

  test(
    'shard load failures are tagged and written to bootstrap status',
    () async {
      final service = CompendiumBootstrapService(
        database: database,
        binaryReader: (_) async => throw StateError('unable to open shard'),
      );

      await expectLater(
        service.ensureBootstrappedWithManifest(_starterManifest()),
        throwsA(
          isA<CompendiumBootstrapFailure>().having(
            (error) => error.stage,
            'stage',
            CompendiumBootstrapFailureStage.shardLoad,
          ),
        ),
      );

      final status = await service.loadStatus('starter_2024_srd');
      expect(status.isFailed, isTrue);
      expect(status.lastError, contains('shard load failed'));
    },
  );
}

CompendiumBrowseManifest _starterManifest() {
  return CompendiumBrowseManifest(
    assetVersion: 'starter-v1',
    rulesets: [
      CompendiumBrowseRulesetAsset(
        rulesetId: 'starter_2024_srd',
        name: 'Starter SRD',
        description: 'Built-in starter.',
        mode: 'bundled',
        schemaVersion: '1.0.0',
        author: 'OpenRPG',
        version: '2024.1',
        license: 'CC-BY-4.0',
        entityCount: 1,
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
        filePath: 'assets/rulesets/starter_2024_srd.ruleset.json',
        collectionStats: const [
          CompendiumBrowseCollectionStatAsset(
            entityType: 'spell',
            collectionKey: 'spellList',
            label: 'Spells',
            entityCount: 1,
          ),
        ],
        shards: const [
          CompendiumBrowseShardAsset(
            entityType: 'spell',
            collectionKey: 'spellList',
            assetPath: 'assets/rulesets/browse/starter_spell.json',
            entityCount: 1,
            linkCount: 0,
          ),
        ],
      ),
    ],
  );
}

String _starterShardJson() {
  return jsonEncode({
    'rulesetId': 'starter_2024_srd',
    'entityType': 'spell',
    'collectionKey': 'spellList',
    'entityRows': [
      {
        'entityId': 'spell:starter:fire_bolt',
        'name': 'Fire Bolt',
        'source': 'SRD',
        'sourceFile': 'starter/spell.json',
        'edition': '2024',
        'sortName': 'fire bolt',
        'searchText': 'fire bolt starter srd',
        'payloadJson': jsonEncode({
          'id': 'spell:starter:fire_bolt',
          'name': 'Fire Bolt',
          'source': 'SRD',
          'sourceFile': 'starter/spell.json',
          'edition': '2024',
          'data': {
            'name': 'Fire Bolt',
            'source': 'SRD',
            'edition': '2024',
            'entries': ['A quick starter cantrip.'],
            'level': 0,
          },
        }),
      },
    ],
    'linkRows': const [],
  });
}

ByteData _byteDataFromString(String value) {
  final bytes = Uint8List.fromList(utf8.encode(value));
  return ByteData.view(bytes.buffer);
}
