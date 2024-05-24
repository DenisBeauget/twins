import 'package:flutter/material.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/screen/home_screen.dart';
import 'package:twins_front/style/style_schema.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twins_front/utils/toaster.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

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
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: appLogo(200),
                    )),
                Expanded(
                  flex: 7,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            AppLocalizations.of(context)!.sign_in_title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: inputStyle(
                              AppLocalizations.of(context)!.email_placeholder,
                              Icons.email_outlined),
                          onChanged: (newValue) {
                            _authController.email = newValue;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: inputStyle(
                              AppLocalizations.of(context)!
                                  .sign_in_password_placeholder,
                              Icons.lock_outline),
                          onChanged: (newValue) {
                            _authController.password = newValue;
                          },
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              _login(context);
                            },
                            style: btnPrimaryStyle(),
                            child: Text(
                                AppLocalizations.of(context)!.sign_in_button),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context) async {
    _authController.registerMode = false;
    try {
      _authController.authenticateWithEmailAndPassword(context: context);
    } catch (e) {
      Toaster.showFailedToast(context, e.toString());
    }
  }
}
