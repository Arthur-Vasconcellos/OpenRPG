import 'ruleset_portability.dart';

Future<String?> loadLegacyRulesetJson(String sourceReference) async => null;

Future<RulesetExportResult> exportRulesetJsonDocument({
  required String fileName,
  required String jsonString,
}) {
  throw UnsupportedError('Ruleset export is not supported on this platform.');
}
