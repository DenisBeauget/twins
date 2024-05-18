import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(-16777216),
  surfaceTint: Color(4278218280),
  onPrimary: Color(4294967295),
  primaryContainer: Color(4284020857),
  onPrimaryContainer: Color(4278210330),
  secondary: Color(4280642610),
  onSecondary: Color(4294967295),
  secondaryContainer: Color(4289459885),
  onSecondaryContainer: Color(4278605087),
  tertiary: Color(4278217075),
  onTertiary: Color(4294967295),
  tertiaryContainer: Color(4285328895),
  onTertiaryContainer: Color(4278209363),
  error: Color(4290386458),
  onError: Color(4294967295),
  errorContainer: Color(4294957782),
  onErrorContainer: Color(4282449922),
  background: Color(4294180078),
  onBackground: Color(4279574037),
  surface: Color(4294180078),
  onSurface: Color(4279574037),
  surfaceVariant: Color(4292339667),
  onSurfaceVariant: Color(4282141243),
  outline: Color(4285299562),
  outlineVariant: Color(4290497463),
  shadow: Color(4278190080),
  scrim: Color(4278190080),
  inverseSurface: Color(4280955689),
  inversePrimary: Color(4282311527),
  primaryFixed: Color(4285267844),
  onPrimaryFixed: Color(4278198535),
  primaryFixedDim: Color(4282311527),
  onPrimaryFixedVariant: Color(4278211356),
  secondaryFixed: Color(4289393836),
  onSecondaryFixed: Color(4278198535),
  secondaryFixedDim: Color(4287551378),
  onSecondaryFixedVariant: Color(4278342429),
  tertiaryFixed: Color(4287951359),
  onTertiaryFixed: Color(4278198052),
  tertiaryFixedDim: Color(4278246128),
  onTertiaryFixedVariant: Color(4278210391),
  surfaceDim: Color(4292074959),
  surfaceBright: Color(4294180078),
  surfaceContainerLowest: Color(4294967295),
  surfaceContainerLow: Color(4293785320),
  surfaceContainer: Color(4293390818),
  surfaceContainerHigh: Color(4292996061),
  surfaceContainerHighest: Color(4292666839),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(4293591014),
  surfaceTint: Color(4282311527),
  onPrimary: Color(4278204689),
  primaryContainer: Color(4283034478),
  onPrimaryContainer: Color(4278208023),
  secondary: Color(4287551378),
  onSecondary: Color(4278204689),
  secondaryContainer: Color(4278209048),
  onSecondaryContainer: Color(4288406942),
  tertiary: Color(4293918207),
  onTertiary: Color(4278203964),
  tertiaryContainer: Color(4279887098),
  onTertiaryContainer: Color(4278207306),
  error: Color(4294948011),
  onError: Color(4285071365),
  errorContainer: Color(4287823882),
  onErrorContainer: Color(4294957782),
  background: Color(4279047437),
  onBackground: Color(4292666839),
  surface: Color(4279047437),
  onSurface: Color(4292666839),
  surfaceVariant: Color(4282141243),
  onSurfaceVariant: Color(4290497463),
  outline: Color(4287010179),
  outlineVariant: Color(4282141243),
  shadow: Color(4278190080),
  scrim: Color(4278190080),
  inverseSurface: Color(4292666839),
  inversePrimary: Color(4278218280),
  primaryFixed: Color(4285267844),
  onPrimaryFixed: Color(4278198535),
  primaryFixedDim: Color(4282311527),
  onPrimaryFixedVariant: Color(4278211356),
  secondaryFixed: Color(4289393836),
  onSecondaryFixed: Color(4278198535),
  secondaryFixedDim: Color(4287551378),
  onSecondaryFixedVariant: Color(4278342429),
  tertiaryFixed: Color(4287951359),
  onTertiaryFixed: Color(4278198052),
  tertiaryFixedDim: Color(4278246128),
  onTertiaryFixedVariant: Color(4278210391),
  surfaceDim: Color(4279047437),
  surfaceBright: Color(4281547570),
  surfaceContainerLowest: Color(4278718472),
  surfaceContainerLow: Color(4279574037),
  surfaceContainer: Color(4279837209),
  surfaceContainerHigh: Color(4280560675),
  surfaceContainerHighest: Color(4281218861),
);


btnPrimaryStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: lightColorScheme.primaryContainer,

    foregroundColor: Colors.black,
    textStyle: const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
    side: const BorderSide(color: Colors.black, width: 1),
    elevation: 5,
  );
}


btnDialogStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: lightColorScheme.primaryContainer,

    foregroundColor: Colors.black,
    textStyle: const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11.0)),
    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
    side: const BorderSide(color: Colors.black, width: 1),
    elevation: 5,
  );
}

btnSecondaryStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,

    foregroundColor: Theme.of(context).colorScheme.background,
    textStyle: const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
  );
}

inputStyle(String label, IconData icon){
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(borderSide: BorderSide(width: 4),borderRadius: BorderRadius.all(Radius.circular(22.0)),
    ),
  );
}

Image appLogo(double height) {
  var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;

  if (isDarkMode) {
    return Image.asset(
      'assets/img/twins_logo_w.png',
      height: height,
    );
  }else{
    return Image.asset(
      'assets/img/twins_logo.png',
      height: height,
    );
  }
}
