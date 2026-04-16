class CompendiumBrowseManifest {
  final String assetVersion;
  final List<CompendiumBrowseRulesetAsset> rulesets;

  const CompendiumBrowseManifest({
    required this.assetVersion,
    required this.rulesets,
  });

  factory CompendiumBrowseManifest.fromJson(Map<String, dynamic> json) {
    final rawRulesets = json['rulesets'];
    return CompendiumBrowseManifest(
      assetVersion: json['assetVersion']?.toString() ?? '',
      rulesets: rawRulesets is List
          ? rawRulesets
                .whereType<Map>()
                .map(
                  (entry) => CompendiumBrowseRulesetAsset.fromJson(
                    entry.cast<String, dynamic>(),
                  ),
                )
                .toList(growable: false)
          : const <CompendiumBrowseRulesetAsset>[],
    );
  }
}

class CompendiumBrowseRulesetAsset {
  final String rulesetId;
  final String name;
  final String description;
  final String mode;
  final String schemaVersion;
  final String author;
  final String version;
  final String license;
  final int entityCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String filePath;
  final List<CompendiumBrowseCollectionStatAsset> collectionStats;
  final List<CompendiumBrowseShardAsset> shards;

  const CompendiumBrowseRulesetAsset({
    required this.rulesetId,
    required this.name,
    required this.description,
    required this.mode,
    required this.schemaVersion,
    required this.author,
    required this.version,
    required this.license,
    required this.entityCount,
    required this.createdAt,
    required this.updatedAt,
    required this.filePath,
    required this.collectionStats,
    required this.shards,
  });

  factory CompendiumBrowseRulesetAsset.fromJson(Map<String, dynamic> json) {
    return CompendiumBrowseRulesetAsset(
      rulesetId: json['rulesetId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      mode: json['mode']?.toString() ?? 'bundled',
      schemaVersion: json['schemaVersion']?.toString() ?? '1.0.0',
      author: json['author']?.toString() ?? '',
      version: json['version']?.toString() ?? '1.0.0',
      license: json['license']?.toString() ?? '',
      entityCount: (json['entityCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      filePath: json['filePath']?.toString() ?? '',
      collectionStats: (json['collectionStats'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (entry) => CompendiumBrowseCollectionStatAsset.fromJson(
              entry.cast<String, dynamic>(),
            ),
          )
          .toList(growable: false),
      shards: (json['shards'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (entry) => CompendiumBrowseShardAsset.fromJson(
              entry.cast<String, dynamic>(),
            ),
          )
          .toList(growable: false),
    );
  }
}

class CompendiumBrowseCollectionStatAsset {
  final String entityType;
  final String collectionKey;
  final String label;
  final int entityCount;

  const CompendiumBrowseCollectionStatAsset({
    required this.entityType,
    required this.collectionKey,
    required this.label,
    required this.entityCount,
  });

  factory CompendiumBrowseCollectionStatAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    return CompendiumBrowseCollectionStatAsset(
      entityType: json['entityType']?.toString() ?? '',
      collectionKey: json['collectionKey']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      entityCount: (json['entityCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class CompendiumBrowseShardAsset {
  final String entityType;
  final String collectionKey;
  final String assetPath;
  final int entityCount;
  final int linkCount;

  const CompendiumBrowseShardAsset({
    required this.entityType,
    required this.collectionKey,
    required this.assetPath,
    required this.entityCount,
    required this.linkCount,
  });

  factory CompendiumBrowseShardAsset.fromJson(Map<String, dynamic> json) {
    return CompendiumBrowseShardAsset(
      entityType: json['entityType']?.toString() ?? '',
      collectionKey: json['collectionKey']?.toString() ?? '',
      assetPath: json['assetPath']?.toString() ?? '',
      entityCount: (json['entityCount'] as num?)?.toInt() ?? 0,
      linkCount: (json['linkCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class CompendiumBrowseShardPayload {
  final String rulesetId;
  final String entityType;
  final String collectionKey;
  final List<CompendiumBrowseEntityRowAsset> entityRows;
  final List<CompendiumBrowseLinkRowAsset> linkRows;

  const CompendiumBrowseShardPayload({
    required this.rulesetId,
    required this.entityType,
    required this.collectionKey,
    required this.entityRows,
    required this.linkRows,
  });

  factory CompendiumBrowseShardPayload.fromJson(Map<String, dynamic> json) {
    return CompendiumBrowseShardPayload(
      rulesetId: json['rulesetId']?.toString() ?? '',
      entityType: json['entityType']?.toString() ?? '',
      collectionKey: json['collectionKey']?.toString() ?? '',
      entityRows: (json['entityRows'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (entry) => CompendiumBrowseEntityRowAsset.fromJson(
              entry.cast<String, dynamic>(),
            ),
          )
          .toList(growable: false),
      linkRows: (json['linkRows'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (entry) => CompendiumBrowseLinkRowAsset.fromJson(
              entry.cast<String, dynamic>(),
            ),
          )
          .toList(growable: false),
    );
  }
}

class CompendiumBrowseEntityRowAsset {
  final String entityId;
  final String name;
  final String source;
  final String sourceFile;
  final String? edition;
  final String sortName;
  final String searchText;
  final String payloadJson;

  const CompendiumBrowseEntityRowAsset({
    required this.entityId,
    required this.name,
    required this.source,
    required this.sourceFile,
    required this.edition,
    required this.sortName,
    required this.searchText,
    required this.payloadJson,
  });

  factory CompendiumBrowseEntityRowAsset.fromJson(Map<String, dynamic> json) {
    return CompendiumBrowseEntityRowAsset(
      entityId: json['entityId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      sourceFile: json['sourceFile']?.toString() ?? '',
      edition: json['edition']?.toString(),
      sortName: json['sortName']?.toString() ?? '',
      searchText: json['searchText']?.toString() ?? '',
      payloadJson: json['payloadJson']?.toString() ?? '{}',
    );
  }
}

class CompendiumBrowseLinkRowAsset {
  final String sourceEntityType;
  final String sourceEntityId;
  final String targetTag;
  final String rawReference;
  final String displayText;
  final String? sourceHint;
  final String? targetEntityType;

  const CompendiumBrowseLinkRowAsset({
    required this.sourceEntityType,
    required this.sourceEntityId,
    required this.targetTag,
    required this.rawReference,
    required this.displayText,
    required this.sourceHint,
    required this.targetEntityType,
  });

  factory CompendiumBrowseLinkRowAsset.fromJson(Map<String, dynamic> json) {
    return CompendiumBrowseLinkRowAsset(
      sourceEntityType: json['sourceEntityType']?.toString() ?? '',
      sourceEntityId: json['sourceEntityId']?.toString() ?? '',
      targetTag: json['targetTag']?.toString() ?? '',
      rawReference: json['rawReference']?.toString() ?? '',
      displayText: json['displayText']?.toString() ?? '',
      sourceHint: json['sourceHint']?.toString(),
      targetEntityType: json['targetEntityType']?.toString(),
    );
  }
}
