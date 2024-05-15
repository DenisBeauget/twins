import 'package:flutter/material.dart';
import 'package:twins_front/screen/connexion_screen.dart';
import 'package:twins_front/screen/register_screen.dart';
import 'package:twins_front/style/style_schema.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/img/twins_logo.png'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: btnSecondaryStyle(),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
              },
              child: Text(AppLocalizations.of(context)!.start_register)
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: btnSecondaryStyle(),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              child: Text(AppLocalizations.of(context)!.start_sign_in)
            ),
          ],
          ),
        )
    );
  }
}