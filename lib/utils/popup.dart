import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:twins_front/services/offers_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/auth_service.dart';

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

  static showValidateOffer(BuildContext context, Offer offer) {

    OffersService().startListeningForUsedBy(context, offer);

    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    QrCode qrCode = QrCode.fromData(
      data: 'mytwins://com.twins.twins/validateOffer?offerId=${offer.id}&userId=${AuthService.currentUser!.uid}',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    QrImage qrImage = QrImage(qrCode);

    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,

      confirmBtnColor: Theme.of(context).colorScheme.inversePrimary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      widget: Column(
        children: [
          Text(AppLocalizations.of(context)!.gr_code_offer_message),
          Padding(
            padding: const EdgeInsets.all(15),
            child: PrettyQrView(
              decoration: PrettyQrDecoration(
                shape: PrettyQrSmoothSymbol(
                  roundFactor: 1,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                image: PrettyQrDecorationImage(
                  image: AssetImage(isDarkMode? 'assets/img/twins_logo_w.png' :'assets/img/twins_logo.png'),
                ),
              ), qrImage: qrImage,
            ),
          ),
        ],
      ),
      barrierDismissible: false,
      confirmBtnText: 'Ok',
      onConfirmBtnTap: () async {
        Navigator.pop(context);
      },
    );
  }
}
