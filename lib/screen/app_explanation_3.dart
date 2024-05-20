import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:twins_front/screen/auth_screen.dart';
import 'package:twins_front/style/style_schema.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class AppExplanation3 extends StatelessWidget {
  const AppExplanation3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: darkColorScheme.primary,
            borderRadius: BorderRadius.circular(25)),
        padding: MediaQuery.of(context).padding,
        child: Column(
          children: <Widget>[
            const Expanded(
              flex: 5,
              child: Image(
                  image: AssetImage('assets/img/twins_logo.png'), height: 180),
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
                          color: darkColorScheme.background,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        )),
                    const SizedBox(height: 80),
                    ElevatedButton(
                        onPressed: () {
                          goToHome(context);
                        },
                        style: btnPrimaryStyle(),
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

void goToHome(BuildContext context) {
  Haptics.vibrate(HapticsType.medium);
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    if(userConnected()) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AuthScreen()));
    }
  });
}
bool userConnected() {
  return AuthService.currentUser != null ? true : false;
}
