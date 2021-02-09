import 'dart:async';

import '../model/formation.dart';
import '../provider/sqlite/sqlite.dart';
import '../provider/firestore/firestore.dart';

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
