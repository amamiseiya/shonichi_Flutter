import 'dart:async';

import '../model/lyric.dart';
import '../provider/provider_sqlite.dart';

class LyricRepository {
  final lyricProvider = ProviderSqlite();

  Future<void> addLyric(Lyric lyric) async =>
      await lyricProvider.insert('lyrictable', lyric.toMap());

  Future<void> deleteLyric(Lyric lyric) async =>
      await lyricProvider.delete('lyrictable',
          where: 'startTime = ?', whereArgs: [lyric.startTime.inMilliseconds]);

  Future<void> updateLyric(Lyric lyric) async =>
      await lyricProvider.update('lyrictable', lyric.toMap(),
          where: 'startTime = ?', whereArgs: [lyric.startTime.inMilliseconds]);

  Future<List<Lyric>> fetchLyricsForSong(int id) {
    final list = lyricProvider.query('lyrictable',
        where: 'songId = ?',
        whereArgs: [
          id
        ]).then((onValue) =>
        List.generate(onValue.length, (i) => Lyric.fromMap(onValue[i])));
    return list;
  }
}
