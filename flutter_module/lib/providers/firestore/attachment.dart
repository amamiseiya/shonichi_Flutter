part of 'firestore.dart';

class AttachmentFirestoreProvider extends FirestoreProvider {
  final CollectionReference _attachmentRef =
      FirebaseFirestore.instance.collection('sn_attachment');

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
}
