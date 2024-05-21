import 'package:cloud_firestore/cloud_firestore.dart';

class EstablishmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Establishment>> getEstablishments() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('establishments').get();
      List<Establishment> establishments = querySnapshot.docs.map((doc) {
        return Establishment.fromDocument(doc);
      }).toList();

      // Fetch categories for each establishment
      for (var establishment in establishments) {
        DocumentSnapshot categoryDoc = await establishment.categoryId.get();
        establishment.categoryName = categoryDoc['name'];
      }
      return establishments;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Establishment>> searchEstablishments(String keyword) async {
    try {
      List<Establishment> establishments = await getEstablishments();

      List<Establishment> filteredEstablishments =
          establishments.where((establishment) {
        return establishment.name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();

      return filteredEstablishments;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Establishment>> searchHighLightEstablishments(
      String keyword) async {
    try {
      List<Establishment> establishments = await getEstablishments();

      List<Establishment> filteredEstablishments =
          establishments.where((establishment) {
        return establishment.name
                .toLowerCase()
                .contains(keyword.toLowerCase()) &&
            establishment.hightlight;
      }).toList();

      return filteredEstablishments;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Establishment>> getHighLightEstablishments() async {
    try {
      List<Establishment> establishments = await getEstablishments();

      List<Establishment> filteredHighlightEstablishments =
          establishments.where((establishment) {
        return establishment.hightlight;
      }).toList();

      return filteredHighlightEstablishments;
    } catch (e) {
      rethrow;
    }
  }
}

class Establishment {
  final String name;
  final bool hightlight;
  final DocumentReference categoryId;
  String? categoryName;

  Establishment(
      {required this.name,
      required this.hightlight,
      required this.categoryId,
      this.categoryName});

  factory Establishment.fromDocument(DocumentSnapshot doc) {
    return Establishment(
      name: doc['name'],
      hightlight: doc['hightlight'],
      categoryId: doc['categorie_id'],
    );
  }
}
