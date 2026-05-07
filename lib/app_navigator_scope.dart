import 'package:flutter/widgets.dart';

class AppNavigatorScope extends InheritedWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const AppNavigatorScope({
    super.key,
    required this.navigatorKey,
    required super.child,
  });

  static GlobalKey<NavigatorState>? maybeNavigatorKeyOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppNavigatorScope>()
        ?.navigatorKey;
  }

  static GlobalKey<NavigatorState> navigatorKeyOf(BuildContext context) {
    final key = maybeNavigatorKeyOf(context);
    assert(key != null, 'No AppNavigatorScope found in context.');
    return key!;
  }

  @override
  bool updateShouldNotify(AppNavigatorScope oldWidget) {
    return oldWidget.navigatorKey != navigatorKey;
  }
}
