import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future createPaymentIntent(
    {required String currency,
    required String amount,
    required String? firstName,
    required String? lastname,
    required String? email}) async {
  final paymentUrl = Uri.parse(dotenv.env["PAYMENT_URL"]!);
  final String? secretKey = dotenv.env["STRIPE_SECRET_KEY"];
  final body = {
    'amount': amount,
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'receipt_email': email,
    'metadata[name]': "$firstName $lastname",
    'description': 'Twins subscription'
  };

  try {
    final response = await http.post(paymentUrl,
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-type": 'application/x-www-form-urlencoded'
        },
        body: body);

    var json = jsonDecode(response.body);
    return json;
  } catch (e) {
    rethrow;
  }
}
