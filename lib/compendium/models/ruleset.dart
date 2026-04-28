import 'package:openrpg/compendium/generated/compendium_generated.dart';
import 'package:openrpg/compendium/models/compendium_entity.dart';

const String kCurrentRulesetSchemaVersion = '1.0.0';

enum RulesetMode {
  bundled,
  imported,
  editable;

  static RulesetMode fromValue(String value) {
    final normalized = value.trim();
    for (final mode in RulesetMode.values) {
      if (mode.name == normalized) {
        return mode;
      }
    }
    throw FormatException('Unsupported ruleset mode "$value".');
  }
}

class RulesetCollectionView {
  final CompendiumCollectionDefinition definition;
  final List<CompendiumEntity> entities;

  const RulesetCollectionView({
    required this.definition,
    required this.entities,
  });
}

class Ruleset {
  final String schemaVersion;
  final String id;
  final String name;
  final String description;
  final String author;
  final String version;
  final String license;
  final RulesetMode mode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, List<CompendiumEntity>> collections;
  final Map<String, dynamic> extra;
  final Map<String, List<Map<String, dynamic>>> extraCollections;

  const Ruleset({
    required this.schemaVersion,
    required this.id,
    required this.name,
    required this.description,
    required this.author,
    required this.version,
    required this.license,
    required this.mode,
    required this.createdAt,
    required this.updatedAt,
    required this.collections,
    this.extra = const {},
    this.extraCollections = const {},
  });

  factory Ruleset.createBlank({
    required String id,
    required String name,
    String description = '',
  }) {
    return Ruleset(
      schemaVersion: kCurrentRulesetSchemaVersion,
      id: id,
      name: name,
      description: description,
      author: '',
      version: '1.0.0',
      license: '',
      mode: RulesetMode.editable,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      collections: {
        for (final descriptor in compendiumEntityDescriptors)
          descriptor.collection.collectionKey: <CompendiumEntity>[],
      },
    );
  }

  factory Ruleset.fromJson(Map<String, dynamic> json) {
    final schemaVersion = json['schemaVersion']?.toString().trim() ?? '';
    if (schemaVersion != kCurrentRulesetSchemaVersion) {
      throw FormatException(
        'Unsupported ruleset schema version "$schemaVersion".',
      );
    }

    final knownTopLevelKeys = <String>{
      'schemaVersion',
      'id',
      'name',
      'description',
      'author',
      'version',
      'license',
      'mode',
      'createdAt',
      'updatedAt',
      ...compendiumEntityDescriptors.map(
        (descriptor) => descriptor.collection.collectionKey,
      ),
    };

    final collections = <String, List<CompendiumEntity>>{};
    for (final descriptor in compendiumEntityDescriptors) {
      final rawList = json[descriptor.collection.collectionKey];
      collections[descriptor.collection.collectionKey] = rawList is List
          ? rawList
                .map(
                  (item) =>
                      descriptor.fromJson(CompendiumJsonUtils.jsonMap(item)),
                )
                .toList()
          : <CompendiumEntity>[];
    }

    final extraCollections = <String, List<Map<String, dynamic>>>{};
    final extra = <String, dynamic>{};
    for (final entry in json.entries) {
      if (knownTopLevelKeys.contains(entry.key)) {
        continue;
      }

      if (entry.value is List) {
        extraCollections[entry.key] = CompendiumJsonUtils.listOfMaps(
          entry.value,
        );
      } else {
        extra[entry.key] = CompendiumJsonUtils.deepCopy(entry.value);
      }
    }

    return Ruleset(
      schemaVersion: schemaVersion,
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      version: json['version']?.toString() ?? '1.0.0',
      license: json['license']?.toString() ?? '',
      mode: RulesetMode.fromValue(json['mode']?.toString() ?? 'imported'),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      collections: collections,
      extra: extra,
      extraCollections: extraCollections,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'schemaVersion': schemaVersion,
      'id': id,
      'name': name,
      'description': description,
      'author': author,
      'version': version,
      'license': license,
      'mode': mode.name,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      ...CompendiumJsonUtils.deepCopyMap(extra),
    };

    for (final descriptor in compendiumEntityDescriptors) {
      final items =
          collections[descriptor.collection.collectionKey] ??
          const <CompendiumEntity>[];
      json[descriptor.collection.collectionKey] = items
          .map((entity) => entity.toJson())
          .toList(growable: false);
    }

    for (final entry in extraCollections.entries) {
      json[entry.key] = entry.value
          .map(CompendiumJsonUtils.deepCopyMap)
          .toList();
    }

    return json;
  }

  List<T> typedCollection<T extends CompendiumEntity>(String collectionKey) {
    return (collections[collectionKey] ?? const <CompendiumEntity>[])
        .whereType<T>()
        .toList(growable: false);
  }

  List<CompendiumEntity> entitiesForType(String entityType) {
    final descriptor = descriptorForType(entityType);
    if (descriptor == null) {
      return const <CompendiumEntity>[];
    }

    return List<CompendiumEntity>.from(
      collections[descriptor.collection.collectionKey] ??
          const <CompendiumEntity>[],
    );
  }

  Iterable<CompendiumEntity> get allEntities sync* {
    for (final descriptor in compendiumEntityDescriptors) {
      final items = collections[descriptor.collection.collectionKey];
      if (items == null) {
        continue;
      }

      for (final entity in items) {
        yield entity;
      }
    }
  }

  int get totalEntityCount => allEntities.length;

  List<RulesetCollectionView> get collectionViews {
    return compendiumEntityDescriptors
        .map((descriptor) {
          return RulesetCollectionView(
            definition: descriptor.collection,
            entities: List<CompendiumEntity>.from(
              collections[descriptor.collection.collectionKey] ??
                  const <CompendiumEntity>[],
            ),
          );
        })
        .toList(growable: false);
  }

  Ruleset copyWith({
    String? schemaVersion,
    String? id,
    String? name,
    String? description,
    String? author,
    String? version,
    String? license,
    RulesetMode? mode,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, List<CompendiumEntity>>? collections,
    Map<String, dynamic>? extra,
    Map<String, List<Map<String, dynamic>>>? extraCollections,
  }) {
    return Ruleset(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      author: author ?? this.author,
      version: version ?? this.version,
      license: license ?? this.license,
      mode: mode ?? this.mode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      collections: collections ?? _cloneCollections(this.collections),
      extra: extra ?? CompendiumJsonUtils.deepCopyMap(this.extra),
      extraCollections:
          extraCollections ?? _cloneExtraCollections(this.extraCollections),
    );
  }

  Ruleset upsertEntity(CompendiumEntity entity) {
    final nextCollections = _cloneCollections(collections);
    final items = List<CompendiumEntity>.from(
      nextCollections[entity.collectionKey] ?? const <CompendiumEntity>[],
    );

    final index = items.indexWhere((existing) => existing.id == entity.id);
    if (index >= 0) {
      items[index] = entity;
    } else {
      items.add(entity);
    }

    items.sort((left, right) {
      final nameCompare = CompendiumJsonUtils.sortName(
        left.displayName,
      ).compareTo(CompendiumJsonUtils.sortName(right.displayName));
      if (nameCompare != 0) {
        return nameCompare;
      }

      return left.id.compareTo(right.id);
    });

    nextCollections[entity.collectionKey] = items;
    return copyWith(collections: nextCollections, updatedAt: DateTime.now());
  }

  Ruleset removeEntity(String entityType, String entityId) {
    final descriptor = descriptorForType(entityType);
    if (descriptor == null) {
      return this;
    }

    final nextCollections = _cloneCollections(collections);
    nextCollections[descriptor.collection.collectionKey] =
        List<CompendiumEntity>.from(
          nextCollections[descriptor.collection.collectionKey] ??
              const <CompendiumEntity>[],
        )..removeWhere((entity) => entity.id == entityId);

    return copyWith(collections: nextCollections, updatedAt: DateTime.now());
  }

  static Map<String, List<CompendiumEntity>> _cloneCollections(
    Map<String, List<CompendiumEntity>> source,
  ) {
    return source.map((collectionKey, entities) {
      return MapEntry(collectionKey, List<CompendiumEntity>.from(entities));
    });
  }

  static Map<String, List<Map<String, dynamic>>> _cloneExtraCollections(
    Map<String, List<Map<String, dynamic>>> source,
  ) {
    return source.map((collectionKey, value) {
      return MapEntry(
        collectionKey,
        value.map(CompendiumJsonUtils.deepCopyMap).toList(),
      );
    });
  }
}
