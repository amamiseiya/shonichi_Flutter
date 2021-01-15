import '../model/project.dart';
import '../provider/provider_sqlite.dart';

class ProjectRepository {
  final projectProvider = ProviderSqlite();

  Future<void> addProject(Project project) async =>
      await projectProvider.insert('projecttable', project.toMap());

  Future<void> deleteProject(Project project) async =>
      await projectProvider.delete('projecttable',
          where: 'projectId = ?', whereArgs: [project.projectId]);

  Future<void> updateProject(Project project) async =>
      await projectProvider.update('projecttable', project.toMap(),
          where: 'projectId = ?', whereArgs: [project.projectId]);

  Future<List<Project>> fetch4Projects() async {
    final List<Map<String, dynamic>> mapList = await projectProvider
        .query('projecttable', orderBy: 'projectId DESC', limit: 4);
    return List.generate(mapList.length, (i) => Project.fromMap(mapList[i]));
  }

  Future<Project> fetchSpecifiedProject(int id) async {
    final List<Map<String, dynamic>> mapList = await projectProvider
        .query('projecttable', where: 'projectId = ?', whereArgs: [id]);
    return Project.fromMap(mapList.first);
  }
}
