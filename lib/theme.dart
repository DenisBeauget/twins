import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffDAFDCC),
      onPrimary: Color(0xff212121),
      secondary: Color(0xffCCCEFD),
      onSecondary: Color(0xff212121),
      error: Color(0xffF9998A),
      onError: Color(0xffffffff),
      surface: Color(0xffffffff),
      surfaceContainer: Color(0xffFFFFFF),
      onSurface: Color(0xff3e3d3d),
      onSurfaceVariant: Color(0xff3c4a3b),
      outline: Color(0xff6c7b6a),
      outlineVariant: Color(0xffbbcbb7),
      shadow: Color(0xffc3c2c2),
      inversePrimary: Color(0xffF1F2F3),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffDAFDCC),
      onPrimary: Color(0xff212121),
      secondary: Color(0xffCCCEFD),
      onSecondary: Color(0xff212121),
      error: Color(0xffF9998A),
      onError: Color(0xffffffff),
      surface: Color(0xff1e1e1e),
      surfaceContainer: Color(0xff2c2c2c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xff3c4a3b),
      outline: Color(0xff6c7b6a),
      outlineVariant: Color(0xffbbcbb7),
      shadow: Color(0xff303030),
      inversePrimary: Color(0xffF1F2F3),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        brightness: colorScheme.brightness,
        primaryColor: colorScheme.onSurface,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(22.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme.brightness == Brightness.dark
                  ? colorScheme.primary
                  : colorScheme.onSurface,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(22.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(18.0)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme.error,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(22.0)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme.error,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(22.0)),
          ),
          labelStyle: TextStyle(
            color: colorScheme.onSurface,
          ),
          floatingLabelStyle: TextStyle(
            color: colorScheme.secondaryContainer,
          ),
          iconColor: colorScheme.onSurface,
          prefixIconColor: colorScheme.onSurface,

          hintStyle: TextStyle(
            color: colorScheme.onSurface,
          ),
        ),
        canvasColor: colorScheme.surface,
        appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.surface,
            surfaceTintColor: Colors.transparent),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: colorScheme.surface,
              selectedItemColor: colorScheme.primary,
              unselectedItemColor: colorScheme.onSurface,
              selectedLabelStyle: TextStyle(
                color: colorScheme.primary,
              ),
              unselectedLabelStyle: TextStyle(
                color: colorScheme.onSurface,
              ),
            ),

      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily dark;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.dark,
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
