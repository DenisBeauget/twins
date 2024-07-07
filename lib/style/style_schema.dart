import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

btnPrimaryStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    foregroundColor: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
    side: const BorderSide(color: Colors.black, width: 1),
    elevation: 5,
  );
}

btnTextPrimaryStyle() {
  return TextButton.styleFrom(
    foregroundColor: Colors.black,
    textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20.0),
    side: const BorderSide(color: Colors.black, width: 1),
    elevation: 5,
  );
}

btnDialogStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.black,
    textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
    side: const BorderSide(color: Colors.black, width: 1),
    elevation: 5,
  );
}

btnDialogStyleCancel(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    elevation: 0,
    textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  );
}

btnSecondaryStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.surface,
    textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
  );
}

inputStyle(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 4),
      borderRadius: BorderRadius.all(Radius.circular(22.0)),
    ),
  );
}

Image appLogo(double height) {
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;

  if (isDarkMode) {
    return Image.asset(
      'assets/img/twins_logo_w.png',
      height: height,
    );
  } else {
    return Image.asset(
      'assets/img/twins_logo.png',
      height: height,
    );
  }
}
