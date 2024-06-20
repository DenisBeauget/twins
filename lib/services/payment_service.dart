import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future createPaymentIntent(
    {required String name,
    required String adresss,
    required String pin,
    required String city,
    required String state,
    required String country,
    required String currency,
    required String amount}) async {
  final paymentUrl = Uri.parse(dotenv.env["PAYMENT_URL"]!);
  final String? secretKey = dotenv.env["STRIPE_SECRET_KEY"];

  final response = await http.post(paymentUrl,
      headers: {
        "Authorization": "Bearer $secretKey",
        "Content-type": 'application/x-www-form-urlencoded'
      },
      body: "any");

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    print(json);
  } else {
    print("nul");
  }
}
