import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/screen/auth_screen.dart';
import 'package:twins_front/screen/home_screen.dart';
import 'package:twins_front/style/style_schema.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:twins_front/utils/toaster.dart';

import 'app_screen.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pushAndRemoveUntil(
            context,
            _createRoute(const AuthScreen()),
                (route) => false,
          );
          },
        ),
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
                      child: appLogoGreen(200),
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
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputStyle(
                              AppLocalizations.of(context)!.email_placeholder,
                              IconsaxPlusLinear.sms),
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
                              IconsaxPlusLinear.password_check),
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
                            style: btnPrimaryStyle(context),
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
      _authController
          .authenticateWithEmailAndPassword(context: context)
          .then((value) {
        if (value == "success") {
          Toaster.showSuccessToast(
              AppLocalizations.of(context)!.sign_in_success);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppScreen()),
              (route) => false);
        } else {
          Toaster.showFailedToast(
              value.contains("credential is malformed")
                  ? AppLocalizations.of(context)!.sign_in_bad_credentials
                  : value);
        }
      });
    } catch (e) {
      Toaster.showFailedToast(e.toString());
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

}
