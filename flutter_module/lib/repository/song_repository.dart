import '../model/song.dart';
import '../provider/sqlite_provider.dart';

class SongRepository {
  final provider = SongSQLiteProvider();

  Future<void> create(SNSong song) async => await provider.create(song);

  Future<SNSong> retrieveById(int id) async => await provider.retrieveById(id);

  Future<List<SNSong>> retrieveAll() async => await provider.retrieveAll();

  Future<void> update(SNSong song) async => await provider.update(song);

  Future<void> delete(SNSong song) async => await provider.delete(song);

  Future<void> deleteMultiple(List<SNSong> songs) async =>
      await provider.deleteMultiple(songs);
}
