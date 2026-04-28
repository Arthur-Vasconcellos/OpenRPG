import 'package:flutter/material.dart';
import 'package:openrpg/app_navigator_scope.dart';
import 'package:openrpg/compendium/data/compendium_import_controller.dart';
import 'package:openrpg/screens/rulesets/compendium_entity_preview_sheet.dart';
import 'package:openrpg/screens/rulesets/ruleset_detail_screen.dart';
import 'package:openrpg/screens/workspace_home_screen.dart';

void main() {
  runApp(const OpenRpgApp());
}

class OpenRpgApp extends StatefulWidget {
  const OpenRpgApp({super.key});

  @override
  State<OpenRpgApp> createState() => _OpenRpgAppState();
}

class _OpenRpgAppState extends State<OpenRpgApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final CompendiumImportController _importController =
      CompendiumImportController()..addListener(_handleImportStateChanged);
  late final CompendiumPreviewController _previewController =
      CompendiumPreviewController();

  int _lastNotificationToken = 0;

  @override
  void dispose() {
    _importController
      ..removeListener(_handleImportStateChanged)
      ..dispose();
    super.dispose();
  }

  void _handleImportStateChanged() {
    final task = _importController.currentTask;
    if (!task.hasTerminalState ||
        task.notificationToken == 0 ||
        task.notificationToken == _lastNotificationToken) {
      return;
    }

    _lastNotificationToken = task.notificationToken;
    final messenger = _scaffoldMessengerKey.currentState;
    if (messenger == null) {
      return;
    }

    messenger.hideCurrentSnackBar();
    if (task.isSucceeded) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(task.statusMessage),
          action: task.rulesetId == null
              ? null
              : SnackBarAction(
                  label: 'Open ruleset',
                  onPressed: () {
                    final navigator = _navigatorKey.currentState;
                    final rulesetId = task.rulesetId;
                    if (navigator == null || rulesetId == null) {
                      return;
                    }
                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) =>
                            RulesetDetailScreen(rulesetId: rulesetId),
                      ),
                    );
                  },
                ),
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(task.errorMessage ?? task.statusMessage),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _importController.retryLastImport,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2F6B62),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      fontFamily: 'Georgia',
    );

    return AppNavigatorScope(
      navigatorKey: _navigatorKey,
      child: CompendiumImportControllerScope(
        controller: _importController,
        child: CompendiumPreviewControllerScope(
          controller: _previewController,
          child: MaterialApp(
            title: 'OpenRPG',
            navigatorKey: _navigatorKey,
            scaffoldMessengerKey: _scaffoldMessengerKey,
            theme: base.copyWith(
              scaffoldBackgroundColor: const Color(0xFFF4EEE1),
              cardTheme: base.cardTheme.copyWith(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            builder: (context, child) {
              return Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) => CompendiumPreviewHost(
                      controller: _previewController,
                      child: _CompendiumImportOverlay(
                        controller: _importController,
                        child: child ?? const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              );
            },
            home: const WorkspaceHomeScreen(),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

class _CompendiumImportOverlay extends StatelessWidget {
  final CompendiumImportController controller;
  final Widget child;

  const _CompendiumImportOverlay({
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final task = controller.currentTask;
        if (!task.isRunning) {
          return child;
        }

        return Stack(
          children: [
            child,
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: SafeArea(
                child: IgnorePointer(
                  ignoring: true,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Importing ${task.fileName ?? 'ruleset'}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                task.statusMessage,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(value: task.progress),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
