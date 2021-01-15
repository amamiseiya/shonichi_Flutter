import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../model/project.dart';
import '../model/song.dart';
import '../model/shot.dart';
import '../model/character.dart';
import '../bloc/project_bloc.dart';
import '../bloc/song_bloc.dart';
import '../repository/project_repository.dart';
import '../repository/song_repository.dart';
import '../repository/shot_repository.dart';
import '../repository/storage_repository.dart';
import '../util/des.dart';
import '../util/reg_exp.dart';
import '../util/data_convert.dart';

part 'migrator_event.dart';
part 'migrator_state.dart';

class MigratorBloc extends Bloc<MigratorEvent, MigratorState> {
  final ProjectBloc projectBloc;
  final SongBloc songBloc;
  StreamSubscription projectBlocSubscription;
  Project currentProject;

  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final ShotRepository shotRepository;
  final StorageRepository storageRepository;
  BehaviorSubject<String> markdownSubject = BehaviorSubject<String>();

  String storyboardTableTitles;

  MigratorBloc(this.projectBloc, this.songBloc, this.projectRepository,
      this.songRepository, this.shotRepository, this.storageRepository)
      : assert(projectBloc != null),
        assert(songBloc != null),
        assert(projectRepository != null),
        assert(songRepository != null),
        assert(shotRepository != null),
        assert(storageRepository != null),
        super(null) {
    storyboardTableTitles = '';
    for (String title in Shot.titles) {
      storyboardTableTitles += '| ' + title + ' ';
    }
    storyboardTableTitles += '|\n';
    storyboardTableTitles += ('| --- ') * Shot.titles.length;
    storyboardTableTitles += '|\n';
    projectBlocSubscription = projectBloc.listen((state) {
      if (state is ProjectSelected) {
        currentProject = state.project;
      }
    });
  }

  @override
  MigratorState get initialState => MigratorInitial();

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
      String mdText = await storageRepository.importMarkdown(currentProject);
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
        final List<Shot> shots = await parseShots(currentProject, onData);
        for (Shot shot in shots) {
          await shotRepository.addShot(shot);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Shot>> parseShots(Project project, String mdText) async {
    String storyboardText = storyboardChapterRegExp.stringMatch(mdText);
    String shotsText =
        RegExp(r'(?<=---\s\|\n).+', dotAll: true).stringMatch(storyboardText);
    final int shotVersion =
        await shotRepository.getLatestShotVersion(project.songId) + 1;
    final String kikaku =
        (await songRepository.fetchSpecifiedSong(project.songId))
            .subordinateKikaku;
    return shotsText
        .split('\n')
        .where((element) => RegExp(r'^\|.+\|$').hasMatch(element))
        .map((String shotText) {
      List<RegExpMatch> shotProps =
          RegExp(r'(?<=\|\s)[^\|]*(?=\s\|)').allMatches(shotText).toList();
      return Shot(
          songId: project.songId,
          shotVersion: shotVersion,
          shotName: 'Imported version $shotVersion',
          startTime: simpleDurationToDuration(shotProps[1].group(0)),
          endTime: simpleDurationToDuration(shotProps[1].group(0)) +
              Duration(seconds: 3),
          shotNumber: int.parse(shotProps[0].group(0)),
          shotLyric: shotProps[2].group(0),
          shotScene: int.parse(shotProps[3].group(0)),
          shotCharacters:
              Character.abbrStringToList(shotProps[4].group(0), kikaku),
          shotType: shotProps[5].group(0),
          shotMovement: shotProps[6].group(0),
          shotAngle: shotProps[7].group(0),
          shotContent: shotProps[8].group(0),
          shotImage: shotProps[9].group(0),
          shotComment: shotProps[10].group(0));
    }).toList();
  }

  Stream<MigratorState> mapPreviewMarkdownToState() async* {
    try {
      final Song currentSong =
          await songRepository.fetchSpecifiedSong(currentProject.songId);
      markdownSubject.add(generateIntro(currentProject, currentSong) +
          generateShotDataTable(await shotRepository.fetchShotsForProject(
              currentProject.songId, currentProject.shotVersion)));
    } catch (e) {
      print(e);
    }
  }

  String generateIntro(Project project, Song song) {
    String mdText =
        '# ' + project.dancerName + ' ' + song.songName + ' 拍摄计划\n\n拍摄日期：\n';
    return mdText;
  }

  String generateShotDataTable(List<Shot> shots) {
    String mdText = '# 分镜表\n';
    mdText += storyboardTableTitles;

    for (Shot shot in shots) {
      mdText += '| ${shot.shotNumber} | ' +
          simpleDurationRegExp.stringMatch(shot.startTime.toString()) +
          ' | ' +
          shot.shotLyric +
          ' | ' +
          shot.shotScene.toString() +
          ' | ' +
          Character.listToAbbrString(shot.shotCharacters) +
          ' | ' +
          shot.shotType +
          ' | ' +
          shot.shotMovement +
          ' | ' +
          shot.shotAngle +
          ' | ' +
          shot.shotContent +
          ' | ' +
          shot.shotImage +
          ' | ' +
          shot.shotComment +
          ' |\n';
    }
    return mdText;
  }

  Stream<MigratorState> mapExportMarkdownToState(String key) async* {
    try {
      markdownSubject.listen((onData) async {
        if (key != null) {
          await storageRepository.exportMarkdown(
              currentProject, desEncrypt(onData, key));
        } else {
          await storageRepository.exportMarkdown(currentProject, onData);
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
