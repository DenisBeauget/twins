import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twins_front/utils/popup.dart';

import '../component/establishment_details.dart';
import '../services/offers_service.dart';

class FeaturedCard extends StatelessWidget {
  final Establishment establishment;

  FeaturedCard({super.key, required this.establishment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showTransparentModalBottomSheet(context, establishment);
      },
      child: Container(
        width: 160,
        height: 200,
        margin: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  establishment.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              establishment.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (establishment.categoryName != null)
              Text(
                establishment.categoryName!,
              ),
          ],
        ),
      ),
    );
  }
}

class FeaturedCardSmall extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? categoryName;

  const FeaturedCardSmall(
      {super.key,
      required this.imageUrl,
      required this.title,
      this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 10,
      margin: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (categoryName != null)
            Text(
              categoryName!,
            ),
        ],
      ),
    );
  }
}

class FeaturedCardBig extends StatelessWidget {
  final Establishment establishment;

  const FeaturedCardBig({super.key, required this.establishment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showTransparentModalBottomSheet(context, establishment);
      },
      child: Container(
        width: 160,
        height: 200,
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      establishment.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.black.withOpacity(0.5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      establishment.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      establishment.categoryName ?? 'Unknown',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              renderOffers(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget renderOffers(BuildContext context) {
    int offerCount = establishment.offers.length;
    return Text(
      offerCount != 0
          ? AppLocalizations.of(context)!.offer_available(offerCount)
          : AppLocalizations.of(context)!.no_offer_available,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }
}

class FeaturedCardOfferAdmin extends StatelessWidget {
  final Offer offer;

  const FeaturedCardOfferAdmin({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = AppLocalizations.of(context)!.start_date +
        DateFormat('dd-MM-yyyy').format(offer.startDate);
    String formattedEndDate = AppLocalizations.of(context)!.end_date +
        DateFormat('dd-MM-yyyy').format(offer.endDate);
    return Container(
        margin: const EdgeInsets.only(left: 16),
        width: 300,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, top: 5),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      formattedStartDate,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      formattedEndDate,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                AppLocalizations.of(context)!.offer_card_hightlight,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              Checkbox(
                activeColor: Colors.white,
                checkColor: lightColorScheme.surfaceTint,
                value: offer.hightlight,
                onChanged: null,
              ),
            ],
          ),
        ));
  }
}

class FeaturedCardOffer extends StatelessWidget {
  final Offer offer;

  const FeaturedCardOffer({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = AppLocalizations.of(context)!.start_date +
        DateFormat('dd-MM-yyyy').format(offer.startDate);
    String formattedEndDate = AppLocalizations.of(context)!.end_date +
        DateFormat('dd-MM-yyyy').format(offer.endDate);

    return Container(
      margin: const EdgeInsets.all(16),
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  offer.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )),
                const SizedBox(height: 8.0),
                Text(
                  'Profite d’une bière offerte chez lfrefrefreferferferforkrfkrekorekoorfeofrealalala',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedEndDate,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.offer_card_bt,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
