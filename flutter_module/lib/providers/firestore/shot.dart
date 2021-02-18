part of 'firestore.dart';

class ShotFirestoreProvider extends FirestoreProvider {
  final CollectionReference _shotRef =
      FirebaseFirestore.instance.collection('sn_shot');

  Future<void> create(SNShot shot) async {
    await _shotRef.add(shot.toMap());
    print('Provider: Create operation succeed');
  }

  Future<List<SNShot>> retrieveForTable(String tableId) async {
    final snapshot = await _shotRef
        .where('tableId', isEqualTo: tableId)
        .orderBy('startTime', descending: false)
        .get();
    print(
        'Provider: ' + snapshot.docs.length.toString() + ' shot(s) retrieved');
    return List.generate(snapshot.docs.length,
        (i) => SNShot.fromMap(snapshot.docs[i].data(), snapshot.docs[i].id));
  }

  Future<void> update(SNShot shot) async {
    await _shotRef.doc(shot.id).set(shot.toMap());
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
}
