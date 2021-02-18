part of 'sqlite.dart';

class SongSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNSong song) async {
    final db = await database;
    await db.insert(
      'sn_song',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Provider: Create operation succeed');
  }

  Future<SNSong> retrieveById(String id) async {
    final db = await database;
    final mapList = await db.query('sn_song', where: 'id = ?', whereArgs: [id]);
    print('Provider: Retrieved song: ' + mapList.first.toString());
    return SNSong.fromMap(mapList.first, id);
  }

  Future<List<SNSong>> retrieveAll() async {
    final db = await database;
    final mapList = await db.query('sn_song', orderBy: 'id DESC');
    print('Provider: ' + mapList.length.toString() + ' song(s) retrieved');
    return List.generate(
        mapList.length, (i) => SNSong.fromMap(mapList[i], mapList[i]['id']));
  }

  Future<void> update(SNSong song) async {
    final db = await database;
    await db.update(
      'sn_song',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      'sn_song',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Provider: Delete operation succeed');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    final db = await database;
    ids.forEach((id) async {
      await db.delete(
        'sn_song',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
    print('Provider: Delete operation succeed');
  }
}
