part of 'sqlite.dart';

class ProjectSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNProject project) async {
    final db = await database;
    await db.insert(
      'sn_project',
      project.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Provider: Create operation succeed');
  }

  Future<SNProject> retrieveById(String id) async {
    final db = await database;
    final mapList =
        await db.query('sn_project', where: 'id = ?', whereArgs: [id]);
    return SNProject.fromJson(mapList.first, id);
  }

  Future<List<SNProject>> retrieveLatestN(int count) async {
    final db = await database;
    final mapList =
        await db.query('sn_project', orderBy: 'id DESC', limit: count);
    return List.generate(mapList.length,
        (i) => SNProject.fromJson(mapList[i], mapList[i]['id'] as String));
  }

  Future<void> update(SNProject project) async {
    final db = await database;
    await db.update(
      'sn_project',
      project.toJson(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'sn_project',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Provider: Delete operation succeed');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    final db = await database;
    ids.forEach((String id) async {
      await db.delete(
        'sn_project',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
    print('Provider: Delete operation succeed');
  }
}
