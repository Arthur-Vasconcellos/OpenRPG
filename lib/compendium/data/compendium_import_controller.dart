import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:openrpg/compendium/data/compendium_repository.dart';
import 'package:openrpg/compendium/models/ruleset.dart';

enum CompendiumImportTaskStatus { idle, running, succeeded, failed }

@immutable
class CompendiumImportTask {
  final CompendiumImportTaskStatus status;
  final CompendiumImportPhase? phase;
  final double progress;
  final String statusMessage;
  final String? fileName;
  final String? rulesetId;
  final String? errorMessage;
  final int notificationToken;

  const CompendiumImportTask({
    required this.status,
    required this.phase,
    required this.progress,
    required this.statusMessage,
    required this.fileName,
    required this.rulesetId,
    required this.errorMessage,
    required this.notificationToken,
  });

  const CompendiumImportTask.idle()
    : status = CompendiumImportTaskStatus.idle,
      phase = null,
      progress = 0,
      statusMessage = '',
      fileName = null,
      rulesetId = null,
      errorMessage = null,
      notificationToken = 0;

  bool get isRunning => status == CompendiumImportTaskStatus.running;
  bool get isSucceeded => status == CompendiumImportTaskStatus.succeeded;
  bool get isFailed => status == CompendiumImportTaskStatus.failed;
  bool get hasTerminalState => isSucceeded || isFailed;

  CompendiumImportTask copyWith({
    CompendiumImportTaskStatus? status,
    CompendiumImportPhase? phase,
    bool clearPhase = false,
    double? progress,
    String? statusMessage,
    String? fileName,
    bool clearFileName = false,
    String? rulesetId,
    bool clearRulesetId = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    int? notificationToken,
  }) {
    return CompendiumImportTask(
      status: status ?? this.status,
      phase: clearPhase ? null : phase ?? this.phase,
      progress: progress ?? this.progress,
      statusMessage: statusMessage ?? this.statusMessage,
      fileName: clearFileName ? null : fileName ?? this.fileName,
      rulesetId: clearRulesetId ? null : rulesetId ?? this.rulesetId,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      notificationToken: notificationToken ?? this.notificationToken,
    );
  }
}

class CompendiumImportController extends ChangeNotifier {
  final CompendiumRepository _repository;

  CompendiumImportTask _currentTask = const CompendiumImportTask.idle();
  Future<void>? _ongoingImport;
  Future<void> Function()? _retryRequest;
  int _notificationSerial = 0;

  CompendiumImportController({CompendiumRepository? repository})
    : _repository = repository ?? CompendiumRepository();

  CompendiumImportTask get currentTask => _currentTask;

  Future<void> startImportFromPicker() async {
    if (_ongoingImport != null) {
      return _ongoingImport;
    }

    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: kIsWeb,
    );
    if (picked == null || picked.files.isEmpty) {
      return;
    }

    final file = picked.files.single;
    final fileName = file.name.trim().isEmpty ? 'ruleset.json' : file.name.trim();
    final filePath = file.path?.trim();
    final fileBytes = file.bytes;

    if (!kIsWeb && filePath != null && filePath.isNotEmpty) {
      _retryRequest = () => _startFileImport(
        sourcePath: filePath,
        displayName: fileName,
      );
      return _startFileImport(sourcePath: filePath, displayName: fileName);
    }

    if (fileBytes == null || fileBytes.isEmpty) {
      throw StateError('Unable to read the selected file on this platform.');
    }

    _retryRequest = () => startImportFromBytes(fileBytes, fileName: fileName);
    return startImportFromBytes(fileBytes, fileName: fileName);
  }

  Future<void> startImportFromBytes(
    Uint8List bytes, {
    required String fileName,
  }) {
    return _runImport(
      fileName: fileName,
      action: () => _repository.importRulesetJson(
        utf8.decode(bytes),
        onProgress: _handleProgress,
      ),
    );
  }

  Future<void> retryLastImport() async {
    final retry = _retryRequest;
    if (retry == null || _ongoingImport != null) {
      return;
    }

    await retry();
  }

  void clearTerminalState() {
    if (!_currentTask.hasTerminalState) {
      return;
    }

    _currentTask = const CompendiumImportTask.idle();
    notifyListeners();
  }

  Future<void> _startFileImport({
    required String sourcePath,
    required String displayName,
  }) {
    return _runImport(
      fileName: displayName,
      action: () => _repository.importRulesetFile(
        sourcePath,
        onProgress: _handleProgress,
      ),
    );
  }

  Future<void> _runImport({
    required String fileName,
    required Future<Ruleset> Function() action,
  }) {
    if (_ongoingImport != null) {
      return _ongoingImport!;
    }

    _currentTask = CompendiumImportTask(
      status: CompendiumImportTaskStatus.running,
      phase: null,
      progress: 0,
      statusMessage: 'Preparing import...',
      fileName: fileName,
      rulesetId: null,
      errorMessage: null,
      notificationToken: _notificationSerial,
    );
    notifyListeners();

    final future = action()
        .then((ruleset) {
          _notificationSerial += 1;
          _currentTask = _currentTask.copyWith(
            status: CompendiumImportTaskStatus.succeeded,
            clearPhase: true,
            progress: 1,
            statusMessage: 'Imported ${_currentTask.fileName ?? 'ruleset'}.',
            rulesetId: ruleset.id,
            clearErrorMessage: true,
            notificationToken: _notificationSerial,
          );
          notifyListeners();
        })
        .catchError((error, stackTrace) {
          _notificationSerial += 1;
          _currentTask = _currentTask.copyWith(
            status: CompendiumImportTaskStatus.failed,
            clearPhase: true,
            progress: 0,
            statusMessage: 'Import failed.',
            clearRulesetId: true,
            errorMessage: error.toString(),
            notificationToken: _notificationSerial,
          );
          notifyListeners();
        })
        .whenComplete(() {
          _ongoingImport = null;
        });

    _ongoingImport = future;
    return future;
  }

  void _handleProgress(CompendiumImportProgress progress) {
    if (!_currentTask.isRunning) {
      return;
    }

    _currentTask = _currentTask.copyWith(
      phase: progress.phase,
      progress: progress.progress,
      statusMessage: progress.message,
      clearErrorMessage: true,
    );
    notifyListeners();
  }
}

class CompendiumImportControllerScope
    extends InheritedNotifier<CompendiumImportController> {
  const CompendiumImportControllerScope({
    super.key,
    required CompendiumImportController controller,
    required super.child,
  }) : super(notifier: controller);

  static CompendiumImportController of(BuildContext context) {
    final controller = maybeOf(context);
    if (controller == null) {
      throw StateError('No CompendiumImportController was found in context.');
    }
    return controller;
  }

  static CompendiumImportController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CompendiumImportControllerScope>()
        ?.notifier;
  }
}
