part of 'sqlite.dart';

class ShotSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNShot shot) async {
    final db = await database;
    await db.insert(
      'sn_shot',
      shot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed');
  }

  Future<List<SNShot>> retrieveForTable(String tableId) async {
    final db = await database;
    final mapList = await db.query('sn_shot',
        where: 'tableId = ?', whereArgs: [tableId], orderBy: 'startTime DESC');
    return List.generate(mapList.length, (i) => SNShot.fromMap(mapList[i]));
  }

  Future<void> update(SNShot shot) async {
    final db = await database;
    await db.update(
      'sn_shot',
      shot.toMap(),
      where: 'id = ?',
      whereArgs: [shot.id],
    );
    print('Update operation succeed');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'sn_shot',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Delete operation succeed');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    final db = await database;
    ids.forEach((id) async {
      await db.delete(
        'sn_shot',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
    print('Delete operation succeed');
  }
}
