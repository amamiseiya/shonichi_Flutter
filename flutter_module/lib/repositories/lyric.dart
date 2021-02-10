import 'dart:async';

import '../models/lyric.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class LyricRepository {
  final provider = LyricFirestoreProvider();

  Future<void> create(SNLyric lyric) async => await provider.create(lyric);

  Future<List<SNLyric>> retrieveForSong(String songId) async =>
      await provider.retrieveForSong(songId);

  Future<void> update(SNLyric lyric) async => await provider.update(lyric);

  Future<void> delete(String id) async => await provider.delete(id);
}
