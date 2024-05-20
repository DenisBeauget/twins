import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twins_front/services/auth_service.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> createUser({
    required String email,
    required String firstName,
    required String lastName,
    required String birthDate,
    required String zipCode,
    required bool isAdmin,
  }) async {
    if (AuthService.currentUser == null) {
      return false;
    }
    try {
      await _firestore
          .collection('users')
          .doc(AuthService.currentUser?.uid)
          .set({
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': birthDate,
        'zip_code': zipCode,
        'email': email,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        'is_active': true,
        'is_deleted': false,
        'is_confirmed': false,
        'is_subscribed': false,
        'isAdmin': false,
        'subscribed_at': null,
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
