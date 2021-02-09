import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/character.dart';
import '../../model/project.dart';
import '../../model/song.dart';
import '../../model/lyric.dart';
import '../../model/shot_table.dart';
import '../../model/shot.dart';
import '../../model/formation.dart';

part 'project.dart';
part 'song.dart';
part 'lyric.dart';
part 'shot_table.dart';
part 'shot.dart';
part 'formation.dart';
part 'attachment.dart';

abstract class SQLiteProvider {
  // Future<void> create();
  // Future<void> retrieve();
  // Future<void> update();
  // Future<void> delete();

  static Future<Database> _database;

  Future<Database> get database async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    if (_database == null) {
      _database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(appDocDir.path, 'database.db'),
        onCreate: (db, version) async {
          db.execute(
            'CREATE TABLE sn_project(id TEXT PRIMARY KEY, dancerName TEXT, createdTime TEXT, modifiedTime TEXT, songId TEXT, shotTableId TEXT, formationTableId TEXT)',
          );
          db.execute(
            'CREATE TABLE sn_song(id TEXT PRIMARY KEY, name TEXT, coverFileName TEXT, lyricOffset INTEGER, subordinateKikaku TEXT)',
          );
          db.execute(
            'CREATE TABLE sn_lyric(id TEXT PRIMARY KEY, startTime INTEGER, endTime INTEGER, text TEXT, songId TEXT, soloPart TEXT)',
          );
          db.execute(
            'CREATE TABLE sn_shot_table(id TEXT PRIMARY KEY, name TEXT, authorId TEXT, songId TEXT)',
          );
          db.execute(
            'CREATE TABLE sn_shot(id TEXT PRIMARY KEY, sceneNumber INTEGER, shotNumber INTEGER, startTime INTEGER, endTime INTEGER, lyric TEXT, shotType TEXT, shotMovement TEXT, shotAngle TEXT, text TEXT, image TEXT, comment TEXT, tableId TEXT, characters TEXT)',
          );
          db.execute(
            'CREATE TABLE sn_formation_table(id TEXT PRIMARY KEY, name TEXT, authorId TEXT, songId TEXT)',
          );
          db.execute(
            'CREATE TABLE sn_formation(id TEXT PRIMARY KEY, startTime INTEGER, posX REAL, posY REAL, curveX1X INTEGER, curveX1Y INTEGER, curveX2X INTEGER, curveX2Y INTEGER, curveY1X INTEGER, curveY1Y INTEGER, curveY2X INTEGER, curveY2Y INTEGER, characterName TEXT, tableId TEXT)',
          );
        },
        version: 1,
      );
    }
    return _database;
  }
}
