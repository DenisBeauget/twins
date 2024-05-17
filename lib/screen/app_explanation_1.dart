import 'package:flutter/material.dart';
import 'package:twins_front/style/style_schema.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppExplanation1 extends StatelessWidget {
  const AppExplanation1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: lightColorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(25)),
        padding: MediaQuery.of(context).padding,
        child: Column(
          children: <Widget>[
            const Expanded(
              flex: 5,
              child: Center(
                  child: Image(
                      image: AssetImage('assets/img/twins_logo.png'),
                      height: 180)),
            ),
            Expanded(
              flex: 5,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.welcome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: lightColorScheme.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.welcome_description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: lightColorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    const Image(
                      image: AssetImage('assets/img/scroll.gif'),
                      height: 200,
                    ),
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
