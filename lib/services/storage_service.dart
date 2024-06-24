import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadFile(String path, File file) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      await ref.delete();
    } catch (e) {
      print(e);
    }
  }
}
