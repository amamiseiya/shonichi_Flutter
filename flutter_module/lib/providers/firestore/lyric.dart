part of 'firestore.dart';

class LyricFirestoreProvider extends FirestoreProvider {
  final CollectionReference _lyricRef =
      FirebaseFirestore.instance.collection('sn_lyric');

  Future<void> create(SNLyric lyric) async {
    await _lyricRef.add(lyric.toMap());
    print('Provider: Create operation succeed');
  }

  Future<List<SNLyric>> retrieveForSong(String songId) async {
    final snapshot = await _lyricRef
        .where('songId', isEqualTo: songId)
        .orderBy('startTime')
        .get();
    print(
        'Provider: ' + snapshot.docs.length.toString() + ' lyric(s) retrieved');
    return List.generate(snapshot.docs.length, (i) {
      final lyric = SNLyric.fromMap(snapshot.docs[i].data());
      lyric.id = snapshot.docs[i].id;
      return lyric;
    });
  }

  Future<void> update(SNLyric lyric) async {
    await _lyricRef.doc(lyric.id).set(lyric.toMap());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _lyricRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }
}
