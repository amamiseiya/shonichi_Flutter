import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'character.dart';
import 'project.dart';
import 'storyboard.dart';
import 'song.dart';
import '../models/project.dart';
import '../models/song.dart';
import '../models/lyric.dart';
import '../models/storyboard.dart';
import '../models/shot.dart';
import '../models/character.dart';
import '../repositories/project.dart';
import '../repositories/song.dart';
import '../repositories/lyric.dart';
import '../repositories/storyboard.dart';
import '../repositories/shot.dart';
import '../repositories/asset.dart';
import '../providers/firestore/firestore.dart';
import '../utils/des.dart';
import '../utils/reg_exp.dart';
import '../utils/data_convert.dart';
import '../pages/storyboard/storyboard.dart';

class DataMigrationController extends GetxController {
  final CharacterController characterController = Get.find();
  final ProjectController projectController = Get.find();
  final StoryboardController storyboardController = Get.find();
  final SongController songController = Get.find();

  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final LyricRepository lyricRepository;
  final StoryboardRepository storyboardRepository;
  final ShotRepository shotRepository;
  final AssetRepository assetRepository;

  RxnString markdownText = RxnString(null);
  bool needEncrypt = false;

  DataMigrationController(this.projectRepository,
      this.songRepository,
      this.lyricRepository,
      this.storyboardRepository,
      this.shotRepository,
      this.assetRepository)
      : assert(projectRepository != null),
        assert(songRepository != null),
        assert(lyricRepository != null),
        assert(storyboardRepository != null),
        assert(shotRepository != null),
        assert(assetRepository != null);

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<SNShot>> parseShots(SNProject project, String mdText) async {
    String storyboardSection = storyboardChapterRegExp.stringMatch(mdText)!;
    String shotSection =
    RegExp(r'(?<=---\s\|\n).+', dotAll: true).stringMatch(storyboardSection)!;
    final String storyboardId =
        (await storyboardController.submitCreate(SNStoryboard.initialValue()
          ..name = 'Imported')).id;
    final String kikaku =
        (await songRepository.retrieveById(project.songId!)).subordinateKikaku;
    return shotSection
        .split('\n')
        .where((element) => RegExp(r'^\|.+\|$').hasMatch(element))
        .map((String shotRecord) {
      List<RegExpMatch> shotProps =
      RegExp(r'(?<=\|\s)[^\|]*(?=\s\|)').allMatches(shotRecord).toList();
      return SNShot.fromText(
          {
        'sceneNumber': shotProps[0].group(0),
        'shotNumber': shotProps[1].group(0),
        'startTime': shotProps[2].group(0),
        'endTime': shotProps[3].group(0),
        'lyric': shotProps[4].group(0),
        'shotType': shotProps[5].group(0),
        'shotMove': shotProps[6].group(0),
        'shotAngle': shotProps[7].group(0),
        'text': shotProps[8].group(0),
        'imageURI': shotProps[9].group(0),
        'comment': shotProps[10].group(0),
        'storyboardId': storyboardId,
        'characters':shotProps[11].group(0),
      });
    }).toList();
  }


  void previewImportMarkdown(String? key) async {
    try {
      String mdText = await assetRepository
          .importMarkdown(projectController.editingProject.value!);
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
          projectController.editingProject.value!, markdownText.value!);
      for (SNShot shot in shots) {
        await shotRepository.create(shot);
      }
      markdownText();
    } catch (e) {
      print(e);
    }
  }

  void previewExportMarkdown() async {
    try {
      markdownText(generateIntro(projectController.editingProject.value!,
          songController.editingSong.value!) +
          generateShotDataTable(await shotRepository.retrieveForStoryboard(
              projectController.editingProject.value!.storyboardId!)));
    } catch (e) {
      print(e);
    }
  }

  String generateIntro(SNProject project, SNSong song) {
    String mdText = '# ' +
        project.dancerName +
        ' ' +
        song.name +
        ' 拍摄计划\n\n拍摄日期：' +
        project.createdTime.toIso8601String() +
        '\n';
    return mdText;
  }

  String generateShotDataTable(List<SNShot> shots) {
    String mdText = '# 分镜表\n';
    for (String title in ShotDataTable.titles.keys
        .toList()
        .sublist(0, ShotDataTable.titles.length - 1)) {
      mdText += '| ' + title + ' ';
    }
    mdText += '|\n';
    mdText += ('| --- ') * (ShotDataTable.titles.length - 1);
    mdText += '|\n';

    for (SNShot shot in shots) {
      final _textMap = shot.toText();
      mdText += ' | ' +
          _textMap['sceneNumber']! +
          ' | ' +
          _textMap['shotNumber']! +
          ' | ' +
          _textMap['startTime']! +
          ' | ' +
          _textMap['endTime']! +
          ' | ' +
          _textMap['lyric']! +
          ' | ' +
          _textMap['shotType']! +
          ' | ' +
          _textMap['shotMove']! +
          ' | ' +
          _textMap['shotAngle']! +
          ' | ' +
          _textMap['text']! +
          ' | ' +
          _textMap['imageURI']! +
          ' | ' +
          _textMap['comment']! +
          ' | ' +
          _textMap['characters']! +
          ' |\n';
    }
    return mdText;
  }

  Future<void> confirmExportMarkdown(String? key) async {
    try {
      if (key != null) {
        await assetRepository.exportMarkdown(
            projectController.editingProject.value!,
            desEncrypt(markdownText.value!, key));
      } else {
        await assetRepository.exportMarkdown(
            projectController.editingProject.value!, markdownText.value!);
      }
      markdownText();
    } catch (e) {
      print(e);
    }
  }

  Future<void> exportJson() async {
    final map = {
      'sn_project': [],
      'sn_song': [],
      'sn_lyric': [],
      'sn_storyboard': [],
      'sn_shot': [],
      'sn_asset': []
    };
    FirebaseFirestore.instance
        .collection('sn_asset')
        .get()
        .then((snapshot) =>
        snapshot.docs.forEach((doc) {
          return map['sn_asset']!.add(doc);
        }));

    await assetRepository.exportJson(json.encode(map), 'shot_data_export.json');
  }

  Future<void> importJson(BuildContext context,) async {
    // await db.delete('sn_project');
    // await db.delete('sn_song');
    // await db.delete('sn_lyric');
    // await db.delete('sn_storyboard');
    // await db.delete('sn_shot');
    // await db.delete('sn_formation');
    // await db.delete('sn_move');

    final map = Map<String, List>.from(json.decode(await assetRepository
        .importFromAssets(context, 'shot_data_example.json')));
    // map['sn_project']!.forEach((p) async => await FirebaseFirestore.instance
    //     .collection('sn_project')
    //     .doc(p['id'])
    //     .set(p));
    // map['sn_song']!.forEach((s) async => await FirebaseFirestore.instance
    //     .collection('sn_song')
    //     .doc(s['id'])
    //     .set(s));
    // map['sn_lyric']!.forEach((l) async => await FirebaseFirestore.instance
    //     .collection('sn_lyric')
    //     .doc(l['id'])
    //     .set(l));
    // map['sn_storyboard']!.forEach((st) async => await FirebaseFirestore.instance
    //     .collection('sn_storyboard')
    //     .doc(st['id'])
    //     .set(st));
    // map['sn_shot']!.forEach((s) async => await FirebaseFirestore.instance
    //     .collection('sn_shot')
    //     .doc(s['id'])
    //     .set(s));
    map['sn_asset']!.forEach((a) async =>
    await FirebaseFirestore.instance
        .collection('sn_asset')
        .doc(a['id'])
        .set(a));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
