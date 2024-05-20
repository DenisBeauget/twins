import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:motion_toast/motion_toast.dart';
class Toaster{
  static void showSuccessToast(BuildContext context, String message) {
    Haptics.vibrate(HapticsType.success);

    MotionToast(
      width: MediaQuery.of(context).size.width*0.8,
      height: 60,
      primaryColor: Theme.of(context).colorScheme.inversePrimary,
      description: Text(message),
      icon: Icons.check,
      animationCurve: Curves.bounceIn,
    ).show(context);
  }


  static void showFailedToast(BuildContext context, String message) {
    Haptics.vibrate(HapticsType.error);
    MotionToast(
      width: MediaQuery.of(context).size.width*0.8,
      height: message.length > 50 ? message.length.toDouble() : 60,
      primaryColor: Theme.of(context).colorScheme.error,
      description: Text(message),
      icon: Icons.error,
      animationCurve: Curves.bounceIn,
    ).show(context);
  }
}