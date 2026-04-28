import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_editor.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_detail_screen.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';
import 'package:openrpg/screens/rulesets/ruleset_object_editor_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CompendiumDatabase database;
  late CompendiumBrowseRepository browseRepository;
  late CompendiumRepository repository;
  late String rulesetId;

  setUp(() async {
    database = CompendiumDatabase(executor: NativeDatabase.memory());
    browseRepository = CompendiumBrowseRepository(database: database);
    repository = CompendiumRepository(
      database: database,
      assetLoader: (_) async => '{}',
    );

    final ruleset = await repository.createRuleset(
      name: 'Test Ruleset',
      description: 'Structured UI test data',
    );
    rulesetId = ruleset.id;

    await repository.saveEntity(
      rulesetId: rulesetId,
      entity: parseEntityJson('spell', {
        'id': 'spell:srd:fire_bolt',
        'name': 'Fire Bolt',
        'source': 'SRD',
        'sourceFile': 'starter/spell.json',
        'edition': '2024',
        'data': {
          'name': 'Fire Bolt',
          'source': 'SRD',
          'edition': '2024',
          'entries': [
            'Practice with {@spell Magic Missile|SRD} for the follow-up.',
          ],
          'level': 0,
          'mysteryNote': 'Internal GM note',
        },
      })!,
    );

    await repository.saveEntity(
      rulesetId: rulesetId,
      entity: parseEntityJson('spell', {
        'id': 'spell:srd:magic_missile',
        'name': 'Magic Missile',
        'source': 'SRD',
        'sourceFile': 'starter/spell.json',
        'edition': '2024',
        'data': {
          'name': 'Magic Missile',
          'source': 'SRD',
          'edition': '2024',
          'entries': ['Automatically hits.'],
          'level': 1,
        },
      })!,
    );

    await repository.saveEntity(
      rulesetId: rulesetId,
      entity: parseEntityJson('spell', {
        'id': 'spell:srd:shield_ward',
        'name': 'Shield Ward',
        'source': 'SRD',
        'sourceFile': 'starter/spell.json',
        'edition': '2024',
        'data': {
          'name': 'Shield Ward',
          'source': 'SRD',
          'edition': '2024',
          'level': 1,
          'components': ['V', 'S'],
        },
      })!,
    );
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('entity detail renders attributes and groups additional data', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(420, 900));

    await tester.pumpWidget(
      MaterialApp(
        home: CompendiumEntityDetailScreen(
          rulesetId: rulesetId,
          entityType: 'spell',
          entityId: 'spell:srd:fire_bolt',
          browseRepository: browseRepository,
          repository: repository,
        ),
      ),
    );

    await _pumpUntilFound(tester, find.text('Attributes'));

    expect(find.text('Structured Fields'), findsNothing);
    expect(find.text('Level'), findsOneWidget);
    expect(find.text('Additional Data'), findsOneWidget);

    await tester.tap(find.text('Additional Data'));
    await tester.pumpAndSettle();

    expect(find.text('Mystery Note'), findsOneWidget);
  });

  testWidgets('detail inline references open the shared preview surface', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(390, 844));

    await tester.pumpWidget(
      MaterialApp(
        home: CompendiumEntityDetailScreen(
          rulesetId: rulesetId,
          entityType: 'spell',
          entityId: 'spell:srd:fire_bolt',
          browseRepository: browseRepository,
          repository: repository,
        ),
      ),
    );

    await _pumpUntilFound(tester, find.text('Magic Missile'));
    await tester.tap(find.text('Magic Missile').first);
    await tester.pump();
    await _pumpUntilFound(
      tester,
      find.byKey(const Key('compendium-preview-sheet')),
    );

    expect(find.byType(CompendiumEntityPreviewPanel), findsOneWidget);
  });

  testWidgets('preview references open nested previews', (tester) async {
    _setSurfaceSize(tester, const Size(390, 844));

    await tester.pumpWidget(
      _PreviewHost(
        onOpen: (context) => showCompendiumEntityPreviewSurface(
          context,
          rulesetId: rulesetId,
          entityType: 'spell',
          entityId: 'spell:srd:fire_bolt',
          browseRepository: browseRepository,
        ),
      ),
    );

    await tester.tap(find.text('Open Preview'));
    await tester.pump();
    await _pumpUntilCount(
      tester,
      find.byType(CompendiumEntityPreviewPanel),
      expectedCount: 1,
    );

    await tester.tap(find.text('Magic Missile').last);
    await tester.pump();
    await _pumpUntilCount(
      tester,
      find.byType(CompendiumEntityPreviewPanel),
      expectedCount: 2,
    );
  });

  testWidgets(
    'preview surface uses sheet on compact layouts and dialog on wide layouts',
    (tester) async {
      _setSurfaceSize(tester, const Size(390, 844));

      await tester.pumpWidget(
        _PreviewHost(
          onOpen: (context) => showCompendiumEntityPreviewSurface(
            context,
            rulesetId: rulesetId,
            entityType: 'spell',
            entityId: 'spell:srd:fire_bolt',
            browseRepository: browseRepository,
          ),
        ),
      );

      await tester.tap(find.text('Open Preview'));
      await tester.pump();
      await _pumpUntilFound(
        tester,
        find.byKey(const Key('compendium-preview-sheet')),
      );
      expect(find.byKey(const Key('compendium-preview-dialog')), findsNothing);

      await tester.pageBack();
      await tester.pumpAndSettle();

      _setSurfaceSize(tester, const Size(1280, 900));
      await tester.pumpWidget(
        _PreviewHost(
          onOpen: (context) => showCompendiumEntityPreviewSurface(
            context,
            rulesetId: rulesetId,
            entityType: 'spell',
            entityId: 'spell:srd:fire_bolt',
            browseRepository: browseRepository,
          ),
        ),
      );

      await tester.tap(find.text('Open Preview'));
      await tester.pump();
      await _pumpUntilFound(
        tester,
        find.byKey(const Key('compendium-preview-dialog')),
      );
      expect(find.byKey(const Key('compendium-preview-sheet')), findsNothing);
    },
  );

  testWidgets(
    'preview falls back to structured attributes when narrative is absent',
    (tester) async {
      _setSurfaceSize(tester, const Size(1280, 900));

      await tester.pumpWidget(
        _PreviewHost(
          onOpen: (context) => showCompendiumEntityPreviewSurface(
            context,
            rulesetId: rulesetId,
            entityType: 'spell',
            entityId: 'spell:srd:shield_ward',
            browseRepository: browseRepository,
          ),
        ),
      );

      await tester.tap(find.text('Open Preview'));
      await tester.pump();
      await _pumpUntilFound(
        tester,
        find.byKey(const Key('compendium-preview-dialog')),
      );

      expect(
        find.text(
          'Narrative text is unavailable for this entry. Showing structured attributes instead.',
        ),
        findsOneWidget,
      );
      expect(find.text('Level'), findsOneWidget);
      expect(find.text('No narrative preview is available.'), findsNothing);
    },
  );

  testWidgets(
    'editor renders structured controls for nested fields and choices',
    (tester) async {
      final descriptor = CompendiumEditorDescriptor(
        entityType: 'spell',
        collectionKey: 'spellList',
        label: 'Spells',
        fields: const [
          CompendiumFieldDescriptor(
            key: 'metadata',
            label: 'Metadata',
            kind: CompendiumFieldKind.object,
            fields: [
              CompendiumFieldDescriptor(
                key: 'title',
                label: 'Title',
                kind: CompendiumFieldKind.string,
              ),
            ],
          ),
          CompendiumFieldDescriptor(
            key: 'tags',
            label: 'Tags',
            kind: CompendiumFieldKind.list,
            isArray: true,
            itemDescriptor: CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
            ),
          ),
          CompendiumFieldDescriptor(
            key: 'rarity',
            label: 'Rarity',
            kind: CompendiumFieldKind.string,
            choices: ['Common', 'Rare', 'Legendary'],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RulesetObjectEditorScreen(
            entityType: 'spell',
            descriptorOverride: descriptor,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Metadata'), findsOneWidget);
      expect(find.text('Tags'), findsOneWidget);
      await tester.tap(find.text('Metadata'));
      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);

      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (widget) => widget is DropdownButtonFormField<String>,
        ),
        findsOneWidget,
      );
      expect(find.text('Edit JSON'), findsNothing);
    },
  );

  testWidgets(
    'editor validates unresolved references and previews resolved ones',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RulesetObjectEditorScreen(
            entityType: 'spell',
            rulesetId: rulesetId,
            browseRepository: browseRepository,
            initialEntity: parseEntityJson('spell', {
              'id': 'spell:test:broken_links',
              'name': 'Broken Links',
              'data': {
                'name': 'Broken Links',
                'entries': [
                  'Preview {@spell Magic Missile|SRD}.',
                  'Missing {@spell Missing Spell|SRD}.',
                  'Broken token {@spell Bad Link',
                ],
              },
            })!,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView).first, const Offset(0, -1400));
      await tester.pumpAndSettle();
      await _pumpUntilFound(tester, find.text('Relationship Validation'));

      expect(find.text('Reference Preview'), findsOneWidget);
      expect(find.textContaining('Missing Spell'), findsOneWidget);
      expect(
        find.textContaining('Malformed inline reference tokens'),
        findsOneWidget,
      );
    },
  );

  testWidgets('editor rebuilds draft data when switching to another entity', (
    tester,
  ) async {
    final descriptor = CompendiumEditorDescriptor(
      entityType: 'spell',
      collectionKey: 'spellList',
      label: 'Spells',
      fields: const [
        CompendiumFieldDescriptor(
          key: 'title',
          label: 'Title',
          kind: CompendiumFieldKind.string,
        ),
      ],
    );
    final currentEntity = ValueNotifier<CompendiumEntity>(
      parseEntityJson('spell', {
        'id': 'spell:test:first',
        'name': 'First Entry',
        'data': {'name': 'First Entry', 'title': 'First draft'},
      })!,
    );
    addTearDown(currentEntity.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder<CompendiumEntity>(
          valueListenable: currentEntity,
          builder: (context, entity, _) {
            return RulesetObjectEditorScreen(
              entityType: 'spell',
              rulesetId: rulesetId,
              browseRepository: browseRepository,
              initialEntity: entity,
              descriptorOverride: descriptor,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('First draft'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Edited first');
    await tester.pumpAndSettle();
    expect(find.text('Edited first'), findsOneWidget);

    currentEntity.value = parseEntityJson('spell', {
      'id': 'spell:test:second',
      'name': 'Second Entry',
      'data': {'name': 'Second Entry', 'title': 'Second draft'},
    })!;
    await tester.pumpAndSettle();

    expect(find.text('Second draft'), findsOneWidget);
    expect(find.text('Edited first'), findsNothing);
  });

  testWidgets('unsupported entity types are shown as read-only', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RulesetObjectEditorScreen(entityType: 'unknownEntityType'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Read-only unknownEntityType'), findsOneWidget);
    expect(find.byIcon(Icons.save_outlined), findsNothing);
    expect(find.textContaining('currently read-only'), findsOneWidget);
  });

  testWidgets('detail screen follows linked references with breadcrumb trail', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(1280, 900));

    await tester.pumpWidget(
      MaterialApp(
        home: CompendiumEntityDetailScreen(
          rulesetId: rulesetId,
          entityType: 'spell',
          entityId: 'spell:srd:fire_bolt',
          browseRepository: browseRepository,
          repository: repository,
        ),
      ),
    );

    await _pumpUntilFound(tester, find.text('Linked References'));
    await tester.tap(find.byTooltip('Open in this detail page').first);
    await tester.pump();
    await _pumpUntilFound(tester, find.text('Automatically hits.'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Back in reference trail'), findsOneWidget);
    expect(find.text('Fire Bolt'), findsAtLeastNWidgets(1));
  });
}

class _PreviewHost extends StatelessWidget {
  final Future<void> Function(BuildContext context) onOpen;

  const _PreviewHost({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: FilledButton(
                onPressed: () => onOpen(context),
                child: const Text('Open Preview'),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _setSurfaceSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration step = const Duration(milliseconds: 50),
  int maxPumps = 50,
}) async {
  for (var index = 0; index < maxPumps; index++) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }

  fail('Did not find $finder after pumping.');
}

Future<void> _pumpUntilCount(
  WidgetTester tester,
  Finder finder, {
  required int expectedCount,
  Duration step = const Duration(milliseconds: 50),
  int maxPumps = 60,
}) async {
  for (var index = 0; index < maxPumps; index++) {
    await tester.pump(step);
    if (finder.evaluate().length == expectedCount) {
      return;
    }
  }

  fail('Did not reach $expectedCount widgets for $finder after pumping.');
}
