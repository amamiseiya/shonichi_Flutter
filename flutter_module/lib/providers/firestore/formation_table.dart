part of 'firestore.dart';

class FormationTableFirestoreProvider extends FirestoreProvider {
  final CollectionReference _formationTableRef =
      FirebaseFirestore.instance.collection('sn_formation_table');

  Future<void> create(SNFormationTable formationTable) async {
    await _formationTableRef.add(formationTable.toMap());
    print('Provider: Create operation succeed');
  }

  Future<SNFormationTable> retrieveById(String id) async {
    final snapshot = await _formationTableRef.doc(id).get();
    assert(snapshot.exists);
    final formationTable = SNFormationTable.fromMap(snapshot.data());
    formationTable.id = snapshot.id;
    print('Provider: Retrieved formationTable: ' + formationTable.toString());
    return formationTable;
  }

  Future<List<SNFormationTable>> retrieveForSong(String id) async {
    final snapshot = await _formationTableRef
        .where('songId', isEqualTo: id)
        .orderBy('name', descending: false)
        .get();
    assert(snapshot.docs.isNotEmpty);
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' formationTable(s) retrieved');
    return List.generate(snapshot.docs.length, (i) {
      final formationTable = SNFormationTable.fromMap(snapshot.docs[i].data());
      formationTable.id = snapshot.docs[i].id;
      return formationTable;
    });
  }

  Future<void> update(SNFormationTable formationTable) async {
    await _formationTableRef.doc(formationTable.id).set(formationTable.toMap());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _formationTableRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }

  Future<SNFormationTable> getLatestFormationTable(String songId) async {
    final snapshot = await _formationTableRef
        .where('songId', isEqualTo: songId)
        .orderBy('id', descending: true)
        .limit(1)
        .get();
    assert(snapshot.docs.isNotEmpty);
    final formationTable = SNFormationTable.fromMap(snapshot.docs.first.data());
    formationTable.id = snapshot.docs.first.id;
    print('Provider: Latest formationTable: ' + formationTable.toString());
    return formationTable;
  }
}
