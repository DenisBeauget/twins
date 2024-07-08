import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/bloc/subscription_bloc.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/component/payment_modal.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firstname =
        Provider.of<AuthController>(context, listen: false).firstName;
    final lastname =
        Provider.of<AuthController>(context, listen: false).lastName;
    final email = AuthService.currentUser?.email;
    final birthdate =
        Provider.of<AuthController>(context, listen: false).birthDate;
    final zipcode = Provider.of<AuthController>(context, listen: false).zipCode;

    DateTime birthDateAsDate = birthdate.toDate();
    String formattedBirthDate =
        DateFormat('dd/MM/yyyy').format(birthDateAsDate);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mon profil"),
      ),
      body: BlocProvider(
        create: (context) => SubscriptionBloc()..add(LoadSubscription()),
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SubscriptionLoaded) {
              String subscriptionEndDate = state.isSubscribed &&
                      state.subscription != null
                  ? DateFormat('dd/MM/yyyy').format(state.subscription!.endDate)
                  : "";

              return ListView(
                shrinkWrap: true,
                children: [
                  _buildTextItem(context, "Prénom", firstname),
                  const SizedBox(height: 20),
                  _buildTextItem(context, "Nom", lastname),
                  const SizedBox(height: 20),
                  _buildTextItem(context, "Email", email!),
                  const SizedBox(height: 20),
                  _buildTextItem(
                      context, "Date de naissance", formattedBirthDate),
                  const SizedBox(height: 20),
                  _buildTextItem(context, "Code postal", zipcode),
                  const SizedBox(height: 20),
                  if (subscriptionEndDate.isNotEmpty)
                    _buildTextItem(
                        context, "Fin d'abonnement", subscriptionEndDate),
                  const SizedBox(height: 20),
                  if (subscriptionEndDate.isEmpty)
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () async {
                            await showPaymentModalBottomSheet(context, null);
                            context
                                .read<SubscriptionBloc>()
                                .add(LoadSubscription());
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            "Je m'abonne !",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            return const Center(child: Text("Une erreur s'est produite"));
          },
        ),
      ),
    );
  }

  Widget _buildTextItem(BuildContext context, String placeHolder, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            placeHolder,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.output,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
