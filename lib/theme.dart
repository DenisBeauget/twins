import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
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
      inversePrimary: Color(0xff1cca46),
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
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4279979043),
      surfaceTint: Color(4281887036),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4283334737),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281747254),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284971365),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4279912783),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283399042),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294441970),
      onSurface: Color(4279770392),
      onSurfaceVariant: Color(4282271036),
      outline: Color(4284113240),
      outlineVariant: Color(4285955443),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281152044),
      inversePrimary: Color(0xff1cca46),
      primaryFixed: Color(4283334737),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281689658),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284971365),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283392078),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283399042),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281754473),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336595),
      surfaceBright: Color(4294441970),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294047212),
      surfaceContainer: Color(4293652454),
      surfaceContainerHigh: Color(4293323233),
      surfaceContainerHighest: Color(4292928731),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278200586),
      surfaceTint: Color(4281887036),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4279979043),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279641623),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281747254),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278200107),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4279912783),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294441970),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280231454),
      outline: Color(4282271036),
      outlineVariant: Color(4282271036),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281152044),
      inversePrimary: Color(4290968257),
      primaryFixed: Color(4279979043),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278203663),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281747254),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280365345),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4279912783),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278202936),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336595),
      surfaceBright: Color(4294441970),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294047212),
      surfaceContainer: Color(4293652454),
      surfaceContainerHigh: Color(4293323233),
      surfaceContainerHighest: Color(4292928731),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
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
      inversePrimary: Color(0xff1cca46),
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
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4288862369),
      surfaceTint: Color(4288599197),
      onPrimary: Color(4278196997),
      primaryContainer: Color(4285111659),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290629817),
      onSecondary: Color(4278852107),
      secondaryContainer: Color(4286813825),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4289057754),
      onTertiary: Color(4278196765),
      tertiaryContainer: Color(4285307039),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279244048),
      onSurface: Color(4294507763),
      onSurfaceVariant: Color(4291218882),
      outline: Color(4288587162),
      outlineVariant: Color(4286481787),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928731),
      inversePrimary: Color(4280308264),
      primaryFixed: Color(4290375864),
      onPrimaryFixed: Color(4278195715),
      primaryFixedDim: Color(4288599197),
      onPrimaryFixedVariant: Color(4278927127),
      secondaryFixed: Color(4292143312),
      onSecondaryFixed: Color(4278588423),
      secondaryFixedDim: Color(4290366645),
      onSecondaryFixedVariant: Color(4280957482),
      tertiaryFixed: Color(4290571250),
      onTertiaryFixed: Color(4278195223),
      tertiaryFixedDim: Color(4288794326),
      onTertiaryFixedVariant: Color(4278729794),
      surfaceDim: Color(4279244048),
      surfaceBright: Color(4281743925),
      surfaceContainerLowest: Color(4278914827),
      surfaceContainerLow: Color(4279770392),
      surfaceContainer: Color(4280033563),
      surfaceContainerHigh: Color(4280757030),
      surfaceContainerHighest: Color(4281415216),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293984235),
      surfaceTint: Color(4288599197),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4288862369),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293984235),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290629817),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294049279),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4289057754),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279244048),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294376945),
      outline: Color(4291218882),
      outlineVariant: Color(4291218882),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928731),
      inversePrimary: Color(4278202894),
      primaryFixed: Color(4290639292),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4288862369),
      onPrimaryFixedVariant: Color(4278196997),
      secondaryFixed: Color(4292472020),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290629817),
      onSecondaryFixedVariant: Color(4278852107),
      tertiaryFixed: Color(4290899959),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4289057754),
      onTertiaryFixedVariant: Color(4278196765),
      surfaceDim: Color(4279244048),
      surfaceBright: Color(4281743925),
      surfaceContainerLowest: Color(4278914827),
      surfaceContainerLow: Color(4279770392),
      surfaceContainer: Color(4280033563),
      surfaceContainerHigh: Color(4280757030),
      surfaceContainerHighest: Color(4281415216),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
