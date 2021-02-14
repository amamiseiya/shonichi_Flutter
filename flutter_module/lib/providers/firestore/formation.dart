part of 'firestore.dart';

class FormationFirestoreProvider extends FirestoreProvider {
  final CollectionReference _formationRef =
      FirebaseFirestore.instance.collection('sn_formation');

  Future<void> create(SNFormation formation) async {
    await _formationRef.add(formation.toMap());
    print('Provider: Create operation succeed');
  }

  Future<List<SNFormation>> retrieveForTable(String tableId) async {
    final snapshot = await _formationRef
        .where('tableId', isEqualTo: tableId)
        .orderBy('startTime', descending: true)
        .get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' formation(s) retrieved');
    return List.generate(snapshot.docs.length, (i) {
      final formation = SNFormation.fromMap(snapshot.docs[i].data());
      formation.id = snapshot.docs[i].id;
      return formation;
    });
  }

  Future<void> update(SNFormation formation) async {
    await _formationRef.doc(formation.id).set(formation.toMap());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _formationRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }
}
