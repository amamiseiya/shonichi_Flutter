import 'dart:async';

import '../models/movement.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class MovementRepository {
  final provider = MovementFirestoreProvider();

  Future<void> create(SNMovement movement) async =>
      await provider.create(movement);

  Future<List<SNMovement>> retrieveForFormation(String formationId) async =>
      await provider.retrieveForFormation(formationId);

  Future<void> update(SNMovement movement) async =>
      await provider.update(movement);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<void> deleteForFormation(String formationId) async =>
      await provider.deleteForFormation(formationId);
}
