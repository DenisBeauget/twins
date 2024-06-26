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
      DocumentSnapshot subscription = await FirebaseFirestore.instance
          .collection('subscription')
          .doc(uid)
          .get();
      return subscription.exists;
    } catch (e) {
      rethrow;
    }
  }
}
