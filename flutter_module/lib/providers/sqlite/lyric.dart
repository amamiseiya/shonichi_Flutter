part of 'sqlite.dart';

class LyricSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNLyric lyric) async {
    final db = await database;
    await db.insert(
      'sn_lyric',
      lyric.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Provider: Create operation succeed');
  }

  Future<List<SNLyric>> retrieveForSong(String songId) async {
    final db = await database;
    final mapList = await db.query('sn_lyric',
        where: 'songId = ?', whereArgs: [songId], orderBy: 'startTime');
    return List.generate(mapList.length,
        (i) => SNLyric.fromMap(mapList[i], mapList[i]['id'] as String));
  }

  Future<void> update(SNLyric lyric) async {
    final db = await database;
    await db.update(
      'sn_lyric',
      lyric.toMap(),
      where: 'id = ?',
      whereArgs: [lyric.id],
    );
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'sn_lyric',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Provider: Delete operation succeed');
  }
}
