import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../model/song.dart';
import '../model/lyric.dart';
import '../bloc/song_bloc.dart';
import '../repository/lyric_repository.dart';
import '../repository/storage_repository.dart';

part 'lyric_event.dart';
part 'lyric_state.dart';

class LyricBloc extends Bloc<LyricEvent, LyricState> {
  final SongBloc songBloc;
  StreamSubscription currentSongSubscription;
  Song currentSong;

  final LyricRepository lyricRepository;
  final StorageRepository storageRepository;
  BehaviorSubject<List<Lyric>> songLyricsSubject =
      BehaviorSubject<List<Lyric>>();

  LyricBloc(this.songBloc, this.lyricRepository, this.storageRepository)
      : assert(songBloc != null),
        assert(lyricRepository != null),
        assert(storageRepository != null),
        super(null) {
    currentSongSubscription = songBloc.currentSongSubject.listen((onData) {
      currentSong = onData;
    });
  }

  @override
  LyricState get initialState => LyricUninitialized();

  @override
  Stream<LyricState> mapEventToState(
    LyricEvent event,
  ) async* {
    if (event is StartFetchingLyric) {
      yield* mapStartFetchingLyricToState();
    } else if (event is ReloadLyric) {
      yield* mapStartFetchingLyricToState();
    } else if (event is FinishFetchingLyric) {
      print(event.toString());
      yield LyricFetched(event.lyrics);
    } else if (event is ChangeLyricData) {
      yield* mapChangeLyricDataToState(event.lyric);
    } else if (event is ImportLyric) {
      yield* mapImportLyricToState(event.lrcStr);
    } else if (event is PressDelete) {
      yield* mapPressDeleteToState(event.lyric);
    }
  }

  Stream<LyricState> mapStartFetchingLyricToState() async* {
    try {
      yield FetchingLyric();
      print(state.toString());
      songLyricsSubject
          .add(await lyricRepository.fetchLyricsForSong(currentSong.songId));
      songLyricsSubject.listen((onData) => add(FinishFetchingLyric(onData)));
    } catch (e) {
      print(e);
    }
  }

  Stream<LyricState> mapChangeLyricDataToState(Lyric lyric) async* {
    try {
      await lyricRepository.updateLyric(lyric);
      add(ReloadLyric());
    } catch (e) {
      print(e);
    }
  }

  Stream<LyricState> mapImportLyricToState(String lrcStr) async* {
    try {
      if (lrcStr != null) {
        final lyrics = Lyric.parseFromLrc(
            lrcStr, currentSong.songId, currentSong.lyricOffset);
        for (Lyric lyric in lyrics) {
          await lyricRepository.addLyric(lyric);
        }
        add(ReloadLyric());
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<LyricState> mapPressDeleteToState(Lyric lyric) async* {
    try {
      await lyricRepository.deleteLyric(lyric);
      add(ReloadLyric());
    } catch (e) {
      print(e);
    }
  }

  void dispose() async {
    currentSongSubscription.cancel();
    super.close();
  }
}
