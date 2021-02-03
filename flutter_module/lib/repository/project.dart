import '../model/project.dart';
import '../provider/sqlite/sqlite.dart';

class ProjectRepository {
  final provider = ProjectSQLiteProvider();

  Future<void> create(SNProject project) async =>
      await provider.create(project);

  Future<SNProject> retrieveById(int id) async =>
      await provider.retrieveById(id);

  Future<List<SNProject>> retrieveLatestN(int count) async =>
      await provider.retrieveLatestN(count);

  Future<void> update(SNProject project) async =>
      await provider.update(project);

  Future<void> delete(SNProject project) async =>
      await provider.delete(project);

  Future<void> deleteMultiple(List<SNProject> projects) async =>
      await provider.deleteMultiple(projects);
}
