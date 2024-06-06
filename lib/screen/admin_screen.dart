import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/screen/manage_category.dart';
import 'package:twins_front/screen/home_screen.dart';
import 'package:twins_front/screen/manage_establishments.dart';
import 'package:twins_front/style/style_schema.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = Provider.of<AuthController>(context).firstName;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bonjour $name"),
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
                      "A partir de cette zone tu pourras ajouter ou consulter différents éléments directement dans l'application"),
            ),
            const SizedBox(height: 50),
            SizedBox(
                child: ElevatedButton(
                    style: btnPrimaryStyle(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageCategory(),fullscreenDialog: false));
                    },
                    child: const Text("Ajoutez des catégories"))),
            const SizedBox(height: 50),
            SizedBox(
                child: ElevatedButton(
                    style: btnSecondaryStyle(context),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ManageEstablishments()));
                    },
                    child: const Text("Ajoutez des établissements"))),
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
                    child: const Text("Ajoutez des offres"))),
            const SizedBox(height: 50)
          ])),
    );
  }
}
