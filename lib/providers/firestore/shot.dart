part of 'firestore.dart';

class ShotFirestoreProvider extends FirestoreProvider {
  final CollectionReference _shotRef =
      FirebaseFirestore.instance.collection('sn_shot');

  Query queryForStoryboard(String storyboardId) => _shotRef
      .where('storyboardId', isEqualTo: storyboardId)
      .orderBy('startTime', descending: false);

  Future<DocumentReference> create(SNShot shot) async {
    return _shotRef.add(shot.toJson());
    // print('Provider: Create operation succeed');
  }

  Future<List<SNShot>> retrieveForStoryboard(String storyboardId) async {
    final snapshot = await queryForStoryboard(storyboardId).get();
    print(
        'Provider: ' + snapshot.docs.length.toString() + ' shot(s) retrieved');
    return List.generate(snapshot.docs.length,
        (i) => SNShot.fromJson(snapshot.docs[i].data(), snapshot.docs[i].id));
  }

  Future<void> update(SNShot shot) async {
    await _shotRef.doc(shot.id).set(shot.toJson());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _shotRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    ids.forEach((id) => batch.delete(_shotRef.doc(id)));
    return batch
        .commit()
        .then((_) => print('Provider: Batch delete operation succeed'));
  }

  Future<void> deleteForStoryboard(String storyboardId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    await queryForStoryboard(storyboardId).get().then((snapshot) =>
        snapshot.docs.forEach((doc) => batch.delete(doc.reference)));
    return batch
        .commit()
        .then((_) => print('Provider: Batch delete operation succeed'));
  }
}
