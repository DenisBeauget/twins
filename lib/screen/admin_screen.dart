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
        backgroundColor: lightColorScheme.primaryContainer,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    text: "Bonjour $name")),
            const SizedBox(width: 20)
          ],
        ),
      ),
      body: Center(
          child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              children: [
            RichText(
              text: const TextSpan(
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  text:
                      "A partir de cette zone tu pourras ajouter ou consulter différents éléments directement dans l'application"),
            ),
            const SizedBox(height: 50),
            SizedBox(
                child: ElevatedButton(
                    style: btnPrimaryStyle(),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageCategory()));
                    },
                    child: const Text("Ajoutez des catégories"))),
            const SizedBox(height: 50),
            SizedBox(
                child: ElevatedButton(
                    style: btnPrimaryStyle(),
                    onPressed: () {
                      Navigator.pushReplacement(
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminScreen()));
                    },
                    child: const Text("Ajoutez des offres"))),
            const SizedBox(height: 50)
          ])),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()))
        },
        tooltip: "Retour à l'accueil",
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
