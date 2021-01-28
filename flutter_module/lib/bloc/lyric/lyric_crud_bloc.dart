import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../model/song.dart';
import '../../model/lyric.dart';
import '../song/song_crud_bloc.dart';
import '../../repository/lyric_repository.dart';
import '../../repository/attachment_repository.dart';

part 'lyric_crud_event.dart';
part 'lyric_crud_state.dart';

class LyricCrudBloc extends Bloc<LyricCrudEvent, LyricCrudState> {
  final SongCrudBloc songBloc;
  StreamSubscription currentSongSubscription;
  SNSong currentSong;

  final LyricRepository lyricRepository;
  final AttachmentRepository attachmentRepository;
  BehaviorSubject<List<SNLyric>> songLyricsSubject =
      BehaviorSubject<List<SNLyric>>();

  LyricCrudBloc(this.songBloc, this.lyricRepository, this.attachmentRepository)
      : assert(songBloc != null),
        assert(lyricRepository != null),
        assert(attachmentRepository != null),
        super(LyricUninitialized()) {
    currentSongSubscription = songBloc.currentSongSubject.listen((onData) {
      currentSong = onData;
    });
  }

  @override
  Stream<LyricCrudState> mapEventToState(
    LyricCrudEvent event,
  ) async* {
    if (event is StartRetrievingLyric) {
      yield* mapStartRetrievingLyricToState();
    } else if (event is ReloadLyric) {
      yield* mapStartRetrievingLyricToState();
    } else if (event is FinishRetrievingLyric) {
      print(event.toString());
      yield LyricRetrieved(event.lyrics);
    } else if (event is ChangeLyricData) {
      yield* mapChangeLyricDataToState(event.lyric);
    } else if (event is ImportLyric) {
      yield* mapImportLyricToState(event.lrcStr);
    } else if (event is PressDelete) {
      yield* mapPressDeleteToState(event.lyric);
    }
  }

  Stream<LyricCrudState> mapStartRetrievingLyricToState() async* {
    try {
      yield RetrievingLyric();
      print(state.toString());
      songLyricsSubject
          .add(await lyricRepository.retrieveForSong(currentSong.id));
      songLyricsSubject.listen((onData) => add(FinishRetrievingLyric(onData)));
    } catch (e) {
      print(e);
    }
  }

  Stream<LyricCrudState> mapChangeLyricDataToState(SNLyric lyric) async* {
    try {
      await lyricRepository.update(lyric);
      add(ReloadLyric());
    } catch (e) {
      print(e);
    }
  }

  Stream<LyricCrudState> mapImportLyricToState(String lrcStr) async* {
    try {
      if (lrcStr != null) {
        final lyrics = SNLyric.parseFromLrc(
            lrcStr, currentSong.id, currentSong.lyricOffset);
        for (SNLyric lyric in lyrics) {
          await lyricRepository.create(lyric);
        }
        add(ReloadLyric());
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<LyricCrudState> mapPressDeleteToState(SNLyric lyric) async* {
    try {
      await lyricRepository.delete(lyric);
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
