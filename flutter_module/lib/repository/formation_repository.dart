import 'dart:async';

import '../model/formation.dart';
import '../provider/provider_sqlite.dart';

class FormationRepository {
  final formationProvider = ProviderSqlite();

  Future<void> addFormation(Formation formation) async =>
      await formationProvider.insert('formationtable', formation.toMap());

  Future<void> deleteFormation(
          {int songId,
          int formationVersion,
          String characterName,
          Duration startTime}) async =>
      await formationProvider.delete('formationtable',
          where:
              'songId = ? AND formationVersion = ? AND characterName = ? AND startTime = ?',
          whereArgs: [
            songId,
            formationVersion,
            characterName,
            startTime.inMilliseconds
          ]);

  Future<void> updateFormation(Formation formation) async =>
      await formationProvider.update('formationtable', formation.toMap(),
          where:
              'songId = ? AND formationVersion = ? AND characterName = ? AND startTime = ?',
          whereArgs: [
            formation.songId,
            formation.formationVersion,
            formation.characterName,
            formation.startTime.inMilliseconds
          ]);

  Future<List<Formation>> fetchFormationsForProject(
      int songId, int formationVersion) {
    return formationProvider.query('formationtable',
        where: 'songId = ? AND formationVersion = ?',
        whereArgs: [
          songId,
          formationVersion
        ]).then((onValue) =>
        List.generate(onValue.length, (i) => Formation.fromMap(onValue[i])));
  }
}
