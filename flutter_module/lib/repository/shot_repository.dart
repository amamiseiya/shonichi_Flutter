import 'dart:async';

import '../model/shot.dart';
import '../provider/provider_sqlite.dart';

class ShotRepository {
  final shotProvider = ProviderSqlite();

  Future<int> getLatestShotVersion(int songId) async {
    final List<Map<String, dynamic>> latestShot = await shotProvider.query(
        'shottable',
        where: 'songId = ?',
        whereArgs: [songId],
        orderBy: 'shotVersion DESC',
        limit: 1);
    return latestShot.first['shotVersion'];
  }

  Future<void> addShot(Shot shot) async =>
      await shotProvider.insert('shottable', shot.toMap());

  Future<void> deleteShot(Shot shot) async =>
      await shotProvider.delete('shottable',
          where: 'startTime = ?', whereArgs: [shot.startTime.inMilliseconds]);

  Future<void> updateShot(Shot shot) async =>
      await shotProvider.update('shottable', shot.toMap(),
          where: 'startTime = ?', whereArgs: [shot.startTime.inMilliseconds]);

  Future<List<Shot>> fetchShotsForProject(int songId, int shotVersion) {
    final list = shotProvider.query('shottable',
        where: 'songId = ? AND shotVersion = ?',
        whereArgs: [
          songId,
          shotVersion
        ]).then((onValue) =>
        List.generate(onValue.length, (i) => Shot.fromMap(onValue[i])));
    return list;
  }
}
