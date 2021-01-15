import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../model/project.dart';
import '../model/song.dart';
import '../model/lyric.dart';
import '../model/shot.dart';
import '../model/character.dart';
import '../bloc/project_bloc.dart';
import '../bloc/song_bloc.dart';
import '../bloc/lyric_bloc.dart';
import '../repository/song_repository.dart';
import '../repository/lyric_repository.dart';
import '../repository/shot_repository.dart';
import '../repository/storage_repository.dart';

part 'shot_event.dart';
part 'shot_state.dart';

class ShotBloc extends Bloc<ShotEvent, ShotState> {
  // Bloc
  final ProjectBloc projectBloc;
  final SongBloc songBloc;
  final LyricBloc lyricBloc;

  // Repository
  final SongRepository songRepository;
  final LyricRepository lyricRepository;
  final ShotRepository shotRepository;
  final StorageRepository storageRepository;

  // 继承来的状态
  StreamSubscription projectBlocSubscription;
  StreamSubscription currentSongSubscription;
  Project currentProject;
  Song currentSong;

  // 生成的Stream
  BehaviorSubject<List<Shot>> shotsSubject = BehaviorSubject<List<Shot>>();
  BehaviorSubject<List<Lyric>> lyricsSubject = BehaviorSubject<List<Lyric>>();
  Stream<List<Map<String, dynamic>>> coverageStream = Stream.empty();
  Stream<Map<String, int>> statisticsStream = Stream.empty();
  BehaviorSubject<int> currentShotTimeSubject = BehaviorSubject<int>.seeded(0);

  double sliderMaxValue = 1.0;

  ShotBloc(this.projectBloc, this.songBloc, this.lyricBloc, this.songRepository,
      this.lyricRepository, this.shotRepository, this.storageRepository)
      : assert(projectBloc != null),
        assert(songBloc != null),
        assert(lyricBloc != null),
        assert(songRepository != null),
        assert(lyricRepository != null),
        assert(shotRepository != null),
        assert(storageRepository != null),
        super(null) {
    projectBlocSubscription = projectBloc.listen((state) {
      if (state is ProjectSelected) {
        currentProject = state.project;
      }
    });

    currentSongSubscription = songBloc.currentSongSubject.listen((song) async {
      currentSong = song;
      lyricsSubject.add(await lyricRepository.fetchLyricsForSong(song.songId));
    });

    coverageStream = Rx.combineLatest2(
        shotsSubject,
        lyricsSubject,
        (List<Shot> shots, List<Lyric> lyrics) => lyrics.map((Lyric lyric) {
              int count = 0;
              for (Shot shot in shots) {
                if (shot.startTime == lyric.startTime) {
                  count++;
                }
              }
              return {
                'lyricTime': lyric.startTime.inMilliseconds,
                'lyricContent': lyric.lyricContent,
                'coverageCount': count
              };
            }).toList()).asBroadcastStream();

    statisticsStream = shotsSubject.asyncMap((List<Shot> shots) {
      Map<String, int> characterCountMap = Map.fromIterable(
          Character.membersSortedByGrade(currentSong.subordinateKikaku),
          key: (character) => character.characterName,
          value: (character) => 0);
      for (Shot shot in shots) {
        for (Character character in shot.shotCharacters) {
          characterCountMap[character.characterName]++;
        }
      }
      return characterCountMap;
    });

    lyricsSubject.listen((lyrics) =>
        sliderMaxValue = lyrics.last.endTime.inMilliseconds.toDouble());
  }

  @override
  ShotState get initialState => ShotUninitialized();

  @override
  Stream<ShotState> mapEventToState(
    ShotEvent event,
  ) async* {
    if (event is StartFetchingShot) {
      yield* mapStartFetchingShotToState();
    } else if (event is ReloadShot) {
      yield* mapStartFetchingShotToState();
    } else if (event is FinishFetchingShot) {
      yield ShotFetched(event.shots);
    } else if (event is ChangeShotData) {
      yield* mapChangeShotDataToState(event.shot);
    } else if (event is AddShot) {
      yield* mapAddShotToState();
    } else if (event is DeleteShot) {
      yield* mapDeleteShotToState(event.shot);
    } else if (event is DeleteSelectedShot) {
      yield* mapDeleteSelectedShotToState(event.shots);
    }
  }

  Stream<ShotState> mapStartFetchingShotToState() async* {
    try {
      yield FetchingShot();
      print('Fetching shots.');
      shotsSubject.add(await shotRepository.fetchShotsForProject(
          currentProject.songId, currentProject.shotVersion));
      shotsSubject.listen((shots) => add(FinishFetchingShot(shots)));
    } catch (e) {
      print(e);
    }
  }

  Stream<ShotState> mapChangeShotDataToState(Shot shot) async* {
    try {
      await shotRepository.updateShot(shot);
      add(ReloadShot());
    } catch (e) {
      print(e);
    }
  }

  Stream<ShotState> mapAddShotToState() async* {
    try {
      final shot = Shot(
          songId: currentProject.songId,
          shotVersion: currentProject.shotVersion,
          startTime: Duration(milliseconds: Random().nextInt(100000)),
          endTime: Duration(milliseconds: Random().nextInt(100000)),
          shotNumber: 1,
          shotLyric: '',
          shotScene: 1010,
          shotCharacters: [],
          shotType: 'VERYLONGSHOT',
          shotMovement: '',
          shotAngle: '',
          shotContent: '',
          shotImage: '',
          shotComment: '');
      await shotRepository.addShot(shot);
      add(ReloadShot());
    } catch (e) {
      print(e);
    }
  }

  Stream<ShotState> mapDeleteShotToState(Shot shot) async* {
    try {
      await shotRepository.deleteShot(shot);
      add(ReloadShot());
    } catch (e) {
      print(e);
    }
  }

  Stream<ShotState> mapDeleteSelectedShotToState(List<Shot> shots) async* {
    try {
      if (shots.isNotEmpty) {
        for (Shot shot in shots) {
          await shotRepository.deleteShot(shot);
        }
        shots.clear();
        add(ReloadShot());
      }
    } catch (e) {
      print(e);
    }
  }

  void dispose() async {
    projectBlocSubscription.cancel();
    currentSongSubscription.cancel();
    shotsSubject.close();
    lyricsSubject.close();
    currentShotTimeSubject.close();
    super.close();
  }
}
