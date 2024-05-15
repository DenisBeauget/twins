import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:twins_front/widget/dialog.dart';

class RegistrationController extends ChangeNotifier {
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
        );
      } else {
        //SignIn
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupDialog(
            title: "Attention",
            content: e.message,
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    } finally {
      isLoading = false;
    }
  }
}
