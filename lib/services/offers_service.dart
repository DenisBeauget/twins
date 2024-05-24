import 'package:cloud_firestore/cloud_firestore.dart';

class OffersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Offer>> getOffersByEstablishment(String keyword) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('offres').get();
      List<Offer> offers = querySnapshot.docs.map((doc) {
        return Offer.fromDocument(doc);
      }).toList();

      // Fetch establishment name for each establishment
      for (var offer in offers) {
        DocumentSnapshot establishmentName = await offer.establishmentId.get();
        offer.establishmentName = establishmentName['name'];
      }

      // Filter offers based on establishmentName
      List<Offer> filteredOffers = offers.where((offer) {
        return offer.establishmentName == keyword;
      }).toList();

      return filteredOffers;
    } catch (e) {
      rethrow;
    }
  }
}

class Offer {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool hightlight;
  final DocumentReference establishmentId;
  String? establishmentName;

  Offer(
      {required this.title,
      required this.hightlight,
      required this.establishmentId,
      required this.startDate,
      required this.endDate,
      this.establishmentName});

  factory Offer.fromDocument(DocumentSnapshot doc) {
    return Offer(
      title: doc['title'],
      hightlight: doc['hightlight'],
      startDate: doc['start_date'],
      endDate: doc['end_date'],
      establishmentId: doc['establishment_id'],
    );
  }
}
