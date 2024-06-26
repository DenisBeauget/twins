import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(-16777216),
  surfaceTint: Color(0xff006e28),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xff58f879),
  onPrimaryContainer: Color(0xff004f1a),
  secondary: Color(0xff256c32),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffabf6ad),
  onSecondaryContainer: Color(0xff06551f),
  tertiary: Color(0xff006973),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xff6cedff),
  onTertiaryContainer: Color(0xff004b53),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff410002),
  surface: Color(0xfff3fcee),
  onSurface: Color(0xff151e15),
  onSurfaceVariant: Color(0xff3c4a3b),
  outline: Color(0xff6c7b6a),
  outlineVariant: Color(0xffbbcbb7),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff2a3329),
  inversePrimary: Color(0xff3ee367),
  primaryFixed: Color(0xff6bff84),
  onPrimaryFixed: Color(0xff002107),
  primaryFixedDim: Color(0xff3ee367),
  onPrimaryFixedVariant: Color(0xff00531c),
  secondaryFixed: Color(0xffaaf4ac),
  onSecondaryFixed: Color(0xff002107),
  secondaryFixedDim: Color(0xff8ed792),
  onSecondaryFixedVariant: Color(0xff02531d),
  tertiaryFixed: Color(0xff94f1ff),
  onTertiaryFixed: Color(0xff001f24),
  tertiaryFixedDim: Color(0xff00daf0),
  onTertiaryFixedVariant: Color(0xff004f57),
  surfaceDim: Color(0xffd3ddcf),
  surfaceBright: Color(0xfff3fcee),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xffedf6e8),
  surfaceContainer: Color(0xffe7f1e2),
  surfaceContainerHigh: Color(0xffe1ebdd),
  surfaceContainerHighest: Color(0xffdce5d7),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xffeaffe6),
  surfaceTint: Color(0xff3ee367),
  onPrimary: Color(0xff003911),
  primaryContainer: Color(0xff49eb6e),
  onPrimaryContainer: Color(0xff004617),
  secondary: Color(0xff8ed792),
  onSecondary: Color(0xff003911),
  secondaryContainer: Color(0xff004a18),
  onSecondaryContainer: Color(0xff9be59e),
  tertiary: Color(0xffeffdff),
  onTertiary: Color(0xff00363c),
  tertiaryContainer: Color(0xff19e4fa),
  onTertiaryContainer: Color(0xff00434a),
  error: Color(0xffffb4ab),
  onError: Color(0xff690005),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffdad6),
  surface: Color(0xff0d150d),
  onSurface: Color(0xffdce5d7),
  onSurfaceVariant: Color(0xffbbcbb7),
  outline: Color(0xff869583),
  outlineVariant: Color(0xff3c4a3b),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffdce5d7),
  inversePrimary: Color(0xff006e28),
  primaryFixed: Color(0xff6bff84),
  onPrimaryFixed: Color(0xff002107),
  primaryFixedDim: Color(0xff3ee367),
  onPrimaryFixedVariant: Color(0xff00531c),
  secondaryFixed: Color(0xffaaf4ac),
  onSecondaryFixed: Color(0xff002107),
  secondaryFixedDim: Color(0xff8ed792),
  onSecondaryFixedVariant: Color(0xff02531d),
  tertiaryFixed: Color(0xff94f1ff),
  onTertiaryFixed: Color(0xff001f24),
  tertiaryFixedDim: Color(0xff00daf0),
  onTertiaryFixedVariant: Color(0xff004f57),
  surfaceDim: Color(0xff0d150d),
  surfaceBright: Color(0xff333b32),
  surfaceContainerLowest: Color(0xff081008),
  surfaceContainerLow: Color(0xff151e15),
  surfaceContainer: Color(0xff192219),
  surfaceContainerHigh: Color(0xff242c23),
  surfaceContainerHighest: Color(0xff2e372d),
);

btnPrimaryStyle() {
  return ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
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

btnDialogStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: lightColorScheme.primaryContainer,
    foregroundColor: Colors.black,
    textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
    side: const BorderSide(color: Colors.black, width: 1),
    elevation: 5,
  );
}

btnDialogStyleCancel() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black,
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
