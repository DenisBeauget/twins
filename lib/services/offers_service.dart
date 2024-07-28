import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twins_front/services/auth_service.dart';
import 'package:twins_front/services/establishments_service.dart';
import 'package:twins_front/utils/toaster.dart';

import '../utils/confetti_controller.dart';

class OffersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot>? _subscription;
  Timer? _cancelTimer;

  Future<List<Offer>> getOffersByEstablishmentID(String establishmentId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('offers').get();
      List<Offer> offers = querySnapshot.docs.map((doc) {
        return Offer.fromDocument(doc);
      }).toList();

      List<Offer> filteredOffers = offers.where((offer) {
        return offer.establishmentId.id.toString() == establishmentId;
      }).toList();

      if (filteredOffers.isEmpty) {
        return filteredOffers;
      }

      for (Offer offer in filteredOffers) {
        if (offer.endDate.isBefore(DateTime.now())) {
          filteredOffers.remove(offer);
          deleteOfferByID(offer.id!);
        }
      }

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
        "description": offer.description,
        "establishment_id": offer.establishmentId
      });

      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteOfferByID(String offerID) async {
    try {
      _firestore.collection('offers').doc(offerID).delete();
      deleteValidatedOffer(offerID);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkOfferAlreadyUsed(String offerId, String userId) async {
    CollectionReference collectionReference = _firestore.collection('used_by');
    try {
      QuerySnapshot querySnapshot = await collectionReference
          .where('user_id', isEqualTo: userId)
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

  Future<String> validateOffer(String offerId, String userID) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('used_by')
          .add({"offer_id": offerId, "user_id": userID});

      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteValidatedOffer(String offerId) async {
    try {
      CollectionReference collectionReference =
          _firestore.collection('used_by');
      QuerySnapshot querySnapshot =
          await collectionReference.where('offer_id', isEqualTo: offerId).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          _firestore.collection('used_by').doc(doc.id).delete();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> startListeningForUsedBy(BuildContext context, Offer offer) async {
    bool isUsed = false;

    final completer = Completer<bool>();

    _subscription = FirebaseFirestore.instance
        .collection('used_by')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        OfferUsedBy offerUsedBy = OfferUsedBy.fromDocument(doc);
        if (offerUsedBy.userId == AuthService.currentUser!.uid &&
            offerUsedBy.offerId == offer.id) {
          Toaster.showSuccessToast('Félicitations, vous venez d\'utiliser l\'offre: ${offer.title} !');
          confettiController.play();

          stopListeningForUsedBy();

          isUsed = true;
          completer.complete(isUsed);
          break;
        }
      }
    });

    _cancelTimer = Timer(const Duration(minutes: 1), () {
      stopListeningForUsedBy();
      isUsed = false;
      if (!completer.isCompleted) {
        completer.complete(isUsed);
      }
    });

    return completer.future;
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
  final String description;
  final DocumentReference establishmentId;
  String? establishmentName;
  String? id;

  Offer(
      {required this.title,
      required this.hightlight,
      required this.establishmentId,
      required this.startDate,
      required this.endDate,
      required this.description,
      this.establishmentName,
      this.id});

  factory Offer.fromDocument(DocumentSnapshot doc) {
    return Offer(
      title: doc['title'],
      hightlight: doc['hightlight'],
      startDate: (doc['start_date'] as Timestamp).toDate(),
      endDate: (doc['end_date'] as Timestamp).toDate(),
      description: (doc['description']),
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
