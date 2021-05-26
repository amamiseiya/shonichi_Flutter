import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/song.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class SongRepository {
  final provider = SongFirestoreProvider();

  // Stream<List<SNSong>> get songsStream => provider.songsStream;

  Future<DocumentReference> create(SNSong song) => provider.create(song);

  Future<SNSong> retrieveById(String id) => provider.retrieveById(id);

  Future<List<SNSong>> retrieveAll() => provider.retrieveAll();

  Future<void> update(SNSong song) => provider.update(song);

  Future<void> delete(String id) => provider.delete(id);

  Future<void> deleteMultiple(List<String> ids) => provider.deleteMultiple(ids);
}
