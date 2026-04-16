import 'dart:typed_data';

import 'ruleset_portability.dart';

Future<String?> loadLegacyRulesetJson(String sourceReference) async => null;

Future<Uint8List?> loadRulesetImportBytes(String sourceReference) async => null;

Future<String> persistImportedRulesetJsonDocument({
  required String sourceReference,
  required String fileName,
}) {
  throw UnsupportedError('Ruleset import is not supported on this platform.');
}

Future<RulesetExportResult> exportRulesetJsonDocument({
  required String fileName,
  required String jsonString,
}) {
  throw UnsupportedError('Ruleset export is not supported on this platform.');
}
