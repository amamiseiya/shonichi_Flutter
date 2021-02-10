import '../models/song.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class SongRepository {
  final provider = SongFirestoreProvider();

  Future<void> create(SNSong song) async => await provider.create(song);

  Future<SNSong> retrieveById(String id) async =>
      await provider.retrieveById(id);

  Future<List<SNSong>> retrieveAll() async => await provider.retrieveAll();

  Future<void> update(SNSong song) async => await provider.update(song);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<void> deleteMultiple(List<String> ids) async =>
      await provider.deleteMultiple(ids);
}
