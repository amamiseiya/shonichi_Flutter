part of 'sqlite.dart';

class MovementSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNMovement movement) async {
    final db = await database;
    await db.insert(
      'sn_movement',
      movement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Provider: Create operation succeed');
  }

  Future<List<SNMovement>> retrieveForTable(String tableId) async {
    final db = await database;
    final mapList = await db.query('sn_movement',
        where: 'tableId = ?', whereArgs: [tableId], orderBy: 'startTime DESC');
    return List.generate(mapList.length,
        (i) => SNMovement.fromMap(mapList[i], mapList[i]['id'] as String));
  }

  Future<void> update(SNMovement movement) async {
    final db = await database;
    await db.update(
      'sn_movement',
      movement.toMap(),
      where: 'id = ?',
      whereArgs: [movement.id],
    );
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'sn_movement',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Provider: Delete operation succeed');
  }
}
