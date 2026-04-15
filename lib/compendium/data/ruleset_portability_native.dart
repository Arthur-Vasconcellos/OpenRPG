import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'ruleset_portability.dart';

Future<String?> loadLegacyRulesetJson(String sourceReference) async {
  if (sourceReference.trim().isEmpty) {
    return null;
  }

  final file = File(sourceReference);
  if (!await file.exists()) {
    return null;
  }

  return file.readAsString();
}

Future<RulesetExportResult> exportRulesetJsonDocument({
  required String fileName,
  required String jsonString,
}) async {
  final root = await getApplicationSupportDirectory();
  final exportDirectory = Directory(p.join(root.path, 'exports'));
  await exportDirectory.create(recursive: true);

  final file = File(p.join(exportDirectory.path, fileName));
  await file.writeAsString(jsonString);

  return RulesetExportResult(locationDescription: file.path);
}
