import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/models/compendium_link.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';

enum CompendiumValidationIssueKind {
  duplicateId,
  unresolvedReference,
  malformedNarrativeToken,
}

class CompendiumDetectedReference {
  final CompendiumLinkCandidate candidate;
  final String path;

  const CompendiumDetectedReference({
    required this.candidate,
    required this.path,
  });

  String get fingerprint =>
      '$path|${candidate.tag}|${candidate.rawReference}|${candidate.targetEntityType ?? ''}';
}

class CompendiumValidationIssue {
  final CompendiumValidationIssueKind kind;
  final String message;
  final String path;
  final CompendiumLinkCandidate? candidate;

  const CompendiumValidationIssue({
    required this.kind,
    required this.message,
    required this.path,
    this.candidate,
  });
}

class CompendiumResolvedReference {
  final CompendiumDetectedReference detected;
  final CompendiumEntityPreview preview;

  const CompendiumResolvedReference({
    required this.detected,
    required this.preview,
  });
}

class CompendiumEntityValidationReport {
  final String entityType;
  final String entityId;
  final String displayName;
  final List<CompendiumDetectedReference> detectedReferences;
  final List<CompendiumResolvedReference> resolvedReferences;
  final List<CompendiumValidationIssue> issues;

  const CompendiumEntityValidationReport({
    required this.entityType,
    required this.entityId,
    required this.displayName,
    required this.detectedReferences,
    required this.resolvedReferences,
    required this.issues,
  });

  bool get hasIssues => issues.isNotEmpty;

  int get unresolvedReferenceCount => issues
      .where(
        (issue) =>
            issue.kind == CompendiumValidationIssueKind.unresolvedReference,
      )
      .length;

  int get malformedTokenCount => issues
      .where(
        (issue) =>
            issue.kind == CompendiumValidationIssueKind.malformedNarrativeToken,
      )
      .length;
}

Future<CompendiumEntityValidationReport> validateCompendiumEntityData({
  required CompendiumBrowseRepository browseRepository,
  required String rulesetId,
  required String entityType,
  required String entityId,
  required String displayName,
  required Map<String, dynamic> data,
  Iterable<String> existingEntityIds = const <String>[],
  String? currentEntityId,
}) async {
  final issues = <CompendiumValidationIssue>[];
  final resolvedReferences = <CompendiumResolvedReference>[];
  final detectedReferences = extractCompendiumReferences(data);

  if (existingEntityIds.contains(entityId) && entityId != currentEntityId) {
    issues.add(
      CompendiumValidationIssue(
        kind: CompendiumValidationIssueKind.duplicateId,
        path: 'id',
        message:
            'Another $entityType already uses `$entityId`, so saving this draft would overwrite it.',
      ),
    );
  }

  final malformedTokens = findMalformedNarrativeTokens(data);
  issues.addAll(malformedTokens);

  for (final detected in detectedReferences) {
    final resolved = await browseRepository.resolveLink(
      detected.candidate,
      preferredRulesetId: rulesetId,
    );
    if (resolved == null) {
      issues.add(
        CompendiumValidationIssue(
          kind: CompendiumValidationIssueKind.unresolvedReference,
          path: detected.path,
          candidate: detected.candidate,
          message:
              'Unable to resolve `${detected.candidate.displayText}` from ${detected.path}.',
        ),
      );
      continue;
    }

    resolvedReferences.add(
      CompendiumResolvedReference(
        detected: detected,
        preview: resolved.preview,
      ),
    );
  }

  return CompendiumEntityValidationReport(
    entityType: entityType,
    entityId: entityId,
    displayName: displayName,
    detectedReferences: detectedReferences,
    resolvedReferences: resolvedReferences,
    issues: issues,
  );
}

List<CompendiumDetectedReference> extractCompendiumReferences(dynamic value) {
  final detected = <CompendiumDetectedReference>[];
  final seen = <String>{};

  void addDetected(CompendiumLinkCandidate candidate, String path) {
    final reference = CompendiumDetectedReference(
      candidate: candidate,
      path: path,
    );
    if (seen.add(reference.fingerprint)) {
      detected.add(reference);
    }
  }

  void visit(dynamic candidate, {required String path, String? currentKey}) {
    if (candidate is String) {
      for (final link in CompendiumLinkParser.extractAll(candidate)) {
        addDetected(link, path);
      }
      final plainReference = CompendiumLinkParser.tryParsePlainReference(
        candidate,
        hintedFieldKey: currentKey,
      );
      if (plainReference != null) {
        addDetected(plainReference, path);
      }
      return;
    }

    if (candidate is List) {
      for (var index = 0; index < candidate.length; index += 1) {
        visit(
          candidate[index],
          path: '$path[${index + 1}]',
          currentKey: currentKey,
        );
      }
      return;
    }

    if (candidate is Map) {
      final asMap = candidate.cast<String, dynamic>();
      final mappedReference = CompendiumLinkParser.extractReferenceFromMap(
        asMap,
      );
      if (mappedReference != null) {
        addDetected(mappedReference, path);
      }

      for (final entry in asMap.entries) {
        visit(entry.value, path: '$path.${entry.key}', currentKey: entry.key);
      }
    }
  }

  visit(value, path: 'data');
  return detected;
}

List<CompendiumValidationIssue> findMalformedNarrativeTokens(dynamic value) {
  final issues = <CompendiumValidationIssue>[];
  final malformedMarker = RegExp(r'\{@');

  void visit(dynamic candidate, {required String path}) {
    if (candidate is String) {
      final malformedCount = malformedMarker.allMatches(candidate).length;
      if (malformedCount > 0) {
        final resolvedCount = CompendiumLinkParser.extractAll(candidate).length;
        if (malformedCount > resolvedCount) {
          issues.add(
            CompendiumValidationIssue(
              kind: CompendiumValidationIssueKind.malformedNarrativeToken,
              path: path,
              message:
                  'Malformed inline reference tokens were found in $path. Use tokens like `{@spell Magic Missile|SRD}`.',
            ),
          );
        }
      }
      return;
    }

    if (candidate is List) {
      for (var index = 0; index < candidate.length; index += 1) {
        visit(candidate[index], path: '$path[${index + 1}]');
      }
      return;
    }

    if (candidate is Map) {
      final asMap = candidate.cast<String, dynamic>();
      for (final entry in asMap.entries) {
        visit(entry.value, path: '$path.${entry.key}');
      }
    }
  }

  visit(value, path: 'data');
  return issues;
}
