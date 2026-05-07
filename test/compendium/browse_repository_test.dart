import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';

void main() {
  late CompendiumDatabase database;
  late CompendiumBrowseRepository repository;

  setUp(() async {
    database = CompendiumDatabase(executor: NativeDatabase.memory());
    repository = CompendiumBrowseRepository(database: database);

    await database
        .into(database.rulesetRecords)
        .insert(
          RulesetRecordsCompanion.insert(
            rulesetId: 'multi_collection_ruleset',
            name: 'Multi-Collection Ruleset',
            mode: 'editable',
            schemaVersion: '1.0.0',
            filePath: 'multi_collection.ruleset.json',
          ),
        );

    await database
        .into(database.rulesetCollectionStats)
        .insert(
          RulesetCollectionStatsCompanion.insert(
            rulesetId: 'multi_collection_ruleset',
            entityType: 'spell',
            collectionKey: 'spellList',
            label: 'Spells',
          ),
        );
    await database
        .into(database.rulesetCollectionStats)
        .insert(
          RulesetCollectionStatsCompanion.insert(
            rulesetId: 'multi_collection_ruleset',
            entityType: 'spell',
            collectionKey: 'ritualList',
            label: 'Rituals',
          ),
        );

    Future<void> insertSpell({
      required String entityId,
      required String collectionKey,
      required String name,
    }) {
      return database
          .into(database.entityRecords)
          .insert(
            EntityRecordsCompanion.insert(
              rulesetId: 'multi_collection_ruleset',
              entityType: 'spell',
              entityId: entityId,
              collectionKey: collectionKey,
              name: name,
              payloadJson:
                  '{"id":"$entityId","name":"$name","data":{"name":"$name"}}',
            ),
          );
    }

    await insertSpell(
      entityId: 'spell:arcane_missile',
      collectionKey: 'spellList',
      name: 'Arcane Missile',
    );
    await insertSpell(
      entityId: 'spell:ember_bolt',
      collectionKey: 'spellList',
      name: 'Ember Bolt',
    );
    await insertSpell(
      entityId: 'spell:moon_chant',
      collectionKey: 'ritualList',
      name: 'Moon Chant',
    );
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'collection summaries group counts and previews by collection key',
    () async {
      final summaries = await repository.loadCollectionSummaries(
        'multi_collection_ruleset',
      );

      final spellSummary = summaries.firstWhere(
        (summary) => summary.collectionKey == 'spellList',
      );
      final ritualSummary = summaries.firstWhere(
        (summary) => summary.collectionKey == 'ritualList',
      );

      expect(spellSummary.entityCount, 2);
      expect(
        spellSummary.representativeEntries.map((entry) => entry.displayName),
        containsAll(<String>['Arcane Missile', 'Ember Bolt']),
      );

      expect(ritualSummary.entityCount, 1);
      expect(
        ritualSummary.representativeEntries.single.displayName,
        'Moon Chant',
      );
    },
  );

  test(
    'semantic link resolution only accepts the current feature reference layouts',
    () async {
      Future<void> insertEntity({
        required String entityType,
        required String entityId,
        required String collectionKey,
        required String name,
        required Map<String, dynamic> data,
      }) {
        return database
            .into(database.entityRecords)
            .insert(
              EntityRecordsCompanion.insert(
                rulesetId: 'multi_collection_ruleset',
                entityType: entityType,
                entityId: entityId,
                collectionKey: collectionKey,
                name: name,
                payloadJson: jsonEncode({
                  'id': entityId,
                  'name': name,
                  'data': data,
                }),
              ),
            );
      }

      await insertEntity(
        entityType: 'classFeature',
        entityId: 'classFeature:arcane_recovery:wizard:1',
        collectionKey: 'classFeatureList',
        name: 'Arcane Recovery',
        data: const {
          'name': 'Arcane Recovery',
          'className': 'Wizard',
          'level': 1,
        },
      );
      await insertEntity(
        entityType: 'subclassFeature',
        entityId: 'subclassFeature:sculpt_spells:wizard:evocation:2',
        collectionKey: 'subclassFeatureList',
        name: 'Sculpt Spells',
        data: const {
          'name': 'Sculpt Spells',
          'className': 'Wizard',
          'subclassShortName': 'Evocation',
          'level': 2,
        },
      );

      final currentClassFeature = CompendiumLinkParser.tryParsePlainReference(
        'Arcane Recovery|Wizard|1|Arcane Recovery',
        hintedFieldKey: 'classFeatures',
      )!;
      final removedClassFeature = CompendiumLinkParser.tryParsePlainReference(
        'Arcane Recovery|Wizard|PHB|1|Arcane Recovery',
        hintedFieldKey: 'classFeatures',
      )!;
      final currentSubclassFeature =
          CompendiumLinkParser.tryParsePlainReference(
            'Sculpt Spells|Wizard|Evocation|2|Sculpt Spells',
            hintedFieldKey: 'subclassFeatures',
          )!;
      final removedSubclassFeature =
          CompendiumLinkParser.tryParsePlainReference(
            'Sculpt Spells|Wizard|PHB|Evocation|PHB|2|Sculpt Spells',
            hintedFieldKey: 'subclassFeatures',
          )!;

      expect(
        await repository.resolveLink(
          currentClassFeature,
          preferredRulesetId: 'multi_collection_ruleset',
        ),
        isNotNull,
      );
      expect(
        await repository.resolveLink(
          removedClassFeature,
          preferredRulesetId: 'multi_collection_ruleset',
        ),
        isNull,
      );
      expect(
        await repository.resolveLink(
          currentSubclassFeature,
          preferredRulesetId: 'multi_collection_ruleset',
        ),
        isNotNull,
      );
      expect(
        await repository.resolveLink(
          removedSubclassFeature,
          preferredRulesetId: 'multi_collection_ruleset',
        ),
        isNull,
      );
    },
  );
}
