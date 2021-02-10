import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/project.dart';
import '../models/song.dart';
import '../models/lyric.dart';
import '../models/shot_table.dart';
import '../models/shot.dart';
import '../models/character.dart';
import 'project.dart';
import 'song.dart';
import '../repositories/project.dart';
import '../repositories/song.dart';
import '../repositories/lyric.dart';
import '../repositories/shot_table.dart';
import '../repositories/shot.dart';
import '../repositories/attachment.dart';
import '../providers/firestore/firestore.dart';
import '../utils/des.dart';
import '../utils/reg_exp.dart';
import '../utils/data_convert.dart';

class MigratorController extends GetxController {
  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();

  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final LyricRepository lyricRepository;
  final ShotTableRepository shotTableRepository;
  final ShotRepository shotRepository;
  final AttachmentRepository attachmentRepository;

  RxString markdownText = RxString(null);
  bool needEncrypt = false;

  String myJson;

  MigratorController(
      this.projectRepository,
      this.songRepository,
      this.lyricRepository,
      this.shotTableRepository,
      this.shotRepository,
      this.attachmentRepository)
      : assert(projectRepository != null),
        assert(songRepository != null),
        assert(lyricRepository != null),
        assert(shotTableRepository != null),
        assert(shotRepository != null),
        assert(attachmentRepository != null);

  @override
  void onInit() {
    super.onInit();
  }

  void importMarkdown(String key) async {
    try {
      String mdText = await attachmentRepository
          .importMarkdown(projectController.editingProject.value);
      if (key != null) {
        mdText = desDecrypt(mdText, key);
      }
      markdownText(mdText);
    } catch (e) {
      print(e);
    }
  }

  void confirmImportMarkdown() async {
    try {
      final List<SNShot> shots = await parseShots(
          projectController.editingProject.value, markdownText.value);
      for (SNShot shot in shots) {
        await shotRepository.create(shot);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<SNShot>> parseShots(SNProject project, String mdText) async {
    String storyboardText = storyboardChapterRegExp.stringMatch(mdText);
    String shotsText =
        RegExp(r'(?<=---\s\|\n).+', dotAll: true).stringMatch(storyboardText);
    final String tableId =
        (await shotTableRepository.getLatestShotTable(project.songId)).id + '1';
    final String kikaku =
        (await songRepository.retrieveById(project.songId)).subordinateKikaku;
    return shotsText
        .split('\n')
        .where((element) => RegExp(r'^\|.+\|$').hasMatch(element))
        .map((String shotText) {
      List<RegExpMatch> shotProps =
          RegExp(r'(?<=\|\s)[^\|]*(?=\s\|)').allMatches(shotText).toList();
      return SNShot(
        id: shotProps[0].group(0),
        sceneNumber: int.parse(shotProps[1].group(0)),
        shotNumber: int.parse(shotProps[2].group(0)),
        startTime: simpleDurationToDuration(shotProps[3].group(0)),
        endTime: simpleDurationToDuration(shotProps[4].group(0)),
        lyric: shotProps[5].group(0),
        shotType: shotProps[6].group(0),
        shotMovement: shotProps[7].group(0),
        shotAngle: shotProps[8].group(0),
        text: shotProps[9].group(0),
        image: shotProps[10].group(0),
        comment: shotProps[11].group(0),
        tableId: tableId,
        characters:
            SNCharacter.abbrStringToList(shotProps[12].group(0), kikaku),
      );
    }).toList();
  }

  void previewMarkdown() async {
    try {
      markdownText(generateIntro(projectController.editingProject.value,
              songController.editingSong.value) +
          generateShotDataTable(await shotRepository.retrieveForTable(
              projectController.editingProject.value.shotTableId)));
    } catch (e) {
      print(e);
    }
  }

  String generateIntro(SNProject project, SNSong song) {
    String mdText =
        '# ' + project.dancerName + ' ' + song.name + ' 拍摄计划\n\n拍摄日期：\n';
    return mdText;
  }

  String generateShotDataTable(List<SNShot> shots) {
    String mdText = '# 分镜表\n';
    for (String title in SNShot.titles) {
      mdText += '| ' + title + ' ';
    }
    mdText += '|\n';
    mdText += ('| --- ') * SNShot.titles.length;
    mdText += '|\n';

    for (SNShot shot in shots) {
      mdText += ' | ' +
          shot.id.toString() +
          ' | ' +
          shot.sceneNumber.toString() +
          ' | ' +
          shot.shotNumber.toString() +
          ' | ' +
          simpleDurationRegExp.stringMatch(shot.startTime.toString()) +
          ' | ' +
          simpleDurationRegExp.stringMatch(shot.endTime.toString()) +
          ' | ' +
          shot.lyric +
          ' | ' +
          shot.shotType +
          ' | ' +
          shot.shotMovement +
          ' | ' +
          shot.shotAngle +
          ' | ' +
          shot.text +
          ' | ' +
          shot.image +
          ' | ' +
          shot.comment +
          ' | ' +
          shot.tableId.toString() +
          ' | ' +
          SNCharacter.listToAbbrString(shot.characters) +
          ' |\n';
    }
    return mdText;
  }

  Future<void> exportMarkdown(String key) async {
    try {
      if (key != null) {
        await attachmentRepository.exportMarkdown(
            projectController.editingProject.value,
            desEncrypt(markdownText.value, key));
      } else {
        await attachmentRepository.exportMarkdown(
            projectController.editingProject.value, markdownText.value);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> exportJson() {
    final map = {
      'sn_project': [],
      'sn_song': [],
      'sn_lyric': [],
      'sn_shot_table': [],
      'sn_shot': []
    };

    map['sn_project'].add(SNProject(
            id: '1001',
            dancerName: '舞团A',
            createdTime: DateTime.parse('20191124'),
            modifiedTime: DateTime.parse('20191124'),
            songId: '1',
            shotTableId: '1',
            formationTableId: '1')
        .toMap());
    map['sn_project'].add(SNProject(
            id: '1002',
            dancerName: '舞团B',
            createdTime: DateTime.parse('20200101'),
            modifiedTime: DateTime.parse('20200101'),
            songId: '2',
            shotTableId: '2',
            formationTableId: '2')
        .toMap());
    map['sn_song'].add(SNSong(
            id: '1',
            name: 'Brightest Melody',
            coverId: 'Brightest Melody_cover.jpg',
            lyricOffset: 0,
            subordinateKikaku: 'Aqours')
        .toMap());
    map['sn_song'].add(SNSong(
            id: '2',
            name: 'Star Diamond',
            coverId: 'Star Diamond_cover.jpg',
            // 精确值为-520
            lyricOffset: -520,
            subordinateKikaku: 'スタァライト九九組')
        .toMap());
    SNLyric.parseFromLrc(
      '[00:01.39]Ah どこへ行っても忘れないよ\n[00:04.67]Brightest Melody\n[00:20.08]いつまでもここにいたい\n[00:23.37]みんなの想いは\n[00:25.71]きっとひとつだよ\n[00:27.88]ずっと歌おうみんなで\n[00:30.29]だけど先に道がある\n[00:33.68]いろんなミライ\n[00:36.06]次のトキメキへと\n[00:39.84]出会い 別れ\n[00:42.57]繰り返すってことが\n[00:45.03]わかってきたんだ\n[00:47.60]でも笑顔でね\n[00:49.68]また会おうと言ってみよう\n[00:52.59]ココロから ね\n[00:59.94]キラキラひかる夢が\n[01:03.36]僕らの胸のなかで輝いてた\n[01:08.19]熱く大きなキラキラ\n[01:11.56]さあ明日に向けて\n[01:13.74]また始めたい\n[01:15.10]とびっきりの何か 何かを\n[01:19.07]それは なんだろうね\n[01:24.24]楽しみなんだ\n[01:36.60]だいじにねしたいんだ\n[01:39.78]みんな汗かいて\n[01:42.25]がんばった日々を\n[01:44.28]いっぱい練習したね\n[01:46.91]やればできる できるんだと\n[01:50.15]描いたミライ\n[01:52.58]それがイマになった\n[01:56.45]別れ 出会い\n[01:59.16]どちらが最初なのか\n[02:01.48]わからないままだよ\n[02:04.10]でも気にしない\n[02:06.33]また会えるね そう思うよ\n[02:09.06]ココロから ね\n[02:13.74]サラサラ流れる風\n[02:17.30]僕らを誘ってるの\n[02:20.10]向かってみよう\n[02:22.24]立ちどまらない方がいいね\n[02:25.62]もう行かなくちゃってさ\n[02:27.64]キモチがせつない\n[02:29.28]そのせつなさを抱きしめ\n[02:32.92]いっしょにBrightest Melody\n[02:58.10]輝いていたいんだ\n[03:00.06]このまま進もう\n[03:05.81]Ah どこへ行っても忘れないよ\n[03:09.00]Brightest Melody\n[03:10.89]歌うたびに\n[03:12.69]生まれ変わるみたいで\n[03:16.09]Ah いつまでもいたい\n[03:18.19]みんなの想いは\n[03:19.91]きっとひとつだよ きっと\n[03:25.15]キラキラひかる夢が\n[03:28.58]僕らの胸のなかで輝いてた\n[03:33.32]熱く大きなキラキラ\n[03:36.81]さあ明日に向けて\n[03:38.92]また始めたい\n[03:40.27]とびっきりの何か 何かを\n[03:44.19]それは なんだろうね\n[03:49.65]あたらしい夢 あたらしい歌\n[03:54.70]つながってくんだ',
      '1',
      0,
    ).forEach((lyric) => map['sn_lyric'].add(lyric.toMap()));
    SNLyric.parseFromLrc(
      '[00:18.67]欠片 それはほんの小さな\n[00:23.41]Starlight\n[00:24.75]砂に混じり 鈍く光る一粒\n[00:30.70]だけどなぜか目を奪われた\n[00:35.34]Starshine\n[00:36.80]だって未知の可能性を反射してる\n[00:42.65]星よ 星よ\n[00:45.14]キラめいていて\n[00:46.58]キラめいていて\n[00:48.63]まだ届かなくても\n[00:50.27]諦めたりしない\n[00:51.76]きっときっと\n[00:53.21]私 追いつくよ\n[00:57.04]幕が開けて 生まれ変われ\n[00:59.96]舞台の上で強くなれるから\n[01:03.65]ぶつかって傷つけて\n[01:05.13]磨り減って削られて\n[01:06.66]意味なすアスペクト\n[01:09.02]たどり着いた軌道までは\n[01:11.92]照らす必要なんてないんだよ\n[01:15.30]眩しいけれど 目をそらさずに\n[01:18.18]この今の私を見て\n[01:21.05]Star diamond\n[01:36.59]熱を秘めた夢の純度は\n[01:41.30]Starlight\n[01:42.77]透明なほど壊れそうで脆くて\n[01:48.67]答えだけは見えていたんだ\n[01:53.35]Starshine\n[01:54.74]だけど\n[01:56.25]近づこうとすれば遠のいてく\n[02:00.73]そっと そっと\n[02:03.00]衣装の裏に\n[02:04.62]衣装の裏に\n[02:06.74]忘れないようにと\n[02:08.24]縫い付けた想いは\n[02:09.73]いつもいつも\n[02:11.24]袖を通すたび\n[02:13.29]はためく\n[02:15.11]私たちは 輝き出す\n[02:17.95]光浴びて 歪にはね返す\n[02:21.70]迷いなんてないよ\n[02:23.15]ただ走り出すんだ\n[02:24.75]存在がクラリティ\n[02:27.01]生まれてきた物語は\n[02:29.96]そう私たちが紡いでいるの\n[02:33.29]他の誰かに 譲ったりしない\n[02:36.34]目の前の私を見て\n[02:39.10]Star diamond\n[03:18.14]誰の心にもきっと\n[03:21.94]原石が磨かれる時を待ってる\n[03:30.38]探しに行こう 一緒に\n[03:33.45]どこまでだって 潜って\n[03:36.69]ときにキミがそう望むのならば\n[03:41.03]戦おう\n[03:43.56]負けられない キミにだけは\n[03:46.44]舞台の上では向かい合おうね\n[03:50.21]暴れる剣先も 震える歌声も\n[03:53.20]受け止めて欲しいよ\n[03:57.01]幕が開けて 生まれ変われ\n[03:59.92]舞台の上で強くなれるから\n[04:03.72]ぶつかって傷つけて\n[04:05.23]磨り減って削られて\n[04:06.70]意味なすアスペクト\n[04:08.97]たどり着いた軌道までは\n[04:11.95]照らす必要なんてないんだよ\n[04:15.10]眩しいけれど 目をそらさずに\n[04:18.14]この今の私を見て\n[04:20.99]Star diamond\n[04:24.11]ずっと私を見ていた\n[04:27.09]Star diamond',
      '2',
      -520,
    ).forEach((lyric) => map['sn_lyric'].add(lyric.toMap()));
    map['sn_shot_table'].add(SNShotTable(
            id: '1',
            name: 'Default ShotTable for Brightest Melody',
            authorId: '1',
            songId: '1')
        .toMap());
    map['sn_shot_table'].add(SNShotTable(
            id: '2',
            name: 'Default ShotTable for Star Diamond',
            authorId: '1',
            songId: '2')
        .toMap());
    map['sn_shot'].add(SNShot(
        id: '100001',
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
        tableId: '2',
        characters: [SNCharacter.karen(), SNCharacter.hikari()]).toMap());
    map['sn_shot'].add(SNShot(
        id: '100002',
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
        tableId: '2',
        characters: [SNCharacter.mahiru(), SNCharacter.kuro()]).toMap());
    attachmentRepository.exportJson(json.encode(map));
  }

  Future<void> importJson() async {
    // await db.delete('sn_project');
    // await db.delete('sn_song');
    // await db.delete('sn_lyric');
    // await db.delete('sn_shot_table');
    // await db.delete('sn_shot');
    // await db.delete('sn_formation_table');
    // await db.delete('sn_formation');

    final map = Map<String, List>.from(
        json.decode(await attachmentRepository.importJsonFromAssets()));
    map['sn_project'].forEach((p) async => await FirebaseFirestore.instance
        .collection('sn_project')
        .doc(p['id'])
        .set(p));
    map['sn_song'].forEach((s) async => await FirebaseFirestore.instance
        .collection('sn_song')
        .doc(s['id'])
        .set(s));
    map['sn_lyric'].forEach((l) async => await FirebaseFirestore.instance
        .collection('sn_lyric')
        .doc(l['id'])
        .set(l));
    map['sn_shot_table'].forEach((st) async => await FirebaseFirestore.instance
        .collection('sn_shot_table')
        .doc(st['id'])
        .set(st));
    map['sn_shot'].forEach((s) async => await FirebaseFirestore.instance
        .collection('sn_shot')
        .doc(s['id'])
        .set(s));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
