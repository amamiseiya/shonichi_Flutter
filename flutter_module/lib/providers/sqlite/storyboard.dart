part of 'sqlite.dart';

class StoryboardSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNStoryboard storyboard) async {
    final db = await database;
    await db.insert(
      'sn_storyboard',
      storyboard.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Provider: Create operation succeed');
  }

  Future<SNStoryboard> retrieveById(String id) async {
    final db = await database;
    final mapList =
        await db.query('sn_storyboard', where: 'id = ?', whereArgs: [id]);
    return SNStoryboard.fromMap(mapList.first, id);
  }

  Future<List<SNStoryboard>> retrieveAll() async {
    final db = await database;
    final mapList = await db.query('sn_storyboard', orderBy: 'id DESC');
    return List.generate(mapList.length,
        (i) => SNStoryboard.fromMap(mapList[i], mapList[i]['id'] as String));
  }

  Future<void> update(SNStoryboard storyboard) async {
    final db = await database;
    await db.update(
      'sn_storyboard',
      storyboard.toMap(),
      where: 'id = ?',
      whereArgs: [storyboard.id],
    );
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'sn_storyboard',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Provider: Delete operation succeed');
  }

  Future<SNStoryboard> getLatestStoryboard(String songId) async {
    final db = await database;
    final List<Map<String, dynamic>> mapList = await db.query('sn_storyboard',
        where: 'songId = ?', whereArgs: [songId], orderBy: 'id DESC', limit: 1);
    return SNStoryboard.fromMap(mapList.first, mapList.first['id']);
  }
}
