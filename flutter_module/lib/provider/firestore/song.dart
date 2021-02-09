part of 'firestore.dart';

class SongFirestoreProvider extends FirestoreProvider {
  final CollectionReference _songRef =
      FirebaseFirestore.instance.collection('sn_song');

  Future<void> create(SNSong song) async {
    await _songRef.add(song.toMap());
    print('Create operation succeed');
  }

  Future<SNSong> retrieveById(String id) async {
    final snapshot = await _songRef.doc(id).get();
    assert(snapshot.exists);
    final song = SNSong.fromMap(snapshot.data());
    song.id = snapshot.id;
    return song;
  }

  Future<List<SNSong>> retrieveAll() async {
    final snapshot = await _songRef.orderBy('name', descending: false).get();
    assert(snapshot.docs.isNotEmpty);
    return List.generate(snapshot.docs.length, (i) {
      final song = SNSong.fromMap(snapshot.docs[i].data());
      song.id = snapshot.docs[i].id;
      return song;
    });
  }

  Future<void> update(SNSong song) async {
    await _songRef.doc(song.id).set(song.toMap());
    print('Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _songRef.doc(id).delete();
    print('Delete operation succeed');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    ids.forEach((id) => batch.delete(_songRef.doc(id)));
    return batch.commit();
  }
}
