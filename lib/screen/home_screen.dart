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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Center(
              child: appLogo(180),
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: btnPrimaryStyle(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child:
                            Text(AppLocalizations.of(context)!.start_register)),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: btnSecondaryStyle(context),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child:
                            Text(AppLocalizations.of(context)!.start_sign_in)),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
