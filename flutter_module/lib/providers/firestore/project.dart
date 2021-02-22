part of 'firestore.dart';

class ProjectFirestoreProvider extends FirestoreProvider {
  final CollectionReference _projectRef =
      FirebaseFirestore.instance.collection('sn_project');

  // Stream<List<SNProject>> get projectsStream => _projectRef
  //     .orderBy('createdTime', descending: true)
  //     .snapshots()
  //     .map((querySnapshot) => List.generate(querySnapshot.docs.length, (i) {
  //           final project = SNProject.fromMap(querySnapshot.docs[i].data());
  //           project.id = querySnapshot.docs[i].id;
  //           return project;
  //         }));

  Future<void> create(SNProject project) async {
    await _projectRef.add(project.toMap());
    print('Provider: Create operation succeed');
  }

  Future<SNProject> retrieveById(String id) async {
    final snapshot = await _projectRef.doc(id).get();
    if (!snapshot.exists) {
      throw FirebaseException(
          plugin: 'Firestore', message: 'Document does not exist');
    }
    final project = SNProject.fromMap(snapshot.data(), snapshot.id);
    print('Provider: Retrieved project: ' + project.toString());
    return project;
  }

  Future<List<SNProject>> retrieveLatestN(String creatorId, int count) async {
    final snapshot = await _projectRef
        .where('creatorId', isEqualTo: creatorId)
        .orderBy('createdTime', descending: true)
        .limit(count)
        .get();
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' project(s) retrieved');
    return List.generate(snapshot.docs.length,
        (i) => SNProject.fromMap(snapshot.docs[i].data(), snapshot.docs[i].id));
  }

  Future<void> update(SNProject project) async {
    await _projectRef.doc(project.id).set(project.toMap());
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    await _projectRef.doc(id).delete();
    print('Provider: Delete operation succeed');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    ids.forEach((id) => batch.delete(_projectRef.doc(id)));
    return batch
        .commit()
        .then((_) => print('Provider: Batch delete operation succeed'));
    ;
  }
}
