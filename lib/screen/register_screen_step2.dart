import 'package:flutter/material.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/screen/connexion_screen.dart';
import 'package:twins_front/utils/toaster.dart';
import 'package:twins_front/utils/validador.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../style/style_schema.dart';

class SignUpScreenStep2 extends StatefulWidget {
  final String email;
  final String password;

  const SignUpScreenStep2(
      {super.key, required this.email, required this.password});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenStep2State createState() => _SignUpScreenStep2State();
}

class _SignUpScreenStep2State extends State<SignUpScreenStep2> {
  late final GlobalKey<FormState> formKey;
  final _firstnameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _registrationController = AuthController();

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey();
    _registrationController.email = widget.email;
    _registrationController.password = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                    flex: 3,
                    child: Center(
                      child: appLogo(200),
                    )),
                Expanded(
                  flex: 7,
                  child: Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .registration_title_step2,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                              controller: _firstnameController,
                              decoration: inputStyle(
                                  AppLocalizations.of(context)!
                                      .first_name_placeholder,
                                  Icons.person_outlined),
                              onChanged: (value) {
                                _registrationController.firstName = value;
                              }),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _surnameController,
                            decoration: inputStyle(
                                AppLocalizations.of(context)!
                                    .last_name_placeholder,
                                Icons.person_outlined),
                            onChanged: (value) {
                              _registrationController.lastName = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                              controller: _birthDateController,
                              decoration: inputStyle(
                                  AppLocalizations.of(context)!
                                      .birthdate_placeholder,
                                  Icons.badge_outlined),
                              onChanged: (value) {
                                _registrationController.birthDate = value;
                              }),
                          const SizedBox(height: 20),
                          TextFormField(
                              controller: _zipCodeController,
                              decoration: inputStyle(
                                  AppLocalizations.of(context)!
                                      .zipcode_placeholder,
                                  Icons.home_outlined),
                              onChanged: (value) {
                                _registrationController.zipCode = value;
                              }),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {
                                registration(context);
                              },
                              style: btnPrimaryStyle(),
                              child: Text(AppLocalizations.of(context)!
                                  .register_button_finish),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void registration(BuildContext context) {
    if (_firstnameController.text == "" ||
        _surnameController.text == "" ||
        _birthDateController.text == "" ||
        _zipCodeController.text == "") {
      Toaster.showFailedToast(context, "One or many fields are empty");
    } else {
      _registrationController.authenticateWithEmailAndPassword(
          context: context);
    }
  }
}
