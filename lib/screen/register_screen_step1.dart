import 'package:flutter/material.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/screen/register_screen_step2.dart';
import 'package:twins_front/services/user_service.dart';
import 'package:twins_front/utils/toaster.dart';
import 'package:twins_front/utils/validador.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../style/style_schema.dart';

class SignUpScreenStep1 extends StatefulWidget {
  const SignUpScreenStep1({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenStep1State createState() => _SignUpScreenStep1State();
}

class _SignUpScreenStep1State extends State<SignUpScreenStep1> {
  late final GlobalKey<FormState> formKey;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
                          ),
                          const SizedBox(height: 50),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: inputStyle(
                                AppLocalizations.of(context)!
                                    .password_placeholder,
                                Icons.lock_outline),
                            validator: Validator.passwordValidator,
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
                              child: Text(AppLocalizations.of(context)!
                                  .register_button),
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
    _emailController.text = _emailController.text.trim();
    _passwordController.text = _passwordController.text.trim();

    String? checkedEmail = Validator.emailValidator(_emailController.text);
    String? checkedPassword =
        Validator.passwordValidator(_passwordController.text);

    if (checkedEmail != null) {
      Toaster.showFailedToast(context, checkedEmail);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Toaster.showFailedToast(
          context, AppLocalizations.of(context)!.password_not_match);
      return;
    }

    if (checkedPassword != null) {
      Toaster.showFailedToast(context, checkedPassword);
      return;
    }

    if (_termsAccepted) {

      // verify if email is already registered
      UserService.userEmailExists(_emailController.text).then((value) {
        if (value) {
          Toaster.showFailedToast(
              context, AppLocalizations.of(context)!.email_already_exist);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpScreenStep2(
                  email: _emailController.text,
                  password: _passwordController.text),
            ),
          );
        }
      });
    } else {
      Toaster.showFailedToast(
          context, AppLocalizations.of(context)!.check_register_conditions);
    }
  }
}
