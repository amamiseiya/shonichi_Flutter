part of 'firestore.dart';

class StoryboardFirestoreProvider extends FirestoreProvider {
  final CollectionReference _storyboardRef =
      FirebaseFirestore.instance.collection('sn_storyboard');

  Future<void> create(SNStoryboard storyboard) async {
    await _storyboardRef.add(storyboard.toMap());
    print('Provider: Create operation succeed');
  }

  Future<SNStoryboard> retrieveById(String id) async {
    final snapshot = await _storyboardRef.doc(id).get();
    if (!snapshot.exists) {
      throw FirebaseException(
          plugin: 'Firestore', message: 'Document does not exist');
    }
    final storyboard = SNStoryboard.fromMap(snapshot.data());
    storyboard.id = snapshot.id;
    print('Provider: Retrieved storyboard: ' + storyboard.toString());
    return storyboard;
  }

  Future<List<SNStoryboard>> retrieveForSong(String id) async {
    final snapshot = await _storyboardRef
        .where('songId', isEqualTo: id)
        .orderBy('name', descending: false)
        .get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' storyboard(s) retrieved');
    return List.generate(snapshot.docs.length, (i) {
      final storyboard = SNStoryboard.fromMap(snapshot.docs[i].data());
      storyboard.id = snapshot.docs[i].id;
      return storyboard;
    });
  }

  Future<void> update(SNStoryboard storyboard) async {
    await _storyboardRef.doc(storyboard.id).set(storyboard.toMap());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _storyboardRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }

  Future<SNStoryboard> getLatestStoryboard(String songId) async {
    final snapshot = await _storyboardRef
        .where('songId', isEqualTo: songId)
        .orderBy('createdTime', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    final storyboard = SNStoryboard.fromMap(snapshot.docs.first.data());
    storyboard.id = snapshot.docs.first.id;
    print('Provider: Latest storyboard: ' + storyboard.toString());
    return storyboard;
  }
}
