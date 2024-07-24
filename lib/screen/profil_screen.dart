import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:twins_front/bloc/subscription_bloc.dart';
import 'package:twins_front/bloc/user_bloc.dart';
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
        title: Text(
          AppLocalizations.of(context)!.profil_title,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<UserBloc>(
              create: (context) => UserBloc(UserService())
                ..add(LoadUser(AuthService.currentUser!.uid)),
            ),
            BlocProvider<SubscriptionBloc>(
              create: (context) => SubscriptionBloc()..add(LoadSubscription()),
            ),
          ],
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              return BlocBuilder<SubscriptionBloc, SubscriptionState>(
                builder: (context, subscriptionState) {
                  if (subscriptionState is SubscriptionLoading ||
                      userState is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (subscriptionState is SubscriptionLoaded) {
                    String subscriptionEndDate =
                        subscriptionState.subscription?.endDate != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(subscriptionState.subscription!.endDate)
                            : "";

                    return BlocBuilder<UserBloc, UserState>(
                      builder: (context, userState) {
                        if (userState is UserLoaded) {
                          final data = userState.user;
                          DateTime birthDateAsDate = data.birthDate.toDate();
                          String formattedBirthDate =
                              DateFormat('dd/MM/yyyy').format(birthDateAsDate);

                          return Column(
                            children: [
                              _buildTextItem(context, "Prénom", data.firstName),
                              const SizedBox(height: 5),
                              _buildTextItem(context, "Nom", data.lastName),
                              const SizedBox(height: 5),
                              _buildTextItem(context, "Email", data.email),
                              const SizedBox(height: 5),
                              _buildTextItem(context, "Date de naissance",
                                  formattedBirthDate),
                              const SizedBox(height: 5),
                              _buildTextItem(
                                  context, "Code postal", data.zipCode),
                              const SizedBox(height: 15),
                              if (subscriptionEndDate.isNotEmpty)
                                _buildTextItem(context, "Fin d'abonnement",
                                    subscriptionEndDate),
                              const SizedBox(height: 15),
                              if (subscriptionEndDate.isEmpty)
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await showPaymentModalBottomSheet(
                                            context, null);
                                        BlocProvider.of<SubscriptionBloc>(
                                                context)
                                            .add(LoadSubscription());
                                      },
                                      style: btnPrimaryStyle(context),
                                      child: Text(AppLocalizations.of(context)!
                                          .profil_subscribe),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 15),
                              Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
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
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                      text: AppLocalizations.of(context)!
                                          .profil_disconnect,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          );
                        } else if (userState is UserError) {
                          return Center(
                              child: Text(
                                  'Erreur utilisateur: ${userState.message}'));
                        } else {
                          return const Center(
                              child: Text(
                                  'Erreur lors du chargement de l\'utilisateur'));
                        }
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(
                            'Erreur lors de la mise à jour de l\'abonnement'));
                  }
                },
              );
            },
          ),
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
          Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: TextFormField(
                    readOnly: true,
                    style: TextStyle(fontSize: 18),
                    decoration: inputStyleWithoutFocus(
                        text, context)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
