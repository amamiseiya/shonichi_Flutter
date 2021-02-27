import 'dart:async';

import '../models/shot.dart';
import '../models/project.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class ShotRepository {
  final provider = ShotFirestoreProvider();

  Future<void> create(SNShot shot) async => await provider.create(shot);

  Future<List<SNShot>> retrieveForStoryboard(String storyboardId) async =>
      await provider.retrieveForStoryboard(storyboardId);

  Future<void> update(SNShot shot) async => await provider.update(shot);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<void> deleteMultiple(List<String> ids) async =>
      await provider.deleteMultiple(ids);

  Future<void> deleteForStoryboard(String storyboardId) async =>
      await provider.deleteForStoryboard(storyboardId);
}
