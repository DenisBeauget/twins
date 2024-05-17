import 'package:flutter/material.dart';
import 'package:twins_front/change/registration_controller.dart';
import 'package:twins_front/utils/validador.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../style/style_schema.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final GlobalKey<FormState> formKey;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _registrationController = RegistrationController();

  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
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
                        AppLocalizations.of(context)!.registration_title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: inputStyle(
                          AppLocalizations.of(context)!.email_placeholder,
                          Icons.email_outlined),
                      validator: Validator.emailValidator,
                      onChanged: (newValue) {
                        _registrationController.email = newValue;
                      },
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: inputStyle(
                          AppLocalizations.of(context)!.password_placeholder,
                          Icons.lock_outline),
                      validator: Validator.passwordValidator,
                      onChanged: (newValue) {
                        _registrationController.password = newValue;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: inputStyle(
                          AppLocalizations.of(context)!
                              .confirm_password_placeholder,
                          Icons.lock_outline),
                      validator: Validator.passwordValidator,
                      onChanged: (newValue) {
                        _registrationController.password = newValue;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onChanged: (bool? value) {
                            setState(() {
                              _termsAccepted = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!
                                .register_conditions,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          registration(context);
                        },
                        style: btnPrimaryStyle(),
                        child: Text(AppLocalizations.of(context)!.register_button),
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
    );
  }

  void registration(BuildContext context) {
    if (_termsAccepted) {
      _registrationController.authenticateWithEmailAndPassword(
          context: context);
    }
  }
}
