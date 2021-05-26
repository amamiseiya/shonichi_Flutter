import 'dart:async';

import '../models/lyric.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class LyricRepository {
  final provider = LyricFirestoreProvider();

  Future<void> create(SNLyric lyric) => provider.create(lyric);

  Future<List<SNLyric>> retrieveForSong(String songId) =>
      provider.retrieveForSong(songId);

  Future<void> update(SNLyric lyric) => provider.update(lyric);

  Future<void> delete(String id) => provider.delete(id);
}
