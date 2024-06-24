import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:twins_front/services/payment_service.dart';
import 'package:twins_front/services/user_service.dart';
import 'package:twins_front/utils/toaster.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'GO !',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildCheckItem(
            AppLocalizations.of(context)!.subscription_argument_first,
          ),
          _buildCheckItem(
            AppLocalizations.of(context)!.subscription_argument_second,
          ),
          _buildCheckItem(
            AppLocalizations.of(context)!.subscription_argument_third,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.subscription_time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.subscription_price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.subscription_argument,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await initPaymentSheet(context);
              try {
                await Stripe.instance.presentPaymentSheet();
                await UserService.subscribeUser(AuthService.currentUser!.uid);
                Toaster.showSuccessToast(context,
                    AppLocalizations.of(context)!.subscription_success);
              } catch (e) {
                Toaster.showFailedToast(
                    context, AppLocalizations.of(context)!.subscription_fail);
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.subscription_button,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.subscription_term,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initPaymentSheet(BuildContext context) async {
    final firstname = AuthService.currentUser?.displayName;
    final email = AuthService.currentUser?.email;

    try {
      final data = await createPaymentIntent(
          amount: '2500', currency: 'eur', firstName: firstname, email: email);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Twins subscription',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
