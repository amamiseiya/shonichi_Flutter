part of 'song_crud_bloc.dart';

abstract class SongCrudState extends Equatable {}

class SongUninitialized extends SongCrudState {
  @override
  String toString() => 'SongUninitialized';
  @override
  List<Object> get props => [];
}

class RetrievingSong extends SongCrudState {
  @override
  String toString() => 'RetrievingSong';
  @override
  List<Object> get props => [];
}

class SongRetrieved extends SongCrudState {
  final List<SNSong> songs;
  SongRetrieved(this.songs);
  @override
  String toString() => 'SongRetrieved';
  @override
  List<Object> get props => [songs];
}

class CreatingSong extends SongCrudState {
  @override
  String toString() => 'CreatingSong';
  @override
  List<Object> get props => [];
}

class UpdatingSong extends SongCrudState {
  final SNSong song;
  UpdatingSong(this.song);
  @override
  String toString() => 'UpdatingSong';
  @override
  List<Object> get props => [song];
}
