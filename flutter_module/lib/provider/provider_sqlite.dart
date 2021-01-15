import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/character.dart';
import '../model/project.dart';
import '../model/song.dart';
import '../model/lyric.dart';
import '../model/shot.dart';

class ProviderSqlite {
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
            'CREATE TABLE projecttable(projectId INTEGER PRIMARY KEY, projectDate TEXT, dancerName TEXT, songId INTEGER, shotVersion INTEGER, formationVersion INTEGER)',
          );
          db.execute(
            'CREATE TABLE songtable(songId INTEGER PRIMARY KEY, songName TEXT, subordinateKikaku TEXT, shotVersions TEXT, lyricOffset INTEGER, coverFileName TEXT, videoIntros TEXT, videoFileNames TEXT, videoOffsets TEXT)',
          );
          db.execute(
            'CREATE TABLE lyrictable(songId INTEGER, startTime INTEGER, endTime INTEGER, lyricContent TEXT, soloCharacters TEXT)',
          );
          db.execute(
            'CREATE TABLE formationtable(songId INTEGER, formationVersion INTEGER, characterName TEXT, memberColor INTEGER, startTime INTEGER, posX REAL, posY REAL, curveX1X INTEGER, curveX1Y INTEGER, curveX2X INTEGER, curveX2Y INTEGER, curveY1X INTEGER, curveY1Y INTEGER, curveY2X INTEGER, curveY2Y INTEGER)',
          );
          db.execute(
            'CREATE TABLE shottable(songId INTEGER, shotVersion INTEGER, shotName TEXT, startTime INTEGER, endTime INTEGER, shotNumber INTEGER, shotLyric TEXT, shotScene INTEGER, shotCharacters TEXT, shotType TEXT, shotMovement TEXT, shotAngle TEXT, shotContent TEXT, shotImage TEXT, shotComment TEXT)',
          );
        },
        version: 1,
      );
    }
    return _database;
  }

  Future<void> insert(String table, Map map) async {
    final db = await database;
    await db.insert(
      table,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Insert succeed.');
  }

  Future<void> delete(String table,
      {String where, List<dynamic> whereArgs}) async {
    final db = await database;
    await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
    print('Delete succeed.');
  }

  Future<void> update(String table, Map map,
      {String where, List<dynamic> whereArgs}) async {
    final db = await database;
    await db.update(
      table,
      map,
      where: where,
      whereArgs: whereArgs,
    );
    print('Update succeed.');
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String where,
      List<dynamic> whereArgs,
      String orderBy,
      int limit}) async {
    final db = await database;
    return await db.query(table,
        where: where, whereArgs: whereArgs, orderBy: orderBy, limit: limit);
  }

  static Future<void> supermutekiniubireset() async {
    final db = await _database;
    await db.delete('projecttable');
    await db.delete('songtable');
    await db.delete('lyrictable');
    await db.delete('shottable');
    await db.delete('formationtable');
    await db.insert(
        'projecttable',
        Project(
                projectId: 3,
                projectDate: DateTime.parse('2019-11-24'),
                dancerName: '秘镜舞团',
                songId: 2,
                shotVersion: 2,
                formationVersion: 2)
            .toMap());
    await db.insert(
        'projecttable',
        Project(
                projectId: 4,
                projectDate: DateTime.parse('2020-01-01'),
                dancerName: '待定',
                songId: 1,
                shotVersion: 1,
                formationVersion: 1)
            .toMap());
    await db.insert(
        'songtable',
        Song(
            songId: 1,
            songName: 'Star Diamond',
            subordinateKikaku: 'スタァライト九九組',
            // 精确值为-520
            lyricOffset: -520,
            coverFileName: 'Star Diamond_cover.jpg',
            videoIntros: ['Default'],
            videoFileNames: ['Star Diamond_video.mp4'],
            // 精确值为172880
            videoOffsets: [172880]).toMap());
    await db.insert(
        'songtable',
        Song(
            songId: 2,
            songName: 'Brightest Melody',
            subordinateKikaku: 'Aqours',
            lyricOffset: 0,
            coverFileName: 'Brightest Melody_cover.jpg',
            videoIntros: [''],
            videoFileNames: [''],
            videoOffsets: [0]).toMap());
    for (Lyric lyric in Lyric.parseFromLrc(
      '[00:18.67]欠片 それはほんの小さな\n[00:23.41]Starlight\n[00:24.75]砂に混じり 鈍く光る一粒\n[00:30.70]だけどなぜか目を奪われた\n[00:35.34]Starshine\n[00:36.80]だって未知の可能性を反射してる\n[00:42.65]星よ 星よ\n[00:45.14]キラめいていて\n[00:46.58]キラめいていて\n[00:48.63]まだ届かなくても\n[00:50.27]諦めたりしない\n[00:51.76]きっときっと\n[00:53.21]私 追いつくよ\n[00:57.04]幕が開けて 生まれ変われ\n[00:59.96]舞台の上で強くなれるから\n[01:03.65]ぶつかって傷つけて\n[01:05.13]磨り減って削られて\n[01:06.66]意味なすアスペクト\n[01:09.02]たどり着いた軌道までは\n[01:11.92]照らす必要なんてないんだよ\n[01:15.30]眩しいけれど 目をそらさずに\n[01:18.18]この今の私を見て\n[01:21.05]Star diamond\n[01:36.59]熱を秘めた夢の純度は\n[01:41.30]Starlight\n[01:42.77]透明なほど壊れそうで脆くて\n[01:48.67]答えだけは見えていたんだ\n[01:53.35]Starshine\n[01:54.74]だけど\n[01:56.25]近づこうとすれば遠のいてく\n[02:00.73]そっと そっと\n[02:03.00]衣装の裏に\n[02:04.62]衣装の裏に\n[02:06.74]忘れないようにと\n[02:08.24]縫い付けた想いは\n[02:09.73]いつもいつも\n[02:11.24]袖を通すたび\n[02:13.29]はためく\n[02:15.11]私たちは 輝き出す\n[02:17.95]光浴びて 歪にはね返す\n[02:21.70]迷いなんてないよ\n[02:23.15]ただ走り出すんだ\n[02:24.75]存在がクラリティ\n[02:27.01]生まれてきた物語は\n[02:29.96]そう私たちが紡いでいるの\n[02:33.29]他の誰かに 譲ったりしない\n[02:36.34]目の前の私を見て\n[02:39.10]Star diamond\n[03:18.14]誰の心にもきっと\n[03:21.94]原石が磨かれる時を待ってる\n[03:30.38]探しに行こう 一緒に\n[03:33.45]どこまでだって 潜って\n[03:36.69]ときにキミがそう望むのならば\n[03:41.03]戦おう\n[03:43.56]負けられない キミにだけは\n[03:46.44]舞台の上では向かい合おうね\n[03:50.21]暴れる剣先も 震える歌声も\n[03:53.20]受け止めて欲しいよ\n[03:57.01]幕が開けて 生まれ変われ\n[03:59.92]舞台の上で強くなれるから\n[04:03.72]ぶつかって傷つけて\n[04:05.23]磨り減って削られて\n[04:06.70]意味なすアスペクト\n[04:08.97]たどり着いた軌道までは\n[04:11.95]照らす必要なんてないんだよ\n[04:15.10]眩しいけれど 目をそらさずに\n[04:18.14]この今の私を見て\n[04:20.99]Star diamond\n[04:24.11]ずっと私を見ていた\n[04:27.09]Star diamond',
      1,
      -520,
    )) {
      await db.insert('lyrictable', lyric.toMap());
    }
    for (Lyric lyric in Lyric.parseFromLrc(
      '[00:01.39]Ah どこへ行っても忘れないよ\n[00:04.67]Brightest Melody\n[00:20.08]いつまでもここにいたい\n[00:23.37]みんなの想いは\n[00:25.71]きっとひとつだよ\n[00:27.88]ずっと歌おうみんなで\n[00:30.29]だけど先に道がある\n[00:33.68]いろんなミライ\n[00:36.06]次のトキメキへと\n[00:39.84]出会い 別れ\n[00:42.57]繰り返すってことが\n[00:45.03]わかってきたんだ\n[00:47.60]でも笑顔でね\n[00:49.68]また会おうと言ってみよう\n[00:52.59]ココロから ね\n[00:59.94]キラキラひかる夢が\n[01:03.36]僕らの胸のなかで輝いてた\n[01:08.19]熱く大きなキラキラ\n[01:11.56]さあ明日に向けて\n[01:13.74]また始めたい\n[01:15.10]とびっきりの何か 何かを\n[01:19.07]それは なんだろうね\n[01:24.24]楽しみなんだ\n[01:36.60]だいじにねしたいんだ\n[01:39.78]みんな汗かいて\n[01:42.25]がんばった日々を\n[01:44.28]いっぱい練習したね\n[01:46.91]やればできる できるんだと\n[01:50.15]描いたミライ\n[01:52.58]それがイマになった\n[01:56.45]別れ 出会い\n[01:59.16]どちらが最初なのか\n[02:01.48]わからないままだよ\n[02:04.10]でも気にしない\n[02:06.33]また会えるね そう思うよ\n[02:09.06]ココロから ね\n[02:13.74]サラサラ流れる風\n[02:17.30]僕らを誘ってるの\n[02:20.10]向かってみよう\n[02:22.24]立ちどまらない方がいいね\n[02:25.62]もう行かなくちゃってさ\n[02:27.64]キモチがせつない\n[02:29.28]そのせつなさを抱きしめ\n[02:32.92]いっしょにBrightest Melody\n[02:58.10]輝いていたいんだ\n[03:00.06]このまま進もう\n[03:05.81]Ah どこへ行っても忘れないよ\n[03:09.00]Brightest Melody\n[03:10.89]歌うたびに\n[03:12.69]生まれ変わるみたいで\n[03:16.09]Ah いつまでもいたい\n[03:18.19]みんなの想いは\n[03:19.91]きっとひとつだよ きっと\n[03:25.15]キラキラひかる夢が\n[03:28.58]僕らの胸のなかで輝いてた\n[03:33.32]熱く大きなキラキラ\n[03:36.81]さあ明日に向けて\n[03:38.92]また始めたい\n[03:40.27]とびっきりの何か 何かを\n[03:44.19]それは なんだろうね\n[03:49.65]あたらしい夢 あたらしい歌\n[03:54.70]つながってくんだ',
      2,
      0,
    )) {
      await db.insert('lyrictable', lyric.toMap());
    }
    await db.insert(
      'shottable',
      Shot(
              songId: 1,
              shotVersion: 1,
              shotName: 'Star Diamond_1',
              startTime: Duration(milliseconds: 18100),
              endTime: Duration(milliseconds: 2222),
              shotNumber: 7,
              shotLyric: 'yarimasune',
              shotScene: 1010,
              shotCharacters: [Character.karen(), Character.hikari()],
              shotType: 'MEDIUMSHOT',
              shotMovement: '逆时针环绕',
              shotAngle: '略仰',
              shotContent: 'taiga!waiya!saiba!faiba!',
              shotImage: '',
              shotComment: 'No additional comment.')
          .toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
      'shottable',
      Shot(
              songId: 1,
              shotVersion: 1,
              shotName: 'Star Diamond_1',
              startTime: Duration(milliseconds: 22900),
              endTime: Duration(milliseconds: 4444),
              shotNumber: 8,
              shotLyric: 'iiyo koiyo',
              shotScene: 1050,
              shotCharacters: [Character.futaba(), Character.kaoruko()],
              shotType: 'LONGSHOT',
              shotMovement: '右移',
              shotAngle: '平',
              shotContent: 'daiba!baiba!jyajya!',
              shotImage: '',
              shotComment: 'No additional comment.')
          .toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
