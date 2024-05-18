import 'dart:io';

import 'package:flutter/material.dart';
import 'package:twins_front/firebase_options.dart';
import 'package:twins_front/screen/welcome_screen.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:firebase_core/firebase_core.dart';


import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twins App',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme, fontFamily: 'Poppins'),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme, fontFamily: 'Poppins'),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        if (locales != null && locales.isNotEmpty) {
          if (locales.first.languageCode == 'fr') {
            return const Locale('fr', '');
          } else {
            return const Locale('en', '');
          }
        }
        return null;
      },
      home: WelcomeScreen(),
    );
  }
}
