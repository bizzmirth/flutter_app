import 'package:bizzmirth_app/main.dart';
import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';

class MyNavigator {
  static BuildContext? get _context => MyApp.navigatorKey.currentContext;
  static NavigatorState? get _navigator => MyApp.navigatorKey.currentState;

  // Basic Navigation Methods
  static void pop([dynamic result]) {
    final navigator = _navigator;
    if (navigator != null && navigator.canPop()) {
      navigator.pop(result);
    } else {
      debugPrint('MyNavigator: Cannot pop - no navigator or nothing to pop');
    }
  }

  // Specific convenience methods for common pop scenarios
  static void popWithResult(dynamic result) {
    pop(result);
  }

  static void popTrue() {
    pop(true);
  }

  static void popFalse() {
    pop(false);
  }

  static Future<T?> push<T extends Object?>(Route<T> route) async {
    final navigator = _navigator;
    if (navigator != null) {
      return await navigator.push(route);
    }
    Logger.error('MyNavigator: Cannot push - no navigator available');
    return null;
  }

  static Future<T?> pushWidget<T extends Object?>(Widget widget) async {
    return await push<T>(MaterialPageRoute(builder: (_) => widget));
  }

  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    final navigator = _navigator;
    if (navigator != null) {
      return await navigator.pushNamed<T>(routeName, arguments: arguments);
    }
    Logger.error('MyNavigator: Cannot pushNamed - no navigator available');
    return null;
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> newRoute, {
    TO? result,
  }) async {
    final navigator = _navigator;
    if (navigator != null) {
      return await navigator.pushReplacement<T, TO>(newRoute, result: result);
    }
    Logger.error(
        'MyNavigator: Cannot pushReplacement - no navigator available');
    return null;
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) async {
    final navigator = _navigator;
    if (navigator != null) {
      return await navigator.pushReplacementNamed<T, TO>(
        routeName,
        result: result,
        arguments: arguments,
      );
    }
    Logger.error(
        'MyNavigator: Cannot pushReplacementNamed - no navigator available');
    return null;
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) async {
    final navigator = _navigator;
    if (navigator != null) {
      return await navigator.pushAndRemoveUntil<T>(newRoute, predicate);
    }
    Logger.error(
        'MyNavigator: Cannot pushAndRemoveUntil - no navigator available');
    return null;
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) async {
    final navigator = _navigator;
    if (navigator != null) {
      return await navigator.pushNamedAndRemoveUntil<T>(
        newRouteName,
        predicate,
        arguments: arguments,
      );
    }
    Logger.error(
        'MyNavigator: Cannot pushNamedAndRemoveUntil - no navigator available');
    return null;
  }

  static void popUntil(RoutePredicate predicate) {
    final navigator = _navigator;
    if (navigator != null) {
      navigator.popUntil(predicate);
    } else {
      Logger.error('MyNavigator: Cannot popUntil - no navigator available');
    }
  }

  // Convenience Methods with MaterialPageRoute
  static Future<T?> pushPage<T extends Object?>(Widget page) async {
    return await push<T>(MaterialPageRoute(builder: (_) => page));
  }

  static Future<T?> pushReplacementPage<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
  }) async {
    return await pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  static Future<T?> pushPageAndRemoveUntil<T extends Object?>(
    Widget page,
    RoutePredicate predicate,
  ) async {
    return await pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  // Utility Methods
  static bool canPop() {
    final navigator = _navigator;
    return navigator?.canPop() ?? false;
  }

  static void popToRoot() {
    popUntil((route) => route.isFirst);
  }

  static Future<T?> pushAndClearStack<T extends Object?>(Widget page) async {
    return await pushPageAndRemoveUntil<T>(page, (route) => false);
  }

  static Future<T?> pushNamedAndClearStack<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    return await pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Dialog and Modal Methods
  static Future<T?> showDialogPage<T>(Widget dialog) async {
    final context = _context;
    if (context != null) {
      return await showDialog<T>(
        context: context,
        builder: (_) => dialog,
      );
    }
    Logger.error('MyNavigator: Cannot showDialog - no context available');
    return null;
  }

  static Future<T?> showModalBottomSheetPage<T>(Widget sheet) async {
    final context = _context;
    if (context != null) {
      return await showModalBottomSheet<T>(
        context: context,
        builder: (_) => sheet,
      );
    }
    Logger.error(
        'MyNavigator: Cannot showModalBottomSheet - no context available');
    return null;
  }

  // Custom convenience methods for common patterns
  static Future<T?> pushWithFadeTransition<T extends Object?>(
      Widget page) async {
    return await push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  static Future<T?> pushWithSlideTransition<T extends Object?>(
      Widget page) async {
    return await push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
