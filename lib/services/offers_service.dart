import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:twins_front/main.dart';
import 'package:twins_front/screen/app_screen.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/utils/toaster.dart';

import '../utils/confetti_controller.dart';

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

  Future<Offer?> getOfferById(String offerId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('offers').doc(offerId).get();
      Offer offer = Offer.fromDocument(doc);

      Establishment establishment = await EstablishmentService()
          .getEstablishmentsById(offer.establishmentId.id);
      offer.establishmentName = establishment.name;

      return offer;
    } catch (e) {
      return null;
    }
  }

  Future<int> getOffersCountByEstablishment(String establishmentId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('offers').get();
      List<Offer> offers = querySnapshot.docs.map((doc) {
        return Offer.fromDocument(doc);
      }).toList();

      List<Offer> filteredOffers = offers.where((offer) {
        return offer.establishmentId.id.toString() == establishmentId;
      }).toList();
      return filteredOffers.length;
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

  Future<String> addOfferToSpecificEstablishment(Offer offer) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('offers').add({
        "title": offer.title,
        "start_date": offer.startDate,
        "end_date": offer.endDate,
        "hightlight": offer.hightlight,
        "establishment_id": offer.establishmentId
      });

      return docRef.id;
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

  Future<bool> checkOfferAlreadyUsed(String offerId) async {
    CollectionReference collectionReference = _firestore.collection('used_by');
    try {
      QuerySnapshot querySnapshot = await collectionReference
          .where('user_id', isEqualTo: AuthService.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          if (doc['offer_id'] == offerId) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> validateOffer(String offerId) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('used_by')
          .add({"offer_id": offerId, "user_id": AuthService.currentUser!.uid});

      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  StreamSubscription<QuerySnapshot>? _subscription;
  Timer? _cancelTimer;

  void startListeningForUsedBy(BuildContext context, Offer offer) {
    _subscription = FirebaseFirestore.instance
        .collection('used_by')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        OfferUsedBy offerUsedBy = OfferUsedBy.fromDocument(doc);
        if (offerUsedBy.userId == AuthService.currentUser!.uid &&
            offerUsedBy.offerId == offer.id) {
          Toaster.showSuccessToast(context,
              'Félicitations, vous venez d\'utiliser l\offre: ${offer.title} !');
          confettiController.play();
        }
      }
    });

    _cancelTimer = Timer(const Duration(minutes: 10), () {
      stopListeningForUsedBy();
    });
  }

  void stopListeningForUsedBy() {
    _subscription?.cancel();
    _cancelTimer?.cancel();
  }
}

class Offer {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool hightlight;
  final DocumentReference establishmentId;
  String? establishmentName;
  String? id;

  Offer(
      {required this.title,
      required this.hightlight,
      required this.establishmentId,
      required this.startDate,
      required this.endDate,
      this.establishmentName,
      this.id});

  factory Offer.fromDocument(DocumentSnapshot doc) {
    return Offer(
      title: doc['title'],
      hightlight: doc['hightlight'],
      startDate: (doc['start_date'] as Timestamp).toDate(),
      endDate: (doc['end_date'] as Timestamp).toDate(),
      establishmentId: doc['establishment_id'],
      id: doc.id,
    );
  }

  @override
  String toString() {
    return title;
  }
}

class OfferUsedBy {
  final String userId;
  final String offerId;

  String? id;

  OfferUsedBy({required this.userId, required this.offerId, this.id});

  factory OfferUsedBy.fromDocument(DocumentSnapshot doc) {
    return OfferUsedBy(
      offerId: doc['offer_id'],
      userId: doc['user_id'],
      id: doc.id,
    );
  }
}
