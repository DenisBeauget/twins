import 'package:flutter/material.dart';
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
            Image.asset('assets/img/twins logo bg removed.png'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: btnSecondaryStyle(),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
              child: Text(AppLocalizations.of(context)!.start_experience)
            ),
          ],
          ),
        )
    );
  }
}