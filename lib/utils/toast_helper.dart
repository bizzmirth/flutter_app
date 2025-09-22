import 'package:bizzmirth_app/main.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, error, info, warning }

class ToastHelper {
  static BuildContext? get _context => MyApp.navigatorKey.currentContext;

  static void showToast({
    required ToastType type,
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomCenter,
    Duration autoCloseDuration = const Duration(seconds: 4),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    final context = _context;
    if (context == null) {
      // Optional: Add debug print to know if context is null
      debugPrint('ToastHelper: Context is null, cannot show toast');
      return;
    }

    ToastificationType toastType;
    switch (type) {
      case ToastType.success:
        toastType = ToastificationType.success;
        break;
      case ToastType.error:
        toastType = ToastificationType.error;
        break;
      case ToastType.info:
        toastType = ToastificationType.info;
        break;
      case ToastType.warning:
        toastType = ToastificationType.warning;
        break;
    }

    toastification.show(
      context: context,
      type: toastType,
      style: style,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
    );
  }

  static void showSuccessToast({
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomRight,
    Duration autoCloseDuration = const Duration(seconds: 3),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      type: ToastType.success,
      title: title,
      description: description,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }

  static void showErrorToast({
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomCenter,
    Duration autoCloseDuration = const Duration(seconds: 4),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      type: ToastType.error,
      title: title,
      description: description,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }

  static void showInfoToast({
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomRight,
    Duration autoCloseDuration = const Duration(seconds: 4),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      type: ToastType.info,
      title: title,
      description: description,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }

  static void showWarningToast({
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomRight,
    Duration autoCloseDuration = const Duration(seconds: 4),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      type: ToastType.warning,
      title: title,
      description: description,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }

  static void showContactToast({
    String phoneNumber = '+91 9876543210',
    Alignment alignment = Alignment.bottomCenter,
    Duration autoCloseDuration = const Duration(seconds: 5),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      type: ToastType.info,
      title: 'Kindly Contact The Company For More Details',
      description: 'Phone: $phoneNumber',
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }

  // Additional utility methods
  static void showQuickSuccess(String message) {
    showSuccessToast(title: message);
  }

  static void showQuickError(String message) {
    showErrorToast(title: message);
  }

  static void showQuickInfo(String message) {
    showInfoToast(title: message);
  }

  static void showQuickWarning(String message) {
    showWarningToast(title: message);
  }
}
