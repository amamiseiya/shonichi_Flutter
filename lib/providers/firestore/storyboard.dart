part of 'firestore.dart';

class StoryboardFirestoreProvider extends FirestoreProvider {
  final CollectionReference _storyboardRef =
      FirebaseFirestore.instance.collection('sn_storyboard');

  Future<DocumentReference> create(SNStoryboard storyboard) async {
    return _storyboardRef.add(storyboard.toJson());
    // print('Provider: Create operation succeed');
  }

  Future<SNStoryboard> retrieveById(String id) async {
    final snapshot = await _storyboardRef.doc(id).get();
    if (!snapshot.exists) {
      throw FirebaseException(
          plugin: 'Firestore', message: 'Document does not exist');
    }
    final storyboard = SNStoryboard.fromJson(snapshot.data(), snapshot.id);
    print('Provider: Retrieved storyboard: ' + storyboard.toString());
    return storyboard;
  }

  Future<List<SNStoryboard>> retrieveForSong(
      String creatorId, String songId) async {
    final snapshot = await _storyboardRef
        .where('creatorId', isEqualTo: creatorId)
        .where('songId', isEqualTo: songId)
        .orderBy('name', descending: false)
        .get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' storyboard(s) retrieved');
    return List.generate(
        snapshot.docs.length,
        (i) =>
            SNStoryboard.fromJson(snapshot.docs[i].data(), snapshot.docs[i].id));
  }

  Future<void> update(SNStoryboard storyboard) async {
    await _storyboardRef.doc(storyboard.id).set(storyboard.toJson());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _storyboardRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }

  Future<SNStoryboard?> getLatestStoryboard(String songId) async {
    final snapshot = await _storyboardRef
        .where('songId', isEqualTo: songId)
        .orderBy('createdTime', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    final storyboard = SNStoryboard.fromJson(
        snapshot.docs.first.data(), snapshot.docs.first.id);
    print('Provider: Latest storyboard: ' + storyboard.toString());
    return storyboard;
  }
}
