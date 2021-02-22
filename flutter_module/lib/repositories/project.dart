import '../models/project.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/leancloud/leancloud.dart';
import '../providers/firestore/firestore.dart';

class ProjectRepository {
  final provider = ProjectFirestoreProvider();

  // Stream<List<SNProject>> get projectsStream => provider.projectsStream;

  Future<void> create(SNProject project) async =>
      await provider.create(project);

  Future<SNProject> retrieveById(String id) async =>
      await provider.retrieveById(id);

  Future<List<SNProject>> retrieveLatestN(String creatorId, int count) async =>
      await provider.retrieveLatestN(creatorId, count);

  Future<void> update(SNProject project) async =>
      await provider.update(project);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<void> deleteMultiple(List<String> ids) async =>
      await provider.deleteMultiple(ids);
}
