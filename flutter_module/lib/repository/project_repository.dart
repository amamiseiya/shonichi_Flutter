import '../model/project.dart';
import '../provider/sqlite_provider.dart';

class ProjectRepository {
  final provider = ProjectSQLiteProvider();

  Future<void> create(SNProject project) async =>
      await provider.create(project);

  Future<SNProject> retrieve(int id) async => await provider.retrieve(id);

  Future<List<SNProject>> retrieveMultiple(int count) async =>
      await provider.retrieveMultiple(count);

  Future<void> update(SNProject project) async =>
      await provider.update(project);

  Future<void> delete(SNProject project) async =>
      await provider.delete(project);

  Future<void> deleteMultiple(List<SNProject> projects) async {
    if (projects.isNotEmpty) {
      for (SNProject project in projects) {
        await provider.delete(project);
      }
    }
  }
}
