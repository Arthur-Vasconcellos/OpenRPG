import 'dart:html' as html;
import 'dart:typed_data';

import 'ruleset_portability.dart';

Future<Uint8List?> loadRulesetImportBytes(String sourceReference) async => null;

Future<String> persistImportedRulesetJsonDocument({
  required String sourceReference,
  required String fileName,
}) {
  throw UnsupportedError('Ruleset import is not supported on the web.');
}

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
