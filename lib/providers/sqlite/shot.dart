part of 'sqlite.dart';

class ShotSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNShot shot) async {
    final db = await database;
    await db.insert(
      'sn_shot',
      shot.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Provider: Create operation succeed');
  }

  Future<List<SNShot>> retrieveForStoryboard(String storyboardId) async {
    final db = await database;
    final mapList = await db.query('sn_shot',
        where: 'storyboardId = ?',
        whereArgs: [storyboardId],
        orderBy: 'startTime DESC');
    return List.generate(mapList.length,
        (i) => SNShot.fromJson(mapList[i], mapList[i]['id'] as String));
  }

  Future<void> update(SNShot shot) async {
    final db = await database;
    await db.update(
      'sn_shot',
      shot.toJson(),
      where: 'id = ?',
      whereArgs: [shot.id],
    );
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'sn_shot',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Provider: Delete operation succeed');
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
    print('Provider: Delete operation succeed');
  }
}
