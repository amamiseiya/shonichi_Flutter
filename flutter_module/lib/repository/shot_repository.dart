import 'dart:async';

import '../model/shot.dart';
import '../model/project.dart';
import '../provider/sqlite_provider.dart';

class ShotRepository {
  final provider = ShotSQLiteProvider();

  Future<int> getLatestShotTable(int songId) async =>
      await provider.getLatestShotTable(songId);

  Future<void> create(SNShot shot) async => await provider.create(shot);

  Future<List<SNShot>> retrieve(int tableId) async =>
      await provider.retrieve(tableId);

  Future<void> update(SNShot shot) async => await provider.update(shot);

  Future<void> delete(SNShot shot) async => await provider.delete(shot);

  Future<void> deleteMultiple(List<SNShot> shots) async =>
      await provider.deleteMultiple(shots);
}
