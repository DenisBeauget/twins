import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

btnPrimaryStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
    side: const BorderSide(color: Colors.black, width: 1),
    elevation: 5,
    shadowColor: Theme.of(context).colorScheme.shadow,
  );
}

btnTextPrimaryStyle() {
  return TextButton.styleFrom(
    foregroundColor: Colors.black,
    textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20.0),
    side: const BorderSide(color: Colors.black, width: 1),
    elevation: 5,
  );
}

btnDialogStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
    textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
  );
}

btnSecondaryStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: Theme.of(context).colorScheme.onSecondary,
    textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
  );
}

inputStyle(String label, IconData icon) {
  return InputDecoration(labelText: label, prefixIcon: Icon(icon));
}

inputStyleWithoutFocus(String label, BuildContext context) {
  return InputDecoration(
    hintText: label,
    prefix: const Padding(
      padding: EdgeInsets.only(left: 25),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 4),
      borderRadius: BorderRadius.all(Radius.circular(22.0)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(22.0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(22.0)),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );
}

Image appLogoPurple(double height) {
  return Image.asset(
    'assets/img/twins_logo_purple.png',
    height: height,
  );
}

Image appLogoGreen(double height) {
  return Image.asset(
    'assets/img/twins_logo_green.png',
    height: height,
  );
}
