part of 'firestore.dart';

class ShotFirestoreProvider extends FirestoreProvider {
  final CollectionReference _shotRef =
      FirebaseFirestore.instance.collection('sn_shot');

  Future<void> create(SNShot shot) async {
    await _shotRef.add(shot.toMap());
    print('Create operation succeed');
  }

  Future<List<SNShot>> retrieveForTable(String tableId) async {
    final snapshot = await _shotRef
        .where('tableId', isEqualTo: tableId)
        .orderBy('startTime', descending: true)
        .get();
    assert(snapshot.docs.isNotEmpty);
    return List.generate(snapshot.docs.length, (i) {
      final shot = SNShot.fromMap(snapshot.docs[i].data());
      shot.id = snapshot.docs[i].id;
      return shot;
    });
  }

  Future<void> update(SNShot shot) async {
    await _shotRef.doc(shot.id).set(shot.toMap());
    print('Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _shotRef.doc(id).delete();
    print('Delete operation succeed');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    ids.forEach((id) => batch.delete(_shotRef.doc(id)));
    return batch.commit();
  }
}
