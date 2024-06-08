import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twins_front/services/establishments_service.dart';

class OffersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Offer>> getOffersByEstablishment(String establishmentId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('offers').get();
      List<Offer> offers = querySnapshot.docs.map((doc) {
        return Offer.fromDocument(doc);
      }).toList();

      List<Offer> filteredOffers = offers.where((offer) {
        return offer.establishmentId.id.toString() == establishmentId;
      }).toList();
      return filteredOffers;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getOfferIdByTitle(String title) async {
    CollectionReference collectionReference = _firestore.collection('offers');
    try {
      QuerySnapshot querySnapshot =
          await collectionReference.where('title', isEqualTo: title).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          return doc.id;
        }
      }
      return "";
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addOfferToSpecificEstablishment(
      Offer offer, String establishmentName) async {
    try {
      Establishment establishment = await EstablishmentService()
          .getEstablishmentByName(establishmentName);

      String establishmentId = establishment.id!;

      if (establishmentId.isEmpty) {
        return false;
      }

      _firestore.collection('offers').doc().set({
        "title": offer.title,
        "start_date": offer.startDate,
        "end_date": offer.endDate,
        "hightlight": offer.hightlight,
        "establishment_id": establishmentId
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteOfferFromSpecificEstablishment(String offerTitle) async {
    try {
      String offerId = await getOfferIdByTitle(offerTitle);

      if (offerId.isNotEmpty) {
        _firestore.collection('offers').doc(offerId).delete();
        return true;
      }
      return false;
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
      startDate: (doc['start_date'] as Timestamp).toDate(),
      endDate: (doc['end_date'] as Timestamp).toDate(),
      establishmentId: doc['establishment_id'],
    );
  }

  @override
  String toString() {
    return title;
  }
}
