part of 'song_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();
}

class SongUninitialized extends SongState {
  @override
  String toString() => 'SongUninitialized';
  @override
  List<Object> get props => [];
}

class FetchingSong extends SongState {
  @override
  String toString() => 'FetchingSong';
  @override
  List<Object> get props => [];
}

class SongFetched extends SongState {
  final List<Song> songs;
  SongFetched(this.songs);
  @override
  String toString() => 'SongFetched';
  @override
  List<Object> get props => [songs];
}

class AddingSong extends SongState {
  @override
  String toString() => 'AddingSong';
  @override
  List<Object> get props => [];
}

class UpdatingSong extends SongState {
  final Song song;
  UpdatingSong(this.song);
  @override
  String toString() => 'UpdatingSong';
  @override
  List<Object> get props => [song];
}
