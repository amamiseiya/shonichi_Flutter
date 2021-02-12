import '../models/shot_table.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class ShotTableRepository {
  final provider = ShotTableFirestoreProvider();

  Future<void> create(SNShotTable shotTable) async =>
      await provider.create(shotTable);

  Future<SNShotTable> retrieveById(String id) async =>
      await provider.retrieveById(id);

  Future<List<SNShotTable>> retrieveForSong(String id) async =>
      await provider.retrieveForSong(id);

  Future<void> update(SNShotTable shotTable) async =>
      await provider.update(shotTable);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<SNShotTable> getLatestShotTable(String songId) async =>
      await provider.getLatestShotTable(songId);
}
