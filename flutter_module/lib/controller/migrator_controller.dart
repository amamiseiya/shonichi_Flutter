import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/project.dart';
import '../model/song.dart';
import '../model/shot.dart';
import '../model/character.dart';
import 'project_controller.dart';
import 'song_controller.dart';
import '../repository/project_repository.dart';
import '../repository/song_repository.dart';
import '../repository/shot_table_repository.dart';
import '../repository/shot_repository.dart';
import '../repository/attachment_repository.dart';
import '../util/des.dart';
import '../util/reg_exp.dart';
import '../util/data_convert.dart';

class MigratorController extends GetxController {
  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();

  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final ShotTableRepository shotTableRepository;
  final ShotRepository shotRepository;
  final AttachmentRepository attachmentRepository;

  String storyboardTableTitles;
  RxString markdownText = RxString(null);
  bool needEncrypt = false;

  MigratorController(this.projectRepository, this.songRepository,
      this.shotTableRepository, this.shotRepository, this.attachmentRepository)
      : assert(projectRepository != null),
        assert(songRepository != null),
        assert(shotTableRepository != null),
        assert(shotRepository != null),
        assert(attachmentRepository != null);

  @override
  void onInit() {
    initializeTitle();
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
    final int tableId =
        (await shotTableRepository.getLatestShotTable(project.songId)).id + 1;
    final String kikaku =
        (await songRepository.retrieveById(project.songId)).subordinateKikaku;
    return shotsText
        .split('\n')
        .where((element) => RegExp(r'^\|.+\|$').hasMatch(element))
        .map((String shotText) {
      List<RegExpMatch> shotProps =
          RegExp(r'(?<=\|\s)[^\|]*(?=\s\|)').allMatches(shotText).toList();
      return SNShot(
        id: int.parse(shotProps[0].group(0)),
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

  void initializeTitle() {
    storyboardTableTitles = '';
    for (String title in SNShot.titles) {
      storyboardTableTitles += '| ' + title + ' ';
    }
    storyboardTableTitles += '|\n';
    storyboardTableTitles += ('| --- ') * SNShot.titles.length;
    storyboardTableTitles += '|\n';
  }

  String generateIntro(SNProject project, SNSong song) {
    String mdText =
        '# ' + project.dancerName + ' ' + song.name + ' 拍摄计划\n\n拍摄日期：\n';
    return mdText;
  }

  String generateShotDataTable(List<SNShot> shots) {
    String mdText = '# 分镜表\n';
    mdText += storyboardTableTitles;

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

  void exportMarkdown(String key) async {
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

  @override
  void dispose() {
    super.dispose();
  }
}
