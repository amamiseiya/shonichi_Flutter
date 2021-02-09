import '../model/project.dart';
import '../provider/sqlite/sqlite.dart';
import '../provider/leancloud/leancloud.dart';
import '../provider/firestore/firestore.dart';

class ProjectRepository {
  final provider = ProjectFirestoreProvider();

  Future<void> create(SNProject project) async =>
      await provider.create(project);

  Future<SNProject> retrieveById(String id) async =>
      await provider.retrieveById(id);

  Future<List<SNProject>> retrieveLatestN(int count) async =>
      await provider.retrieveLatestN(count);

  Future<void> update(SNProject project) async =>
      await provider.update(project);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<void> deleteMultiple(List<String> ids) async =>
      await provider.deleteMultiple(ids);
}
