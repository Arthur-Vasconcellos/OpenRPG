import 'package:openrpg/compendium/models/compendium_editor.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';

Map<String, dynamic> _generatedEntityExtra(Map<String, dynamic> json) {
  const knownKeys = <String>{'id', 'name', 'data'};
  final extra = <String, dynamic>{};
  for (final entry in json.entries) {
    if (knownKeys.contains(entry.key)) {
      continue;
    }
    extra[entry.key] = CompendiumJsonUtils.deepCopy(entry.value);
  }
  return extra;
}

class ActionEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'action';
  static const String collectionKeyValue = 'actionList';

  const ActionEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ActionEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ActionEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class BackgroundEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'background';
  static const String collectionKeyValue = 'backgroundList';

  const BackgroundEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory BackgroundEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return BackgroundEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class ClassEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'class';
  static const String collectionKeyValue = 'classList';

  const ClassEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ClassEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ClassEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class ClassFeatureEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'classFeature';
  static const String collectionKeyValue = 'classFeatureList';

  const ClassFeatureEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ClassFeatureEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ClassFeatureEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class ConditionEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'condition';
  static const String collectionKeyValue = 'conditionList';

  const ConditionEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ConditionEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ConditionEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class DeityEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'deity';
  static const String collectionKeyValue = 'deityList';

  const DeityEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory DeityEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return DeityEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class DiseaseEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'disease';
  static const String collectionKeyValue = 'diseaseList';

  const DiseaseEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory DiseaseEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return DiseaseEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class FeatEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'feat';
  static const String collectionKeyValue = 'featList';

  const FeatEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory FeatEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return FeatEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class HazardEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'hazard';
  static const String collectionKeyValue = 'hazardList';

  const HazardEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory HazardEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return HazardEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class ItemEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'item';
  static const String collectionKeyValue = 'itemList';

  const ItemEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ItemEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ItemEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class ItemGroupEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'itemGroup';
  static const String collectionKeyValue = 'itemGroupList';

  const ItemGroupEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ItemGroupEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ItemGroupEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class ItemMasteryEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'itemMastery';
  static const String collectionKeyValue = 'itemMasteryList';

  const ItemMasteryEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ItemMasteryEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ItemMasteryEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class ItemPropertyEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'itemProperty';
  static const String collectionKeyValue = 'itemPropertyList';

  const ItemPropertyEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ItemPropertyEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ItemPropertyEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class ItemTypeEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'itemType';
  static const String collectionKeyValue = 'itemTypeList';

  const ItemTypeEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ItemTypeEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ItemTypeEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class LanguageEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'language';
  static const String collectionKeyValue = 'languageList';

  const LanguageEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory LanguageEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return LanguageEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class MagicvariantEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'magicvariant';
  static const String collectionKeyValue = 'magicvariantList';

  const MagicvariantEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory MagicvariantEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return MagicvariantEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class MonsterEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'monster';
  static const String collectionKeyValue = 'monsterList';

  const MonsterEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory MonsterEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return MonsterEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class MonsterfeaturesEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'monsterfeatures';
  static const String collectionKeyValue = 'monsterfeaturesList';

  const MonsterfeaturesEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory MonsterfeaturesEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return MonsterfeaturesEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class ObjectEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'object';
  static const String collectionKeyValue = 'objectList';

  const ObjectEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory ObjectEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return ObjectEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class RaceEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'race';
  static const String collectionKeyValue = 'raceList';

  const RaceEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory RaceEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return RaceEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class RewardEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'reward';
  static const String collectionKeyValue = 'rewardList';

  const RewardEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory RewardEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return RewardEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class SenseEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'sense';
  static const String collectionKeyValue = 'senseList';

  const SenseEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory SenseEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return SenseEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class SkillEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'skill';
  static const String collectionKeyValue = 'skillList';

  const SkillEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory SkillEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return SkillEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class SpellEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'spell';
  static const String collectionKeyValue = 'spellList';

  const SpellEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory SpellEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return SpellEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class StatusEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'status';
  static const String collectionKeyValue = 'statusList';

  const StatusEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory StatusEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return StatusEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class SubclassEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'subclass';
  static const String collectionKeyValue = 'subclassList';

  const SubclassEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory SubclassEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return SubclassEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class SubclassFeatureEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'subclassFeature';
  static const String collectionKeyValue = 'subclassFeatureList';

  const SubclassFeatureEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory SubclassFeatureEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return SubclassFeatureEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class SubraceEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'subrace';
  static const String collectionKeyValue = 'subraceList';

  const SubraceEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory SubraceEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return SubraceEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class TrapEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'trap';
  static const String collectionKeyValue = 'trapList';

  const TrapEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory TrapEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return TrapEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class VariantruleEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'variantrule';
  static const String collectionKeyValue = 'variantruleList';

  const VariantruleEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory VariantruleEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return VariantruleEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

class VehicleEntity extends GeneratedCompendiumEntityBase {
  static const String entityTypeValue = 'vehicle';
  static const String collectionKeyValue = 'vehicleList';

  const VehicleEntity({
    required super.id,
    required super.name,
    required super.data,
    super.extra,
  });

  factory VehicleEntity.fromJson(Map<String, dynamic> json) {
    final sanitized = CompendiumJsonUtils.sanitizeEntityJson(json);
    final data = CompendiumJsonUtils.jsonMap(sanitized['data']);
    final payload = <String, dynamic>{
      'id': sanitized['id'],
      'name': sanitized['name'],
      'data': data,
    };
    final name = (sanitized['name']?.toString() ?? CompendiumJsonUtils.extractName(payload)).trim();
    return VehicleEntity(
      id: sanitized['id']?.toString() ??
          CompendiumJsonUtils.stableEntityId(
            entityType: entityTypeValue,
            payload: payload,
          ),
      name: name.isEmpty ? sanitized['id']?.toString() ?? 'untitled' : name,
      data: data,
      extra: _generatedEntityExtra(sanitized),
    );
  }

  @override
  String get entityType => entityTypeValue;

  @override
  String get collectionKey => collectionKeyValue;
}

final List<CompendiumEntityDescriptor<CompendiumEntity>> compendiumEntityDescriptors = [
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'action',
      collectionKey: 'actionList',
      label: 'Actions',
    ),
    fromJson: ActionEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'background',
      collectionKey: 'backgroundList',
      label: 'Backgrounds',
    ),
    fromJson: BackgroundEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'class',
      collectionKey: 'classList',
      label: 'Classes',
    ),
    fromJson: ClassEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'classFeature',
      collectionKey: 'classFeatureList',
      label: 'Class Features',
    ),
    fromJson: ClassFeatureEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'condition',
      collectionKey: 'conditionList',
      label: 'Conditions',
    ),
    fromJson: ConditionEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'deity',
      collectionKey: 'deityList',
      label: 'Deities',
    ),
    fromJson: DeityEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'disease',
      collectionKey: 'diseaseList',
      label: 'Diseases',
    ),
    fromJson: DiseaseEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'feat',
      collectionKey: 'featList',
      label: 'Feats',
    ),
    fromJson: FeatEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'hazard',
      collectionKey: 'hazardList',
      label: 'Hazards',
    ),
    fromJson: HazardEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'item',
      collectionKey: 'itemList',
      label: 'Items',
    ),
    fromJson: ItemEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'itemGroup',
      collectionKey: 'itemGroupList',
      label: 'Item Groups',
    ),
    fromJson: ItemGroupEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'itemMastery',
      collectionKey: 'itemMasteryList',
      label: 'Item Masteries',
    ),
    fromJson: ItemMasteryEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'itemProperty',
      collectionKey: 'itemPropertyList',
      label: 'Item Properties',
    ),
    fromJson: ItemPropertyEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'itemType',
      collectionKey: 'itemTypeList',
      label: 'Item Types',
    ),
    fromJson: ItemTypeEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'language',
      collectionKey: 'languageList',
      label: 'Languages',
    ),
    fromJson: LanguageEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'magicvariant',
      collectionKey: 'magicvariantList',
      label: 'Magic Variants',
    ),
    fromJson: MagicvariantEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'monster',
      collectionKey: 'monsterList',
      label: 'Monsters',
    ),
    fromJson: MonsterEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'monsterfeatures',
      collectionKey: 'monsterfeaturesList',
      label: 'Monster Features',
    ),
    fromJson: MonsterfeaturesEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'object',
      collectionKey: 'objectList',
      label: 'Objects',
    ),
    fromJson: ObjectEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'race',
      collectionKey: 'raceList',
      label: 'Races',
    ),
    fromJson: RaceEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'reward',
      collectionKey: 'rewardList',
      label: 'Rewards',
    ),
    fromJson: RewardEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'sense',
      collectionKey: 'senseList',
      label: 'Senses',
    ),
    fromJson: SenseEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'skill',
      collectionKey: 'skillList',
      label: 'Skills',
    ),
    fromJson: SkillEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'spell',
      collectionKey: 'spellList',
      label: 'Spells',
    ),
    fromJson: SpellEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'status',
      collectionKey: 'statusList',
      label: 'Statuses',
    ),
    fromJson: StatusEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'subclass',
      collectionKey: 'subclassList',
      label: 'Subclasses',
    ),
    fromJson: SubclassEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'subclassFeature',
      collectionKey: 'subclassFeatureList',
      label: 'Subclass Features',
    ),
    fromJson: SubclassFeatureEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'subrace',
      collectionKey: 'subraceList',
      label: 'Subraces',
    ),
    fromJson: SubraceEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'trap',
      collectionKey: 'trapList',
      label: 'Traps',
    ),
    fromJson: TrapEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'variantrule',
      collectionKey: 'variantruleList',
      label: 'Variant Rules',
    ),
    fromJson: VariantruleEntity.fromJson,
  ),
  CompendiumEntityDescriptor(
    collection: CompendiumCollectionDefinition(
      entityType: 'vehicle',
      collectionKey: 'vehicleList',
      label: 'Vehicles',
    ),
    fromJson: VehicleEntity.fromJson,
  ),
];

CompendiumEntityDescriptor<CompendiumEntity>? descriptorForType(String entityType) {
  for (final descriptor in compendiumEntityDescriptors) {
    if (descriptor.collection.entityType == entityType) {
      return descriptor;
    }
  }
  return null;
}

CompendiumEntity? parseEntityJson(String entityType, Map<String, dynamic> json) {
  switch (entityType) {
    case 'action': return ActionEntity.fromJson(json);
    case 'background': return BackgroundEntity.fromJson(json);
    case 'class': return ClassEntity.fromJson(json);
    case 'classFeature': return ClassFeatureEntity.fromJson(json);
    case 'condition': return ConditionEntity.fromJson(json);
    case 'deity': return DeityEntity.fromJson(json);
    case 'disease': return DiseaseEntity.fromJson(json);
    case 'feat': return FeatEntity.fromJson(json);
    case 'hazard': return HazardEntity.fromJson(json);
    case 'item': return ItemEntity.fromJson(json);
    case 'itemGroup': return ItemGroupEntity.fromJson(json);
    case 'itemMastery': return ItemMasteryEntity.fromJson(json);
    case 'itemProperty': return ItemPropertyEntity.fromJson(json);
    case 'itemType': return ItemTypeEntity.fromJson(json);
    case 'language': return LanguageEntity.fromJson(json);
    case 'magicvariant': return MagicvariantEntity.fromJson(json);
    case 'monster': return MonsterEntity.fromJson(json);
    case 'monsterfeatures': return MonsterfeaturesEntity.fromJson(json);
    case 'object': return ObjectEntity.fromJson(json);
    case 'race': return RaceEntity.fromJson(json);
    case 'reward': return RewardEntity.fromJson(json);
    case 'sense': return SenseEntity.fromJson(json);
    case 'skill': return SkillEntity.fromJson(json);
    case 'spell': return SpellEntity.fromJson(json);
    case 'status': return StatusEntity.fromJson(json);
    case 'subclass': return SubclassEntity.fromJson(json);
    case 'subclassFeature': return SubclassFeatureEntity.fromJson(json);
    case 'subrace': return SubraceEntity.fromJson(json);
    case 'trap': return TrapEntity.fromJson(json);
    case 'variantrule': return VariantruleEntity.fromJson(json);
    case 'vehicle': return VehicleEntity.fromJson(json);
    default:
      return null;
  }
}

final Map<String, CompendiumEditorDescriptor> compendiumEditorDescriptors = {
  'action': CompendiumEditorDescriptor(
    entityType: 'action',
    collectionKey: 'actionList',
    label: 'Actions',
    fields: [
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'caption',
                    label: 'Caption',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colLabels',
                    label: 'Col Labels',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colStyles',
                    label: 'Col Styles',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 7,
                    ),
                    sampleCount: 7,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'rows',
                    label: 'Rows',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.dynamic,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 10,
                      ),
                      sampleCount: 5,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 8,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 15,
              ),
              sampleCount: 8,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 8,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 62,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'fromVariant',
        label: 'From Variant',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'tag',
              label: 'Tag',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'uid',
              label: 'Uid',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 13,
        ),
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'seeAlsoAction',
        label: 'See Also Action',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 11,
        ),
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'time',
        label: 'Time',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'number',
              label: 'Number',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 27,
            ),
            CompendiumFieldDescriptor(
              key: 'unit',
              label: 'Unit',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 27,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 32,
        ),
        sampleCount: 31,
      ),
    ],
  ),
  'background': CompendiumEditorDescriptor(
    entityType: 'background',
    collectionKey: 'backgroundList',
    label: 'Backgrounds',
    fields: [
      CompendiumFieldDescriptor(
        key: '_copy',
        label: 'Copy',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: '_mod',
            label: 'Mod',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: 'entries',
                label: 'Entries',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'index',
                    label: 'Index',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 12,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'items',
                    label: 'Items',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'data',
                        label: 'Data',
                        kind: CompendiumFieldKind.object,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                          CompendiumFieldDescriptor(
                            key: 'isFeature',
                            label: 'Is Feature',
                            kind: CompendiumFieldKind.boolean,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 8,
                          ),
                        ],
                        itemDescriptor: null,
                        sampleCount: 8,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'entries',
                        label: 'Entries',
                        kind: CompendiumFieldKind.list,
                        required: false,
                        nullable: true,
                        isArray: true,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor:                         CompendiumFieldDescriptor(
                          key: 'item',
                          label: 'Item',
                          kind: CompendiumFieldKind.string,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 17,
                        ),
                        sampleCount: 8,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'name',
                        label: 'Name',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 8,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'type',
                        label: 'Type',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 8,
                      ),
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'data',
                          label: 'Data',
                          kind: CompendiumFieldKind.object,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                            CompendiumFieldDescriptor(
                              key: 'isFeature',
                              label: 'Is Feature',
                              kind: CompendiumFieldKind.dynamic,
                              required: false,
                              nullable: true,
                              isArray: false,
                              choices: [
                              ],
                              fields: [
                              ],
                              itemDescriptor: null,
                              sampleCount: 6,
                            ),
                          ],
                          itemDescriptor: null,
                          sampleCount: 6,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'entries',
                          label: 'Entries',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 22,
                          ),
                          sampleCount: 10,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.string,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 10,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.string,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 10,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 10,
                    ),
                    sampleCount: 13,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'mode',
                    label: 'Mode',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 13,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'replace',
                    label: 'Replace',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 13,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 13,
          ),
          CompendiumFieldDescriptor(
            key: 'name',
            label: 'Name',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 14,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'ability',
        label: 'Ability',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'choose',
              label: 'Choose',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'weighted',
                  label: 'Weighted',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'from',
                      label: 'From',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 42,
                      ),
                      sampleCount: 14,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'weights',
                      label: 'Weights',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 35,
                      ),
                      sampleCount: 14,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 14,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 14,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 14,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'additionalSpells',
        label: 'Additional Spells',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'expanded',
              label: 'Expanded',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 's0',
                  label: 'S0',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 's1',
                  label: 'S1',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 's2',
                  label: 'S2',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 's3',
                  label: 'S3',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 's4',
                  label: 'S4',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 's5',
                  label: 'S5',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 2,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'data',
              label: 'Data',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'isFeature',
                  label: 'Is Feature',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 11,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 11,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'caption',
                    label: 'Caption',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 21,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colLabels',
                    label: 'Col Labels',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 102,
                    ),
                    sampleCount: 51,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colStyles',
                    label: 'Col Styles',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 102,
                    ),
                    sampleCount: 51,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'rows',
                    label: 'Rows',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.dynamic,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 692,
                      ),
                      sampleCount: 346,
                    ),
                    sampleCount: 51,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 52,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 100,
              ),
              sampleCount: 36,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entry',
                    label: 'Entry',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 73,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 73,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 73,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 73,
              ),
              sampleCount: 18,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 36,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 18,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 54,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 54,
        ),
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'feats',
        label: 'Feats',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'aberrant dragonmark|efa',
              label: 'Aberrant Dragonmark|efa',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'crafter|xphb',
              label: 'Crafter|xphb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'magic initiate; cleric|xphb',
              label: 'Magic Initiate; Cleric|xphb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'magic initiate|phb',
              label: 'Magic Initiate|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'skilled|xphb',
              label: 'Skilled|xphb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'tireless reveler|abh',
              label: 'Tireless Reveler|abh',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 8,
        ),
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'fromFeature',
        label: 'From Feature',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'feats',
            label: 'Feats',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluff',
        label: 'Has Fluff',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 10,
      ),
      CompendiumFieldDescriptor(
        key: 'languageProficiencies',
        label: 'Language Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'anyStandard',
              label: 'Any Standard',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 8,
            ),
            CompendiumFieldDescriptor(
              key: 'choose',
              label: 'Choose',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'from',
                  label: 'From',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 9,
        ),
        sampleCount: 9,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 3,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'skillProficiencies',
        label: 'Skill Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'acrobatics',
              label: 'Acrobatics',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'animal handling',
              label: 'Animal Handling',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'athletics',
              label: 'Athletics',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'deception',
              label: 'Deception',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'history',
              label: 'History',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'insight',
              label: 'Insight',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'intimidation',
              label: 'Intimidation',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'investigation',
              label: 'Investigation',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'perception',
              label: 'Perception',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'performance',
              label: 'Performance',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'persuasion',
              label: 'Persuasion',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'religion',
              label: 'Religion',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'sleight of hand',
              label: 'Sleight Of Hand',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'survival',
              label: 'Survival',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 18,
        ),
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'startingEquipment',
        label: 'Starting Equipment',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: '_',
              label: '_',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.dynamic,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'containsValue',
                    label: 'Contains Value',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 11,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'displayName',
                    label: 'Display Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 16,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'quantity',
                    label: 'Quantity',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'special',
                    label: 'Special',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 11,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 53,
              ),
              sampleCount: 11,
            ),
            CompendiumFieldDescriptor(
              key: 'a',
              label: 'A',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.dynamic,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'displayName',
                    label: 'Display Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'equipmentType',
                    label: 'Equipment Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 13,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'quantity',
                    label: 'Quantity',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'special',
                    label: 'Special',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'value',
                    label: 'Value',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 53,
              ),
              sampleCount: 12,
            ),
            CompendiumFieldDescriptor(
              key: 'b',
              label: 'B',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'equipmentType',
                    label: 'Equipment Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'special',
                    label: 'Special',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'value',
                    label: 'Value',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 12,
              ),
              sampleCount: 12,
            ),
            CompendiumFieldDescriptor(
              key: 'c',
              label: 'C',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'special',
                    label: 'Special',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'd',
              label: 'D',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'special',
                    label: 'Special',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 23,
        ),
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'toolProficiencies',
        label: 'Tool Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'anyArtisansTool',
              label: 'Any Artisans Tool',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'anyGamingSet',
              label: 'Any Gaming Set',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'calligrapher\'s supplies',
              label: 'Calligrapher\'s Supplies',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'cartographer\'s tools',
              label: 'Cartographer\'s Tools',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'choose',
              label: 'Choose',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'from',
                  label: 'From',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'disguise kit',
              label: 'Disguise Kit',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'forgery kit',
              label: 'Forgery Kit',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'gaming set',
              label: 'Gaming Set',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'vehicles (land)',
              label: 'Vehicles (land)',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'weaver\'s tools',
              label: 'Weaver\'s Tools',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 14,
        ),
        sampleCount: 14,
      ),
    ],
  ),
  'class': CompendiumEditorDescriptor(
    entityType: 'class',
    collectionKey: 'classList',
    label: 'Classes',
    fields: [
      CompendiumFieldDescriptor(
        key: 'additionalSpells',
        label: 'Additional Spells',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'expanded',
              label: 'Expanded',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '10',
                  label: '10',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'all',
                        label: 'All',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 's6',
                  label: 'S6',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'all',
                        label: 'All',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 's7',
                  label: 'S7',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'all',
                        label: 'All',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 's8',
                  label: 'S8',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'all',
                        label: 'All',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 's9',
                  label: 'S9',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'all',
                        label: 'All',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'innate',
              label: 'Innate',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '1',
                  label: '1',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'known',
              label: 'Known',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '10',
                  label: '10',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'choose',
                        label: 'Choose',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 2,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: '14',
                  label: '14',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'choose',
                        label: 'Choose',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 2,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: '18',
                  label: '18',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'choose',
                        label: 'Choose',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 2,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'prepared',
              label: 'Prepared',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '1',
                  label: '1',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: '2',
                  label: '2',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: '20',
                  label: '20',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: '5',
                  label: '5',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: '9',
                  label: '9',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 7,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'advancement',
        label: 'Advancement',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'configuration',
              label: 'Configuration',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'identifier',
                  label: 'Identifier',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: 'scale',
                  label: 'Scale',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: '10',
                      label: '10',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: '11',
                      label: '11',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '12',
                      label: '12',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '13',
                      label: '13',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '14',
                      label: '14',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: '15',
                      label: '15',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '16',
                      label: '16',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '17',
                      label: '17',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '18',
                      label: '18',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: '19',
                      label: '19',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '2',
                      label: '2',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: '20',
                      label: '20',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '3',
                      label: '3',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '4',
                      label: '4',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '5',
                      label: '5',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '6',
                      label: '6',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: '7',
                      label: '7',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '8',
                      label: '8',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: '9',
                      label: '9',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'value',
                          label: 'Value',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: 'type',
                  label: 'Type',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'title',
              label: 'Title',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 3,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'cantripProgression',
        label: 'Cantrip Progression',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.integer,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 180,
        ),
        sampleCount: 15,
      ),
      CompendiumFieldDescriptor(
        key: 'casterProgression',
        label: 'Caster Progression',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 19,
      ),
      CompendiumFieldDescriptor(
        key: 'classFeatures',
        label: 'Class Features',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.dynamic,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'classFeature',
              label: 'Class Feature',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 64,
            ),
            CompendiumFieldDescriptor(
              key: 'gainSubclassFeature',
              label: 'Gain Subclass Feature',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 62,
            ),
            CompendiumFieldDescriptor(
              key: 'gainSubclassFeatureHasContent',
              label: 'Gain Subclass Feature Has Content',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'tableDisplayName',
              label: 'Table Display Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 359,
        ),
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'classTableGroups',
        label: 'Class Table Groups',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'colLabels',
              label: 'Col Labels',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 190,
              ),
              sampleCount: 47,
            ),
            CompendiumFieldDescriptor(
              key: 'rows',
              label: 'Rows',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'rollable',
                      label: 'Rollable',
                      kind: CompendiumFieldKind.boolean,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 60,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'toRoll',
                      label: 'To Roll',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.object,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 60,
                      ),
                      sampleCount: 60,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'type',
                      label: 'Type',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 108,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'value',
                      label: 'Value',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 48,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 840,
                ),
                sampleCount: 372,
              ),
              sampleCount: 31,
            ),
            CompendiumFieldDescriptor(
              key: 'rowsSpellProgression',
              label: 'Rows Spell Progression',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1440,
                ),
                sampleCount: 192,
              ),
              sampleCount: 16,
            ),
            CompendiumFieldDescriptor(
              key: 'title',
              label: 'Title',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 17,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 47,
        ),
        sampleCount: 27,
      ),
      CompendiumFieldDescriptor(
        key: 'featProgression',
        label: 'Feat Progression',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'category',
              label: 'Category',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 18,
              ),
              sampleCount: 16,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 16,
            ),
            CompendiumFieldDescriptor(
              key: 'progression',
              label: 'Progression',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '1',
                  label: '1',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: '19',
                  label: '19',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 13,
                ),
                CompendiumFieldDescriptor(
                  key: '2',
                  label: '2',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 16,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 16,
        ),
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluff',
        label: 'Has Fluff',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 29,
      ),
      CompendiumFieldDescriptor(
        key: 'hd',
        label: 'Hd',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'faces',
            label: 'Faces',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 27,
          ),
          CompendiumFieldDescriptor(
            key: 'number',
            label: 'Number',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 27,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 27,
      ),
      CompendiumFieldDescriptor(
        key: 'isSidekick',
        label: 'Is Sidekick',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'migrationVersion',
        label: 'Migration Version',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'multiclassing',
        label: 'Multiclassing',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'proficienciesGained',
            label: 'Proficiencies Gained',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: 'armor',
                label: 'Armor',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'full',
                      label: 'Full',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'proficiency',
                      label: 'Proficiency',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 43,
                ),
                sampleCount: 20,
              ),
              CompendiumFieldDescriptor(
                key: 'skills',
                label: 'Skills',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'choose',
                      label: 'Choose',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'count',
                          label: 'Count',
                          kind: CompendiumFieldKind.integer,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 7,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'from',
                          label: 'From',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 68,
                          ),
                          sampleCount: 7,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 7,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 7,
                ),
                sampleCount: 7,
              ),
              CompendiumFieldDescriptor(
                key: 'toolProficiencies',
                label: 'Tool Proficiencies',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'anyMusicalInstrument',
                      label: 'Any Musical Instrument',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'thieves\' tools',
                      label: 'Thieves\' Tools',
                      kind: CompendiumFieldKind.boolean,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'tinker\'s tools',
                      label: 'Tinker\'s Tools',
                      kind: CompendiumFieldKind.boolean,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 6,
                ),
                sampleCount: 6,
              ),
              CompendiumFieldDescriptor(
                key: 'tools',
                label: 'Tools',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 7,
                ),
                sampleCount: 6,
              ),
              CompendiumFieldDescriptor(
                key: 'weapons',
                label: 'Weapons',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 15,
                ),
                sampleCount: 10,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 21,
          ),
          CompendiumFieldDescriptor(
            key: 'requirements',
            label: 'Requirements',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: 'cha',
                label: 'Cha',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 4,
              ),
              CompendiumFieldDescriptor(
                key: 'dex',
                label: 'Dex',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 3,
              ),
              CompendiumFieldDescriptor(
                key: 'int',
                label: 'Int',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
              CompendiumFieldDescriptor(
                key: 'or',
                label: 'Or',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'dex',
                      label: 'Dex',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'str',
                      label: 'Str',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                sampleCount: 1,
              ),
              CompendiumFieldDescriptor(
                key: 'str',
                label: 'Str',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
              CompendiumFieldDescriptor(
                key: 'wis',
                label: 'Wis',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 4,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 13,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 26,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'optionalfeatureProgression',
        label: 'Optionalfeature Progression',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'featureType',
              label: 'Feature Type',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 9,
              ),
              sampleCount: 9,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 9,
            ),
            CompendiumFieldDescriptor(
              key: 'progression',
              label: 'Progression',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '1',
                  label: '1',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: '10',
                  label: '10',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: '17',
                  label: '17',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: '2',
                  label: '2',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: '3',
                  label: '3',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 36,
              ),
              sampleCount: 9,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 9,
        ),
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'preparedSpells',
        label: 'Prepared Spells',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'preparedSpellsChange',
        label: 'Prepared Spells Change',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'preparedSpellsProgression',
        label: 'Prepared Spells Progression',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.integer,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 108,
        ),
        sampleCount: 9,
      ),
      CompendiumFieldDescriptor(
        key: 'primaryAbility',
        label: 'Primary Ability',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'cha',
              label: 'Cha',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'dex',
              label: 'Dex',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'int',
              label: 'Int',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'str',
              label: 'Str',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'wis',
              label: 'Wis',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 14,
        ),
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'proficiency',
        label: 'Proficiency',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 54,
        ),
        sampleCount: 27,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 13,
        ),
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'spellcastingAbility',
        label: 'Spellcasting Ability',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'spellsKnownProgression',
        label: 'Spells Known Progression',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.integer,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 60,
        ),
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'spellsKnownProgressionFixed',
        label: 'Spells Known Progression Fixed',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.integer,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 24,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'spellsKnownProgressionFixedAllowLowerLevel',
        label: 'Spells Known Progression Fixed Allow Lower Level',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'spellsKnownProgressionFixedByLevel',
        label: 'Spells Known Progression Fixed By Level',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: '11',
            label: '11',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: '6',
                label: '6',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: '13',
            label: '13',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: '7',
                label: '7',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: '15',
            label: '15',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: '8',
                label: '8',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: '17',
            label: '17',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: '9',
                label: '9',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'startingEquipment',
        label: 'Starting Equipment',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'additionalFromBackground',
            label: 'Additional From Background',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 27,
          ),
          CompendiumFieldDescriptor(
            key: 'default',
            label: 'Default',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 54,
            ),
            sampleCount: 14,
          ),
          CompendiumFieldDescriptor(
            key: 'defaultData',
            label: 'Default Data',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '_',
                  label: '_',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.dynamic,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'equipmentType',
                        label: 'Equipment Type',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 5,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 5,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'quantity',
                        label: 'Quantity',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 6,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 27,
                  ),
                  sampleCount: 14,
                ),
                CompendiumFieldDescriptor(
                  key: 'a',
                  label: 'A',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'equipmentType',
                        label: 'Equipment Type',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 3,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'equipmentTypes',
                        label: 'Equipment Types',
                        kind: CompendiumFieldKind.list,
                        required: false,
                        nullable: true,
                        isArray: true,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor:                         CompendiumFieldDescriptor(
                          key: 'item',
                          label: 'Item',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 2,
                        ),
                        sampleCount: 1,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 69,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'quantity',
                        label: 'Quantity',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 12,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'special',
                        label: 'Special',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'value',
                        label: 'Value',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 13,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 130,
                  ),
                  sampleCount: 53,
                ),
                CompendiumFieldDescriptor(
                  key: 'b',
                  label: 'B',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'equipmentType',
                        label: 'Equipment Type',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 17,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 8,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'quantity',
                        label: 'Quantity',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 4,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'value',
                        label: 'Value',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 13,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 62,
                  ),
                  sampleCount: 53,
                ),
                CompendiumFieldDescriptor(
                  key: 'c',
                  label: 'C',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.dynamic,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'equipmentType',
                        label: 'Equipment Type',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'value',
                        label: 'Value',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 4,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 67,
            ),
            sampleCount: 27,
          ),
          CompendiumFieldDescriptor(
            key: 'entries',
            label: 'Entries',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 13,
            ),
            sampleCount: 13,
          ),
          CompendiumFieldDescriptor(
            key: 'goldAlternative',
            label: 'Gold Alternative',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 14,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 27,
      ),
      CompendiumFieldDescriptor(
        key: 'startingProficiencies',
        label: 'Starting Proficiencies',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'armor',
            label: 'Armor',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'full',
                  label: 'Full',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'proficiency',
                  label: 'Proficiency',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 52,
            ),
            sampleCount: 21,
          ),
          CompendiumFieldDescriptor(
            key: 'skills',
            label: 'Skills',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'any',
                  label: 'Any',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'choose',
                  label: 'Choose',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'count',
                      label: 'Count',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 25,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'from',
                      label: 'From',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 176,
                      ),
                      sampleCount: 25,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 25,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 27,
            ),
            sampleCount: 27,
          ),
          CompendiumFieldDescriptor(
            key: 'toolProficiencies',
            label: 'Tool Proficiencies',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'anyArtisansTool',
                  label: 'Any Artisans Tool',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 4,
                ),
                CompendiumFieldDescriptor(
                  key: 'anyMusicalInstrument',
                  label: 'Any Musical Instrument',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 4,
                ),
                CompendiumFieldDescriptor(
                  key: 'herbalism kit',
                  label: 'Herbalism Kit',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'thieves\' tools',
                  label: 'Thieves\' Tools',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 4,
                ),
                CompendiumFieldDescriptor(
                  key: 'tinker\'s tools',
                  label: 'Tinker\'s Tools',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 12,
            ),
            sampleCount: 10,
          ),
          CompendiumFieldDescriptor(
            key: 'tools',
            label: 'Tools',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 14,
            ),
            sampleCount: 10,
          ),
          CompendiumFieldDescriptor(
            key: 'weaponProficiencies',
            label: 'Weapon Proficiencies',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'all',
                  label: 'All',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'fromFilter',
                      label: 'From Filter',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'simple',
                  label: 'Simple',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'weapons',
            label: 'Weapons',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'optional',
                  label: 'Optional',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'proficiency',
                  label: 'Proficiency',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 64,
            ),
            sampleCount: 27,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 27,
      ),
      CompendiumFieldDescriptor(
        key: 'subclassTitle',
        label: 'Subclass Title',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 27,
      ),
    ],
  ),
  'classFeature': CompendiumEditorDescriptor(
    entityType: 'classFeature',
    collectionKey: 'classFeatureList',
    label: 'Class Features',
    fields: [
      CompendiumFieldDescriptor(
        key: 'className',
        label: 'Class Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'classFeature',
              label: 'Class Feature',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'columns',
              label: 'Columns',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'attributes',
                    label: 'Attributes',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'caption',
                    label: 'Caption',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colLabels',
                    label: 'Col Labels',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 8,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colStyles',
                    label: 'Col Styles',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 8,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 31,
                    ),
                    sampleCount: 19,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'footnotes',
                    label: 'Footnotes',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 21,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'rows',
                    label: 'Rows',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.dynamic,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 84,
                      ),
                      sampleCount: 42,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 25,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 43,
              ),
              sampleCount: 12,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 16,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 15,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 70,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'header',
        label: 'Header',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'level',
        label: 'Level',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
    ],
  ),
  'condition': CompendiumEditorDescriptor(
    entityType: 'condition',
    collectionKey: 'conditionList',
    label: 'Conditions',
    fields: [
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'colLabels',
              label: 'Col Labels',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'colStyles',
              label: 'Col Styles',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 48,
                    ),
                    sampleCount: 48,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 48,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 48,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 48,
              ),
              sampleCount: 15,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 38,
              ),
              sampleCount: 14,
            ),
            CompendiumFieldDescriptor(
              key: 'rows',
              label: 'Rows',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 12,
                ),
                sampleCount: 6,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 30,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 50,
        ),
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 15,
        ),
        sampleCount: 15,
      ),
    ],
  ),
  'deity': CompendiumEditorDescriptor(
    entityType: 'deity',
    collectionKey: 'deityList',
    label: 'Deities',
    fields: [
      CompendiumFieldDescriptor(
        key: 'alignment',
        label: 'Alignment',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 54,
        ),
        sampleCount: 28,
      ),
      CompendiumFieldDescriptor(
        key: 'altNames',
        label: 'Alt Names',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 12,
        ),
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'category',
        label: 'Category',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'domains',
        label: 'Domains',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 59,
        ),
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'credit',
                          label: 'Credit',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'entries',
                          label: 'Entries',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 8,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'href',
                          label: 'Href',
                          kind: CompendiumFieldKind.object,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 7,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 9,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 15,
                    ),
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'items',
                    label: 'Items',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 6,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 8,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entry',
                    label: 'Entry',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 5,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 43,
        ),
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'pantheon',
        label: 'Pantheon',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'piety',
        label: 'Piety',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'plane',
        label: 'Plane',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'province',
        label: 'Province',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintAlias',
        label: 'Reprint Alias',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'symbol',
        label: 'Symbol',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 29,
      ),
      CompendiumFieldDescriptor(
        key: 'symbolImg',
        label: 'Symbol Img',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'credit',
            label: 'Credit',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
          CompendiumFieldDescriptor(
            key: 'height',
            label: 'Height',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'href',
            label: 'Href',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: 'path',
                label: 'Path',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 8,
              ),
              CompendiumFieldDescriptor(
                key: 'type',
                label: 'Type',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 8,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 8,
          ),
          CompendiumFieldDescriptor(
            key: 'title',
            label: 'Title',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'type',
            label: 'Type',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 8,
          ),
          CompendiumFieldDescriptor(
            key: 'width',
            label: 'Width',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'title',
        label: 'Title',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 22,
      ),
      CompendiumFieldDescriptor(
        key: 'worshipers',
        label: 'Worshipers',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
    ],
  ),
  'disease': CompendiumEditorDescriptor(
    entityType: 'disease',
    collectionKey: 'diseaseList',
    label: 'Diseases',
    fields: [
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 9,
                    ),
                    sampleCount: 9,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 9,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 9,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 19,
              ),
              sampleCount: 13,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entry',
                    label: 'Entry',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 14,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 14,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 14,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 14,
              ),
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 8,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 19,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 84,
        ),
        sampleCount: 29,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 29,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 3,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'type',
        label: 'Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 7,
      ),
    ],
  ),
  'feat': CompendiumEditorDescriptor(
    entityType: 'feat',
    collectionKey: 'featList',
    label: 'Feats',
    fields: [
      CompendiumFieldDescriptor(
        key: 'ability',
        label: 'Ability',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'cha',
              label: 'Cha',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'choose',
              label: 'Choose',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'amount',
                  label: 'Amount',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 4,
                ),
                CompendiumFieldDescriptor(
                  key: 'count',
                  label: 'Count',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'from',
                  label: 'From',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 93,
                  ),
                  sampleCount: 19,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 19,
            ),
            CompendiumFieldDescriptor(
              key: 'con',
              label: 'Con',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'dex',
              label: 'Dex',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'hidden',
              label: 'Hidden',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'max',
              label: 'Max',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 12,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 23,
        ),
        sampleCount: 22,
      ),
      CompendiumFieldDescriptor(
        key: 'additionalSpells',
        label: 'Additional Spells',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ability',
              label: 'Ability',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'choose',
                  label: 'Choose',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 9,
                  ),
                  sampleCount: 3,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
            CompendiumFieldDescriptor(
              key: 'innate',
              label: 'Innate',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '_',
                  label: '_',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'daily',
                      label: 'Daily',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.object,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                          sampleCount: 1,
                        ),
                        CompendiumFieldDescriptor(
                          key: '1e',
                          label: '1e',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.object,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 3,
                          ),
                          sampleCount: 3,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 4,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'rest',
                      label: 'Rest',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.object,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 5,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'known',
              label: 'Known',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '_',
                  label: '_',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'choose',
                        label: 'Choose',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 4,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'count',
                        label: 'Count',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 4,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'prepared',
              label: 'Prepared',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '_',
                  label: '_',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'rest',
                      label: 'Rest',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.object,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 7,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'category',
        label: 'Category',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 22,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'caption',
              label: 'Caption',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'colLabels',
              label: 'Col Labels',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'colStyles',
              label: 'Col Styles',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'entries',
                          label: 'Entries',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 1,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 40,
              ),
              sampleCount: 37,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.dynamic,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 8,
                    ),
                    sampleCount: 8,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 8,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 8,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 21,
              ),
              sampleCount: 10,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 36,
            ),
            CompendiumFieldDescriptor(
              key: 'rows',
              label: 'Rows',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 16,
                ),
                sampleCount: 8,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 48,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 81,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'immune',
        label: 'Immune',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'prerequisite',
        label: 'Prerequisite',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ability',
              label: 'Ability',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'cha',
                    label: 'Cha',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'dex',
                    label: 'Dex',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'str',
                    label: 'Str',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 3,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'campaign',
              label: 'Campaign',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'exclusiveFeatCategory',
              label: 'Exclusive Feat Category',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'feat',
              label: 'Feat',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 5,
              ),
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'feature',
              label: 'Feature',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'level',
              label: 'Level',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 23,
            ),
            CompendiumFieldDescriptor(
              key: 'other',
              label: 'Other',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'otherSummary',
              label: 'Other Summary',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'entry',
                  label: 'Entry',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'entrySummary',
                  label: 'Entry Summary',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 28,
        ),
        sampleCount: 27,
      ),
      CompendiumFieldDescriptor(
        key: 'repeatable',
        label: 'Repeatable',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'repeatableHidden',
        label: 'Repeatable Hidden',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 4,
        ),
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'resist',
        label: 'Resist',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'choose',
              label: 'Choose',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'count',
                  label: 'Count',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'from',
                  label: 'From',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 9,
                  ),
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'senses',
        label: 'Senses',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'blindsight',
              label: 'Blindsight',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'toolProficiencies',
        label: 'Tool Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'anyArtisansTool',
              label: 'Any Artisans Tool',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
    ],
  ),
  'hazard': CompendiumEditorDescriptor(
    entityType: 'hazard',
    collectionKey: 'hazardList',
    label: 'Hazards',
    fields: [
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'caption',
              label: 'Caption',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'colLabels',
              label: 'Col Labels',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 4,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'colStyles',
              label: 'Col Styles',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 4,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 4,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'rows',
              label: 'Rows',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 36,
                ),
                sampleCount: 18,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 73,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'rating',
        label: 'Rating',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'threat',
              label: 'Threat',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 8,
            ),
            CompendiumFieldDescriptor(
              key: 'tier',
              label: 'Tier',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 8,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 8,
        ),
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 6,
        ),
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'trapHazType',
        label: 'Trap Haz Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 20,
      ),
    ],
  ),
  'item': CompendiumEditorDescriptor(
    entityType: 'item',
    collectionKey: 'itemList',
    label: 'Items',
    fields: [
      CompendiumFieldDescriptor(
        key: 'baseItem',
        label: 'Base Item',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'bonusSpellAttack',
        label: 'Bonus Spell Attack',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 26,
      ),
      CompendiumFieldDescriptor(
        key: 'bonusSpellSaveDc',
        label: 'Bonus Spell Save Dc',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 22,
      ),
      CompendiumFieldDescriptor(
        key: 'bonusWeapon',
        label: 'Bonus Weapon',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'classFeatures',
        label: 'Class Features',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 4,
        ),
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'dmg1',
        label: 'Dmg1',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'dmgType',
        label: 'Dmg Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 57,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'focus',
        label: 'Focus',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 13,
        ),
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'lootTables',
        label: 'Loot Tables',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 11,
        ),
        sampleCount: 9,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'property',
        label: 'Property',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 2,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'rarity',
        label: 'Rarity',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 6,
        ),
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'reqAttune',
        label: 'Req Attune',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 28,
      ),
      CompendiumFieldDescriptor(
        key: 'reqAttuneTags',
        label: 'Req Attune Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'class',
              label: 'Class',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 31,
            ),
            CompendiumFieldDescriptor(
              key: 'spellcasting',
              label: 'Spellcasting',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 35,
        ),
        sampleCount: 28,
      ),
      CompendiumFieldDescriptor(
        key: 'tier',
        label: 'Tier',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'type',
        label: 'Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 21,
      ),
      CompendiumFieldDescriptor(
        key: 'weaponCategory',
        label: 'Weapon Category',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'weight',
        label: 'Weight',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'wondrous',
        label: 'Wondrous',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 22,
      ),
    ],
  ),
  'itemGroup': CompendiumEditorDescriptor(
    entityType: 'itemGroup',
    collectionKey: 'itemGroupList',
    label: 'Item Groups',
    fields: [
      CompendiumFieldDescriptor(
        key: 'ac',
        label: 'Ac',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'attachedSpells',
        label: 'Attached Spells',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'limited',
            label: 'Limited',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: '1',
                label: '1',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                sampleCount: 1,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'baseItem',
        label: 'Base Item',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'bonusAc',
        label: 'Bonus Ac',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'charges',
        label: 'Charges',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'classFeatures',
        label: 'Class Features',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'curse',
        label: 'Curse',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'dmg1',
        label: 'Dmg1',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'dmg2',
        label: 'Dmg2',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'dmgType',
        label: 'Dmg Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'caption',
              label: 'Caption',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'colLabels',
              label: 'Col Labels',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 14,
              ),
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'colStyles',
              label: 'Col Styles',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 14,
              ),
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'caption',
                    label: 'Caption',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colLabels',
                    label: 'Col Labels',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colStyles',
                    label: 'Col Styles',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'rows',
                    label: 'Rows',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.dynamic,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 30,
                      ),
                      sampleCount: 10,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 5,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'rows',
              label: 'Rows',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 86,
                ),
                sampleCount: 34,
              ),
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 8,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 25,
        ),
        sampleCount: 12,
      ),
      CompendiumFieldDescriptor(
        key: 'focus',
        label: 'Focus',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 17,
        ),
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 12,
      ),
      CompendiumFieldDescriptor(
        key: 'items',
        label: 'Items',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 188,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'itemsHidden',
        label: 'Items Hidden',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'lootTables',
        label: 'Loot Tables',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 32,
        ),
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'mastery',
        label: 'Mastery',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'miscTags',
        label: 'Misc Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'property',
        label: 'Property',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 6,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'range',
        label: 'Range',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'rarity',
        label: 'Rarity',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'recharge',
        label: 'Recharge',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'rechargeAmount',
        label: 'Recharge Amount',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 10,
        ),
        sampleCount: 10,
      ),
      CompendiumFieldDescriptor(
        key: 'reqAttune',
        label: 'Req Attune',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'reqAttuneTags',
        label: 'Req Attune Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'creatureType',
              label: 'Creature Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'spellcasting',
              label: 'Spellcasting',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 3,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'scfType',
        label: 'Scf Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'sentient',
        label: 'Sentient',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'staff',
        label: 'Staff',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'stealth',
        label: 'Stealth',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'strength',
        label: 'Strength',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'tattoo',
        label: 'Tattoo',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'tier',
        label: 'Tier',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'type',
        label: 'Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'weaponCategory',
        label: 'Weapon Category',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'weight',
        label: 'Weight',
        kind: CompendiumFieldKind.number,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'wondrous',
        label: 'Wondrous',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 15,
      ),
    ],
  ),
  'itemMastery': CompendiumEditorDescriptor(
    entityType: 'itemMastery',
    collectionKey: 'itemMasteryList',
    label: 'Item Masteries',
    fields: [
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 8,
        ),
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 8,
      ),
    ],
  ),
  'itemProperty': CompendiumEditorDescriptor(
    entityType: 'itemProperty',
    collectionKey: 'itemPropertyList',
    label: 'Item Properties',
    fields: [
      CompendiumFieldDescriptor(
        key: 'abbreviation',
        label: 'Abbreviation',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 26,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 27,
              ),
              sampleCount: 25,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 25,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 25,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 25,
        ),
        sampleCount: 25,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 12,
        ),
        sampleCount: 12,
      ),
      CompendiumFieldDescriptor(
        key: 'template',
        label: 'Template',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 26,
      ),
    ],
  ),
  'itemType': CompendiumEditorDescriptor(
    entityType: 'itemType',
    collectionKey: 'itemTypeList',
    label: 'Item Types',
    fields: [
      CompendiumFieldDescriptor(
        key: '_copy',
        label: 'Copy',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'abbreviation',
            label: 'Abbreviation',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'abbreviation',
        label: 'Abbreviation',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 11,
        ),
        sampleCount: 9,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 15,
        ),
        sampleCount: 15,
      ),
    ],
  ),
  'language': CompendiumEditorDescriptor(
    entityType: 'language',
    collectionKey: 'languageList',
    label: 'Languages',
    fields: [
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 6,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 5,
        ),
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'fonts',
        label: 'Fonts',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'origin',
        label: 'Origin',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 9,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 7,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'script',
        label: 'Script',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 15,
      ),
      CompendiumFieldDescriptor(
        key: 'type',
        label: 'Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 19,
      ),
      CompendiumFieldDescriptor(
        key: 'typicalSpeakers',
        label: 'Typical Speakers',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 42,
        ),
        sampleCount: 23,
      ),
    ],
  ),
  'magicvariant': CompendiumEditorDescriptor(
    entityType: 'magicvariant',
    collectionKey: 'magicvariantList',
    label: 'Magic Variants',
    fields: [
      CompendiumFieldDescriptor(
        key: 'ammo',
        label: 'Ammo',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 22,
        ),
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'excludes',
        label: 'Excludes',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'cellEnergy',
            label: 'Cell Energy',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'name',
            label: 'Name',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'net',
            label: 'Net',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 4,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'inherits',
        label: 'Inherits',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'bonusAc',
            label: 'Bonus Ac',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 12,
          ),
          CompendiumFieldDescriptor(
            key: 'bonusWeapon',
            label: 'Bonus Weapon',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 13,
          ),
          CompendiumFieldDescriptor(
            key: 'bonusWeaponAttack',
            label: 'Bonus Weapon Attack',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
          CompendiumFieldDescriptor(
            key: 'classFeatures',
            label: 'Class Features',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            sampleCount: 6,
          ),
          CompendiumFieldDescriptor(
            key: 'entries',
            label: 'Entries',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'entries',
                  label: 'Entries',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'name',
                  label: 'Name',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'type',
                  label: 'Type',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 34,
            ),
            sampleCount: 32,
          ),
          CompendiumFieldDescriptor(
            key: 'lootTables',
            label: 'Loot Tables',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 25,
            ),
            sampleCount: 19,
          ),
          CompendiumFieldDescriptor(
            key: 'namePrefix',
            label: 'Name Prefix',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 32,
          ),
          CompendiumFieldDescriptor(
            key: 'rarity',
            label: 'Rarity',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 32,
          ),
          CompendiumFieldDescriptor(
            key: 'reprintedAs',
            label: 'Reprinted As',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 14,
            ),
            sampleCount: 14,
          ),
          CompendiumFieldDescriptor(
            key: 'reqAttune',
            label: 'Req Attune',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'tier',
            label: 'Tier',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 18,
          ),
          CompendiumFieldDescriptor(
            key: 'valueExpression',
            label: 'Value Expression',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'requires',
        label: 'Requires',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'armor',
              label: 'Armor',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'net',
              label: 'Net',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'sword',
              label: 'Sword',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 46,
            ),
            CompendiumFieldDescriptor(
              key: 'weapon',
              label: 'Weapon',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 60,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'type',
        label: 'Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
    ],
  ),
  'monster': CompendiumEditorDescriptor(
    entityType: 'monster',
    collectionKey: 'monsterList',
    label: 'Monsters',
    fields: [
      CompendiumFieldDescriptor(
        key: 'ac',
        label: 'Ac',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.dynamic,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ac',
              label: 'Ac',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 26,
            ),
            CompendiumFieldDescriptor(
              key: 'braces',
              label: 'Braces',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'condition',
              label: 'Condition',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'from',
              label: 'From',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 22,
              ),
              sampleCount: 21,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 37,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'action',
        label: 'Action',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 93,
              ),
              sampleCount: 89,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 89,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 89,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'actionTags',
        label: 'Action Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 29,
        ),
        sampleCount: 26,
      ),
      CompendiumFieldDescriptor(
        key: 'alignment',
        label: 'Alignment',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'alignment',
              label: 'Alignment',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 4,
              ),
              sampleCount: 2,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 57,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'attachedItems',
        label: 'Attached Items',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 19,
        ),
        sampleCount: 15,
      ),
      CompendiumFieldDescriptor(
        key: 'bonus',
        label: 'Bonus',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 5,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 3,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'cha',
        label: 'Cha',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'con',
        label: 'Con',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'conditionImmune',
        label: 'Condition Immune',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 44,
        ),
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'conditionInflict',
        label: 'Condition Inflict',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 23,
        ),
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'conditionInflictSpell',
        label: 'Condition Inflict Spell',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 19,
        ),
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'cr',
        label: 'Cr',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'cr',
            label: 'Cr',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'xpLair',
            label: 'Xp Lair',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'damageTags',
        label: 'Damage Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 69,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'damageTagsSpell',
        label: 'Damage Tags Spell',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 40,
        ),
        sampleCount: 15,
      ),
      CompendiumFieldDescriptor(
        key: 'dex',
        label: 'Dex',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'environment',
        label: 'Environment',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 8,
        ),
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'gear',
        label: 'Gear',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluff',
        label: 'Has Fluff',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 31,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 27,
      ),
      CompendiumFieldDescriptor(
        key: 'hasToken',
        label: 'Has Token',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'hp',
        label: 'Hp',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'average',
            label: 'Average',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 32,
          ),
          CompendiumFieldDescriptor(
            key: 'formula',
            label: 'Formula',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 32,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'immune',
        label: 'Immune',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 14,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'initiative',
        label: 'Initiative',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'proficiency',
            label: 'Proficiency',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'int',
        label: 'Int',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'isNamedCreature',
        label: 'Is Named Creature',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 16,
      ),
      CompendiumFieldDescriptor(
        key: 'isNpc',
        label: 'Is Npc',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 16,
      ),
      CompendiumFieldDescriptor(
        key: 'languages',
        label: 'Languages',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 69,
        ),
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'languageTags',
        label: 'Language Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 75,
        ),
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'legendary',
        label: 'Legendary',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 6,
              ),
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 6,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'legendaryActionsLair',
        label: 'Legendary Actions Lair',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'legendaryGroup',
        label: 'Legendary Group',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'name',
            label: 'Name',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'miscTags',
        label: 'Misc Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 77,
        ),
        sampleCount: 31,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'passive',
        label: 'Passive',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reaction',
        label: 'Reaction',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 9,
              ),
              sampleCount: 9,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 9,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 9,
        ),
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'reactionHeader',
        label: 'Reaction Header',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'resist',
        label: 'Resist',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.dynamic,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'cond',
              label: 'Cond',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'note',
              label: 'Note',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'resist',
              label: 'Resist',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 9,
              ),
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 12,
        ),
        sampleCount: 9,
      ),
      CompendiumFieldDescriptor(
        key: 'save',
        label: 'Save',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'cha',
            label: 'Cha',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 5,
          ),
          CompendiumFieldDescriptor(
            key: 'con',
            label: 'Con',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 8,
          ),
          CompendiumFieldDescriptor(
            key: 'dex',
            label: 'Dex',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 4,
          ),
          CompendiumFieldDescriptor(
            key: 'int',
            label: 'Int',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 10,
          ),
          CompendiumFieldDescriptor(
            key: 'str',
            label: 'Str',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 4,
          ),
          CompendiumFieldDescriptor(
            key: 'wis',
            label: 'Wis',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 15,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 19,
      ),
      CompendiumFieldDescriptor(
        key: 'savingThrowForced',
        label: 'Saving Throw Forced',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 24,
        ),
        sampleCount: 16,
      ),
      CompendiumFieldDescriptor(
        key: 'savingThrowForcedSpell',
        label: 'Saving Throw Forced Spell',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 35,
        ),
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'senses',
        label: 'Senses',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 25,
        ),
        sampleCount: 21,
      ),
      CompendiumFieldDescriptor(
        key: 'senseTags',
        label: 'Sense Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 25,
        ),
        sampleCount: 21,
      ),
      CompendiumFieldDescriptor(
        key: 'size',
        label: 'Size',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 34,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'skill',
        label: 'Skill',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'acrobatics',
            label: 'Acrobatics',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 5,
          ),
          CompendiumFieldDescriptor(
            key: 'animal handling',
            label: 'Animal Handling',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'arcana',
            label: 'Arcana',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 8,
          ),
          CompendiumFieldDescriptor(
            key: 'athletics',
            label: 'Athletics',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 7,
          ),
          CompendiumFieldDescriptor(
            key: 'deception',
            label: 'Deception',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'history',
            label: 'History',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 7,
          ),
          CompendiumFieldDescriptor(
            key: 'insight',
            label: 'Insight',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 7,
          ),
          CompendiumFieldDescriptor(
            key: 'intimidation',
            label: 'Intimidation',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
          CompendiumFieldDescriptor(
            key: 'investigation',
            label: 'Investigation',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'medicine',
            label: 'Medicine',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
          CompendiumFieldDescriptor(
            key: 'nature',
            label: 'Nature',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'perception',
            label: 'Perception',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 23,
          ),
          CompendiumFieldDescriptor(
            key: 'performance',
            label: 'Performance',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 6,
          ),
          CompendiumFieldDescriptor(
            key: 'persuasion',
            label: 'Persuasion',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 8,
          ),
          CompendiumFieldDescriptor(
            key: 'religion',
            label: 'Religion',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 5,
          ),
          CompendiumFieldDescriptor(
            key: 'sleight of hand',
            label: 'Sleight Of Hand',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'stealth',
            label: 'Stealth',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 12,
          ),
          CompendiumFieldDescriptor(
            key: 'survival',
            label: 'Survival',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 31,
      ),
      CompendiumFieldDescriptor(
        key: 'speed',
        label: 'Speed',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'canHover',
            label: 'Can Hover',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'climb',
            label: 'Climb',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
          CompendiumFieldDescriptor(
            key: 'fly',
            label: 'Fly',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: 'condition',
                label: 'Condition',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              CompendiumFieldDescriptor(
                key: 'number',
                label: 'Number',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 6,
          ),
          CompendiumFieldDescriptor(
            key: 'swim',
            label: 'Swim',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'walk',
            label: 'Walk',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 32,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'spellcasting',
        label: 'Spellcasting',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ability',
              label: 'Ability',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 20,
            ),
            CompendiumFieldDescriptor(
              key: 'daily',
              label: 'Daily',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '1',
                  label: '1',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: '1e',
                  label: '1e',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 13,
                  ),
                  sampleCount: 5,
                ),
                CompendiumFieldDescriptor(
                  key: '2',
                  label: '2',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: '2e',
                  label: '2e',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 8,
                  ),
                  sampleCount: 3,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
            CompendiumFieldDescriptor(
              key: 'displayAs',
              label: 'Display As',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'footerEntries',
              label: 'Footer Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'headerEntries',
              label: 'Header Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 20,
              ),
              sampleCount: 20,
            ),
            CompendiumFieldDescriptor(
              key: 'hidden',
              label: 'Hidden',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 20,
            ),
            CompendiumFieldDescriptor(
              key: 'spells',
              label: 'Spells',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '0',
                  label: '0',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'spells',
                      label: 'Spells',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 37,
                      ),
                      sampleCount: 9,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 9,
                ),
                CompendiumFieldDescriptor(
                  key: '1',
                  label: '1',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'slots',
                      label: 'Slots',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 10,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'spells',
                      label: 'Spells',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 35,
                      ),
                      sampleCount: 10,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 10,
                ),
                CompendiumFieldDescriptor(
                  key: '2',
                  label: '2',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'slots',
                      label: 'Slots',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 10,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'spells',
                      label: 'Spells',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 28,
                      ),
                      sampleCount: 10,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 10,
                ),
                CompendiumFieldDescriptor(
                  key: '3',
                  label: '3',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'lower',
                      label: 'Lower',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'slots',
                      label: 'Slots',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 7,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'spells',
                      label: 'Spells',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 21,
                      ),
                      sampleCount: 7,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 7,
                ),
                CompendiumFieldDescriptor(
                  key: '4',
                  label: '4',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'slots',
                      label: 'Slots',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 4,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'spells',
                      label: 'Spells',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 9,
                      ),
                      sampleCount: 4,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 4,
                ),
                CompendiumFieldDescriptor(
                  key: '5',
                  label: '5',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'slots',
                      label: 'Slots',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'spells',
                      label: 'Spells',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 7,
                      ),
                      sampleCount: 3,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 11,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 20,
            ),
            CompendiumFieldDescriptor(
              key: 'will',
              label: 'Will',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 22,
              ),
              sampleCount: 9,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 20,
        ),
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'spellcastingTags',
        label: 'Spellcasting Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 21,
        ),
        sampleCount: 18,
      ),
      CompendiumFieldDescriptor(
        key: 'str',
        label: 'Str',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'tokenCredit',
        label: 'Token Credit',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'tokenCustom',
        label: 'Token Custom',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'trait',
        label: 'Trait',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'items',
                    label: 'Items',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'entries',
                          label: 'Entries',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 9,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 9,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 9,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 9,
                    ),
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'style',
                    label: 'Style',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 65,
              ),
              sampleCount: 60,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 60,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 60,
        ),
        sampleCount: 29,
      ),
      CompendiumFieldDescriptor(
        key: 'traitTags',
        label: 'Trait Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 28,
        ),
        sampleCount: 21,
      ),
      CompendiumFieldDescriptor(
        key: 'type',
        label: 'Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'tags',
            label: 'Tags',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'prefix',
                  label: 'Prefix',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'prefixHidden',
                  label: 'Prefix Hidden',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'tag',
                  label: 'Tag',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 21,
            ),
            sampleCount: 21,
          ),
          CompendiumFieldDescriptor(
            key: 'type',
            label: 'Type',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 21,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'vulnerable',
        label: 'Vulnerable',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'wis',
        label: 'Wis',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
    ],
  ),
  'monsterfeatures': CompendiumEditorDescriptor(
    entityType: 'monsterfeatures',
    collectionKey: 'monsterfeaturesList',
    label: 'Monster Features',
    fields: [
      CompendiumFieldDescriptor(
        key: 'ac',
        label: 'Ac',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 9,
      ),
      CompendiumFieldDescriptor(
        key: 'attackBonus',
        label: 'Attack Bonus',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'dpr',
        label: 'Dpr',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'effect',
        label: 'Effect',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 25,
      ),
      CompendiumFieldDescriptor(
        key: 'example',
        label: 'Example',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 25,
      ),
      CompendiumFieldDescriptor(
        key: 'hasNumberParam',
        label: 'Has Number Param',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'hp',
        label: 'Hp',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 25,
      ),
    ],
  ),
  'object': CompendiumEditorDescriptor(
    entityType: 'object',
    collectionKey: 'objectList',
    label: 'Objects',
    fields: [
      CompendiumFieldDescriptor(
        key: 'ac',
        label: 'Ac',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'special',
            label: 'Special',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'actionEntries',
        label: 'Action Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'attackEntries',
                    label: 'Attack Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 5,
                    ),
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'attackType',
                    label: 'Attack Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'hitEntries',
                    label: 'Hit Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 5,
                    ),
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'items',
                    label: 'Items',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'entries',
                          label: 'Entries',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 3,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'style',
                    label: 'Style',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 6,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 29,
              ),
              sampleCount: 27,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 27,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 27,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 27,
        ),
        sampleCount: 26,
      ),
      CompendiumFieldDescriptor(
        key: 'altArt',
        label: 'Alt Art',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 6,
        ),
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'cha',
        label: 'Cha',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'con',
        label: 'Con',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'conditionImmune',
        label: 'Condition Immune',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 36,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'dex',
        label: 'Dex',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'caption',
                          label: 'Caption',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 2,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'colLabels',
                          label: 'Col Labels',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 2,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'colStyles',
                          label: 'Col Styles',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 2,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'rows',
                          label: 'Rows',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 2,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 2,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 9,
                    ),
                    sampleCount: 7,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'items',
                    label: 'Items',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 4,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 8,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 14,
              ),
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 44,
        ),
        sampleCount: 31,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 9,
      ),
      CompendiumFieldDescriptor(
        key: 'hasToken',
        label: 'Has Token',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 29,
      ),
      CompendiumFieldDescriptor(
        key: 'hp',
        label: 'Hp',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'special',
            label: 'Special',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 5,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'immune',
        label: 'Immune',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'special',
              label: 'Special',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 45,
        ),
        sampleCount: 17,
      ),
      CompendiumFieldDescriptor(
        key: 'int',
        label: 'Int',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'isNpc',
        label: 'Is Npc',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'objectType',
        label: 'Object Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 6,
        ),
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'resist',
        label: 'Resist',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'senses',
        label: 'Senses',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'size',
        label: 'Size',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 36,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'speed',
        label: 'Speed',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'str',
        label: 'Str',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'token',
        label: 'Token',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'name',
            label: 'Name',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'tokenCredit',
        label: 'Token Credit',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'tokenCustom',
        label: 'Token Custom',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'vulnerable',
        label: 'Vulnerable',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 3,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'wis',
        label: 'Wis',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
    ],
  ),
  'race': CompendiumEditorDescriptor(
    entityType: 'race',
    collectionKey: 'raceList',
    label: 'Races',
    fields: [
      CompendiumFieldDescriptor(
        key: '_copy',
        label: 'Copy',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: '_mod',
            label: 'Mod',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: 'entries',
                label: 'Entries',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'items',
                      label: 'Items',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'entries',
                          label: 'Entries',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 3,
                          ),
                          sampleCount: 3,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.string,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.string,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'mode',
                      label: 'Mode',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'replace',
                      label: 'Replace',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
                sampleCount: 1,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'name',
            label: 'Name',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: '_versions',
        label: 'Versions',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: '_abstract',
              label: 'Abstract',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '_mod',
                  label: 'Mod',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'entries',
                      label: 'Entries',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.object,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                          CompendiumFieldDescriptor(
                            key: 'items',
                            label: 'Items',
                            kind: CompendiumFieldKind.object,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 8,
                          ),
                          CompendiumFieldDescriptor(
                            key: 'mode',
                            label: 'Mode',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 12,
                          ),
                          CompendiumFieldDescriptor(
                            key: 'names',
                            label: 'Names',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 4,
                          ),
                          CompendiumFieldDescriptor(
                            key: 'replace',
                            label: 'Replace',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 8,
                          ),
                        ],
                        itemDescriptor: null,
                        sampleCount: 12,
                      ),
                      sampleCount: 4,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 4,
                ),
                CompendiumFieldDescriptor(
                  key: 'name',
                  label: 'Name',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 4,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: '_implementations',
              label: 'Implementations',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: '_variables',
                    label: 'Variables',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'color',
                        label: 'Color',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 25,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'damageType',
                        label: 'Damage Type',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 25,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'resist',
                        label: 'Resist',
                        kind: CompendiumFieldKind.list,
                        required: false,
                        nullable: true,
                        isArray: true,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor:                         CompendiumFieldDescriptor(
                          key: 'item',
                          label: 'Item',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 5,
                        ),
                        sampleCount: 5,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 25,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'resist',
                    label: 'Resist',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 20,
                    ),
                    sampleCount: 20,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 25,
              ),
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: '_mod',
              label: 'Mod',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'entries',
                  label: 'Entries',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'items',
                      label: 'Items',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'entries',
                          label: 'Entries',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 9,
                          ),
                          sampleCount: 6,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.string,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 6,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.string,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 6,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 6,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'mode',
                      label: 'Mode',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 6,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'replace',
                      label: 'Replace',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 5,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 6,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'darkvision',
              label: 'Darkvision',
              kind: CompendiumFieldKind.dynamic,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 0,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'skillProficiencies',
              label: 'Skill Proficiencies',
              kind: CompendiumFieldKind.dynamic,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 0,
            ),
            CompendiumFieldDescriptor(
              key: 'traitTags',
              label: 'Trait Tags',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 10,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'ability',
        label: 'Ability',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'cha',
              label: 'Cha',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'choose',
              label: 'Choose',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'amount',
                  label: 'Amount',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'count',
                  label: 'Count',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'from',
                  label: 'From',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 16,
                  ),
                  sampleCount: 3,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'dex',
              label: 'Dex',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'int',
              label: 'Int',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'str',
              label: 'Str',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'wis',
              label: 'Wis',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 14,
        ),
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'additionalSpells',
        label: 'Additional Spells',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ability',
              label: 'Ability',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'choose',
                  label: 'Choose',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 18,
                  ),
                  sampleCount: 6,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 9,
            ),
            CompendiumFieldDescriptor(
              key: 'innate',
              label: 'Innate',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '3',
                  label: '3',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'daily',
                      label: 'Daily',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 2,
                          ),
                          sampleCount: 2,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: '5',
                  label: '5',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'daily',
                      label: 'Daily',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 2,
                          ),
                          sampleCount: 2,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'known',
              label: 'Known',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '1',
                  label: '1',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                  sampleCount: 7,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 9,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'age',
        label: 'Age',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'mature',
            label: 'Mature',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 11,
          ),
          CompendiumFieldDescriptor(
            key: 'max',
            label: 'Max',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 14,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'conditionImmune',
        label: 'Condition Immune',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'creatureTypes',
        label: 'Creature Types',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 10,
        ),
        sampleCount: 10,
      ),
      CompendiumFieldDescriptor(
        key: 'creatureTypeTags',
        label: 'Creature Type Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 3,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'darkvision',
        label: 'Darkvision',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'caption',
                    label: 'Caption',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colLabels',
                    label: 'Col Labels',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 11,
                    ),
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colStyles',
                    label: 'Col Styles',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 11,
                    ),
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'items',
                    label: 'Items',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'entries',
                          label: 'Entries',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 7,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'entry',
                          label: 'Entry',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 10,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 10,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 12,
                    ),
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'rows',
                    label: 'Rows',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.dynamic,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 80,
                      ),
                      sampleCount: 35,
                    ),
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'style',
                    label: 'Style',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 10,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 206,
              ),
              sampleCount: 168,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 168,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 168,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 170,
        ),
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'feats',
        label: 'Feats',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'any',
              label: 'Any',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluff',
        label: 'Has Fluff',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 27,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 28,
      ),
      CompendiumFieldDescriptor(
        key: 'heightAndWeight',
        label: 'Height And Weight',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'baseHeight',
            label: 'Base Height',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 6,
          ),
          CompendiumFieldDescriptor(
            key: 'baseWeight',
            label: 'Base Weight',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 6,
          ),
          CompendiumFieldDescriptor(
            key: 'heightMod',
            label: 'Height Mod',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 6,
          ),
          CompendiumFieldDescriptor(
            key: 'weightMod',
            label: 'Weight Mod',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 6,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'languageProficiencies',
        label: 'Language Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'anyStandard',
              label: 'Any Standard',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'auran',
              label: 'Auran',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'celestial',
              label: 'Celestial',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'common',
              label: 'Common',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 12,
            ),
            CompendiumFieldDescriptor(
              key: 'draconic',
              label: 'Draconic',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'goblin',
              label: 'Goblin',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'other',
              label: 'Other',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'sylvan',
              label: 'Sylvan',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 14,
        ),
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'lineage',
        label: 'Lineage',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 16,
        ),
        sampleCount: 14,
      ),
      CompendiumFieldDescriptor(
        key: 'resist',
        label: 'Resist',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'choose',
              label: 'Choose',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'from',
                  label: 'From',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 24,
                  ),
                  sampleCount: 5,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 16,
        ),
        sampleCount: 12,
      ),
      CompendiumFieldDescriptor(
        key: 'size',
        label: 'Size',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 37,
        ),
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'sizeEntry',
        label: 'Size Entry',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'entries',
            label: 'Entries',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            sampleCount: 4,
          ),
          CompendiumFieldDescriptor(
            key: 'name',
            label: 'Name',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 4,
          ),
          CompendiumFieldDescriptor(
            key: 'type',
            label: 'Type',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 4,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'skillProficiencies',
        label: 'Skill Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'any',
              label: 'Any',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'choose',
              label: 'Choose',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'count',
                  label: 'Count',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: 'from',
                  label: 'From',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 21,
                  ),
                  sampleCount: 5,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'intimidation',
              label: 'Intimidation',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'perception',
              label: 'Perception',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'stealth',
              label: 'Stealth',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 12,
        ),
        sampleCount: 12,
      ),
      CompendiumFieldDescriptor(
        key: 'soundClip',
        label: 'Sound Clip',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'path',
            label: 'Path',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 19,
          ),
          CompendiumFieldDescriptor(
            key: 'type',
            label: 'Type',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 19,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 19,
      ),
      CompendiumFieldDescriptor(
        key: 'speed',
        label: 'Speed',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'climb',
            label: 'Climb',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'fly',
            label: 'Fly',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 5,
          ),
          CompendiumFieldDescriptor(
            key: 'swim',
            label: 'Swim',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'walk',
            label: 'Walk',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 8,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 30,
      ),
      CompendiumFieldDescriptor(
        key: 'toolProficiencies',
        label: 'Tool Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'any',
              label: 'Any',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'traitTags',
        label: 'Trait Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 23,
        ),
        sampleCount: 14,
      ),
    ],
  ),
  'reward': CompendiumEditorDescriptor(
    entityType: 'reward',
    collectionKey: 'rewardList',
    label: 'Rewards',
    fields: [
      CompendiumFieldDescriptor(
        key: 'additionalSpells',
        label: 'Additional Spells',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ability',
              label: 'Ability',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'innate',
              label: 'Innate',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '_',
                  label: '_',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'daily',
                      label: 'Daily',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1e',
                          label: '1e',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 3,
                          ),
                          sampleCount: 3,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'wis',
                          label: 'Wis',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 4,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'limited',
                      label: 'Limited',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 4,
                          ),
                          sampleCount: 2,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'rest',
                      label: 'Rest',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1e',
                          label: '1e',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 7,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 7,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 3,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 6,
              ),
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'id',
              label: 'Id',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entry',
                    label: 'Entry',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 2,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 40,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'tag',
              label: 'Tag',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'uid',
              label: 'Uid',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 11,
        ),
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'type',
        label: 'Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
    ],
  ),
  'sense': CompendiumEditorDescriptor(
    entityType: 'sense',
    collectionKey: 'senseList',
    label: 'Senses',
    fields: [
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.dynamic,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 5,
                    ),
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 5,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 10,
        ),
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 4,
        ),
        sampleCount: 4,
      ),
    ],
  ),
  'skill': CompendiumEditorDescriptor(
    entityType: 'skill',
    collectionKey: 'skillList',
    label: 'Skills',
    fields: [
      CompendiumFieldDescriptor(
        key: 'ability',
        label: 'Ability',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 3,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 34,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 16,
        ),
        sampleCount: 16,
      ),
    ],
  ),
  'spell': CompendiumEditorDescriptor(
    entityType: 'spell',
    collectionKey: 'spellList',
    label: 'Spells',
    fields: [
      CompendiumFieldDescriptor(
        key: 'activities',
        label: 'Activities',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'activation',
              label: 'Activation',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'condition',
                  label: 'Condition',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: 'type',
                  label: 'Type',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 51,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 51,
            ),
            CompendiumFieldDescriptor(
              key: 'attack',
              label: 'Attack',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'ability',
                  label: 'Ability',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: 'type',
                  label: 'Type',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'classification',
                      label: 'Classification',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'value',
                      label: 'Value',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'consumption',
              label: 'Consumption',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'targets',
                  label: 'Targets',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'scaling',
                        label: 'Scaling',
                        kind: CompendiumFieldKind.object,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                          CompendiumFieldDescriptor(
                            key: 'formula',
                            label: 'Formula',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 5,
                          ),
                          CompendiumFieldDescriptor(
                            key: 'mode',
                            label: 'Mode',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 5,
                          ),
                        ],
                        itemDescriptor: null,
                        sampleCount: 5,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'target',
                        label: 'Target',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 5,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'type',
                        label: 'Type',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 5,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'value',
                        label: 'Value',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 5,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  sampleCount: 5,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'damage',
              label: 'Damage',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'includeBase',
                  label: 'Include Base',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: 'onSave',
                  label: 'On Save',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 16,
                ),
                CompendiumFieldDescriptor(
                  key: 'parts',
                  label: 'Parts',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'bonus',
                        label: 'Bonus',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 4,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'custom',
                        label: 'Custom',
                        kind: CompendiumFieldKind.object,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                          CompendiumFieldDescriptor(
                            key: 'formula',
                            label: 'Formula',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'denomination',
                        label: 'Denomination',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 10,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'number',
                        label: 'Number',
                        kind: CompendiumFieldKind.integer,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 10,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'scaling',
                        label: 'Scaling',
                        kind: CompendiumFieldKind.object,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                          CompendiumFieldDescriptor(
                            key: 'formula',
                            label: 'Formula',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                          CompendiumFieldDescriptor(
                            key: 'mode',
                            label: 'Mode',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 3,
                          ),
                          CompendiumFieldDescriptor(
                            key: 'number',
                            label: 'Number',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 10,
                          ),
                        ],
                        itemDescriptor: null,
                        sampleCount: 11,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'types',
                        label: 'Types',
                        kind: CompendiumFieldKind.list,
                        required: false,
                        nullable: true,
                        isArray: true,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor:                         CompendiumFieldDescriptor(
                          key: 'item',
                          label: 'Item',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 11,
                        ),
                        sampleCount: 11,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 11,
                  ),
                  sampleCount: 11,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 21,
            ),
            CompendiumFieldDescriptor(
              key: 'duration',
              label: 'Duration',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'units',
                  label: 'Units',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'value',
                  label: 'Value',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'effects',
              label: 'Effects',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'foundryId',
                    label: 'Foundry Id',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 39,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 39,
              ),
              sampleCount: 27,
            ),
            CompendiumFieldDescriptor(
              key: 'healing',
              label: 'Healing',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'bonus',
                  label: 'Bonus',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 8,
                ),
                CompendiumFieldDescriptor(
                  key: 'custom',
                  label: 'Custom',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'enabled',
                      label: 'Enabled',
                      kind: CompendiumFieldKind.boolean,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'formula',
                      label: 'Formula',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 8,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 8,
                ),
                CompendiumFieldDescriptor(
                  key: 'denomination',
                  label: 'Denomination',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 7,
                ),
                CompendiumFieldDescriptor(
                  key: 'number',
                  label: 'Number',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 7,
                ),
                CompendiumFieldDescriptor(
                  key: 'scaling',
                  label: 'Scaling',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'formula',
                      label: 'Formula',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'mode',
                      label: 'Mode',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 7,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'number',
                      label: 'Number',
                      kind: CompendiumFieldKind.integer,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 6,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 8,
                ),
                CompendiumFieldDescriptor(
                  key: 'types',
                  label: 'Types',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 11,
                  ),
                  sampleCount: 11,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 11,
            ),
            CompendiumFieldDescriptor(
              key: 'img',
              label: 'Img',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'match',
              label: 'Match',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'attacks',
                  label: 'Attacks',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'proficiency',
                  label: 'Proficiency',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 33,
            ),
            CompendiumFieldDescriptor(
              key: 'profiles',
              label: 'Profiles',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'count',
                    label: 'Count',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'cr',
                    label: 'Cr',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'sizes',
                    label: 'Sizes',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 8,
                    ),
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'types',
                    label: 'Types',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'uuid',
                    label: 'Uuid',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 7,
              ),
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'range',
              label: 'Range',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'units',
                  label: 'Units',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 7,
                ),
                CompendiumFieldDescriptor(
                  key: 'value',
                  label: 'Value',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 6,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
            CompendiumFieldDescriptor(
              key: 'roll',
              label: 'Roll',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'formula',
                  label: 'Formula',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'name',
                  label: 'Name',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'visible',
                  label: 'Visible',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'save',
              label: 'Save',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'ability',
                  label: 'Ability',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 16,
                  ),
                  sampleCount: 16,
                ),
                CompendiumFieldDescriptor(
                  key: 'dc',
                  label: 'Dc',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'calculation',
                      label: 'Calculation',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 16,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 16,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 16,
            ),
            CompendiumFieldDescriptor(
              key: 'settings',
              label: 'Settings',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'effects',
                  label: 'Effects',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 6,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'keep',
                  label: 'Keep',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 8,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'preset',
                  label: 'Preset',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'tempFormula',
                  label: 'Temp Formula',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: 'transformTokens',
                  label: 'Transform Tokens',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'target',
              label: 'Target',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'affects',
                  label: 'Affects',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'count',
                      label: 'Count',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 6,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'special',
                      label: 'Special',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'type',
                      label: 'Type',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 8,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 8,
                ),
                CompendiumFieldDescriptor(
                  key: 'template',
                  label: 'Template',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'count',
                      label: 'Count',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'height',
                      label: 'Height',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'size',
                      label: 'Size',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 4,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'type',
                      label: 'Type',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 4,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'units',
                      label: 'Units',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 4,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'width',
                      label: 'Width',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 4,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 8,
            ),
            CompendiumFieldDescriptor(
              key: 'transform',
              label: 'Transform',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'customize',
                  label: 'Customize',
                  kind: CompendiumFieldKind.boolean,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'mode',
                  label: 'Mode',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 'preset',
                  label: 'Preset',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 52,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 52,
        ),
        sampleCount: 31,
      ),
      CompendiumFieldDescriptor(
        key: 'effects',
        label: 'Effects',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'changes',
              label: 'Changes',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'key',
                    label: 'Key',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 44,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'mode',
                    label: 'Mode',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 44,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'priority',
                    label: 'Priority',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'value',
                    label: 'Value',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 44,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 44,
              ),
              sampleCount: 27,
            ),
            CompendiumFieldDescriptor(
              key: 'description',
              label: 'Description',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 30,
            ),
            CompendiumFieldDescriptor(
              key: 'descriptionEntries',
              label: 'Description Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 5,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'disabled',
              label: 'Disabled',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'duration',
              label: 'Duration',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'rounds',
                  label: 'Rounds',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 14,
                ),
                CompendiumFieldDescriptor(
                  key: 'seconds',
                  label: 'Seconds',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 35,
                ),
                CompendiumFieldDescriptor(
                  key: 'turns',
                  label: 'Turns',
                  kind: CompendiumFieldKind.integer,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 42,
            ),
            CompendiumFieldDescriptor(
              key: 'foundryId',
              label: 'Foundry Id',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 37,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 39,
            ),
            CompendiumFieldDescriptor(
              key: 'statuses',
              label: 'Statuses',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 15,
              ),
              sampleCount: 15,
            ),
            CompendiumFieldDescriptor(
              key: 'transfer',
              label: 'Transfer',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 44,
        ),
        sampleCount: 21,
      ),
      CompendiumFieldDescriptor(
        key: 'migrationVersion',
        label: 'Migration Version',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'system',
        label: 'System',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'duration.value',
            label: 'Duration.value',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'target.affects.count',
            label: 'Target.affects.count',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 6,
          ),
          CompendiumFieldDescriptor(
            key: 'target.affects.type',
            label: 'Target.affects.type',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 8,
      ),
    ],
  ),
  'status': CompendiumEditorDescriptor(
    entityType: 'status',
    collectionKey: 'statusList',
    label: 'Statuses',
    fields: [
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 3,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 3,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 3,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 3,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 3,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 12,
        ),
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 2,
        ),
        sampleCount: 2,
      ),
    ],
  ),
  'subclass': CompendiumEditorDescriptor(
    entityType: 'subclass',
    collectionKey: 'subclassList',
    label: 'Subclasses',
    fields: [
      CompendiumFieldDescriptor(
        key: '_copy',
        label: 'Copy',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: '_preserve',
            label: 'Preserve',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: 'reprintedAs',
                label: 'Reprinted As',
                kind: CompendiumFieldKind.boolean,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 13,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 13,
          ),
          CompendiumFieldDescriptor(
            key: 'className',
            label: 'Class Name',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 13,
          ),
          CompendiumFieldDescriptor(
            key: 'name',
            label: 'Name',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 13,
          ),
          CompendiumFieldDescriptor(
            key: 'shortName',
            label: 'Short Name',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 13,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'additionalSpells',
        label: 'Additional Spells',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'innate',
              label: 'Innate',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '10',
                  label: '10',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'ritual',
                      label: 'Ritual',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 1,
                      ),
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: '15',
                  label: '15',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'daily',
                      label: 'Daily',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
                CompendiumFieldDescriptor(
                  key: '3',
                  label: '3',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'ritual',
                      label: 'Ritual',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 2,
                      ),
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: '9',
                  label: '9',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'daily',
                      label: 'Daily',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'int',
                          label: 'Int',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 1,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'prepared',
              label: 'Prepared',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '13',
                  label: '13',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 18,
                  ),
                  sampleCount: 9,
                ),
                CompendiumFieldDescriptor(
                  key: '17',
                  label: '17',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 18,
                  ),
                  sampleCount: 9,
                ),
                CompendiumFieldDescriptor(
                  key: '3',
                  label: '3',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 19,
                  ),
                  sampleCount: 9,
                ),
                CompendiumFieldDescriptor(
                  key: '5',
                  label: '5',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 18,
                  ),
                  sampleCount: 9,
                ),
                CompendiumFieldDescriptor(
                  key: '9',
                  label: '9',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 18,
                  ),
                  sampleCount: 9,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 9,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 13,
        ),
        sampleCount: 12,
      ),
      CompendiumFieldDescriptor(
        key: 'className',
        label: 'Class Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'fluff',
        label: 'Fluff',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: '_subclassFluff',
            label: 'Subclass Fluff',
            kind: CompendiumFieldKind.object,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: 'className',
                label: 'Class Name',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 5,
              ),
              CompendiumFieldDescriptor(
                key: 'name',
                label: 'Name',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 5,
              ),
              CompendiumFieldDescriptor(
                key: 'shortName',
                label: 'Short Name',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 5,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 5,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 5,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluff',
        label: 'Has Fluff',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 17,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 7,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'shortName',
        label: 'Short Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'spellcastingAbility',
        label: 'Spellcasting Ability',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'subclassFeatures',
        label: 'Subclass Features',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 76,
        ),
        sampleCount: 19,
      ),
    ],
  ),
  'subclassFeature': CompendiumEditorDescriptor(
    entityType: 'subclassFeature',
    collectionKey: 'subclassFeatureList',
    label: 'Subclass Features',
    fields: [
      CompendiumFieldDescriptor(
        key: 'className',
        label: 'Class Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'caption',
              label: 'Caption',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'colLabels',
              label: 'Col Labels',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 10,
              ),
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'colStyles',
              label: 'Col Styles',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 10,
              ),
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 40,
              ),
              sampleCount: 33,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 7,
                    ),
                    sampleCount: 7,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 7,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 33,
            ),
            CompendiumFieldDescriptor(
              key: 'rows',
              label: 'Rows',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 52,
                ),
                sampleCount: 26,
              ),
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'subclassFeature',
              label: 'Subclass Feature',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 17,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 58,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 101,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'header',
        label: 'Header',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'level',
        label: 'Level',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'subclassShortName',
        label: 'Subclass Short Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
    ],
  ),
  'subrace': CompendiumEditorDescriptor(
    entityType: 'subrace',
    collectionKey: 'subraceList',
    label: 'Subraces',
    fields: [
      CompendiumFieldDescriptor(
        key: '_versions',
        label: 'Versions',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: '_abstract',
              label: 'Abstract',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '_mod',
                  label: 'Mod',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'entries',
                      label: 'Entries',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.object,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                          CompendiumFieldDescriptor(
                            key: 'items',
                            label: 'Items',
                            kind: CompendiumFieldKind.object,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 4,
                          ),
                          CompendiumFieldDescriptor(
                            key: 'mode',
                            label: 'Mode',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 7,
                          ),
                          CompendiumFieldDescriptor(
                            key: 'names',
                            label: 'Names',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 3,
                          ),
                          CompendiumFieldDescriptor(
                            key: 'replace',
                            label: 'Replace',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 4,
                          ),
                        ],
                        itemDescriptor: null,
                        sampleCount: 7,
                      ),
                      sampleCount: 3,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
                CompendiumFieldDescriptor(
                  key: 'name',
                  label: 'Name',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 3,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: '_implementations',
              label: 'Implementations',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: '_variables',
                    label: 'Variables',
                    kind: CompendiumFieldKind.object,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                      CompendiumFieldDescriptor(
                        key: 'area',
                        label: 'Area',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 30,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'color',
                        label: 'Color',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 30,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'damageType',
                        label: 'Damage Type',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 30,
                      ),
                      CompendiumFieldDescriptor(
                        key: 'savingThrow',
                        label: 'Saving Throw',
                        kind: CompendiumFieldKind.string,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 30,
                      ),
                    ],
                    itemDescriptor: null,
                    sampleCount: 30,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'resist',
                    label: 'Resist',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 10,
                    ),
                    sampleCount: 10,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 30,
              ),
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 3,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'ability',
        label: 'Ability',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'cha',
              label: 'Cha',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'con',
              label: 'Con',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'dex',
              label: 'Dex',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'int',
              label: 'Int',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'str',
              label: 'Str',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'wis',
              label: 'Wis',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 27,
        ),
        sampleCount: 27,
      ),
      CompendiumFieldDescriptor(
        key: 'additionalSpells',
        label: 'Additional Spells',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ability',
              label: 'Ability',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'choose',
                  label: 'Choose',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 6,
                  ),
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 15,
            ),
            CompendiumFieldDescriptor(
              key: 'expanded',
              label: 'Expanded',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 's1',
                  label: 'S1',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 's2',
                  label: 'S2',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 's3',
                  label: 'S3',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 's4',
                  label: 'S4',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  sampleCount: 2,
                ),
                CompendiumFieldDescriptor(
                  key: 's5',
                  label: 'S5',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 2,
                  ),
                  sampleCount: 2,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'innate',
              label: 'Innate',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '3',
                  label: '3',
                  kind: CompendiumFieldKind.object,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'daily',
                      label: 'Daily',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 8,
                          ),
                          sampleCount: 8,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 8,
                    ),
                  ],
                  itemDescriptor: null,
                  sampleCount: 8,
                ),
                CompendiumFieldDescriptor(
                  key: '5',
                  label: '5',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: 'daily',
                      label: 'Daily',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 5,
                          ),
                          sampleCount: 5,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 5,
                    ),
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  sampleCount: 6,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 9,
            ),
            CompendiumFieldDescriptor(
              key: 'known',
              label: 'Known',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: '1',
                  label: '1',
                  kind: CompendiumFieldKind.list,
                  required: false,
                  nullable: true,
                  isArray: true,
                  choices: [
                  ],
                  fields: [
                    CompendiumFieldDescriptor(
                      key: '_',
                      label: '_',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.object,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                          CompendiumFieldDescriptor(
                            key: 'choose',
                            label: 'Choose',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 2,
                          ),
                        ],
                        itemDescriptor: null,
                        sampleCount: 2,
                      ),
                      sampleCount: 2,
                    ),
                    CompendiumFieldDescriptor(
                      key: 'rest',
                      label: 'Rest',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: '1',
                          label: '1',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 1,
                          ),
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 1,
                    ),
                  ],
                  itemDescriptor:                   CompendiumFieldDescriptor(
                    key: 'item',
                    label: 'Item',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 12,
                  ),
                  sampleCount: 14,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 14,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 15,
        ),
        sampleCount: 15,
      ),
      CompendiumFieldDescriptor(
        key: 'alias',
        label: 'Alias',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'armorProficiencies',
        label: 'Armor Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'light',
              label: 'Light',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'medium',
              label: 'Medium',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'darkvision',
        label: 'Darkvision',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'data',
              label: 'Data',
              kind: CompendiumFieldKind.object,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
                CompendiumFieldDescriptor(
                  key: 'overwrite',
                  label: 'Overwrite',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 11,
                ),
              ],
              itemDescriptor: null,
              sampleCount: 11,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'caption',
                    label: 'Caption',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colLabels',
                    label: 'Col Labels',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 10,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colStyles',
                    label: 'Col Styles',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 10,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'items',
                    label: 'Items',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'entry',
                          label: 'Entry',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 4,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 4,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 4,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 4,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'rows',
                    label: 'Rows',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.dynamic,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 80,
                      ),
                      sampleCount: 30,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'style',
                    label: 'Style',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 5,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 89,
              ),
              sampleCount: 73,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 73,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 73,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 74,
        ),
        sampleCount: 31,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluff',
        label: 'Has Fluff',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 29,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 26,
      ),
      CompendiumFieldDescriptor(
        key: 'heightAndWeight',
        label: 'Height And Weight',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'baseHeight',
            label: 'Base Height',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 9,
          ),
          CompendiumFieldDescriptor(
            key: 'baseWeight',
            label: 'Base Weight',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 9,
          ),
          CompendiumFieldDescriptor(
            key: 'heightMod',
            label: 'Height Mod',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 9,
          ),
          CompendiumFieldDescriptor(
            key: 'weightMod',
            label: 'Weight Mod',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 9,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 9,
      ),
      CompendiumFieldDescriptor(
        key: 'languageProficiencies',
        label: 'Language Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'anyStandard',
              label: 'Any Standard',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'aquan',
              label: 'Aquan',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'common',
              label: 'Common',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'dwarvish',
              label: 'Dwarvish',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'elvish',
              label: 'Elvish',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'undercommon',
              label: 'Undercommon',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 3,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 31,
      ),
      CompendiumFieldDescriptor(
        key: 'overwrite',
        label: 'Overwrite',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'ability',
            label: 'Ability',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'languageProficiencies',
            label: 'Language Proficiencies',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'traitTags',
            label: 'Trait Tags',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'raceName',
        label: 'Race Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'tag',
              label: 'Tag',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'uid',
              label: 'Uid',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 22,
        ),
        sampleCount: 19,
      ),
      CompendiumFieldDescriptor(
        key: 'resist',
        label: 'Resist',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 4,
        ),
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'skillProficiencies',
        label: 'Skill Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'perception',
              label: 'Perception',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'skillToolLanguageProficiencies',
        label: 'Skill Tool Language Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'choose',
              label: 'Choose',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'count',
                    label: 'Count',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'from',
                    label: 'From',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    sampleCount: 1,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'speed',
        label: 'Speed',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'swim',
            label: 'Swim',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'walk',
            label: 'Walk',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'traitTags',
        label: 'Trait Tags',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 12,
        ),
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'weaponProficiencies',
        label: 'Weapon Proficiencies',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'hand crossbow|phb',
              label: 'Hand Crossbow|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'light crossbow|phb',
              label: 'Light Crossbow|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'longbow|phb',
              label: 'Longbow|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'longsword|phb',
              label: 'Longsword|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'net|phb',
              label: 'Net|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'rapier|phb',
              label: 'Rapier|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'shortbow|phb',
              label: 'Shortbow|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 5,
            ),
            CompendiumFieldDescriptor(
              key: 'shortsword|phb',
              label: 'Shortsword|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'spear|phb',
              label: 'Spear|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'trident|phb',
              label: 'Trident|phb',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 7,
        ),
        sampleCount: 7,
      ),
    ],
  ),
  'trap': CompendiumEditorDescriptor(
    entityType: 'trap',
    collectionKey: 'trapList',
    label: 'Traps',
    fields: [
      CompendiumFieldDescriptor(
        key: 'countermeasures',
        label: 'Countermeasures',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entry',
                    label: 'Entry',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 15,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 15,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 15,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 15,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 16,
        ),
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'duration',
        label: 'Duration',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'condition',
              label: 'Condition',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 7,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'eActive',
        label: 'E Active',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.dynamic,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.dynamic,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'caption',
                          label: 'Caption',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'colLabels',
                          label: 'Col Labels',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 1,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'colStyles',
                          label: 'Col Styles',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 1,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'rows',
                          label: 'Rows',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 1,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 1,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 2,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'entry',
                    label: 'Entry',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 8,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 8,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 8,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 6,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'eConstant',
        label: 'E Constant',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.dynamic,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entry',
                    label: 'Entry',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 4,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 4,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'eDynamic',
        label: 'E Dynamic',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.dynamic,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entry',
                    label: 'Entry',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 6,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 6,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 6,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 6,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 6,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'effect',
        label: 'Effect',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 10,
        ),
        sampleCount: 10,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'colLabels',
                    label: 'Col Labels',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 12,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'colStyles',
                    label: 'Col Styles',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 12,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'rows',
                    label: 'Rows',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.list,
                      required: false,
                      nullable: true,
                      isArray: true,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor:                       CompendiumFieldDescriptor(
                        key: 'item',
                        label: 'Item',
                        kind: CompendiumFieldKind.dynamic,
                        required: false,
                        nullable: true,
                        isArray: false,
                        choices: [
                        ],
                        fields: [
                        ],
                        itemDescriptor: null,
                        sampleCount: 36,
                      ),
                      sampleCount: 12,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 39,
              ),
              sampleCount: 28,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 27,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 28,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 89,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'hauntBonus',
        label: 'Haunt Bonus',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'initiative',
        label: 'Initiative',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'rating',
        label: 'Rating',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'threat',
              label: 'Threat',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 22,
            ),
            CompendiumFieldDescriptor(
              key: 'tier',
              label: 'Tier',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 22,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 22,
        ),
        sampleCount: 21,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 8,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'trapHazType',
        label: 'Trap Haz Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'trigger',
        label: 'Trigger',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 20,
        ),
        sampleCount: 20,
      ),
    ],
  ),
  'variantrule': CompendiumEditorDescriptor(
    entityType: 'variantrule',
    collectionKey: 'variantruleList',
    label: 'Variant Rules',
    fields: [
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'caption',
              label: 'Caption',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'colLabels',
              label: 'Col Labels',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 10,
              ),
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'colStyles',
              label: 'Col Styles',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 10,
              ),
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'columns',
              label: 'Columns',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 7,
                    ),
                    sampleCount: 7,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 7,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 17,
              ),
              sampleCount: 10,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 30,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 6,
            ),
            CompendiumFieldDescriptor(
              key: 'rows',
              label: 'Rows',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 49,
                ),
                sampleCount: 20,
              ),
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 17,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 63,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'ruleType',
        label: 'Rule Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'type',
        label: 'Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
    ],
  ),
  'vehicle': CompendiumEditorDescriptor(
    entityType: 'vehicle',
    collectionKey: 'vehicleList',
    label: 'Vehicles',
    fields: [
      CompendiumFieldDescriptor(
        key: 'ac',
        label: 'Ac',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ac',
              label: 'Ac',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'from',
              label: 'From',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'action',
        label: 'Action',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 3,
              ),
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'items',
              label: 'Items',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entry',
                    label: 'Entry',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 16,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 16,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 16,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 16,
              ),
              sampleCount: 7,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 3,
            ),
            CompendiumFieldDescriptor(
              key: 'style',
              label: 'Style',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 17,
        ),
        sampleCount: 8,
      ),
      CompendiumFieldDescriptor(
        key: 'actionStation',
        label: 'Action Station',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 8,
              ),
              sampleCount: 8,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 8,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 8,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'actionThresholds',
        label: 'Action Thresholds',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: '0',
            label: '0',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 7,
          ),
          CompendiumFieldDescriptor(
            key: '1',
            label: '1',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 7,
          ),
          CompendiumFieldDescriptor(
            key: '2',
            label: '2',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 4,
          ),
          CompendiumFieldDescriptor(
            key: '3',
            label: '3',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'capCargo',
        label: 'Cap Cargo',
        kind: CompendiumFieldKind.number,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 26,
      ),
      CompendiumFieldDescriptor(
        key: 'capCreature',
        label: 'Cap Creature',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'capCrew',
        label: 'Cap Crew',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 28,
      ),
      CompendiumFieldDescriptor(
        key: 'capCrewNote',
        label: 'Cap Crew Note',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'capPassenger',
        label: 'Cap Passenger',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 15,
      ),
      CompendiumFieldDescriptor(
        key: 'cha',
        label: 'Cha',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'con',
        label: 'Con',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'conditionImmune',
        label: 'Condition Immune',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 120,
        ),
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'control',
        label: 'Control',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ac',
              label: 'Ac',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 7,
              ),
              sampleCount: 7,
            ),
            CompendiumFieldDescriptor(
              key: 'hp',
              label: 'Hp',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 7,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 7,
        ),
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'cost',
        label: 'Cost',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 16,
      ),
      CompendiumFieldDescriptor(
        key: 'dex',
        label: 'Dex',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'dimensions',
        label: 'Dimensions',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 46,
        ),
        sampleCount: 23,
      ),
      CompendiumFieldDescriptor(
        key: 'entries',
        label: 'Entries',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.dynamic,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'caption',
              label: 'Caption',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'colLabels',
              label: 'Col Labels',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 6,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'colStyles',
              label: 'Col Styles',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 6,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'rows',
              label: 'Rows',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.list,
                required: false,
                nullable: true,
                isArray: true,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor:                 CompendiumFieldDescriptor(
                  key: 'item',
                  label: 'Item',
                  kind: CompendiumFieldKind.string,
                  required: false,
                  nullable: true,
                  isArray: false,
                  choices: [
                  ],
                  fields: [
                  ],
                  itemDescriptor: null,
                  sampleCount: 60,
                ),
                sampleCount: 20,
              ),
              sampleCount: 2,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 2,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 10,
        ),
        sampleCount: 2,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluff',
        label: 'Has Fluff',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 29,
      ),
      CompendiumFieldDescriptor(
        key: 'hasFluffImages',
        label: 'Has Fluff Images',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 26,
      ),
      CompendiumFieldDescriptor(
        key: 'hasToken',
        label: 'Has Token',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'hp',
        label: 'Hp',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'average',
            label: 'Average',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'dt',
            label: 'Dt',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
          CompendiumFieldDescriptor(
            key: 'formula',
            label: 'Formula',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
          CompendiumFieldDescriptor(
            key: 'hp',
            label: 'Hp',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
          CompendiumFieldDescriptor(
            key: 'mt',
            label: 'Mt',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 6,
      ),
      CompendiumFieldDescriptor(
        key: 'hull',
        label: 'Hull',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'ac',
            label: 'Ac',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 23,
          ),
          CompendiumFieldDescriptor(
            key: 'acFrom',
            label: 'Ac From',
            kind: CompendiumFieldKind.list,
            required: false,
            nullable: true,
            isArray: true,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor:             CompendiumFieldDescriptor(
              key: 'item',
              label: 'Item',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 13,
            ),
            sampleCount: 13,
          ),
          CompendiumFieldDescriptor(
            key: 'dt',
            label: 'Dt',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 22,
          ),
          CompendiumFieldDescriptor(
            key: 'hp',
            label: 'Hp',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 23,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 23,
      ),
      CompendiumFieldDescriptor(
        key: 'immune',
        label: 'Immune',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 29,
        ),
        sampleCount: 13,
      ),
      CompendiumFieldDescriptor(
        key: 'int',
        label: 'Int',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'movement',
        label: 'Movement',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ac',
              label: 'Ac',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 10,
            ),
            CompendiumFieldDescriptor(
              key: 'hp',
              label: 'Hp',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 10,
            ),
            CompendiumFieldDescriptor(
              key: 'hpNote',
              label: 'Hp Note',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 9,
            ),
            CompendiumFieldDescriptor(
              key: 'isControl',
              label: 'Is Control',
              kind: CompendiumFieldKind.boolean,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 10,
            ),
            CompendiumFieldDescriptor(
              key: 'speed',
              label: 'Speed',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 11,
                    ),
                    sampleCount: 10,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'mode',
                    label: 'Mode',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 10,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 10,
              ),
              sampleCount: 10,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 10,
        ),
        sampleCount: 7,
      ),
      CompendiumFieldDescriptor(
        key: 'name',
        label: 'Name',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'pace',
        label: 'Pace',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'fly',
            label: 'Fly',
            kind: CompendiumFieldKind.dynamic,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 16,
          ),
          CompendiumFieldDescriptor(
            key: 'walk',
            label: 'Walk',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 1,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 26,
      ),
      CompendiumFieldDescriptor(
        key: 'reaction',
        label: 'Reaction',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 1,
              ),
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'type',
              label: 'Type',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'reprintedAs',
        label: 'Reprinted As',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'size',
        label: 'Size',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 1,
        ),
        sampleCount: 16,
      ),
      CompendiumFieldDescriptor(
        key: 'speed',
        label: 'Speed',
        kind: CompendiumFieldKind.object,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
          CompendiumFieldDescriptor(
            key: 'canHover',
            label: 'Can Hover',
            kind: CompendiumFieldKind.boolean,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 3,
          ),
          CompendiumFieldDescriptor(
            key: 'fly',
            label: 'Fly',
            kind: CompendiumFieldKind.dynamic,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
              CompendiumFieldDescriptor(
                key: 'condition',
                label: 'Condition',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 3,
              ),
              CompendiumFieldDescriptor(
                key: 'number',
                label: 'Number',
                kind: CompendiumFieldKind.integer,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 3,
              ),
            ],
            itemDescriptor: null,
            sampleCount: 16,
          ),
          CompendiumFieldDescriptor(
            key: 'note',
            label: 'Note',
            kind: CompendiumFieldKind.string,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'swim',
            label: 'Swim',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 2,
          ),
          CompendiumFieldDescriptor(
            key: 'walk',
            label: 'Walk',
            kind: CompendiumFieldKind.integer,
            required: false,
            nullable: true,
            isArray: false,
            choices: [
            ],
            fields: [
            ],
            itemDescriptor: null,
            sampleCount: 4,
          ),
        ],
        itemDescriptor: null,
        sampleCount: 22,
      ),
      CompendiumFieldDescriptor(
        key: 'station',
        label: 'Station',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ac',
              label: 'Ac',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'action',
              label: 'Action',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 8,
                    ),
                    sampleCount: 8,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 8,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 8,
              ),
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'crew',
              label: 'Crew',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.dynamic,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'entries',
                          label: 'Entries',
                          kind: CompendiumFieldKind.list,
                          required: false,
                          nullable: true,
                          isArray: true,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor:                           CompendiumFieldDescriptor(
                            key: 'item',
                            label: 'Item',
                            kind: CompendiumFieldKind.dynamic,
                            required: false,
                            nullable: true,
                            isArray: false,
                            choices: [
                            ],
                            fields: [
                            ],
                            itemDescriptor: null,
                            sampleCount: 0,
                          ),
                          sampleCount: 4,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 4,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 4,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 4,
                    ),
                    sampleCount: 4,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 4,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 12,
              ),
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'hp',
              label: 'Hp',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 4,
            ),
            CompendiumFieldDescriptor(
              key: 'size',
              label: 'Size',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 4,
              ),
              sampleCount: 4,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 4,
        ),
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'str',
        label: 'Str',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 11,
      ),
      CompendiumFieldDescriptor(
        key: 'terrain',
        label: 'Terrain',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.string,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
          ],
          itemDescriptor: null,
          sampleCount: 44,
        ),
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'tokenCredit',
        label: 'Token Credit',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'tokenCustom',
        label: 'Token Custom',
        kind: CompendiumFieldKind.boolean,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'trait',
        label: 'Trait',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 10,
              ),
              sampleCount: 10,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 10,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 10,
        ),
        sampleCount: 4,
      ),
      CompendiumFieldDescriptor(
        key: 'type',
        label: 'Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 1,
      ),
      CompendiumFieldDescriptor(
        key: 'vehicleType',
        label: 'Vehicle Type',
        kind: CompendiumFieldKind.string,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 32,
      ),
      CompendiumFieldDescriptor(
        key: 'weapon',
        label: 'Weapon',
        kind: CompendiumFieldKind.list,
        required: false,
        nullable: true,
        isArray: true,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor:         CompendiumFieldDescriptor(
          key: 'item',
          label: 'Item',
          kind: CompendiumFieldKind.object,
          required: false,
          nullable: true,
          isArray: false,
          choices: [
          ],
          fields: [
            CompendiumFieldDescriptor(
              key: 'ac',
              label: 'Ac',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 35,
            ),
            CompendiumFieldDescriptor(
              key: 'action',
              label: 'Action',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'entries',
                    label: 'Entries',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.string,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                      ],
                      itemDescriptor: null,
                      sampleCount: 34,
                    ),
                    sampleCount: 34,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'name',
                    label: 'Name',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 34,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 34,
              ),
              sampleCount: 32,
            ),
            CompendiumFieldDescriptor(
              key: 'costs',
              label: 'Costs',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.object,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'cost',
                    label: 'Cost',
                    kind: CompendiumFieldKind.integer,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 36,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'note',
                    label: 'Note',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 52,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 52,
              ),
              sampleCount: 29,
            ),
            CompendiumFieldDescriptor(
              key: 'count',
              label: 'Count',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 18,
            ),
            CompendiumFieldDescriptor(
              key: 'crew',
              label: 'Crew',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 28,
            ),
            CompendiumFieldDescriptor(
              key: 'dt',
              label: 'Dt',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 1,
            ),
            CompendiumFieldDescriptor(
              key: 'entries',
              label: 'Entries',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                  CompendiumFieldDescriptor(
                    key: 'items',
                    label: 'Items',
                    kind: CompendiumFieldKind.list,
                    required: false,
                    nullable: true,
                    isArray: true,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor:                     CompendiumFieldDescriptor(
                      key: 'item',
                      label: 'Item',
                      kind: CompendiumFieldKind.object,
                      required: false,
                      nullable: true,
                      isArray: false,
                      choices: [
                      ],
                      fields: [
                        CompendiumFieldDescriptor(
                          key: 'entry',
                          label: 'Entry',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'name',
                          label: 'Name',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                        CompendiumFieldDescriptor(
                          key: 'type',
                          label: 'Type',
                          kind: CompendiumFieldKind.dynamic,
                          required: false,
                          nullable: true,
                          isArray: false,
                          choices: [
                          ],
                          fields: [
                          ],
                          itemDescriptor: null,
                          sampleCount: 3,
                        ),
                      ],
                      itemDescriptor: null,
                      sampleCount: 3,
                    ),
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'style',
                    label: 'Style',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                  CompendiumFieldDescriptor(
                    key: 'type',
                    label: 'Type',
                    kind: CompendiumFieldKind.string,
                    required: false,
                    nullable: true,
                    isArray: false,
                    choices: [
                    ],
                    fields: [
                    ],
                    itemDescriptor: null,
                    sampleCount: 1,
                  ),
                ],
                itemDescriptor: null,
                sampleCount: 47,
              ),
              sampleCount: 44,
            ),
            CompendiumFieldDescriptor(
              key: 'hp',
              label: 'Hp',
              kind: CompendiumFieldKind.integer,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 35,
            ),
            CompendiumFieldDescriptor(
              key: 'name',
              label: 'Name',
              kind: CompendiumFieldKind.string,
              required: false,
              nullable: true,
              isArray: false,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor: null,
              sampleCount: 44,
            ),
            CompendiumFieldDescriptor(
              key: 'size',
              label: 'Size',
              kind: CompendiumFieldKind.list,
              required: false,
              nullable: true,
              isArray: true,
              choices: [
              ],
              fields: [
              ],
              itemDescriptor:               CompendiumFieldDescriptor(
                key: 'item',
                label: 'Item',
                kind: CompendiumFieldKind.string,
                required: false,
                nullable: true,
                isArray: false,
                choices: [
                ],
                fields: [
                ],
                itemDescriptor: null,
                sampleCount: 3,
              ),
              sampleCount: 3,
            ),
          ],
          itemDescriptor: null,
          sampleCount: 44,
        ),
        sampleCount: 23,
      ),
      CompendiumFieldDescriptor(
        key: 'weight',
        label: 'Weight',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 3,
      ),
      CompendiumFieldDescriptor(
        key: 'wis',
        label: 'Wis',
        kind: CompendiumFieldKind.integer,
        required: false,
        nullable: true,
        isArray: false,
        choices: [
        ],
        fields: [
        ],
        itemDescriptor: null,
        sampleCount: 11,
      ),
    ],
  ),
};

CompendiumEditorDescriptor? editorDescriptorForType(String entityType) {
  return compendiumEditorDescriptors[entityType];
}
