part of 'sqlite.dart';

class ProjectSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNProject project) async {
    final db = await database;
    await db.insert(
      'sn_project',
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed');
  }

  Future<SNProject> retrieveById(int id) async {
    final db = await database;
    final mapList =
        await db.query('sn_project', where: 'id = ?', whereArgs: [id]);
    return SNProject.fromMap(mapList.first);
  }

  Future<List<SNProject>> retrieveLatestN(int count) async {
    final db = await database;
    final mapList =
        await db.query('sn_project', orderBy: 'id DESC', limit: count);
    return List.generate(mapList.length, (i) => SNProject.fromMap(mapList[i]));
  }

  Future<void> update(SNProject project) async {
    final db = await database;
    await db.update(
      'sn_project',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
    print('Update operation succeed');
  }

  Future<void> delete(SNProject project) async {
    final db = await database;
    await db.delete(
      'sn_project',
      where: 'id = ?',
      whereArgs: [project.id],
    );
    print('Delete operation succeed');
  }

  Future<void> deleteMultiple(List<SNProject> projects) async {
    final db = await database;
    projects.forEach((SNProject project) async {
      await db.delete(
        'sn_project',
        where: 'id = ?',
        whereArgs: [project.id],
      );
    });
    print('Delete operation succeed');
  }
}
