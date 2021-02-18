part of 'firestore.dart';

class AttachmentFirestoreProvider extends FirestoreProvider {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final CollectionReference _attachmentRef =
      FirebaseFirestore.instance.collection('sn_attachment');

  // * -------- Simple Functions --------

  Future<String> getImageURI(String id) async {
    return await storage.ref().child('images').child(id).getDownloadURL();
  }

  Future<String> getVideoURI(String id) async {
    return await storage.ref().child('videos').child(id).getDownloadURL();
  }

  // * -------- Attachment For Song CRUD --------

  Future<List<SNAttachment>> retrieveAttachmentsForSong(String songId) async {
    final snapshot = await _attachmentRef
        .where('songId', isEqualTo: songId)
        .orderBy('name')
        .get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' attachment(s) retrieved');
    return List.generate(
        snapshot.docs.length,
        (i) =>
            SNAttachment.fromMap(snapshot.docs[i].data(), snapshot.docs[i].id));
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
