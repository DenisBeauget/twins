import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:twins_front/utils/confetti_controller.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/bloc/establishment_bloc.dart';
import 'package:twins_front/bloc/offer_bloc.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/firebase_options.dart';
import 'package:twins_front/screen/app_screen.dart';
import 'package:twins_front/screen/auth_screen.dart';
import 'package:twins_front/screen/manage_establishments.dart';
import 'package:twins_front/screen/validate_offer_screen.dart';
import 'package:twins_front/screen/welcome_screen.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:twins_front/services/deeplink_service.dart';
import 'package:twins_front/services/user_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:firebase_core/firebase_core.dart';

import 'utils/util.dart';

import 'theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uni_links/uni_links.dart';
import 'bloc/category_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"]!;
  Stripe.instance.applySettings;
  await _initDevicesParameters();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController()),
      ChangeNotifierProvider<ScreenIndexProvider>(
          create: (context) => ScreenIndexProvider()),
      ListenableProvider<CheckboxProvider>(
          create: (context) => CheckboxProvider()),
      BlocProvider<CategoryBloc>(create: (context) => CategoryBloc()),
      BlocProvider<EstablishmentBloc>(create: (context) => EstablishmentBloc()),
      BlocProvider<OfferBloc>(create: (context) => OfferBloc())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  StreamSubscription? _sub;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getUserInfo(context);

    TextTheme textTheme = createTextTheme(context, "Chakra Petch", "Tajawal");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Twins App',
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
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
      home: Stack(
        children: [
          redirectUser(),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.1,
              numberOfParticles: 25,
              minBlastForce: 10,
              maxBlastForce: 50,
            ),
          ),
        ],
      ),
    );
  }
}

Widget redirectUser() {
  if (FirebaseAuth.instance.currentUser != null) {
    return const AppScreen();
    return const AppScreen();
  } else {
    return const WelcomeScreen();
  }
}

Future<void> _initDevicesParameters() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

Future<void> getUserInfo(BuildContext context) async {
  if (AuthService.currentUser != null) {
    try {
      await UserService.initializetUserAttributes(
          AuthService.currentUser!.uid, context);
    } catch (e) {
      AuthService.logout().whenComplete(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AuthScreen()));
      });
    }
  }
}
