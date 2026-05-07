import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_editor.dart';

void main() {
  test('generated descriptors keep only the whitelisted entity types', () {
    const expectedEntityTypes = <String>{
      'action',
      'background',
      'class',
      'classFeature',
      'condition',
      'deity',
      'disease',
      'feat',
      'hazard',
      'item',
      'itemGroup',
      'itemMastery',
      'itemProperty',
      'itemType',
      'language',
      'magicvariant',
      'monster',
      'monsterfeatures',
      'object',
      'race',
      'reward',
      'sense',
      'skill',
      'spell',
      'status',
      'subclass',
      'subclassFeature',
      'subrace',
      'trap',
      'variantrule',
      'vehicle',
    };

    expect(
      compendiumEntityDescriptors
          .map((descriptor) => descriptor.collection.entityType)
          .toSet(),
      expectedEntityTypes,
    );
  });

  test('generated editor descriptors hide srd metadata fields', () {
    for (final descriptor in compendiumEditorDescriptors.values) {
      expect(
        _containsFieldKey(descriptor.fields, 'srd'),
        isFalse,
        reason: 'Unexpected srd field in ${descriptor.entityType}',
      );
      expect(
        _containsFieldKey(descriptor.fields, 'srd52'),
        isFalse,
        reason: 'Unexpected srd52 field in ${descriptor.entityType}',
      );
    }
  });

  test('starter browse manifest only references whitelisted collections', () {
    final manifest =
        jsonDecode(
              File('assets/rulesets/browse_manifest.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    final ruleset = (manifest['rulesets'] as List<dynamic>).single as Map;

    const allowedCollectionKeys = <String>{
      'actionList',
      'backgroundList',
      'classList',
      'classFeatureList',
      'conditionList',
      'deityList',
      'diseaseList',
      'featList',
      'hazardList',
      'itemList',
      'itemGroupList',
      'itemMasteryList',
      'itemPropertyList',
      'itemTypeList',
      'languageList',
      'magicvariantList',
      'monsterList',
      'monsterfeaturesList',
      'objectList',
      'raceList',
      'rewardList',
      'senseList',
      'skillList',
      'spellList',
      'statusList',
      'subclassList',
      'subclassFeatureList',
      'subraceList',
      'trapList',
      'variantruleList',
      'vehicleList',
    };

    final statKeys = (ruleset['collectionStats'] as List<dynamic>)
        .map((entry) => (entry as Map)['collectionKey'])
        .toSet();
    final shardKeys = (ruleset['shards'] as List<dynamic>)
        .map((entry) => (entry as Map)['collectionKey'])
        .toSet();

    expect(statKeys.difference(allowedCollectionKeys), isEmpty);
    expect(shardKeys.difference(allowedCollectionKeys), isEmpty);
  });

  test(
    'starter bundle rewrites visible srd metadata outside the ruleset name',
    () {
      final starterRuleset =
          jsonDecode(
                File(
                  'assets/rulesets/starter_2024_srd.ruleset.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      expect(starterRuleset['name'], contains('SRD'));
      expect(
        starterRuleset['description'].toString().toLowerCase(),
        isNot(contains('srd')),
      );

      final manifest =
          jsonDecode(
                File('assets/rulesets/browse_manifest.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final ruleset = (manifest['rulesets'] as List<dynamic>).single as Map;
      expect(
        ruleset['description'].toString().toLowerCase(),
        isNot(contains('srd')),
      );

      for (final shard in ruleset['shards'] as List<dynamic>) {
        final assetPath = (shard as Map)['assetPath'].toString();
        final shardJson = jsonDecode(File(assetPath).readAsStringSync()) as Map;
        for (final row in shardJson['entityRows'] as List<dynamic>) {
          final entityRow = row as Map;
          expect(
            entityRow['source'].toString().toLowerCase(),
            isNot(contains('srd')),
          );
          expect(
            entityRow['searchText'].toString().toLowerCase(),
            isNot(contains('srd')),
          );
          expect(
            entityRow['entityId'].toString().toLowerCase(),
            isNot(contains(':srd:')),
          );
        }
      }
    },
  );
}

bool _containsFieldKey(
  List<CompendiumFieldDescriptor> fields,
  String targetKey,
) {
  for (final field in fields) {
    if (field.key == targetKey) {
      return true;
    }
    if (_containsFieldKey(field.fields, targetKey)) {
      return true;
    }
    final itemDescriptor = field.itemDescriptor;
    if (itemDescriptor != null &&
        _containsFieldKey(<CompendiumFieldDescriptor>[
          itemDescriptor,
        ], targetKey)) {
      return true;
    }
  }
  return false;
}
