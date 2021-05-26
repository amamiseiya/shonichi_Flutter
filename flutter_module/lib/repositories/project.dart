import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/leancloud/leancloud.dart';
import '../providers/firestore/firestore.dart';

class ProjectRepository {
  final provider = ProjectFirestoreProvider();

  // Stream<List<SNProject>> get projectsStream => provider.projectsStream;

  Future<DocumentReference> create(SNProject project) =>
      provider.create(project);

  Future<SNProject> retrieveById(String id) => provider.retrieveById(id);

  Future<List<SNProject>> retrieveLatestN(String creatorId, int count) =>
      provider.retrieveLatestN(creatorId, count);

  Future<void> update(SNProject project) => provider.update(project);

  Future<void> delete(String id) => provider.delete(id);

  Future<void> deleteMultiple(List<String> ids) => provider.deleteMultiple(ids);
}
