import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twins_front/services/category_service.dart';
import 'package:twins_front/services/storage_service.dart';

class EstablishmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final StorageService storageService = StorageService();

  Future<List<Establishment>> getEstablishments() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('establishments').get();
      List<Establishment> establishments = querySnapshot.docs.map((doc) {
        return Establishment.fromDocument(doc);
      }).toList();

      // Fetch categories for each establishment
      for (Establishment establishment in establishments) {
        try {
          DocumentSnapshot categoryDoc =
          await establishment.categoryId!.get();
          establishment.categoryName = categoryDoc['name'];
        } catch (e) {
          establishment.categoryName = 'Unknown';
        }
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

  Future<Establishment> getEstablishmentByName(String? name) async {
    CollectionReference collectionReference =
        _firestore.collection('establishments');
    try {
      QuerySnapshot querySnapshot =
          await collectionReference.where('name', isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          return Establishment.fromDocument(doc);
        }
      }
      return Establishment(
          name: 'Unknown', hightlight: false, imageUrl: 'Unknown', imageName: 'Unknown');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addEstablishment(Establishment establishmentToAdd) async {
    try {
      List<Establishment> listEstablishment = await getEstablishments();

      for (Establishment establishment in listEstablishment) {
        if (establishment.name.toLowerCase() ==
            establishmentToAdd.name.toLowerCase()) {
          return false;
        }
      }
      String caterogyId = await CategoryService()
          .getCategoryIdByName(establishmentToAdd.categoryName);
      DocumentReference categoryReference =
          _firestore.collection('categories').doc(caterogyId);

      _firestore.collection('establishments').doc().set({
        'name': establishmentToAdd.name,
        'categorie_id': categoryReference,
        'hightlight': establishmentToAdd.hightlight,
        'imageUrl': establishmentToAdd.imageUrl,
        'imageName': establishmentToAdd.imageName,
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteEstablishment(String? name) async {
    try {
      Establishment toDelete = await getEstablishmentByName(name);
      String idToDelete = toDelete.id!;

      if (idToDelete.isNotEmpty) {
        _firestore.collection('establishments').doc(idToDelete).delete();
        storageService.deleteFile(toDelete.imageName);
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
  String imageUrl;
  String imageName;
  DocumentReference? categoryId;
  String? categoryName;
  String? id;

  Establishment(
      {required this.name,
      required this.hightlight,
      required this.imageUrl,
      required this.imageName,
      this.categoryId,
      this.categoryName,
      this.id});

  factory Establishment.fromDocument(DocumentSnapshot doc) {
    return Establishment(
      name: doc['name'],
      hightlight: doc['hightlight'],
      categoryId: doc['categorie_id'],
      imageUrl: doc['imageUrl'],
      imageName: doc['imageName'],
      id: doc.id,
    );
  }
}
