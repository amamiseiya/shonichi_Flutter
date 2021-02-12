part of 'firestore.dart';

class ProjectFirestoreProvider extends FirestoreProvider {
  final CollectionReference _projectRef =
      FirebaseFirestore.instance.collection('sn_project');

  Future<void> create(SNProject project) async {
    await _projectRef.add(project.toMap());
    print('Provider: Create operation succeed');
  }

  Future<SNProject> retrieveById(String id) async {
    final snapshot = await _projectRef.doc(id).get();
    assert(snapshot.exists);
    final project = SNProject.fromMap(snapshot.data());
    project.id = snapshot.id;
    print('Provider: Retrieved project: ' + project.toString());
    return project;
  }

  Future<List<SNProject>> retrieveLatestN(int count) async {
    final snapshot = await _projectRef
        .orderBy('createdTime', descending: true)
        .limit(count)
        .get();
    // assert(snapshot.docs.isNotEmpty);
    print('Provider: ' +
        snapshot.docs.length.toString() +
        ' project(s) retrieved');
    return List.generate(snapshot.docs.length, (i) {
      final project = SNProject.fromMap(snapshot.docs[i].data());
      project.id = snapshot.docs[i].id;
      return project;
    });
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
