import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future createPaymentIntent(
    {required String currency,
    required String amount,
    required String? firstName,
    required String? lastname,
    required String? email,
    required String customerId}) async {
  final paymentUrl = Uri.parse(dotenv.env["PAYMENT_URL"]!);
  final String? secretKey = dotenv.env["STRIPE_SECRET_KEY"];
  final body = {
    'amount': amount,
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'receipt_email': email,
    'description': 'Twins subscription',
    'setup_future_usage': 'off_session',
    'customer': customerId
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

Future createCustomer(
    {required String firstname,
    required String lastname,
    required String? email}) async {
  final customerUrl = Uri.parse(dotenv.env["CUSTOMER_URL"]!);
  final String? secretKey = dotenv.env["STRIPE_SECRET_KEY"];
  final fullName = firstname + lastname;

  final body = {'name': fullName, 'email': email};

  try {
    final response = await http.post(customerUrl,
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
