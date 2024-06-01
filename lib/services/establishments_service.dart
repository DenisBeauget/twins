import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twins_front/services/category_service.dart';

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

  Future<List<Establishment>> getEstablishmentsByCategory(String categoryName) {
    try {
      return getEstablishments().then((establishments) {
        return establishments.where((establishment) {
          return establishment.categoryName == categoryName;
        }).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getEstablishmentIdByName(String? name) async {
    CollectionReference collectionReference =
        _firestore.collection('establishments');
    try {
      QuerySnapshot querySnapshot =
          await collectionReference.where('name', isEqualTo: name).get();

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

  Future<bool> addEstablishment(
      String categorieName, String name, bool? isHightlight) async {
    try {
      List<Establishment> listEstablishment = await getEstablishments();

      for (Establishment establishment in listEstablishment) {
        if (establishment.name.toLowerCase() == name.toLowerCase()) {
          return false;
        }
      }
      String caterogyId =
          await CategoryService().getCategoryIdByName(categorieName);
      DocumentReference categoryReference =
          _firestore.collection('categories').doc(caterogyId);

      _firestore.collection('establishments').doc().set({
        'name': name,
        'categorie_id': categoryReference,
        'hightlight': isHightlight
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteEstablishment(String? name) async {
    try {
      String idToDelete = await getEstablishmentIdByName(name);

      if (idToDelete.isNotEmpty) {
        _firestore.collection('establishments').doc(idToDelete).delete();
        return true;
      }
      return false;
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
