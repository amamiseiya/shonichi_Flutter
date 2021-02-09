import 'dart:async';

import '../model/lyric.dart';
import '../provider/sqlite/sqlite.dart';
import '../provider/firestore/firestore.dart';

class LyricRepository {
  final provider = LyricFirestoreProvider();

  Future<void> create(SNLyric lyric) async => await provider.create(lyric);

  Future<List<SNLyric>> retrieveForSong(String songId) async =>
      await provider.retrieveForSong(songId);

  Future<void> update(SNLyric lyric) async => await provider.update(lyric);

  Future<void> delete(String id) async => await provider.delete(id);
}
