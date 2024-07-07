import 'package:flutter/material.dart';
import 'package:twins_front/screen/establishment_screen.dart';
import 'package:twins_front/screen/payment_screen.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/services/offers_service.dart';

Future<Offer?> showPaymentModalBottomSheet(BuildContext context, [Offer? offerCallback]) async {
  final Offer? result = await showModalBottomSheet<Offer>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.8,
        maxChildSize: 0.95,
        builder: (BuildContext context, ScrollController scrollController) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: PrimaryScrollController(
                  controller: scrollController,
                  child: PaymentScreen(offerEntry: offerCallback)
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
  return result;
}
