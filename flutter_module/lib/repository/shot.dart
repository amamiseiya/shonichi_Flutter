import 'dart:async';

import '../model/shot.dart';
import '../model/project.dart';
import '../provider/sqlite/sqlite.dart';
import '../provider/firestore/firestore.dart';

class ShotRepository {
  final provider = ShotFirestoreProvider();

  Future<void> create(SNShot shot) async => await provider.create(shot);

  Future<List<SNShot>> retrieveForTable(String tableId) async =>
      await provider.retrieveForTable(tableId);

  Future<void> update(SNShot shot) async => await provider.update(shot);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<void> deleteMultiple(List<String> ids) async =>
      await provider.deleteMultiple(ids);
}
