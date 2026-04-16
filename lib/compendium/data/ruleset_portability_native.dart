import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

Future<Uint8List?> loadRulesetImportBytes(String sourceReference) async {
  if (sourceReference.trim().isEmpty) {
    return null;
  }

  final file = File(sourceReference);
  if (!await file.exists()) {
    return null;
  }

  return file.readAsBytes();
}

Future<String> persistImportedRulesetJsonDocument({
  required String sourceReference,
  required String fileName,
}) async {
  final trimmedSource = sourceReference.trim();
  if (trimmedSource.isEmpty) {
    throw StateError('The selected ruleset file does not have a readable path.');
  }

  final sourceFile = File(trimmedSource);
  if (!await sourceFile.exists()) {
    throw StateError('The selected ruleset file could not be found.');
  }

  final documentsDirectory = await getApplicationDocumentsDirectory();
  final importDirectory = Directory(
    p.join(documentsDirectory.path, 'rulesets', 'imports'),
  );
  await importDirectory.create(recursive: true);

  final destinationPath = p.join(importDirectory.path, fileName);
  final destinationFile = File(destinationPath);
  if (p.equals(sourceFile.path, destinationFile.path)) {
    return destinationFile.path;
  }

  if (await destinationFile.exists()) {
    await destinationFile.delete();
  }

  await sourceFile.copy(destinationPath);
  return destinationPath;
}

Future<RulesetExportResult> exportRulesetJsonDocument({
  required String fileName,
  required String jsonString,
}) async {
  final bytes = Uint8List.fromList(utf8.encode(jsonString));

  if (Platform.isAndroid || Platform.isIOS) {
    final temporaryDirectory = await getTemporaryDirectory();
    final file = File(p.join(temporaryDirectory.path, fileName));
    await file.writeAsString(jsonString);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: fileName,
        text: 'Exported ruleset JSON',
      ),
    );

    return const RulesetExportResult(
      locationDescription: 'the system share sheet',
    );
  }

  final outputPath = await FilePicker.platform.saveFile(
    dialogTitle: 'Export Ruleset JSON',
    fileName: fileName,
    type: FileType.custom,
    allowedExtensions: const ['json'],
    bytes: bytes,
  );
  if (outputPath == null || outputPath.trim().isEmpty) {
    throw StateError('Export was cancelled.');
  }

  return RulesetExportResult(locationDescription: outputPath);
}
