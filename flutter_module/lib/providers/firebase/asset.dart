import 'dart:io' show Platform;
import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AssetFirebaseProvider {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  // * -------- Simple Functions --------

  Future<String> getImageURI(String id) async {
    return await storage.ref().child('images').child(id).getDownloadURL();
  }

  Future<String> getVideoURI(String id) async {
    return await storage.ref().child('videos').child(id).getDownloadURL();
  }

  // * -------- Text File I/O --------

  Future<void> writeAsString(
      String text, String folder, String fileName) async {
    final Uint8List rawData = Uint8List.fromList(utf8.encode(text));
    final ref = storage.ref().child(folder).child(fileName);
    await ref.putData(rawData);
  }

  Future<String> readAsString(String folder, String fileName) async {
    final ref = storage.ref().child(folder).child(fileName);
    final Uint8List rawData = await ref.getData();
    return utf8.decode(rawData.toList());
  }
}
