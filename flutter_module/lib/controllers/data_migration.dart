import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shonichi_flutter_module/controllers/character.dart';

import '../models/project.dart';
import '../models/song.dart';
import '../models/lyric.dart';
import '../models/storyboard.dart';
import '../models/shot.dart';
import '../models/character.dart';
import 'project.dart';
import 'song.dart';
import '../repositories/project.dart';
import '../repositories/song.dart';
import '../repositories/lyric.dart';
import '../repositories/storyboard.dart';
import '../repositories/shot.dart';
import '../repositories/attachment.dart';
import '../providers/firestore/firestore.dart';
import '../utils/des.dart';
import '../utils/reg_exp.dart';
import '../utils/data_convert.dart';

class DataMigrationController extends GetxController {
  final CharacterController characterController = Get.find();
  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();

  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final LyricRepository lyricRepository;
  final StoryboardRepository storyboardRepository;
  final ShotRepository shotRepository;
  final AttachmentRepository attachmentRepository;

  RxString markdownText = RxString(null);
  bool needEncrypt = false;

  DataMigrationController(
      this.projectRepository,
      this.songRepository,
      this.lyricRepository,
      this.storyboardRepository,
      this.shotRepository,
      this.attachmentRepository)
      : assert(projectRepository != null),
        assert(songRepository != null),
        assert(lyricRepository != null),
        assert(storyboardRepository != null),
        assert(shotRepository != null),
        assert(attachmentRepository != null);

  @override
  void onInit() {
    super.onInit();
  }

  void importMarkdown(String? key) async {
    try {
      String mdText = await attachmentRepository
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
          projectController.editingProject.value!, markdownText.value);
      for (SNShot shot in shots) {
        await shotRepository.create(shot);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<SNShot>> parseShots(SNProject project, String mdText) async {
    String storyboardText = storyboardChapterRegExp.stringMatch(mdText)!;
    String shotsText =
        RegExp(r'(?<=---\s\|\n).+', dotAll: true).stringMatch(storyboardText)!;
    final String tableId =
        (await storyboardRepository.getLatestStoryboard(project.songId!))!.id +
            '1';
    final String kikaku =
        (await songRepository.retrieveById(project.songId!)).subordinateKikaku;
    return shotsText
        .split('\n')
        .where((element) => RegExp(r'^\|.+\|$').hasMatch(element))
        .map((String shotText) {
      List<RegExpMatch> shotProps =
          RegExp(r'(?<=\|\s)[^\|]*(?=\s\|)').allMatches(shotText).toList();
      return SNShot(
          id: 'initial',
          sceneNumber: int.parse(shotProps[0].group(0)!),
          shotNumber: int.parse(shotProps[1].group(0)!),
          startTime: simpleDurationToDuration(shotProps[2].group(0)!),
          endTime: simpleDurationToDuration(shotProps[3].group(0)!),
          lyric: shotProps[4].group(0)!,
          shotType: shotProps[5].group(0)!,
          shotMovement: shotProps[6].group(0)!,
          shotAngle: shotProps[7].group(0)!,
          text: shotProps[8].group(0)!,
          imageURI: shotProps[9].group(0)!,
          comment: shotProps[10].group(0)!,
          tableId: tableId,
          characters: json
              .decode(shotProps[11].group(0)!)
              .map((Map<String, dynamic> cm) => SNCharacter.fromMap(cm))
              .toList());
    }).toList();
  }

  // 输入角色列表返回String
  String serializeCharacters(List<SNCharacter> characters,
      {required CharacterSerializeMode mode}) {
    String str = '';
    for (SNCharacter character in characters) {
      if (mode == CharacterSerializeMode.Normal) {
        str += character.name + ', ';
      }
      if (mode == CharacterSerializeMode.Abbreviation) {
        str += character.nameAbbr + ', ';
      }
    }
    str.substring(0, str.lastIndexOf(', '));
    return str;
  }

  // 输入String返回角色列表
  List<SNCharacter> unserializeCharacters(String str,
      {required CharacterSerializeMode mode}) {
    if (str != null) {
      final Iterable<String> csi =
          str.split(', ').where((row) => characterNameRegExp.hasMatch(row));
      final List<SNCharacter> cl = [];
      if (mode == CharacterSerializeMode.Normal) {
        csi.forEach((cs) async {
          cl.add(await characterController.retrieveFromString(
              name: cs,
              kikaku: songController.editingSong.value!.subordinateKikaku));
        });
        return cl;
      } else if (mode == CharacterSerializeMode.Abbreviation) {
        csi.forEach((cs) async {
          cl.add(await characterController.retrieveFromString(
              nameAbbr: cs,
              kikaku: songController.editingSong.value!.subordinateKikaku));
        });
        return cl;
      } else {
        throw FormatException();
      }
    } else {
      return [];
    }
  }

  void previewMarkdown() async {
    try {
      markdownText(generateIntro(projectController.editingProject.value!,
              songController.editingSong.value!) +
          generateShotDataTable(await shotRepository.retrieveForTable(
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
        project.createdTime.toString() +
        '\n';
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
          shot.sceneNumber.toString() +
          ' | ' +
          shot.shotNumber.toString() +
          ' | ' +
          simpleDurationRegExp.stringMatch(shot.startTime.toString())! +
          ' | ' +
          simpleDurationRegExp.stringMatch(shot.endTime.toString())! +
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
          shot.imageURI +
          ' | ' +
          shot.comment +
          ' | ' +
          json.encode(
              shot.characters.map((character) => character.toMap()).toList()) +
          ' |\n';
    }
    return mdText;
  }

  Future<void> exportMarkdown(String? key) async {
    try {
      if (key != null) {
        await attachmentRepository.exportMarkdown(
            projectController.editingProject.value!,
            desEncrypt(markdownText.value, key));
      } else {
        await attachmentRepository.exportMarkdown(
            projectController.editingProject.value!, markdownText.value);
      }
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
      'sn_shot': []
    };

    await attachmentRepository.exportJson(
        json.encode(map), 'shot_data_export.json');
  }

  Future<void> importJson() async {
    // await db.delete('sn_project');
    // await db.delete('sn_song');
    // await db.delete('sn_lyric');
    // await db.delete('sn_storyboard');
    // await db.delete('sn_shot');
    // await db.delete('sn_formation');
    // await db.delete('sn_movement');

    final map = Map<String, List>.from(json.decode(
        await attachmentRepository.importFromAssets('shot_data_example.json')));
    map['sn_project']!.forEach((p) async => await FirebaseFirestore.instance
        .collection('sn_project')
        .doc(p['id'])
        .set(p));
    map['sn_song']!.forEach((s) async => await FirebaseFirestore.instance
        .collection('sn_song')
        .doc(s['id'])
        .set(s));
    map['sn_lyric']!.forEach((l) async => await FirebaseFirestore.instance
        .collection('sn_lyric')
        .doc(l['id'])
        .set(l));
    map['sn_storyboard']!.forEach((st) async => await FirebaseFirestore.instance
        .collection('sn_storyboard')
        .doc(st['id'])
        .set(st));
    map['sn_shot']!.forEach((s) async => await FirebaseFirestore.instance
        .collection('sn_shot')
        .doc(s['id'])
        .set(s));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
