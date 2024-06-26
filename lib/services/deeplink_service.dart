import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

import '../screen/validate_offer_screen.dart';

class DeeplinkService {
  static void handleDeepLink(BuildContext context) async {
    try {
      final Uri? initialUri = await getInitialUri();
      if (initialUri != null) {
        _processUri(initialUri, context);
      }
    } on Exception {
      // Handle exception
    }

    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _processUri(uri, context);
      }
    }, onError: (Object err) {
      // Handle exception
    });
  }

  static void _processUri(Uri uri, BuildContext context) async {
    final String path = uri.path;

    if (path == '/validateOffer') {
      final String? offerId = uri.queryParameters['offerId'];
      final String? userId = uri.queryParameters['userId'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ValidateOfferScreen(offerId: offerId!, userId: userId!),
        ),
      );
    }
  }
}
