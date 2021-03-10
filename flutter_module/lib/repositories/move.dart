import 'dart:async';

import '../models/move.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class MoveRepository {
  final provider = MoveFirestoreProvider();

  Future<void> create(SNMove move) async =>
      await provider.create(move);

  Future<List<SNMove>> retrieveForFormation(String formationId) async =>
      await provider.retrieveForFormation(formationId);

  Future<void> update(SNMove move) async =>
      await provider.update(move);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<void> deleteForFormation(String formationId) async =>
      await provider.deleteForFormation(formationId);
}
