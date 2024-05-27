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

  Future<List<Category>> searchCategories(String keyword) async {
    try {
      List<Category> categories = await getCategory();

      List<Category> filteredCategory = categories.where((category) {
        return category.name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();

      return filteredCategory;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addCategory(String name) async {
    try {
      List<Category> actualCategories = await getCategory();
      for (Category category in actualCategories) {
        if (category.name.toLowerCase() == name.toLowerCase()) {
          return false;
        }
      }

      await _firestore.collection('categories').doc().set({'name': name});
      return true;
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
