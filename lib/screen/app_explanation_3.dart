import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twins_front/screen/app_screen.dart';
import 'package:twins_front/screen/auth_screen.dart';
import 'package:twins_front/screen/home_screen.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:twins_front/services/user_service.dart';
import 'package:twins_front/style/style_schema.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/auth_service.dart';

class AppExplanation3 extends StatelessWidget {
  const AppExplanation3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const ColorScheme.light().surface,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(25)),
        padding: MediaQuery.of(context).padding,
        child: Column(
          children: <Widget>[
            const Expanded(
              flex: 5,
              child: Center(
                child: Image(
                    image: AssetImage('assets/img/twins_logo_green_full.png'),
                    height: 180),
              ),
            ),
            Expanded(
              flex: 5,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        AppLocalizations.of(context)!
                            .welcome_content_categories,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const ColorScheme.light().onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        )),
                    const SizedBox(height: 80),
                    ElevatedButton(
                        onPressed: () {
                          goToHome(context);
                        },
                        style: btnPrimaryStyle(context),
                        child: Text(
                            AppLocalizations.of(context)!.start_experience)),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> goToHome(BuildContext context) async {
  Haptics.vibrate(HapticsType.medium);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('firstTime', false);

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      if (await userConnected(context)) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AppScreen()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false);
      }
    } catch (e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false);
    }
  });
}

Future<bool> userConnected(BuildContext context) async {
  if (AuthService.currentUser != null) {
    await UserService.initializetUserAttributes(
        AuthService.currentUser!.uid, context);
    return true;
  }
  return false;
}
