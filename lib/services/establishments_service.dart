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
