import 'dart:async';

import '../model/lyric.dart';
import '../provider/sqlite/sqlite.dart';

class LyricRepository {
  final provider = LyricSQLiteProvider();

  Future<void> create(SNLyric lyric) async => await provider.create(lyric);

  Future<List<SNLyric>> retrieveForSong(int songId) async =>
      await provider.retrieveForSong(songId);

  Future<void> update(SNLyric lyric) async => await provider.update(lyric);

  Future<void> delete(SNLyric lyric) async => await provider.delete(lyric);
}
