import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:toastification/toastification.dart';

class Toaster {
  static void showSuccessToast(BuildContext context, String message) {
    Haptics.vibrate(HapticsType.success);

    toastification.show(
      context: context,
      title: Text(message, style: const TextStyle(fontSize: 16)),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      icon: const Icon(FluentIcons.checkmark_circle_12_regular, size: 35),
      style: ToastificationStyle.flat,
      type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  static void showFailedToast(BuildContext context, String message) {
    Haptics.vibrate(HapticsType.error);

    toastification.show(
      context: context,
      title: Text(message, style: const TextStyle(fontSize: 16)),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      icon: const Icon(FluentIcons.error_circle_12_regular, size: 35),
      style: ToastificationStyle.flat,
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}
