import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shonichi_flutter_module/bloc/project/project_selection_bloc.dart';

import '../../model/project.dart';
import '../../model/song.dart';
import '../../model/shot.dart';
import '../../model/character.dart';
import '../project/project_crud_bloc.dart';
import '../song/song_crud_bloc.dart';
import '../../repository/project_repository.dart';
import '../../repository/song_repository.dart';
import '../../repository/shot_repository.dart';
import '../../repository/attachment_repository.dart';
import '../../util/des.dart';
import '../../util/reg_exp.dart';
import '../../util/data_convert.dart';

part 'migrator_event.dart';
part 'migrator_state.dart';

class MigratorBloc extends Bloc<MigratorEvent, MigratorState> {
  final ProjectCrudBloc projectBloc;
  final ProjectSelectionBloc projectSelectionBloc;
  final SongCrudBloc songBloc;
  StreamSubscription projectBlocSubscription;
  SNProject currentProject;

  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final ShotRepository shotRepository;
  final AttachmentRepository attachmentRepository;
  BehaviorSubject<String> markdownSubject = BehaviorSubject<String>();

  String storyboardTableTitles;

  MigratorBloc(
      this.projectBloc,
      this.projectSelectionBloc,
      this.songBloc,
      this.projectRepository,
      this.songRepository,
      this.shotRepository,
      this.attachmentRepository)
      : assert(projectBloc != null),
        assert(projectSelectionBloc != null),
        assert(songBloc != null),
        assert(projectRepository != null),
        assert(songRepository != null),
        assert(shotRepository != null),
        assert(attachmentRepository != null),
        super(MigratorInitial()) {
    storyboardTableTitles = '';
    for (String title in SNShot.titles) {
      storyboardTableTitles += '| ' + title + ' ';
    }
    storyboardTableTitles += '|\n';
    storyboardTableTitles += ('| --- ') * SNShot.titles.length;
    storyboardTableTitles += '|\n';
    projectBlocSubscription = projectSelectionBloc.listen((state) {
      if (state is ProjectSelected) {
        currentProject = state.project;
      }
    });
  }

  @override
  Stream<MigratorState> mapEventToState(
    MigratorEvent event,
  ) async* {
    if (event is ImportMarkdown) {
      yield* mapImportMarkdownToState(event.key);
    } else if (event is ConfirmImportMarkdown) {
      yield* mapConfirmImportMarkdownToState();
    } else if (event is PreviewMarkdown) {
      yield* mapPreviewMarkdownToState();
    } else if (event is ExportMarkdown) {
      yield* mapExportMarkdownToState(event.key);
    }
  }

  Stream<MigratorState> mapImportMarkdownToState(String key) async* {
    try {
      String mdText = await attachmentRepository.importMarkdown(currentProject);
      if (key != null) {
        mdText = desDecrypt(mdText, key);
      }
      markdownSubject.add(mdText);
    } catch (e) {
      print(e);
    }
  }

  Stream<MigratorState> mapConfirmImportMarkdownToState() async* {
    try {
      markdownSubject.listen((onData) async {
        final List<SNShot> shots = await parseShots(currentProject, onData);
        for (SNShot shot in shots) {
          await shotRepository.create(shot);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<SNShot>> parseShots(SNProject project, String mdText) async {
    String storyboardText = storyboardChapterRegExp.stringMatch(mdText);
    String shotsText =
        RegExp(r'(?<=---\s\|\n).+', dotAll: true).stringMatch(storyboardText);
    final int tableId = 0;
    // await shotRepository.getLatestShotTable(project.songId) + 1;
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
        characters: SNCharacter.abbrStringToList(shotProps[4].group(0), kikaku),
      );
    }).toList();
  }

  Stream<MigratorState> mapPreviewMarkdownToState() async* {
    try {
      final SNSong currentSong =
          await songRepository.retrieveById(currentProject.songId);
      markdownSubject.add(generateIntro(currentProject, currentSong) +
          generateShotDataTable(await shotRepository
              .retrieveForTable(currentProject.shotTableId)));
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

  Stream<MigratorState> mapExportMarkdownToState(String key) async* {
    try {
      markdownSubject.listen((onData) async {
        if (key != null) {
          await attachmentRepository.exportMarkdown(
              currentProject, desEncrypt(onData, key));
        } else {
          await attachmentRepository.exportMarkdown(currentProject, onData);
        }
      });
      yield MarkdownExported();
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    projectBlocSubscription.cancel();
    markdownSubject.close();
    super.close();
  }
}
