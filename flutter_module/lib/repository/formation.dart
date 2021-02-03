import 'dart:async';

import '../model/formation.dart';
import '../provider/sqlite/sqlite.dart';

class FormationRepository {
  final provider = FormationSQLiteProvider();

  Future<void> create(SNFormation formation) async =>
      await provider.create(formation);

  Future<List<SNFormation>> retrieveForTable(int tableId) async =>
      await provider.retrieveForTable(tableId);

  Future<void> update(SNFormation formation) async =>
      await provider.update(formation);

  Future<void> delete(SNFormation formation) async =>
      await provider.delete(formation);
}
