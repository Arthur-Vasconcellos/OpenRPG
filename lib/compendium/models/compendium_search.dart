import 'package:openrpg/compendium/models/compendium_entity.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';

enum CompendiumBootstrapPhase { idle, running, ready, failed }

class CompendiumBootstrapStatus {
  final String rulesetId;
  final String assetVersion;
  final CompendiumBootstrapPhase phase;
  final double progress;
  final String? lastError;
  final DateTime? updatedAt;

  const CompendiumBootstrapStatus({
    required this.rulesetId,
    required this.assetVersion,
    required this.phase,
    required this.progress,
    required this.lastError,
    required this.updatedAt,
  });

  const CompendiumBootstrapStatus.idle({
    this.rulesetId = '',
    this.assetVersion = '',
    this.progress = 0,
    this.lastError,
    this.updatedAt,
  }) : phase = CompendiumBootstrapPhase.idle;

  bool get isRunning => phase == CompendiumBootstrapPhase.running;
  bool get isReady => phase == CompendiumBootstrapPhase.ready;
  bool get isFailed => phase == CompendiumBootstrapPhase.failed;
}

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

class RulesetCollectionSummary {
  final String rulesetId;
  final String entityType;
  final String collectionKey;
  final String label;
  final int entityCount;

  const RulesetCollectionSummary({
    required this.rulesetId,
    required this.entityType,
    required this.collectionKey,
    required this.label,
    required this.entityCount,
  });
}

class CompendiumEntityPreview {
  final String rulesetId;
  final String entityType;
  final String entityId;
  final String name;
  final String source;
  final String sourceFile;
  final String? edition;

  const CompendiumEntityPreview({
    required this.rulesetId,
    required this.entityType,
    required this.entityId,
    required this.name,
    required this.source,
    required this.sourceFile,
    required this.edition,
  });

  String get displayName => name.trim().isEmpty ? entityId : name.trim();
}

class CompendiumCollectionPage {
  final String rulesetId;
  final String entityType;
  final List<CompendiumEntityPreview> items;
  final List<String> availableSources;
  final List<String> availableEditions;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasMore;

  const CompendiumCollectionPage({
    required this.rulesetId,
    required this.entityType,
    required this.items,
    required this.availableSources,
    required this.availableEditions,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasMore,
  });
}

class CompendiumSearchFacets {
  final List<String> sources;
  final List<String> editions;

  const CompendiumSearchFacets({required this.sources, required this.editions});
}

class CompendiumSearchQuery {
  final String text;
  final List<String> rulesetIds;
  final List<String> entityTypes;
  final String? source;
  final String? edition;
  final int limit;

  const CompendiumSearchQuery({
    this.text = '',
    this.rulesetIds = const [],
    this.entityTypes = const [],
    this.source,
    this.edition,
    this.limit = 100,
  });
}

class CompendiumSearchResult {
  final CompendiumEntityPreview preview;

  const CompendiumSearchResult({required this.preview});
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
