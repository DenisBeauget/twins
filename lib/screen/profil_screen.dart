import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:twins_front/bloc/subscription_bloc.dart';
import 'package:twins_front/component/payment_modal.dart';
import 'package:twins_front/screen/auth_screen.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:twins_front/services/user_service.dart';
import 'package:twins_front/style/style_schema.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.profil_title,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface))),
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

              return FutureBuilder<CompleteUser?>(
                future: UserService.getCompleteUserByUid(
                    AuthService.currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<CompleteUser?> completeUser) {
                  if (completeUser.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (completeUser.hasError) {
                    return Center(child: Text('Error: ${completeUser.error}'));
                  } else if (completeUser.hasData) {
                    var data = completeUser.data!;
                    DateTime birthDateAsDate = data.birthDate.toDate();
                    String formattedBirthDate =
                        DateFormat('dd/MM/yyyy').format(birthDateAsDate);
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        _buildTextItem(context, "Prénom", data.firstName),
                        const SizedBox(height: 20),
                        _buildTextItem(context, "Nom", data.lastName),
                        const SizedBox(height: 20),
                        _buildTextItem(context, "Email", data.email),
                        const SizedBox(height: 20),
                        _buildTextItem(
                            context, "Date de naissance", formattedBirthDate),
                        const SizedBox(height: 20),
                        _buildTextItem(context, "Code postal", data.zipCode),
                        const SizedBox(height: 20),
                        if (subscriptionEndDate.isNotEmpty)
                          _buildTextItem(
                              context, "Fin d'abonnement", subscriptionEndDate),
                        const SizedBox(height: 15),
                        if (subscriptionEndDate.isEmpty)
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 325,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await showPaymentModalBottomSheet(
                                      context, null);
                                  BlocProvider.of<SubscriptionBloc>(context)
                                      .add(LoadSubscription());
                                },
                                style: btnPrimaryStyle(context),
                                child: Text(
                                  "Je m'abonne !",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 15),
                        Center(
                          child: SizedBox(
                              width: 250,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await AuthService.logout();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AuthScreen()),
                                          (Route<dynamic> route) => false);
                                    },
                                  text: "Se déconnecter",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data'));
                  }
                },
              );
            }

            return const Center(child: Text('Erreur lors de la mise à jour'));
          },
        ),
      ),
    );
  }

  Widget _buildTextItem(BuildContext context, String placeHolder, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              placeHolder,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Icon(
                      Icons.mail_lock_outlined,
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                const SizedBox(width: 5),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
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
