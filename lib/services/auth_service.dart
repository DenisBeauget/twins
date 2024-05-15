import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final _auth = FirebaseAuth.instance;

  static Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
}
