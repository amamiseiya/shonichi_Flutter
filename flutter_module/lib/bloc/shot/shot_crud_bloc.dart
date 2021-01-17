import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shonichi_flutter_module/bloc/project/project_selection_bloc.dart';

import '../../model/project.dart';
import '../../model/song.dart';
import '../../model/lyric.dart';
import '../../model/shot.dart';
import '../../model/character.dart';
import '../project/project_crud_bloc.dart';
import '../song/song_crud_bloc.dart';
import '../lyric/lyric_crud_bloc.dart';
import '../../repository/song_repository.dart';
import '../../repository/lyric_repository.dart';
import '../../repository/shot_repository.dart';
import '../../repository/storage_repository.dart';

part 'shot_crud_event.dart';
part 'shot_crud_state.dart';

class ShotCrudBloc extends Bloc<ShotCrudEvent, ShotCrudState> {
  // Bloc
  final ProjectCrudBloc projectCrudBloc;
  final ProjectSelectionBloc projectSelectionBloc;
  final SongCrudBloc songBloc;
  final LyricCrudBloc lyricBloc;

  // Repository
  final SongRepository songRepository;
  final LyricRepository lyricRepository;
  final ShotRepository shotRepository;
  final StorageRepository storageRepository;

  // 继承来的状态
  StreamSubscription projectSelectionBlocSubscription;
  StreamSubscription currentSongSubscription;
  SNProject currentProject;
  SNSong currentSong;

  // 生成的Stream
  BehaviorSubject<List<SNShot>> shotsSubject = BehaviorSubject<List<SNShot>>();
  BehaviorSubject<List<SNLyric>> lyricsSubject =
      BehaviorSubject<List<SNLyric>>();
  Stream<List<Map<String, dynamic>>> coverageStream = Stream.empty();
  Stream<Map<String, int>> statisticsStream = Stream.empty();
  BehaviorSubject<int> currentShotTimeSubject = BehaviorSubject<int>.seeded(0);

  double sliderMaxValue = 1.0;

  ShotCrudBloc(
      this.projectCrudBloc,
      this.projectSelectionBloc,
      this.songBloc,
      this.lyricBloc,
      this.songRepository,
      this.lyricRepository,
      this.shotRepository,
      this.storageRepository)
      : assert(projectCrudBloc != null),
        assert(projectSelectionBloc != null),
        assert(songBloc != null),
        assert(lyricBloc != null),
        assert(songRepository != null),
        assert(lyricRepository != null),
        assert(shotRepository != null),
        assert(storageRepository != null),
        super(ShotUninitialized()) {
    projectSelectionBlocSubscription = projectSelectionBloc.listen((state) {
      if (state is ProjectSelected) {
        currentProject = state.project;
      }
    });

    currentSongSubscription = songBloc.currentSongSubject.listen((song) async {
      currentSong = song;
      lyricsSubject.add(await lyricRepository.retrieve(song.id));
    });

    coverageStream = Rx.combineLatest2(
        shotsSubject,
        lyricsSubject,
        (List<SNShot> shots, List<SNLyric> lyrics) =>
            lyrics.map((SNLyric lyric) {
              int count = 0;
              for (SNShot shot in shots) {
                if (shot.startTime == lyric.startTime) {
                  count++;
                }
              }
              return {
                'lyricTime': lyric.startTime.inMilliseconds,
                'lyricContent': lyric.text,
                'coverageCount': count
              };
            }).toList()).asBroadcastStream();

    statisticsStream = shotsSubject.asyncMap((List<SNShot> shots) {
      Map<String, int> characterCountMap = Map.fromIterable(
          SNCharacter.membersSortedByGrade(currentSong.subordinateKikaku),
          key: (character) => character.characterName,
          value: (character) => 0);
      for (SNShot shot in shots) {
        for (SNCharacter character in shot.characters) {
          characterCountMap[character.name]++;
        }
      }
      return characterCountMap;
    });

    lyricsSubject.listen((lyrics) =>
        sliderMaxValue = lyrics.last.endTime.inMilliseconds.toDouble());
  }

  @override
  Stream<ShotCrudState> mapEventToState(
    ShotCrudEvent event,
  ) async* {
    if (event is RetrieveShot) {
      yield* mapRetrieveShotToState();
    } else if (event is UpdateShot) {
      yield* mapUpdateShotToState(event.shot);
    } else if (event is CreateShot) {
      yield* mapCreateShotToState();
    } else if (event is DeleteShot) {
      yield* mapDeleteShotToState(event.shot);
    } else if (event is DeleteMultipleShot) {
      yield* mapDeleteMultipleShotToState(event.shots);
    }
  }

  Stream<ShotCrudState> mapRetrieveShotToState() async* {
    try {
      yield RetrievingShot();
      print('Retrieving shots.');
      yield (ShotRetrieved(
          await shotRepository.retrieve(currentProject.shotTableId)));

      // shotsSubject.add(await shotRepository.fetchShotsForProject(
      //     currentProject.songId, currentProject.shotVersion));
      // shotsSubject.listen((shots) => add(FinishRetrievingShot(shots)));
    } catch (e) {
      print(e);
    }
  }

  Stream<ShotCrudState> mapUpdateShotToState(SNShot shot) async* {
    try {
      await shotRepository.update(shot);
      add(RetrieveShot());
    } catch (e) {
      print(e);
    }
  }

  Stream<ShotCrudState> mapCreateShotToState() async* {
    try {
      final shot = SNShot(
          id: Random().nextInt(1000),
          sceneNumber: 1010,
          shotNumber: 1,
          startTime: Duration(milliseconds: Random().nextInt(100000)),
          endTime: Duration(milliseconds: Random().nextInt(100000)),
          lyric: '',
          shotType: 'VERYLONGSHOT',
          shotMovement: '',
          shotAngle: '',
          text: '',
          image: '',
          comment: '',
          tableId: currentProject.shotTableId,
          characters: []);
      await shotRepository.create(shot);
      add(RetrieveShot());
    } catch (e) {
      print(e);
    }
  }

  Stream<ShotCrudState> mapDeleteShotToState(SNShot shot) async* {
    try {
      await shotRepository.delete(shot);
      add(RetrieveShot());
    } catch (e) {
      print(e);
    }
  }

  Stream<ShotCrudState> mapDeleteMultipleShotToState(
      List<SNShot> shots) async* {
    try {
      await shotRepository.deleteMultiple(shots);
      add(RetrieveShot());
    } catch (e) {
      print(e);
    }
  }

  void dispose() async {
    projectSelectionBlocSubscription.cancel();
    currentSongSubscription.cancel();
    shotsSubject.close();
    lyricsSubject.close();
    currentShotTimeSubject.close();
    super.close();
  }
}
