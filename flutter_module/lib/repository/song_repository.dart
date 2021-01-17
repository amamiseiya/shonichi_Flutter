import '../model/song.dart';
import '../provider/sqlite_provider.dart';

class SongRepository {
  final provider = SongSQLiteProvider();

  Future<void> create(SNSong song) async => await provider.create(song);

  Future<SNSong> retrieve(int id) async => await provider.retrieve(id);

  Future<List<SNSong>> retrieveMultiple() async =>
      await provider.retrieveMultiple();

  Future<void> update(SNSong song) async => await provider.update(song);

  Future<void> delete(SNSong song) async => await provider.delete(song);
}
