import 'dart:async';

import '../models/formation.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class FormationRepository {
  final provider = FormationFirestoreProvider();

  Future<void> create(SNFormation formation) async =>
      await provider.create(formation);

  Future<List<SNFormation>> retrieveForTable(String tableId) async =>
      await provider.retrieveForTable(tableId);

  Future<void> update(SNFormation formation) async =>
      await provider.update(formation);

  Future<void> delete(String id) async => await provider.delete(id);
}
