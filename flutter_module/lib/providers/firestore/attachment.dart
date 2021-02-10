part of 'firestore.dart';

class AttachmentFirestoreProvider extends FirestoreProvider {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> getImageURL(String id) async {
    return await storage.ref().child('images').child(id).getDownloadURL();
  }
}
