part of 'sqlite.dart';

class ShotTableSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNShotTable shotTable) async {
    final db = await database;
    await db.insert(
      'sn_shot_table',
      shotTable.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed');
  }

  Future<SNShotTable> retrieveById(int id) async {
    final db = await database;
    final mapList =
        await db.query('sn_shot_table', where: 'id = ?', whereArgs: [id]);
    return SNShotTable.fromMap(mapList.first);
  }

  Future<List<SNShotTable>> retrieveAll() async {
    final db = await database;
    final mapList = await db.query('sn_shot_table', orderBy: 'id DESC');
    return List.generate(
        mapList.length, (i) => SNShotTable.fromMap(mapList[i]));
  }

  Future<void> update(SNShotTable shotTable) async {
    final db = await database;
    await db.update(
      'sn_shot_table',
      shotTable.toMap(),
      where: 'id = ?',
      whereArgs: [shotTable.id],
    );
    print('Update operation succeed');
  }

  Future<void> delete(SNShotTable shotTable) async {
    final db = await database;
    await db.delete(
      'sn_shot_table',
      where: 'id = ?',
      whereArgs: [shotTable.id],
    );
    print('Delete operation succeed');
  }

  Future<SNShotTable> getLatestShotTable(int songId) async {
    final db = await database;
    final List<Map<String, dynamic>> mapList = await db.query('sn_shot_table',
        where: 'songId = ?', whereArgs: [songId], orderBy: 'id DESC', limit: 1);
    return SNShotTable.fromMap(mapList.first);
  }
}
