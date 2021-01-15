import '../model/song.dart';
import '../provider/provider_sqlite.dart';

class SongRepository {
  final songProvider = ProviderSqlite();

  Future<void> addSong(Song song) async =>
      await songProvider.insert('songtable', song.toMap());

  Future<void> deleteSong(Song song) async => await songProvider
      .delete('songtable', where: 'songId = ?', whereArgs: [song.songId]);

  Future<void> updateSong(Song song) async =>
      await songProvider.update('songtable', song.toMap(),
          where: 'songId = ?', whereArgs: [song.songId]);

  Future<List<Song>> fetchSongs() async {
    final List<Map<String, dynamic>> mapList =
        await songProvider.query('songtable');
    return List.generate(mapList.length, (i) => Song.fromMap(mapList[i]));
  }

  Future<Song> fetchSpecifiedSong(int id) async {
    final List<Map<String, dynamic>> mapList = await songProvider
        .query('songtable', where: 'songId = ?', whereArgs: [id]);
    return Song.fromMap(mapList.first);
  }
}
