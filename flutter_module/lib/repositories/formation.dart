import '../models/formation.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class FormationRepository {
  final provider = FormationFirestoreProvider();

  Future<void> create(SNFormation formation) async =>
      await provider.create(formation);

  Future<SNFormation> retrieveById(String id) async =>
      await provider.retrieveById(id);

  Future<List<SNFormation>> retrieveForSong(String id) async =>
      await provider.retrieveForSong(id);

  Future<void> update(SNFormation formation) async =>
      await provider.update(formation);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<SNFormation?> getLatestFormation(String songId) async =>
      await provider.getLatestFormation(songId);
}
