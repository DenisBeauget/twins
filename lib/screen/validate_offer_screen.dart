import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twins_front/screen/app_screen.dart';
import 'package:twins_front/services/offers_service.dart';
import 'package:twins_front/services/user_service.dart';
import 'package:twins_front/utils/toaster.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../style/style_schema.dart';

class ValidateOfferScreen extends StatelessWidget {
  final String offerId;
  final String userId;

  const ValidateOfferScreen({
    super.key,
    required this.offerId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>const  AppScreen(),
              ),
            );
          },
        ),
        title: Text(AppLocalizations.of(context)!.offer_validation_title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: returnContent(context, offerId, userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data!;
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<Widget> returnContent(
    BuildContext context, String offerId, String userId) async {
  BasicUser? user = await UserService.getUserByUid(userId);

  if (user == null) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Text(
              AppLocalizations.of(context)!.offer_validation_user_not_found,
              style: const TextStyle(fontSize: 16)),
        ));
  }

  OffersService offersService = OffersService();

  Offer? offer = await offersService.getOfferById(offerId);

  if (offer == null) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text(AppLocalizations.of(context)!.offer_not_found,
              style: const TextStyle(fontSize: 16)),
        ));
  }

  if (offer.endDate.isBefore(DateTime.now())) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Text(AppLocalizations.of(context)!.offer_validation_offer_expired,
              style: const TextStyle(fontSize: 16)),
        ));
  }

  bool alreadyUse = await offersService.checkOfferAlreadyUsed(offerId);

  if (alreadyUse) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Text(
              AppLocalizations.of(context)!.offer_validation_offer_already_used,
              style: const TextStyle(fontSize: 16)),
        ));
  } else {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                border: Border.all(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    width: 20),
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 40),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.offer_validation_warning,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildOffer(context, offer),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildUser(context, user),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            child: ElevatedButton(
              style: btnPrimaryStyle(),
              onPressed: () async {
                try {
                  await offersService.validateOffer(offerId);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppScreen(),
                    ),
                  );
                  Toaster.showSuccessToast(context, AppLocalizations.of(context)!.offer_validation_success);
                } catch (e) {
                  Toaster.showFailedToast(context, AppLocalizations.of(context)!.offer_validation_fail);
                }
              },
              child: Text(
                AppLocalizations.of(context)!.offer_validation_bt,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildUser(BuildContext context, BasicUser user) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(AppLocalizations.of(context)!.offer_validation_user_card_title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(AppLocalizations.of(context)!.offer_validation_card_name(user.displayName)
          , style: const TextStyle(fontSize: 16)),
      Text(AppLocalizations.of(context)!.offer_validation_user_card_email(user.email), style: TextStyle(fontSize: 16)),
    ],
  );
}

Widget buildOffer(BuildContext context, Offer offer) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(AppLocalizations.of(context)!.offer_validation_offer_card_title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(AppLocalizations.of(context)!.offer_validation_card_name(offer.title), style: TextStyle(fontSize: 16)),
      Text(AppLocalizations.of(context)!.offer_validation_offer_card_establishment(offer.establishmentName!),
          style: const TextStyle(fontSize: 16)),
    ],
  );
}
