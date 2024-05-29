import 'package:flutter/material.dart';
import 'package:twins_front/screen/manage_category.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/utils/toaster.dart';

class Popup {
  static void showPopupForDeleteCategory(
      BuildContext context, String? categoryName, Function onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: lightColorScheme.primaryContainer,
          title: const Text(
            'Supprimer la catégorie ?',
            style: TextStyle(color: Colors.black),
          ),
          content: Text('Tu as sélectioné : $categoryName',
              style: const TextStyle(color: Colors.black)),
          actions: <Widget>[
            Row(children: [
              TextButton(
                style: btnTextPrimaryStyle(),
                child: const Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 10),
              TextButton(
                style: btnTextPrimaryStyle(),
                child: const Text('Supprimer'),
                onPressed: () async {
                  if (await CategoryService().deleteCategory(categoryName)) {
                    Toaster.showSuccessToast(context, "Catégorie supprimer");
                    onDelete();
                    Navigator.of(context).pop();
                  } else {
                    Toaster.showFailedToast(
                        context, "Erreur pendant la suppression");
                    Navigator.of(context).pop();
                  }
                },
              ),
            ]),
          ],
        );
      },
    );
  }

  static void showPopupForDeleteEstablishment(
      BuildContext context, String? etablissementName, Function onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: lightColorScheme.primaryContainer,
          title: const Text(
            "Supprimer l'établissement ?",
            style: TextStyle(color: Colors.black),
          ),
          content: Text('Tu as sélectioné : $etablissementName',
              style: const TextStyle(color: Colors.black)),
          actions: <Widget>[
            Row(children: [
              TextButton(
                style: btnTextPrimaryStyle(),
                child: const Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 10),
              TextButton(
                style: btnTextPrimaryStyle(),
                child: const Text('Supprimer'),
                onPressed: () async {
                  if (await EstablishmentService()
                      .deleteEstablishment(etablissementName)) {
                    Toaster.showSuccessToast(context, "Etablissement supprimé");
                    onDelete(context, true);
                    Navigator.of(context).pop();
                  } else {
                    Toaster.showFailedToast(
                        context, "Erreur pendant la suppression");
                    Navigator.of(context).pop();
                  }
                },
              ),
            ]),
          ],
        );
      },
    );
  }

  static void showPopup(BuildContext context, String any) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your text here'),
          content: Text('You selected: $any'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Action'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
