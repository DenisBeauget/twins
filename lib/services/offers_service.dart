import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twins_front/services/establishments_service.dart';

class OffersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Offer>> getOffersByEstablishment(String name) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('offers').get();
      List<Offer> offers = querySnapshot.docs.map((doc) {
        return Offer.fromDocument(doc);
      }).toList();

      for (var offer in offers) {
        DocumentSnapshot establishmentName = await offer.establishmentId.get();
        offer.establishmentName = establishmentName['name'];
      }

      List<Offer> filteredOffers = offers.where((offer) {
        return offer.establishmentName == name;
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
      String establishmentName,
      String offerTitle,
      DateTime startDate,
      DateTime endDate,
      bool isHighlight) async {
    try {
      Establishment establishment = await EstablishmentService()
          .getEstablishmentByName(establishmentName);

      String establishmentId = establishment.id!;

      if (establishmentId.isEmpty) {
        return false;
      }

      _firestore.collection('offers').doc().set({
        "title": offerTitle,
        "start_date": startDate,
        "end_date": endDate,
        "hightlight": isHighlight,
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
      startDate: doc['start_date'],
      endDate: doc['end_date'],
      establishmentId: doc['establishment_id'],
    );
  }
}
