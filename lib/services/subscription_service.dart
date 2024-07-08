import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class SubscriptionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future subscribeUser(String uid, String customerId) async {
    try {
      DocumentReference userReference =
          FirebaseFirestore.instance.collection('users').doc(uid);

      _firestore.collection('subscription').doc().set({
        'user_id': userReference,
        'customer_id': customerId,
        'start_date': Timestamp.fromDate(DateTime.now()),
        'end_date': Timestamp.fromDate(DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day))
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> isSubscribed() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DocumentReference userRef =
        _firestore.collection('users').doc(auth.currentUser!.uid);

    CollectionReference collectionReference =
        _firestore.collection('subscription');
    try {
      QuerySnapshot querySnapshot =
          await collectionReference.where('user_id', isEqualTo: userRef).get();
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Subscription?> getSubscription() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DocumentReference userRef =
        _firestore.collection('users').doc(auth.currentUser!.uid);

    CollectionReference collectionReference =
        _firestore.collection('subscription');
    try {
      QuerySnapshot querySnapshot =
          await collectionReference.where('user_id', isEqualTo: userRef).get();
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;

        Timestamp endDateTimestamp = doc['end_date'];
        return Subscription(endDate: endDateTimestamp.toDate());
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}

class Subscription {
  final DateTime endDate;

  Subscription({required this.endDate});
}
