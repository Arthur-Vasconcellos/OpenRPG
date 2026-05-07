import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:openrpg/characters/data/character_portability.dart';
import 'package:openrpg/compendium/data/compendium_browse_repository.dart';
import 'package:openrpg/compendium/data/compendium_database.dart';
import 'package:openrpg/compendium/data/compendium_database_provider.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';
import 'package:openrpg/compendium/data/ruleset_portability.dart';
import 'package:openrpg/models/character.dart';

class CharacterSummary {
  final String id;
  final String name;
  final String primaryRulesetId;
  final String? primaryRulesetName;
  final bool primaryRulesetMissing;
  final int unresolvedSelectionCount;
  final int totalLevel;
  final String classSummary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastOpenedAt;

  const CharacterSummary({
    required this.id,
    required this.name,
    required this.primaryRulesetId,
    required this.primaryRulesetName,
    required this.primaryRulesetMissing,
    required this.unresolvedSelectionCount,
    required this.totalLevel,
    required this.classSummary,
    required this.createdAt,
    required this.updatedAt,
    required this.lastOpenedAt,
  });
}

class CharacterRepository {
  final CompendiumDatabase _database;
  final CompendiumBrowseRepository _browseRepository;

  CharacterRepository({
    CompendiumDatabase? database,
    CompendiumBrowseRepository? browseRepository,
  }) : _database = database ?? sharedCompendiumDatabase,
       _browseRepository =
           browseRepository ??
           CompendiumBrowseRepository(
             database: database ?? sharedCompendiumDatabase,
           );

  Stream<List<CharacterSummary>> watchCharacters() {
    final query = _database.select(_database.characterRecords)
      ..orderBy([
        (tbl) => drift.OrderingTerm.desc(tbl.lastOpenedAt),
        (tbl) => drift.OrderingTerm.desc(tbl.updatedAt),
      ]);
    return query.watch().asyncMap(_mapSummaries);
  }

  Future<List<CharacterSummary>> loadCharacters() async {
    final query = _database.select(_database.characterRecords)
      ..orderBy([
        (tbl) => drift.OrderingTerm.desc(tbl.lastOpenedAt),
        (tbl) => drift.OrderingTerm.desc(tbl.updatedAt),
      ]);
    final rows = await query.get();
    return _mapSummaries(rows);
  }

  Future<CharacterSummary> createCharacter({
    required String name,
    required String primaryRulesetId,
    String playerName = '',
    Map<String, dynamic> creationExtraData = const <String, dynamic>{},
  }) async {
    final timestamp = DateTime.now().toUtc();
    final characterId = 'character:${timestamp.microsecondsSinceEpoch}';
    var character = Character.createBlank(
      id: characterId,
      name: name.trim().isEmpty ? 'New Character' : name.trim(),
      primaryRulesetId: primaryRulesetId,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
    if (playerName.trim().isNotEmpty || creationExtraData.isNotEmpty) {
      character = character.copyWith(
        playerName: playerName.trim(),
        extraData: creationExtraData.isEmpty
            ? const <String, dynamic>{}
            : <String, dynamic>{
                'creation': Map<String, dynamic>.from(creationExtraData),
              },
      );
    }

    await _upsertCharacterRecord(character, lastOpenedAt: null);

    return _summaryForCharacter(
      character,
      await _loadRulesetNames(),
      lastOpenedAt: null,
    );
  }

  Future<Character> loadCharacter(String characterId) async {
    final row = await (_database.select(
      _database.characterRecords,
    )..where((tbl) => tbl.characterId.equals(characterId))).getSingleOrNull();
    if (row == null) {
      throw StateError('Character $characterId was not found.');
    }

    final character = Character.fromJson(
      jsonDecode(row.payloadJson) as Map<String, dynamic>,
    );
    return character.copyWith(
      name: row.name,
      primaryRulesetId: row.primaryRulesetId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<void> saveCharacter(Character character) async {
    final existing = await _loadCharacterRecord(character.id);
    final updatedCharacter = character.copyWith(
      updatedAt: DateTime.now().toUtc(),
    );
    await _upsertCharacterRecord(
      updatedCharacter,
      lastOpenedAt: existing?.lastOpenedAt,
    );
  }

  Future<void> markOpened(String characterId) async {
    final openedAt = DateTime.now().toUtc();
    await (_database.update(_database.characterRecords)
          ..where((tbl) => tbl.characterId.equals(characterId)))
        .write(CharacterRecordsCompanion(lastOpenedAt: drift.Value(openedAt)));
  }

  Future<void> renameCharacter(String characterId, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw StateError('Character name cannot be empty.');
    }

    final character = await loadCharacter(characterId);
    await saveCharacter(character.copyWith(name: trimmed));
  }

  Future<CharacterSummary> duplicateCharacter(String characterId) async {
    final character = await loadCharacter(characterId);
    final duplicated = character.copyWith(
      id: 'character:${DateTime.now().toUtc().microsecondsSinceEpoch}',
      name: '${character.name} Copy',
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    await _upsertCharacterRecord(duplicated, lastOpenedAt: null);

    return _summaryForCharacter(
      duplicated,
      await _loadRulesetNames(),
      lastOpenedAt: null,
    );
  }

  Future<void> deleteCharacter(String characterId) async {
    await (_database.delete(
      _database.characterRecords,
    )..where((tbl) => tbl.characterId.equals(characterId))).go();
  }

  Future<CharacterSummary> importCharacterFromPicker() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: kIsWeb,
    );
    if (picked == null || picked.files.isEmpty) {
      throw StateError('Character import was cancelled.');
    }

    final file = picked.files.single;
    if (file.bytes != null && file.bytes!.isNotEmpty) {
      return importCharacterJson(utf8.decode(file.bytes!), fileName: file.name);
    }

    final sourcePath = file.path?.trim();
    if (sourcePath == null || sourcePath.isEmpty) {
      throw StateError('Unable to read the selected character file.');
    }

    final bytes = await loadRulesetImportBytes(sourcePath);
    if (bytes == null || bytes.isEmpty) {
      throw StateError('Unable to read the selected character file.');
    }

    return importCharacterJson(utf8.decode(bytes), fileName: file.name);
  }

  Future<CharacterSummary> importCharacterJson(
    String jsonString, {
    String? fileName,
  }) async {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw StateError('Character import must be a JSON object.');
    }

    final imported = Character.fromJson(decoded).copyWith(
      id: 'character:${DateTime.now().toUtc().microsecondsSinceEpoch}',
      name: Character.importedName(
        decodedName: decoded['name']?.toString(),
        fileName: fileName,
      ),
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    await _upsertCharacterRecord(imported, lastOpenedAt: null);

    return _summaryForCharacter(
      imported,
      await _loadRulesetNames(),
      lastOpenedAt: null,
    );
  }

  Future<String> exportCharacterJson(String characterId) async {
    final character = await loadCharacter(characterId);
    return const JsonEncoder.withIndent('  ').convert(character.toJson());
  }

  Future<CharacterExportResult> exportCharacterFile(String characterId) async {
    final character = await loadCharacter(characterId);
    return exportCharacterJsonDocument(
      fileName: '${_safeFileName(character.name)}.character.json',
      jsonString: const JsonEncoder.withIndent(
        '  ',
      ).convert(character.toJson()),
    );
  }

  Future<List<RulesetSummary>> loadInstalledRulesets() {
    return _browseRepository.loadInstalledRulesets();
  }

  Future<Map<String, String>> _loadRulesetNames() async {
    final rulesets = await _browseRepository.loadInstalledRulesets();
    return {for (final ruleset in rulesets) ruleset.id: ruleset.name};
  }

  Future<CharacterRecord?> _loadCharacterRecord(String characterId) {
    return (_database.select(
      _database.characterRecords,
    )..where((tbl) => tbl.characterId.equals(characterId))).getSingleOrNull();
  }

  Future<void> _upsertCharacterRecord(
    Character character, {
    required DateTime? lastOpenedAt,
  }) {
    return _database
        .into(_database.characterRecords)
        .insertOnConflictUpdate(
          CharacterRecordsCompanion.insert(
            characterId: character.id,
            name: character.name,
            primaryRulesetId: drift.Value(character.primaryRulesetId),
            payloadJson: jsonEncode(character.toJson()),
            createdAt: character.createdAt,
            updatedAt: character.updatedAt,
            lastOpenedAt: drift.Value(lastOpenedAt),
          ),
        );
  }

  Future<List<CharacterSummary>> _mapSummaries(
    List<CharacterRecord> rows,
  ) async {
    final rulesetNames = await _loadRulesetNames();
    return rows
        .map((row) {
          final character = Character.fromJson(
            jsonDecode(row.payloadJson) as Map<String, dynamic>,
          );
          return CharacterSummary(
            id: row.characterId,
            name: row.name,
            primaryRulesetId: row.primaryRulesetId,
            primaryRulesetName: rulesetNames[row.primaryRulesetId],
            primaryRulesetMissing:
                row.primaryRulesetId.trim().isNotEmpty &&
                !rulesetNames.containsKey(row.primaryRulesetId),
            unresolvedSelectionCount: _countUnresolvedSelections(
              character,
              rulesetNames: rulesetNames,
            ),
            totalLevel: character.totalLevel,
            classSummary: character.classes.isEmpty
                ? 'No classes'
                : character.classes
                      .map((entry) => '${entry.className} ${entry.level}')
                      .join(' / '),
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
            lastOpenedAt: row.lastOpenedAt,
          );
        })
        .toList(growable: false);
  }

  CharacterSummary _summaryForCharacter(
    Character character,
    Map<String, String> rulesetNames, {
    DateTime? lastOpenedAt,
  }) {
    final primaryRulesetName = rulesetNames[character.primaryRulesetId];
    return CharacterSummary(
      id: character.id,
      name: character.name,
      primaryRulesetId: character.primaryRulesetId,
      primaryRulesetName: primaryRulesetName,
      primaryRulesetMissing:
          character.primaryRulesetId.trim().isNotEmpty &&
          primaryRulesetName == null,
      unresolvedSelectionCount: _countUnresolvedSelections(
        character,
        rulesetNames: rulesetNames,
      ),
      totalLevel: character.totalLevel,
      classSummary: character.classes.isEmpty
          ? 'No classes'
          : character.classes
                .map((entry) => '${entry.className} ${entry.level}')
                .join(' / '),
      createdAt: character.createdAt,
      updatedAt: character.updatedAt,
      lastOpenedAt: lastOpenedAt,
    );
  }

  static String _safeFileName(String value) {
    final sanitized = value
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]+'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
    return sanitized.isEmpty ? 'character' : sanitized;
  }

  static int _countUnresolvedSelections(
    Character character, {
    required Map<String, String> rulesetNames,
  }) {
    var count = 0;
    if (character.primaryRulesetId.trim().isNotEmpty &&
        !rulesetNames.containsKey(character.primaryRulesetId)) {
      count++;
    }
    final raceRef = character.raceRef;
    if (raceRef != null && !raceRef.isResolved) {
      count++;
    }
    final backgroundRef = character.backgroundRef;
    if (backgroundRef != null && !backgroundRef.isResolved) {
      count++;
    }
    for (final entry in character.classes) {
      final classRef = entry.classRef;
      if (classRef != null && !classRef.isResolved) {
        count++;
      }
      final subclassRef = entry.subclassRef;
      if (subclassRef != null && !subclassRef.isResolved) {
        count++;
      }
    }
    final spellcasting = character.spellcasting;
    if (spellcasting != null) {
      for (final spell in spellcasting.allSpells) {
        final reference = spell.reference;
        if (reference != null && !reference.isResolved) {
          count++;
        }
      }
    }
    for (final entry in character.equipment.entries) {
      final reference = entry.reference;
      if (reference != null && !reference.isResolved) {
        count++;
      }
    }
    final deityRef = character.physicalDescription.deityRef;
    if (deityRef != null && !deityRef.isResolved) {
      count++;
    }
    return count;
  }
}
