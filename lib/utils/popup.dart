import 'package:flutter/material.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:twins_front/utils/toaster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Popup {
  static Future<bool> showPopupForDelete(
      BuildContext context, String title, String description) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Center(
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20))),
          content: Text(description),
          actions: [
            ElevatedButton(
              style: btnDialogStyleCancel(),
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.popup_cancel_bt),
            ),
            ElevatedButton(
              style: btnDialogStyle(),
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.popup_delete_bt),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
