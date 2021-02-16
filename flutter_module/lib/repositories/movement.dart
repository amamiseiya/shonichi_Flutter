import 'dart:async';

import '../models/movement.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class MovementRepository {
  final provider = MovementFirestoreProvider();

  Future<void> create(SNMovement movement) async =>
      await provider.create(movement);

  Future<List<SNMovement>> retrieveForTable(String tableId) async =>
      await provider.retrieveForTable(tableId);

  Future<void> update(SNMovement movement) async =>
      await provider.update(movement);

  Future<void> delete(String id) async => await provider.delete(id);
}
