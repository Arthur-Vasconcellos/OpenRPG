import 'dart:convert';
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
      _setSurfaceSize(tester, const Size(420, 900));
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
        find.widgetWithText(FilledButton, 'Retry'),
      );

      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
      expect(find.text('No rulesets installed yet.'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets('retry reruns initialization after a startup failure', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(420, 900));
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
      await _pumpUntilFound(tester, find.widgetWithText(FilledButton, 'Retry'));

      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);

      shouldFail = false;
    final retryButton = find.widgetWithText(FilledButton, 'Retry');
    await tester.ensureVisible(retryButton);
    await tester.tap(retryButton);
    await tester.pump();
    await _pumpUntil(
      tester,
      () async => find.widgetWithText(FilledButton, 'Retry').evaluate().isEmpty,
    );

    expect(find.widgetWithText(FilledButton, 'Retry'), findsNothing);
    expect(
      find.text(
        'Built-in 2024 SRD starter ruleset, editable homebrew, portable JSON.',
      ),
      findsNothing,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
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
        'name': '2024 SRD Starter',
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
        'source': 'Starter',
        'sourceFile': 'starter/spell.json',
        'edition': '2024',
        'sortName': 'fire bolt',
        'searchText': 'fire bolt starter',
        'payloadJson': jsonEncode({
          'id': 'spell:starter:fire_bolt',
          'name': 'Fire Bolt',
          'source': 'Starter',
          'sourceFile': 'starter/spell.json',
          'edition': '2024',
          'data': {
            'name': 'Fire Bolt',
            'source': 'Starter',
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

void _setSurfaceSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration step = const Duration(milliseconds: 50),
  int maxPumps = 120,
}) async {
  for (var index = 0; index < maxPumps; index++) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Did not find the expected widget after pumping.');
}

Future<void> _pumpUntil(
  WidgetTester tester,
  Future<bool> Function() predicate, {
  Duration step = const Duration(milliseconds: 50),
  int maxPumps = 120,
}) async {
  for (var index = 0; index < maxPumps; index++) {
    await tester.pump(step);
    if (await predicate()) {
      return;
    }
  }

  fail('Predicate did not become true after pumping.');
}
