import '../model/shot_table.dart';
import '../provider/sqlite_provider.dart';

class ShotTableRepository {
  final provider = ShotTableSQLiteProvider();

  Future<void> create(SNShotTable shotTable) async =>
      await provider.create(shotTable);

  Future<SNShotTable> retrieveById(int id) async =>
      await provider.retrieveById(id);

  Future<List<SNShotTable>> retrieveAll() async => await provider.retrieveAll();

  Future<void> update(SNShotTable shotTable) async =>
      await provider.update(shotTable);

  Future<void> delete(SNShotTable shotTable) async =>
      await provider.delete(shotTable);

  Future<SNShotTable> getLatestShotTable(int songId) async =>
      await provider.getLatestShotTable(songId);
}
