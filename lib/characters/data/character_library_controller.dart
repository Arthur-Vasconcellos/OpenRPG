import 'package:flutter/foundation.dart';
import 'package:openrpg/characters/data/character_portability.dart';
import 'package:openrpg/characters/data/character_repository.dart';
import 'package:openrpg/compendium/models/compendium_search.dart';

class CharacterLibraryController extends ChangeNotifier {
  final CharacterRepository _repository;

  bool _isBusy = false;
  String? _errorMessage;
  String? _statusMessage;

  CharacterLibraryController({CharacterRepository? repository})
    : _repository = repository ?? CharacterRepository();

  CharacterRepository get repository => _repository;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  String? get statusMessage => _statusMessage;

  Stream<List<CharacterSummary>> watchCharacters() {
    return _repository.watchCharacters();
  }

  Future<List<RulesetSummary>> loadInstalledRulesets() {
    return _repository.loadInstalledRulesets();
  }

  Future<CharacterSummary> createCharacter({
    required String name,
    required String primaryRulesetId,
  }) async {
    return _runBusy(
      'Creating character...',
      () => _repository.createCharacter(
        name: name,
        primaryRulesetId: primaryRulesetId,
      ),
    );
  }

  Future<CharacterSummary> duplicateCharacter(String characterId) async {
    return _runBusy(
      'Duplicating character...',
      () => _repository.duplicateCharacter(characterId),
    );
  }

  Future<void> renameCharacter(String characterId, String name) async {
    await _runBusy(
      'Renaming character...',
      () => _repository.renameCharacter(characterId, name),
    );
  }

  Future<void> deleteCharacter(String characterId) async {
    await _runBusy(
      'Deleting character...',
      () => _repository.deleteCharacter(characterId),
    );
  }

  Future<CharacterSummary> importCharacterFromPicker() async {
    return _runBusy(
      'Importing character...',
      _repository.importCharacterFromPicker,
    );
  }

  Future<CharacterExportResult> exportCharacter(String characterId) async {
    return _runBusy(
      'Exporting character...',
      () => _repository.exportCharacterFile(characterId),
    );
  }

  void clearMessage() {
    if (_errorMessage == null && _statusMessage == null) {
      return;
    }
    _errorMessage = null;
    _statusMessage = null;
    notifyListeners();
  }

  Future<T> _runBusy<T>(
    String statusMessage,
    Future<T> Function() action,
  ) async {
    _isBusy = true;
    _errorMessage = null;
    _statusMessage = statusMessage;
    notifyListeners();

    try {
      final result = await action();
      _isBusy = false;
      notifyListeners();
      return result;
    } catch (error) {
      _isBusy = false;
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }
}
