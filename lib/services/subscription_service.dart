import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Future isSubscribed(String uid) async {
    try {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      QuerySnapshot querySnapshot = await _firestore
          .collection('subscription')
          .where('user_id', isEqualTo: userRef)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
