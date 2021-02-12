import '../models/formation_table.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class FormationTableRepository {
  final provider = FormationTableFirestoreProvider();

  Future<void> create(SNFormationTable formationTable) async =>
      await provider.create(formationTable);

  Future<SNFormationTable> retrieveById(String id) async =>
      await provider.retrieveById(id);

  Future<List<SNFormationTable>> retrieveForSong(String id) async =>
      await provider.retrieveForSong(id);

  Future<void> update(SNFormationTable formationTable) async =>
      await provider.update(formationTable);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<SNFormationTable> getLatestFormationTable(String songId) async =>
      await provider.getLatestFormationTable(songId);
}
