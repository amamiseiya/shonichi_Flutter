part of 'firestore.dart';

class SongFirestoreProvider extends FirestoreProvider {
  final CollectionReference _songRef =
      FirebaseFirestore.instance.collection('sn_song');

  // Stream<List<SNSong>> get songsStream => _songRef
  //     .orderBy('name', descending: false)
  //     .snapshots()
  //     .map((querySnapshot) => List.generate(querySnapshot.docs.length, (i) {
  //           final song = SNSong.fromJson(querySnapshot.docs[i].data());
  //           song.id = querySnapshot.docs[i].id;
  //           return song;
  //         }));

  Future<void> create(SNSong song) async {
    await _songRef.add(song.toJson());
    print('Provider: Create operation succeed');
  }

  Future<SNSong> retrieveById(String id) async {
    final snapshot = await _songRef.doc(id).get();
    if (!snapshot.exists) {
      throw FirebaseException(
          plugin: 'Firestore', message: 'Document does not exist');
    }
    final song = SNSong.fromJson(snapshot.data(), snapshot.id);
    print('Provider: Retrieved song: ' + song.toString());
    return song;
  }

  Future<List<SNSong>> retrieveAll() async {
    final snapshot = await _songRef.orderBy('name', descending: false).get();
    print(
        'Provider: ' + snapshot.docs.length.toString() + ' song(s) retrieved');
    return List.generate(snapshot.docs.length,
        (i) => SNSong.fromJson(snapshot.docs[i].data(), snapshot.docs[i].id));
  }

  Future<void> update(SNSong song) async {
    await _songRef.doc(song.id).set(song.toJson());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _songRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    ids.forEach((id) => batch.delete(_songRef.doc(id)));
    return batch
        .commit()
        .then((_) => print('Provider: Batch delete operation succeed'));
  }
}
