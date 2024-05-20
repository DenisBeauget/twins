import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twins_front/screen/auth_screen.dart';
import 'package:twins_front/screen/connexion_screen.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:twins_front/utils/toaster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:twins_front/widget/dialog.dart';

import '../screen/home_screen.dart';

class AuthController extends ChangeNotifier {
  bool _registerMode = true;

  bool get registerMode => _registerMode;

  set registerMode(bool value) {
    _registerMode = value;
    notifyListeners();
  }

  bool _isPasswordHidden = true;

  bool get isPasswordHidden => _isPasswordHidden;

  set isPasswordHidden(bool value) {
    _isPasswordHidden = value;
    notifyListeners();
  }

  String _email = '';

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get email => _email.trim();

  String _password = '';

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get password => _password;

  String _firstName = '';

  set firstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  String get firstName => _firstName;

  String _lastName = '';

  set lastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  String get lastName => _lastName;

  String _birthDate = '';

  set birthDate(String value) {
    _birthDate = value;
    notifyListeners();
  }

  String get birthDate => _birthDate;

  String _zipCode = '';

  set zipCode(String value) {
    _zipCode = value;
    notifyListeners();
  }

  String get zipCode => _zipCode;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> authenticateWithEmailAndPassword(
      {required BuildContext context}) async {
    // ignore: prefer_interpolation_to_compose_strings
    isLoading = true;
    try {
      if (_registerMode) {
        await AuthService.register(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          birthDate: birthDate,
          zipCode: zipCode,
        );
        Toaster.showSuccessToast(context, AppLocalizations.of(context)!.registration_message);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginScreen()));
      } else {
        await AuthService.login(
          email: email,
          password: password,
        );
        Toaster.showSuccessToast(context, AppLocalizations.of(context)!.sign_in_success);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      Toaster.showFailedToast(context, e.message!.contains("credential is malformed")? AppLocalizations.of(context)!.sign_in_bad_credentials : e.message!);
    } finally {
      isLoading = false;
    }
  }
}
