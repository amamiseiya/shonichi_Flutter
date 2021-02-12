part of 'firestore.dart';

class AttachmentFirestoreProvider extends FirestoreProvider {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> getImageURL(String id) async {
    return await storage.ref().child('images').child(id).getDownloadURL();
  }

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
