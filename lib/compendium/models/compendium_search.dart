import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';

class RulesetSummary {
  final String id;
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

  const RulesetSummary({
    required this.id,
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
  });
}

class CompendiumCollectionPage {
  final String rulesetId;
  final String entityType;
  final List<CompendiumEntity> items;
  final List<String> availableSources;

  const CompendiumCollectionPage({
    required this.rulesetId,
    required this.entityType,
    required this.items,
    required this.availableSources,
  });
}

class CompendiumSearchQuery {
  final String text;
  final List<String> rulesetIds;
  final List<String> entityTypes;
  final String? source;
  final int limit;

  const CompendiumSearchQuery({
    this.text = '',
    this.rulesetIds = const [],
    this.entityTypes = const [],
    this.source,
    this.limit = 100,
  });
}

class CompendiumSearchResult {
  final String rulesetId;
  final CompendiumEntity entity;

  const CompendiumSearchResult({required this.rulesetId, required this.entity});
}

class CompendiumEntityDetail {
  final String rulesetId;
  final CompendiumEntity entity;
  final List<CompendiumLinkCandidate> outgoingLinks;

  const CompendiumEntityDetail({
    required this.rulesetId,
    required this.entity,
    required this.outgoingLinks,
  });
}
