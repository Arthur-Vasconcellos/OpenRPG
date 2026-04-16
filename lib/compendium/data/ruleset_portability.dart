import 'dart:typed_data';

import 'ruleset_portability_stub.dart'
    if (dart.library.io) 'ruleset_portability_native.dart'
    if (dart.library.html) 'ruleset_portability_web.dart'
    as impl;

class RulesetExportResult {
  final String locationDescription;

  const RulesetExportResult({required this.locationDescription});
}

Future<String?> loadLegacyRulesetJson(String sourceReference) =>
    impl.loadLegacyRulesetJson(sourceReference);

Future<Uint8List?> loadRulesetImportBytes(String sourceReference) =>
    impl.loadRulesetImportBytes(sourceReference);

Future<String> persistImportedRulesetJsonDocument({
  required String sourceReference,
  required String fileName,
}) => impl.persistImportedRulesetJsonDocument(
  sourceReference: sourceReference,
  fileName: fileName,
);

Future<RulesetExportResult> exportRulesetJsonDocument({
  required String fileName,
  required String jsonString,
}) =>
    impl.exportRulesetJsonDocument(fileName: fileName, jsonString: jsonString);
