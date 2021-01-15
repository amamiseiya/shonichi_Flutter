part of 'song_bloc.dart';

@immutable
abstract class SongEvent extends Equatable {
  SongEvent();
}

class ReloadSongList extends SongEvent {
  @override
  String toString() => 'ReloadSongList';
  @override
  List<Object> get props => [];
}

class AddSong extends SongEvent {
  @override
  String toString() => 'AddSong';
  @override
  List<Object> get props => [];
}

class UpdateSong extends SongEvent {
  final Song song;
  UpdateSong(this.song);
  @override
  String toString() => 'UpdateSong';
  @override
  List<Object> get props => [song];
}

class SubmitAddSong extends SongEvent {
  final Song song;
  SubmitAddSong(this.song);
  @override
  String toString() => 'SubmitAddSong';
  @override
  List<Object> get props => [song];
}

class SubmitUpdateSong extends SongEvent {
  final Song song;
  SubmitUpdateSong(this.song);
  @override
  String toString() => 'SubmitUpdateSong';
  @override
  List<Object> get props => [song];
}

class DeleteSong extends SongEvent {
  final Song song;
  DeleteSong(this.song);
  @override
  String toString() => 'DeleteSong';
  @override
  List<Object> get props => [song];
}

class DeleteSelectedSong extends SongEvent {
  final List<Song> songs;
  DeleteSelectedSong(this.songs);
  @override
  String toString() => 'DeleteSelectedSong';
  @override
  List<Object> get props => [songs];
}
