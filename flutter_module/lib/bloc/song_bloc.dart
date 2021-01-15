import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../model/project.dart';
import '../model/song.dart';
import '../bloc/project_bloc.dart';
import '../repository/song_repository.dart';
import '../repository/storage_repository.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final ProjectBloc projectBloc;
  StreamSubscription projectBlocSubscription;

  final SongRepository songRepository;
  final StorageRepository storageRepository;

  BehaviorSubject<Song> currentSongSubject = BehaviorSubject<Song>();

  SongBloc(this.projectBloc, this.songRepository, this.storageRepository)
      : assert(projectBloc != null),
        assert(songRepository != null),
        assert(storageRepository != null),
        super(null) {
    projectBlocSubscription = projectBloc.listen((state) async {
      if (state is ProjectSelected) {
        currentSongSubject
            .add(await songRepository.fetchSpecifiedSong(state.project.songId));
      }
    });
  }

  @override
  SongState get initialState => SongUninitialized();

  @override
  Stream<SongState> mapEventToState(
    SongEvent event,
  ) async* {
    if (event is ReloadSongList) {
      yield* mapReloadSongListToState();
    } else if (event is AddSong) {
      yield AddingSong();
    } else if (event is UpdateSong) {
      print(event.toString());
      yield UpdatingSong(event.song);
    } else if (event is SubmitAddSong) {
      yield* mapSubmitAddSongToState(event.song);
    } else if (event is SubmitUpdateSong) {
      yield* mapSubmitUpdateSongToState(event.song);
    } else if (event is DeleteSong) {
      yield* mapDeleteSongToState(event.song);
      // } else if (event is PressedDeleteSelected) {
      //   yield* mapPressedDeleteSelectedToState(event.songs);
    }
  }

  Stream<SongState> mapReloadSongListToState() async* {
    try {
      yield FetchingSong();
      final songs = await songRepository.fetchSongs();
      yield SongFetched(songs);
    } catch (e) {
      print(e);
    }
  }

  Stream<SongState> mapSubmitAddSongToState(Song song) async* {
    try {
      if (song != null) {
        await songRepository.addSong(song);
      }
      add(ReloadSongList());
    } catch (e) {
      print(e);
    }
  }

  Stream<SongState> mapSubmitUpdateSongToState(Song song) async* {
    try {
      if (song != null) {
        await songRepository.updateSong(song);
      }
      add(ReloadSongList());
    } catch (e) {
      print(e);
    }
  }

  Stream<SongState> mapDeleteSongToState(Song song) async* {
    try {
      await songRepository.deleteSong(song);
      add(ReloadSongList());
    } catch (e) {
      print(e);
    }
  }

  // Stream<SongState> mapPressedDeleteSelectedToState(List<Song> songs) async* {
  // try {
  //   await songRepository.deleteSong(songs);
  //   add(RequiredReloadingSongs());
  // } catch (_, stacktrace) {
  //   print(stacktrace);
  //   yield SongUninitialized();
  // }
  // }

  void dispose() async {
    projectBlocSubscription.cancel();
    currentSongSubject.close();
    super.close();
  }
}
