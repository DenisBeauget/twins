import 'package:flutter/material.dart';
import 'package:twins_front/style/style_schema.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppExplanation2 extends StatelessWidget {
  const AppExplanation2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: darkColorScheme.background,
            borderRadius: BorderRadius.circular(25)),
        padding: MediaQuery.of(context).padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Expanded(
              flex: 5,
              child: Center(
                  child: Image(
                      image: AssetImage('assets/img/twins_logo_w.png'),
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
                      AppLocalizations.of(context)!.welcome_content_app,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: lightColorScheme.background,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const Image(
                      image: AssetImage('assets/img/scroll_w.gif'),
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
