import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/data/compendium_bootstrap_service.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/screens/rulesets/ruleset_library_screen.dart';

void main() {
  late CompendiumDatabase database;
  late CompendiumBrowseRepository browseRepository;
  late CompendiumRepository repository;

  setUp(() async {
    database = CompendiumDatabase(executor: NativeDatabase.memory());
    browseRepository = CompendiumBrowseRepository(database: database);
    repository = CompendiumRepository(
      database: database,
      assetLoader: (_) async => '{}',
    );
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets(
    'startup manifest load failure shows a failure card instead of an empty library',
    (tester) async {
      final service = CompendiumBootstrapService(
        database: database,
        stringReader: (_) async => throw StateError('manifest missing'),
      );

      await tester.pumpWidget(
        _buildLibraryScreen(
          service: service,
          browseRepository: browseRepository,
          repository: repository,
        ),
      );
      await _pumpUntilFound(
        tester,
        find.text('Bundled starter startup failed'),
      );

      expect(find.text('Bundled starter startup failed'), findsOneWidget);
      expect(find.textContaining('manifest load failed'), findsOneWidget);
      expect(find.text('No rulesets installed yet.'), findsNothing);
    },
  );

  testWidgets('retry reruns initialization after a startup failure', (
    tester,
  ) async {
    var shouldFail = true;
    final service = CompendiumBootstrapService(
      database: database,
      stringReader: (_) async {
        if (shouldFail) {
          throw StateError('manifest missing');
        }

        return _starterManifestJson();
      },
      binaryReader: (_) async => _byteDataFromString(_starterShardJson()),
    );

    await tester.pumpWidget(
      _buildLibraryScreen(
        service: service,
        browseRepository: browseRepository,
        repository: repository,
      ),
    );
    await _pumpUntilFound(tester, find.text('Bundled starter startup failed'));

    expect(find.text('Bundled starter startup failed'), findsOneWidget);

    shouldFail = false;
    final retryButton = find.widgetWithText(FilledButton, 'Retry');
    await tester.ensureVisible(retryButton);
    await tester.tap(retryButton);
    await tester.pump();
    await _pumpUntilFound(tester, find.text('Starter SRD'));

    expect(find.text('Bundled starter startup failed'), findsNothing);
    expect(find.text('Starter SRD'), findsOneWidget);
  });
}

Widget _buildLibraryScreen({
  required CompendiumBootstrapService service,
  required CompendiumBrowseRepository browseRepository,
  required CompendiumRepository repository,
}) {
  return MaterialApp(
    home: RulesetLibraryScreen(
      bootstrapService: service,
      browseRepository: browseRepository,
      repository: repository,
    ),
  );
}

String _starterManifestJson() {
  return jsonEncode({
    'assetVersion': 'starter-v1',
    'rulesets': [
      {
        'rulesetId': 'starter_2024_srd',
        'name': 'Starter SRD',
        'description': 'Built-in starter.',
        'mode': 'bundled',
        'schemaVersion': '1.0.0',
        'author': 'OpenRPG',
        'version': '2024.1',
        'license': 'CC-BY-4.0',
        'entityCount': 1,
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
        'filePath': 'assets/rulesets/starter_2024_srd.ruleset.json',
        'collectionStats': [
          {
            'entityType': 'spell',
            'collectionKey': 'spellList',
            'label': 'Spells',
            'entityCount': 1,
          },
        ],
        'shards': [
          {
            'entityType': 'spell',
            'collectionKey': 'spellList',
            'assetPath': 'assets/rulesets/browse/starter_spell.json',
            'entityCount': 1,
            'linkCount': 0,
          },
        ],
      },
    ],
  });
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

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration step = const Duration(milliseconds: 50),
  int maxPumps = 40,
}) async {
  for (var index = 0; index < maxPumps; index++) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }

  fail('Did not find ${finder.description} after pumping.');
}
