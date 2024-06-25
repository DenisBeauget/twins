import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twins_front/change/auth_controller.dart';
import 'package:twins_front/services/auth_service.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> createUser({
    required String email,
    required String firstName,
    required String lastName,
    required Timestamp birthDate,
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
        'isAdmin': false
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> initializetUserAttributes(
      String uid, BuildContext context) async {
    try {
      DocumentSnapshot userAttributes =
          await _firestore.collection('users').doc(uid).get();
      Provider.of<AuthController>(context, listen: false).isAdmin =
          userAttributes['isAdmin'];
      Provider.of<AuthController>(context, listen: false).firstName =
          userAttributes['first_name'];
      return userAttributes.data() as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> userEmailExists(String email) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
