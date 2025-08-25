import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, error, info, warning }

class ToastHelper {
  static void showToast({
    required BuildContext context,
    required ToastType type,
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomCenter,
    Duration autoCloseDuration = const Duration(seconds: 4),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
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
    required BuildContext context,
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomRight,
    Duration autoCloseDuration = const Duration(seconds: 3),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      context: context,
      type: ToastType.success,
      title: title,
      description: description,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }

  static void showErrorToast({
    required BuildContext context,
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomCenter,
    Duration autoCloseDuration = const Duration(seconds: 4),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      context: context,
      type: ToastType.error,
      title: title,
      description: description,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }

  static void showInfoToast({
    required BuildContext context,
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomRight,
    Duration autoCloseDuration = const Duration(seconds: 4),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      context: context,
      type: ToastType.info,
      title: title,
      description: description,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }

  static void showWarningToast({
    required BuildContext context,
    required String title,
    String? description,
    Alignment alignment = Alignment.bottomRight,
    Duration autoCloseDuration = const Duration(seconds: 4),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      context: context,
      type: ToastType.warning,
      title: title,
      description: description,
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }

  static void showContactToast({
    required BuildContext context,
    String phoneNumber = "+91 9876543210",
    Alignment alignment = Alignment.bottomCenter,
    Duration autoCloseDuration = const Duration(seconds: 5),
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    showToast(
      context: context,
      type: ToastType.info,
      title: "Kindly Contact The Company For More Details",
      alignment: alignment,
      autoCloseDuration: autoCloseDuration,
      style: style,
    );
  }
}
