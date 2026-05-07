import 'package:openrpg/compendium/data/ruleset_portability.dart';

typedef CharacterExportResult = RulesetExportResult;

Future<CharacterExportResult> exportCharacterJsonDocument({
  required String fileName,
  required String jsonString,
}) => exportRulesetJsonDocument(fileName: fileName, jsonString: jsonString);
