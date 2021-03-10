part of 'sqlite.dart';

class MoveSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNMove move) async {
    final db = await database;
    await db.insert(
      'sn_move',
      move.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Provider: Create operation succeed');
  }

  Future<List<SNMove>> retrieveForFormation(String formationId) async {
    final db = await database;
    final mapList = await db.query('sn_move',
        where: 'formationId = ?',
        whereArgs: [formationId],
        orderBy: 'startTime DESC');
    return List.generate(mapList.length,
        (i) => SNMove.fromJson(mapList[i], mapList[i]['id'] as String));
  }

  Future<void> update(SNMove move) async {
    final db = await database;
    await db.update(
      'sn_move',
      move.toJson(),
      where: 'id = ?',
      whereArgs: [move.id],
    );
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'sn_move',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Provider: Delete operation succeed');
  }
}
