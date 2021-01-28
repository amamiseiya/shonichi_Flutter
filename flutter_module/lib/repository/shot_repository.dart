import 'dart:async';

import '../model/shot.dart';
import '../model/project.dart';
import '../provider/sqlite_provider.dart';

class ShotRepository {
  final provider = ShotSQLiteProvider();

  Future<void> create(SNShot shot) async => await provider.create(shot);

  Future<List<SNShot>> retrieveForTable(int tableId) async =>
      await provider.retrieveForTable(tableId);

  Future<void> update(SNShot shot) async => await provider.update(shot);

  Future<void> delete(SNShot shot) async => await provider.delete(shot);

  Future<void> deleteMultiple(List<SNShot> shots) async =>
      await provider.deleteMultiple(shots);
}
