import '../model/shot_table.dart';
import '../provider/sqlite/sqlite.dart';
import '../provider/firestore/firestore.dart';

class ShotTableRepository {
  final provider = ShotTableFirestoreProvider();

  Future<void> create(SNShotTable shotTable) async =>
      await provider.create(shotTable);

  Future<SNShotTable> retrieveById(String id) async =>
      await provider.retrieveById(id);

  Future<List<SNShotTable>> retrieveAll() async => await provider.retrieveAll();

  Future<void> update(SNShotTable shotTable) async =>
      await provider.update(shotTable);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<SNShotTable> getLatestShotTable(String songId) async =>
      await provider.getLatestShotTable(songId);
}
