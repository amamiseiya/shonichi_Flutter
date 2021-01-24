import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/character.dart';
import '../model/project.dart';
import '../model/song.dart';
import '../model/lyric.dart';
import '../model/shot_table.dart';
import '../model/shot.dart';
import '../model/formation.dart';

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
            'CREATE TABLE sn_project(id INTEGER PRIMARY KEY, dancerName TEXT, createdTime TEXT, modifiedTime TEXT, songId INTEGER, shotTableId INTEGER, formationTableId INTEGER)',
          );
          db.execute(
            'CREATE TABLE sn_song(id INTEGER PRIMARY KEY, name TEXT, coverFileName TEXT, lyricOffset INTEGER, subordinateKikaku TEXT)',
          );
          db.execute(
            'CREATE TABLE sn_lyric(id INTEGER PRIMARY KEY, startTime INTEGER, endTime INTEGER, text TEXT, songId INTEGER, soloPart TEXT)',
          );
          db.execute(
            'CREATE TABLE sn_shot_table(id INTEGER PRIMARY KEY, name TEXT, authorId INTEGER, songId INTEGER)',
          );
          db.execute(
            'CREATE TABLE sn_shot(id INTEGER PRIMARY KEY, sceneNumber INTEGER, shotNumber INTEGER, startTime INTEGER, endTime INTEGER, lyric TEXT, shotType TEXT, shotMovement TEXT, shotAngle TEXT, text TEXT, image TEXT, comment TEXT, tableId INTEGER, characters TEXT)',
          );
          db.execute(
            'CREATE TABLE sn_formation_table(id INTEGER PRIMARY KEY, name TEXT, authorId INTEGER, songId INTEGER)',
          );
          db.execute(
            'CREATE TABLE sn_formation(id INTEGER PRIMARY KEY, startTime INTEGER, posX REAL, posY REAL, curveX1X INTEGER, curveX1Y INTEGER, curveX2X INTEGER, curveX2Y INTEGER, curveY1X INTEGER, curveY1Y INTEGER, curveY2X INTEGER, curveY2Y INTEGER, characterName TEXT, tableId INTEGER)',
          );
        },
        version: 1,
      );
    }
    return _database;
  }

  static Future<void> cheatCodeReset() async {
    final db = await _database;

    await db.delete('sn_project');
    await db.delete('sn_song');
    await db.delete('sn_lyric');
    await db.delete('sn_shot_table');
    await db.delete('sn_shot');
    await db.delete('sn_formation_table');
    await db.delete('sn_formation');

    await db.insert(
        'sn_project',
        SNProject(
                id: 1001,
                dancerName: '舞团A',
                createdTime: DateTime.parse('20191124'),
                modifiedTime: DateTime.parse('20191124'),
                songId: 1,
                shotTableId: 1,
                formationTableId: 1)
            .toMap());
    await db.insert(
        'sn_project',
        SNProject(
                id: 1002,
                dancerName: '舞团B',
                createdTime: DateTime.parse('20200101'),
                modifiedTime: DateTime.parse('20200101'),
                songId: 2,
                shotTableId: 2,
                formationTableId: 2)
            .toMap());
    await db.insert(
        'sn_song',
        SNSong(
                id: 1,
                name: 'Brightest Melody',
                coverFileName: 'Brightest Melody_cover.jpg',
                lyricOffset: 0,
                subordinateKikaku: 'Aqours')
            .toMap());
    await db.insert(
        'sn_song',
        SNSong(
                id: 2,
                name: 'Star Diamond',
                coverFileName: 'Star Diamond_cover.jpg',
                // 精确值为-520
                lyricOffset: -520,
                subordinateKikaku: 'スタァライト九九組')
            .toMap());
    for (SNLyric lyric in SNLyric.parseFromLrc(
      '[00:01.39]Ah どこへ行っても忘れないよ\n[00:04.67]Brightest Melody\n[00:20.08]いつまでもここにいたい\n[00:23.37]みんなの想いは\n[00:25.71]きっとひとつだよ\n[00:27.88]ずっと歌おうみんなで\n[00:30.29]だけど先に道がある\n[00:33.68]いろんなミライ\n[00:36.06]次のトキメキへと\n[00:39.84]出会い 別れ\n[00:42.57]繰り返すってことが\n[00:45.03]わかってきたんだ\n[00:47.60]でも笑顔でね\n[00:49.68]また会おうと言ってみよう\n[00:52.59]ココロから ね\n[00:59.94]キラキラひかる夢が\n[01:03.36]僕らの胸のなかで輝いてた\n[01:08.19]熱く大きなキラキラ\n[01:11.56]さあ明日に向けて\n[01:13.74]また始めたい\n[01:15.10]とびっきりの何か 何かを\n[01:19.07]それは なんだろうね\n[01:24.24]楽しみなんだ\n[01:36.60]だいじにねしたいんだ\n[01:39.78]みんな汗かいて\n[01:42.25]がんばった日々を\n[01:44.28]いっぱい練習したね\n[01:46.91]やればできる できるんだと\n[01:50.15]描いたミライ\n[01:52.58]それがイマになった\n[01:56.45]別れ 出会い\n[01:59.16]どちらが最初なのか\n[02:01.48]わからないままだよ\n[02:04.10]でも気にしない\n[02:06.33]また会えるね そう思うよ\n[02:09.06]ココロから ね\n[02:13.74]サラサラ流れる風\n[02:17.30]僕らを誘ってるの\n[02:20.10]向かってみよう\n[02:22.24]立ちどまらない方がいいね\n[02:25.62]もう行かなくちゃってさ\n[02:27.64]キモチがせつない\n[02:29.28]そのせつなさを抱きしめ\n[02:32.92]いっしょにBrightest Melody\n[02:58.10]輝いていたいんだ\n[03:00.06]このまま進もう\n[03:05.81]Ah どこへ行っても忘れないよ\n[03:09.00]Brightest Melody\n[03:10.89]歌うたびに\n[03:12.69]生まれ変わるみたいで\n[03:16.09]Ah いつまでもいたい\n[03:18.19]みんなの想いは\n[03:19.91]きっとひとつだよ きっと\n[03:25.15]キラキラひかる夢が\n[03:28.58]僕らの胸のなかで輝いてた\n[03:33.32]熱く大きなキラキラ\n[03:36.81]さあ明日に向けて\n[03:38.92]また始めたい\n[03:40.27]とびっきりの何か 何かを\n[03:44.19]それは なんだろうね\n[03:49.65]あたらしい夢 あたらしい歌\n[03:54.70]つながってくんだ',
      1,
      0,
    )) {
      await db.insert('sn_lyric', lyric.toMap());
    }
    for (SNLyric lyric in SNLyric.parseFromLrc(
      '[00:18.67]欠片 それはほんの小さな\n[00:23.41]Starlight\n[00:24.75]砂に混じり 鈍く光る一粒\n[00:30.70]だけどなぜか目を奪われた\n[00:35.34]Starshine\n[00:36.80]だって未知の可能性を反射してる\n[00:42.65]星よ 星よ\n[00:45.14]キラめいていて\n[00:46.58]キラめいていて\n[00:48.63]まだ届かなくても\n[00:50.27]諦めたりしない\n[00:51.76]きっときっと\n[00:53.21]私 追いつくよ\n[00:57.04]幕が開けて 生まれ変われ\n[00:59.96]舞台の上で強くなれるから\n[01:03.65]ぶつかって傷つけて\n[01:05.13]磨り減って削られて\n[01:06.66]意味なすアスペクト\n[01:09.02]たどり着いた軌道までは\n[01:11.92]照らす必要なんてないんだよ\n[01:15.30]眩しいけれど 目をそらさずに\n[01:18.18]この今の私を見て\n[01:21.05]Star diamond\n[01:36.59]熱を秘めた夢の純度は\n[01:41.30]Starlight\n[01:42.77]透明なほど壊れそうで脆くて\n[01:48.67]答えだけは見えていたんだ\n[01:53.35]Starshine\n[01:54.74]だけど\n[01:56.25]近づこうとすれば遠のいてく\n[02:00.73]そっと そっと\n[02:03.00]衣装の裏に\n[02:04.62]衣装の裏に\n[02:06.74]忘れないようにと\n[02:08.24]縫い付けた想いは\n[02:09.73]いつもいつも\n[02:11.24]袖を通すたび\n[02:13.29]はためく\n[02:15.11]私たちは 輝き出す\n[02:17.95]光浴びて 歪にはね返す\n[02:21.70]迷いなんてないよ\n[02:23.15]ただ走り出すんだ\n[02:24.75]存在がクラリティ\n[02:27.01]生まれてきた物語は\n[02:29.96]そう私たちが紡いでいるの\n[02:33.29]他の誰かに 譲ったりしない\n[02:36.34]目の前の私を見て\n[02:39.10]Star diamond\n[03:18.14]誰の心にもきっと\n[03:21.94]原石が磨かれる時を待ってる\n[03:30.38]探しに行こう 一緒に\n[03:33.45]どこまでだって 潜って\n[03:36.69]ときにキミがそう望むのならば\n[03:41.03]戦おう\n[03:43.56]負けられない キミにだけは\n[03:46.44]舞台の上では向かい合おうね\n[03:50.21]暴れる剣先も 震える歌声も\n[03:53.20]受け止めて欲しいよ\n[03:57.01]幕が開けて 生まれ変われ\n[03:59.92]舞台の上で強くなれるから\n[04:03.72]ぶつかって傷つけて\n[04:05.23]磨り減って削られて\n[04:06.70]意味なすアスペクト\n[04:08.97]たどり着いた軌道までは\n[04:11.95]照らす必要なんてないんだよ\n[04:15.10]眩しいけれど 目をそらさずに\n[04:18.14]この今の私を見て\n[04:20.99]Star diamond\n[04:24.11]ずっと私を見ていた\n[04:27.09]Star diamond',
      2,
      -520,
    )) {
      await db.insert('sn_lyric', lyric.toMap());
    }
    await db.insert(
      'sn_shot_table',
      SNShotTable(
              id: 1,
              name: 'Default ShotTable for Brightest Melody',
              authorId: 1,
              songId: 1)
          .toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
      'sn_shot_table',
      SNShotTable(
              id: 2,
              name: 'Default ShotTable for Star Diamond',
              authorId: 1,
              songId: 2)
          .toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
      'sn_shot',
      SNShot(
          id: 100001,
          sceneNumber: 1010,
          shotNumber: 1,
          startTime: Duration(milliseconds: 18100),
          endTime: Duration(milliseconds: 20000),
          lyric: 'yarimasune',
          shotType: 'MEDIUMSHOT',
          shotMovement: '逆时针环绕',
          shotAngle: '略仰',
          text: 'taiga!waiya!saiba!faiba!',
          image: '',
          comment: 'No additional comment.',
          tableId: 2,
          characters: [SNCharacter.karen(), SNCharacter.hikari()]).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
      'sn_shot',
      SNShot(
          id: 100002,
          sceneNumber: 1020,
          shotNumber: 2,
          startTime: Duration(milliseconds: 22900),
          endTime: Duration(milliseconds: 23333),
          lyric: 'iiyo koiyo',
          shotType: 'CLOSEUP',
          shotMovement: '前推',
          shotAngle: '略俯',
          text: 'jyajya!',
          image: '',
          comment: 'No additional comment.',
          tableId: 2,
          characters: [SNCharacter.mahiru(), SNCharacter.kuro()]).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class ProjectSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNProject project) async {
    final db = await database;
    await db.insert(
      'sn_project',
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed.');
  }

  Future<SNProject> retrieve(int id) async {
    final db = await database;
    final mapList =
        await db.query('sn_project', where: 'id = ?', whereArgs: [id]);
    return SNProject.fromMap(mapList.first);
  }

  Future<List<SNProject>> retrieveMultiple(int count) async {
    final db = await database;
    final mapList =
        await db.query('sn_project', orderBy: 'id DESC', limit: count);
    return List.generate(mapList.length, (i) => SNProject.fromMap(mapList[i]));
  }

  Future<void> update(SNProject project) async {
    final db = await database;
    await db.update(
      'sn_project',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
    print('Update operation succeed.');
  }

  Future<void> delete(SNProject project) async {
    final db = await database;
    await db.delete(
      'sn_project',
      where: 'id = ?',
      whereArgs: [project.id],
    );
    print('Delete operation succeed.');
  }
}

class SongSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNSong song) async {
    final db = await database;
    await db.insert(
      'sn_song',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed.');
  }

  Future<SNSong> retrieve(int id) async {
    final db = await database;
    final mapList = await db.query('sn_song', where: 'id = ?', whereArgs: [id]);
    return SNSong.fromMap(mapList.first);
  }

  Future<List<SNSong>> retrieveMultiple() async {
    final db = await database;
    final mapList = await db.query('sn_song', orderBy: 'id DESC');
    return List.generate(mapList.length, (i) => SNSong.fromMap(mapList[i]));
  }

  Future<void> update(SNSong song) async {
    final db = await database;
    await db.update(
      'sn_song',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
    print('Update operation succeed.');
  }

  Future<void> delete(SNSong song) async {
    final db = await database;
    await db.delete(
      'sn_song',
      where: 'id = ?',
      whereArgs: [song.id],
    );
    print('Delete operation succeed.');
  }
}

class ShotSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNShot shot) async {
    final db = await database;
    await db.insert(
      'sn_shot',
      shot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed.');
  }

  Future<List<SNShot>> retrieve(int tableId) async {
    final db = await database;
    final mapList = await db.query('sn_shot',
        where: 'tableId = ?', whereArgs: [tableId], orderBy: 'startTime DESC');
    return List.generate(mapList.length, (i) => SNShot.fromMap(mapList[i]));
  }

  Future<void> update(SNShot shot) async {
    final db = await database;
    await db.update(
      'sn_shot',
      shot.toMap(),
      where: 'id = ?',
      whereArgs: [shot.id],
    );
    print('Update operation succeed.');
  }

  Future<void> delete(SNShot shot) async {
    final db = await database;
    await db.delete(
      'sn_shot',
      where: 'id = ?',
      whereArgs: [shot.id],
    );
    print('Delete operation succeed.');
  }

  Future<void> deleteMultiple(List<SNShot> shots) async {
    final db = await database;
    shots.forEach((shot) async {
      await db.delete(
        'sn_shot',
        where: 'id = ?',
        whereArgs: [shot.id],
      );
    });
    print('Delete operation succeed.');
  }

  Future<int> getLatestShotTable(int songId) async {
    // final db = await database;
    // final List<Map<String, dynamic>> latestShot = await db.query(
    //     'sn_shot',
    //     where: 'songId = ?',
    //     whereArgs: [songId],
    //     orderBy: 'shotVersion DESC',
    //     limit: 1);
    // return latestShot.first['shotVersion'];
  }
}

class LyricSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNLyric lyric) async {
    final db = await database;
    await db.insert(
      'sn_lyric',
      lyric.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed.');
  }

  Future<List<SNLyric>> retrieve(int songId) async {
    final db = await database;
    final mapList = await db.query('sn_lyric',
        where: 'songId = ?', whereArgs: [songId], orderBy: 'startTime DESC');
    return List.generate(mapList.length, (i) => SNLyric.fromMap(mapList[i]));
  }

  Future<void> update(SNLyric lyric) async {
    final db = await database;
    await db.update(
      'sn_lyric',
      lyric.toMap(),
      where: 'id = ?',
      whereArgs: [lyric.id],
    );
    print('Update operation succeed.');
  }

  Future<void> delete(SNLyric lyric) async {
    final db = await database;
    await db.delete(
      'sn_lyric',
      where: 'id = ?',
      whereArgs: [lyric.id],
    );
    print('Delete operation succeed.');
  }
}

class FormationSQLiteProvider extends SQLiteProvider {
  Future<void> create(SNFormation formation) async {
    final db = await database;
    await db.insert(
      'sn_formation',
      formation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Create operation succeed.');
  }

  Future<List<SNFormation>> retrieve(int tableId) async {
    final db = await database;
    final mapList = await db.query('sn_formation',
        where: 'tableId = ?', whereArgs: [tableId], orderBy: 'startTime DESC');
    return List.generate(
        mapList.length, (i) => SNFormation.fromMap(mapList[i]));
  }

  Future<void> update(SNFormation formation) async {
    final db = await database;
    await db.update(
      'sn_formation',
      formation.toMap(),
      where: 'id = ?',
      whereArgs: [formation.id],
    );
    print('Update operation succeed.');
  }

  Future<void> delete(SNFormation formation) async {
    final db = await database;
    await db.delete(
      'sn_formation',
      where: 'id = ?',
      whereArgs: [formation.id],
    );
    print('Delete operation succeed.');
  }
}
