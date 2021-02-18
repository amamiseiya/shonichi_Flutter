part of 'firestore.dart';

class FormationFirestoreProvider extends FirestoreProvider {
  final CollectionReference _formationRef =
      FirebaseFirestore.instance.collection('sn_formation');

  Future<void> create(SNFormation formation) async {
    await _formationRef.add(formation.toMap());
    print('Provider: Create operation succeed');
  }

  Future<SNFormation> retrieveById(String id) async {
    final snapshot = await _formationRef.doc(id).get();
    if (!snapshot.exists) {
      throw FirebaseException(
          plugin: 'Firestore', message: 'Document does not exist');
    }
    final formation = SNFormation.fromMap(snapshot.data(), snapshot.id);
    print('Provider: Retrieved formation: ' + formation.toString());
    return formation;
  }

  Future<List<SNFormation>> retrieveForSong(String id) async {
    final snapshot = await _formationRef
        .where('songId', isEqualTo: id)
        .orderBy('name', descending: false)
        .get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' formation(s) retrieved');
    return List.generate(
        snapshot.docs.length,
        (i) =>
            SNFormation.fromMap(snapshot.docs[i].data(), snapshot.docs[i].id));
  }

  Future<void> update(SNFormation formation) async {
    await _formationRef.doc(formation.id).set(formation.toMap());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _formationRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }

  Future<SNFormation?> getLatestFormation(String songId) async {
    final snapshot = await _formationRef
        .where('songId', isEqualTo: songId)
        .orderBy('createdTime', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    final formation =
        SNFormation.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
    print('Provider: Latest formation: ' + formation.toString());
    return formation;
  }
}
