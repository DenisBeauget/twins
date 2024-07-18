import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:twins_front/services/payment_service.dart';
import 'package:twins_front/services/subscription_service.dart';
import 'package:twins_front/utils/toaster.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/subscription_bloc.dart';
import '../services/offers_service.dart';

class PaymentScreen extends StatelessWidget {
  final Offer? offerEntry;

  const PaymentScreen({super.key, this.offerEntry});

  @override
  Widget build(BuildContext context) {
    SubscriptionBloc subscriptionBloc =
        BlocProvider.of<SubscriptionBloc>(context);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
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
                String customerId = await initPaymentSheet(context);
                try {
                  await Stripe.instance.presentPaymentSheet();
                  await SubscriptionService.subscribeUser(
                      AuthService.currentUser!.uid, customerId);
                  subscriptionBloc.add(LoadSubscription());
                  Toaster.showSuccessToast(AppLocalizations.of(context)!.subscription_success);
                  Navigator.of(context).pop(offerEntry);
                } catch (e) {
                  Toaster.showFailedToast(AppLocalizations.of(context)!.subscription_fail);
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

  Future<String> initPaymentSheet(BuildContext context) async {
    final firstname =
        Provider.of<AuthController>(context, listen: false).firstName;
    final lastname =
        Provider.of<AuthController>(context, listen: false).lastName;
    final email = AuthService.currentUser?.email;

    try {
      final customerData = await createCustomer(
          firstname: firstname, lastname: lastname, email: email);
      final data = await createPaymentIntent(
          amount: '2500',
          currency: 'eur',
          firstName: firstname,
          lastname: lastname,
          email: email,
          customerId: customerData['id']);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Twins subscription',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: customerData['id'],
          style: ThemeMode.dark,
        ),
      );
      return customerData['id'];
    } catch (e) {
      rethrow;
    }
  }
}
