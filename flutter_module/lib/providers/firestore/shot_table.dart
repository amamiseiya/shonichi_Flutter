part of 'firestore.dart';

class ShotTableFirestoreProvider extends FirestoreProvider {
  final CollectionReference _shotTableRef =
      FirebaseFirestore.instance.collection('sn_shot_table');

  Future<void> create(SNShotTable shotTable) async {
    await _shotTableRef.add(shotTable.toMap());
    print('Provider: Create operation succeed');
  }

  Future<SNShotTable> retrieveById(String id) async {
    final snapshot = await _shotTableRef.doc(id).get();
    if (!snapshot.exists) {
      throw FirebaseException(
          plugin: 'Firestore', message: 'Document does not exist');
    }
    final shotTable = SNShotTable.fromMap(snapshot.data());
    shotTable.id = snapshot.id;
    print('Provider: Retrieved shotTable: ' + shotTable.toString());
    return shotTable;
  }

  Future<List<SNShotTable>> retrieveForSong(String id) async {
    final snapshot = await _shotTableRef
        .where('songId', isEqualTo: id)
        .orderBy('name', descending: false)
        .get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' shotTable(s) retrieved');
    return List.generate(snapshot.docs.length, (i) {
      final shotTable = SNShotTable.fromMap(snapshot.docs[i].data());
      shotTable.id = snapshot.docs[i].id;
      return shotTable;
    });
  }

  Future<void> update(SNShotTable shotTable) async {
    await _shotTableRef.doc(shotTable.id).set(shotTable.toMap());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _shotTableRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }

  Future<SNShotTable> getLatestShotTable(String songId) async {
    final snapshot = await _shotTableRef
        .where('songId', isEqualTo: songId)
        .orderBy('createdTime', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    final shotTable = SNShotTable.fromMap(snapshot.docs.first.data());
    shotTable.id = snapshot.docs.first.id;
    print('Provider: Latest shotTable: ' + shotTable.toString());
    return shotTable;
  }
}
