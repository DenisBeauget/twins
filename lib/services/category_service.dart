import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategory() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('categories').get();
      List<Category> categories = querySnapshot.docs.map((doc) {
        return Category.fromDocument(doc);
      }).toList();
      return categories;
    } catch (e) {
      rethrow;
    }
  }
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromDocument(DocumentSnapshot doc) {
    return Category(name: doc['name']);
  }
}
