part of 'sqlite.dart';

class SongSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNSong song) async {
    final db = await database;
    await db.insert(
      'sn_song',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed');
  }

  Future<SNSong> retrieveById(int id) async {
    final db = await database;
    final mapList = await db.query('sn_song', where: 'id = ?', whereArgs: [id]);
    return SNSong.fromMap(mapList.first);
  }

  Future<List<SNSong>> retrieveAll() async {
    final db = await database;
    final mapList = await db.query('sn_song', orderBy: 'id DESC');
    return List.generate(mapList.length, (i) => SNSong.fromMap(mapList[i]));
  }

  Future<void> update(SNSong song) async {
    final db = await database;
    await db.update(
      'sn_song',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
    print('Update operation succeed');
  }

  Future<void> delete(SNSong song) async {
    final db = await database;
    await db.delete(
      'sn_song',
      where: 'id = ?',
      whereArgs: [song.id],
    );
    print('Delete operation succeed');
  }

  Future<void> deleteMultiple(List<SNSong> songs) async {
    final db = await database;
    songs.forEach((song) async {
      await db.delete(
        'sn_song',
        where: 'id = ?',
        whereArgs: [song.id],
      );
    });
  }
}
