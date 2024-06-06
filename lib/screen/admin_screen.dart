import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/screen/manage_category.dart';
import 'package:twins_front/screen/manage_establishments.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = Provider.of<AuthController>(context).firstName;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.admin_hello(name)),
      ),
      body: Center(
          child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,

                      color: Theme.of(context).colorScheme.onSurface),
                  text:
                      AppLocalizations.of(context)!.admin_presentation),
            ),
            const SizedBox(height: 50),
            SizedBox(
                child: ElevatedButton(
                    style: btnPrimaryStyle(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageCategory(),fullscreenDialog: false));
                    },
                    child: Text(AppLocalizations.of(context)!.admin_category))),
            const SizedBox(height: 50),
            SizedBox(
                child: ElevatedButton(
                    style: btnSecondaryStyle(context),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                   ManageEstablishments()));
                    },
                    child: Text(AppLocalizations.of(context)!.admin_establishment))),
            const SizedBox(height: 50),
            SizedBox(
                child: ElevatedButton(
                    style: btnPrimaryStyle(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminScreen()));
                    },
                    child: Text(AppLocalizations.of(context)!.admin_offer))),
            const SizedBox(height: 50)
          ])),
    );
  }
}
