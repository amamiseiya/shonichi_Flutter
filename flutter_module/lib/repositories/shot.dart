import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/shot.dart';
import '../models/project.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class ShotRepository {
  final provider = ShotFirestoreProvider();

  Future<DocumentReference> create(SNShot shot) => provider.create(shot);

  Future<List<SNShot>> retrieveForStoryboard(String storyboardId) =>
      provider.retrieveForStoryboard(storyboardId);

  Future<void> update(SNShot shot) => provider.update(shot);

  Future<void> delete(String id) => provider.delete(id);

  Future<void> deleteMultiple(List<String> ids) => provider.deleteMultiple(ids);

  Future<void> deleteForStoryboard(String storyboardId) =>
      provider.deleteForStoryboard(storyboardId);
}
