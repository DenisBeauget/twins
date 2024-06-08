import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twins_front/services/user_service.dart';

import '../screen/auth_screen.dart';

class AuthService {
  AuthService._();

  static final _auth = FirebaseAuth.instance;

  static Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required Timestamp birthDate,
    required String zipCode,
    required bool isAdmin,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AuthService.currentUser?.sendEmailVerification();
      await UserService.createUser(
        email: email,
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        zipCode: zipCode,
        isAdmin: isAdmin,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!credential.user!.emailVerified) {
        logout();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email not verified',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get userStream => _auth.authStateChanges();

  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> userAlreadyExists(BuildContext context) async {
    try {
      UserService.userEmailExists(currentUser!.email!).then((value) {
        if (!value) {
          logout().whenComplete(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()));
          });
        }
      });
    } catch (e) {
      logout().whenComplete(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()));
      });
    }
  }
}