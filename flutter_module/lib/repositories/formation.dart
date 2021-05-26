import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/formation.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class FormationRepository {
  final provider = FormationFirestoreProvider();

  Future<DocumentReference> create(SNFormation formation) =>
      provider.create(formation);

  Future<SNFormation> retrieveById(String id) => provider.retrieveById(id);

  Future<List<SNFormation>> retrieveForSong(String creatorId, String songId) =>
      provider.retrieveForSong(creatorId, songId);

  Future<void> update(SNFormation formation) => provider.update(formation);

  Future<void> delete(String id) => provider.delete(id);

  Future<SNFormation?> getLatestFormation(String songId) =>
      provider.getLatestFormation(songId);
}
