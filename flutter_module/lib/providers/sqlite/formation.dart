part of 'sqlite.dart';

class FormationSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNFormation formation) async {
    final db = await database;
    await db.insert(
      'sn_formation',
      formation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed');
  }

  Future<List<SNFormation>> retrieveForTable(String tableId) async {
    final db = await database;
    final mapList = await db.query('sn_formation',
        where: 'tableId = ?', whereArgs: [tableId], orderBy: 'startTime DESC');
    return List.generate(
        mapList.length, (i) => SNFormation.fromMap(mapList[i]));
  }

  Future<void> update(SNFormation formation) async {
    final db = await database;
    await db.update(
      'sn_formation',
      formation.toMap(),
      where: 'id = ?',
      whereArgs: [formation.id],
    );
    print('Update operation succeed');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'sn_formation',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Delete operation succeed');
  }
}
