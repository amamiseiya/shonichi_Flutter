import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/project.dart';
import '../../model/song.dart';
import '../project/project_crud_bloc.dart';
import '../project/project_selection_bloc.dart';
import '../../repository/song_repository.dart';
import '../../repository/attachment_repository.dart';

part 'song_crud_event.dart';
part 'song_crud_state.dart';

class SongCrudBloc extends Bloc<SongCrudEvent, SongCrudState> {
  final ProjectCrudBloc projectCrudBloc;
  final ProjectSelectionBloc projectSelectionBloc;
  StreamSubscription projectSelectionBlocSubscription;

  final SongRepository songRepository;
  final AttachmentRepository attachmentRepository;

  BehaviorSubject<SNSong> currentSongSubject = BehaviorSubject<SNSong>();

  SongCrudBloc(this.projectCrudBloc, this.projectSelectionBloc,
      this.songRepository, this.attachmentRepository)
      : assert(projectCrudBloc != null),
        assert(projectSelectionBloc != null),
        assert(songRepository != null),
        assert(attachmentRepository != null),
        super(SongUninitialized()) {
    projectSelectionBlocSubscription =
        projectSelectionBloc.listen((state) async {
      if (state is ProjectSelected) {
        currentSongSubject
            .add(await songRepository.retrieveById(state.project.songId));
      }
    });
  }

  @override
  Stream<SongCrudState> mapEventToState(
    SongCrudEvent event,
  ) async* {
    if (event is RetrieveSong) {
      yield* mapRetrieveSongToState();
    } else if (event is CreateSong) {
      print(event.toString());
      yield CreatingSong();
    } else if (event is UpdateSong) {
      print(event.toString());
      yield UpdatingSong(event.song);
    } else if (event is SubmitCreateSong) {
      yield* mapSubmitCreateSongToState(event.song);
    } else if (event is SubmitUpdateSong) {
      yield* mapSubmitUpdateSongToState(event.song);
    } else if (event is DeleteSong) {
      yield* mapDeleteSongToState(event.song);
    } else if (event is DeleteMultipleSong) {
      yield* mapDeleteMultipleSongToState(event.songs);
    }
  }

  Stream<SongCrudState> mapRetrieveSongToState() async* {
    try {
      yield RetrievingSong();
      final songs = await songRepository.retrieveAll();
      yield SongRetrieved(songs);
    } catch (e) {
      print(e);
    }
  }

  Stream<SongCrudState> mapSubmitCreateSongToState(SNSong song) async* {
    try {
      if (song != null) {
        await songRepository.create(song);
      }
      add(RetrieveSong());
    } catch (e) {
      print(e);
    }
  }

  Stream<SongCrudState> mapSubmitUpdateSongToState(SNSong song) async* {
    try {
      if (song != null) {
        await songRepository.update(song);
      }
      add(RetrieveSong());
    } catch (e) {
      print(e);
    }
  }

  Stream<SongCrudState> mapDeleteSongToState(SNSong song) async* {
    try {
      await songRepository.delete(song);
      add(RetrieveSong());
    } catch (e) {
      print(e);
    }
  }

  Stream<SongCrudState> mapDeleteMultipleSongToState(
      List<SNSong> songs) async* {
    try {
      if (songs.isNotEmpty) {
        for (SNSong song in songs) {
          await songRepository.delete(song);
        }
        songs.clear();
        add(RetrieveSong());
      }
    } catch (e) {
      print(e);
    }
  }

  void dispose() async {
    projectSelectionBlocSubscription.cancel();
    currentSongSubject.close();
    super.close();
  }
}
