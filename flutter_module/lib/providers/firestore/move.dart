part of 'firestore.dart';

class MoveFirestoreProvider extends FirestoreProvider {
  final CollectionReference _moveRef =
      FirebaseFirestore.instance.collection('sn_move');

  Query queryForFormation(String formationId) => _moveRef
      .where('formationId', isEqualTo: formationId)
      .orderBy('startTime', descending: false);

  Future<DocumentReference> create(SNMove move) async {
    return _moveRef.add(move.toJson());
    // print('Provider: Create operation succeed');
  }

  Future<List<SNMove>> retrieveForFormation(String formationId) async {
    final snapshot = await queryForFormation(formationId).get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' move(s) retrieved');
    return List.generate(
        snapshot.docs.length,
        (i) =>
            SNMove.fromJson(snapshot.docs[i].data(), snapshot.docs[i].id));
  }

  Future<void> update(SNMove move) async {
    await _moveRef.doc(move.id).set(move.toJson());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _moveRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }

  Future<void> deleteForFormation(String formationId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    await queryForFormation(formationId).get().then((snapshot) =>
        snapshot.docs.forEach((doc) => batch.delete(doc.reference)));
    return batch
        .commit()
        .then((_) => print('Provider: Batch delete operation succeed'));
  }
}
