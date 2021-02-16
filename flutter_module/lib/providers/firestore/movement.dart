part of 'firestore.dart';

class MovementFirestoreProvider extends FirestoreProvider {
  final CollectionReference _movementRef =
      FirebaseFirestore.instance.collection('sn_movement');

  Future<void> create(SNMovement movement) async {
    await _movementRef.add(movement.toMap());
    print('Provider: Create operation succeed');
  }

  Future<List<SNMovement>> retrieveForTable(String tableId) async {
    final snapshot = await _movementRef
        .where('tableId', isEqualTo: tableId)
        .orderBy('startTime', descending: false)
        .get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' movement(s) retrieved');
    return List.generate(snapshot.docs.length, (i) {
      final movement = SNMovement.fromMap(snapshot.docs[i].data());
      movement.id = snapshot.docs[i].id;
      return movement;
    });
  }

  Future<void> update(SNMovement movement) async {
    await _movementRef.doc(movement.id).set(movement.toMap());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _movementRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }
}
