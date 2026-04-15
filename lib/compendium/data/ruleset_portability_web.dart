import 'dart:html' as html;

import 'ruleset_portability.dart';

Future<String?> loadLegacyRulesetJson(String sourceReference) async => null;

Future<RulesetExportResult> exportRulesetJsonDocument({
  required String fileName,
  required String jsonString,
}) async {
  final blob = html.Blob(<String>[jsonString], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = fileName
    ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);

  return RulesetExportResult(locationDescription: fileName);
}
