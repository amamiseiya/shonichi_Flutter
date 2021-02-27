part of 'firestore.dart';

class MovementFirestoreProvider extends FirestoreProvider {
  final CollectionReference _movementRef =
      FirebaseFirestore.instance.collection('sn_movement');

  Query queryForFormation(String formationId) => _movementRef
      .where('formationId', isEqualTo: formationId)
      .orderBy('startTime', descending: false);

  Future<void> create(SNMovement movement) async {
    await _movementRef.add(movement.toMap());
    print('Provider: Create operation succeed');
  }

  Future<List<SNMovement>> retrieveForFormation(String formationId) async {
    final snapshot = await queryForFormation(formationId).get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' movement(s) retrieved');
    return List.generate(
        snapshot.docs.length,
        (i) =>
            SNMovement.fromMap(snapshot.docs[i].data(), snapshot.docs[i].id));
  }

  Future<void> update(SNMovement movement) async {
    await _movementRef.doc(movement.id).set(movement.toMap());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _movementRef.doc(id).delete();
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
