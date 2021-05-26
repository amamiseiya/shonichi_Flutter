import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/move.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class MoveRepository {
  final provider = MoveFirestoreProvider();

  Future<DocumentReference> create(SNMove move) => provider.create(move);

  Future<List<SNMove>> retrieveForFormation(String formationId) =>
      provider.retrieveForFormation(formationId);

  Future<void> update(SNMove move) => provider.update(move);

  Future<void> delete(String id) => provider.delete(id);

  Future<void> deleteForFormation(String formationId) =>
      provider.deleteForFormation(formationId);
}
