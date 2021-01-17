part of 'song_crud_bloc.dart';

@immutable
abstract class SongCrudEvent extends Equatable {}

class RetrieveSong extends SongCrudEvent {
  @override
  String toString() => 'RetrieveSong';
  @override
  List<Object> get props => [];
}

class CreateSong extends SongCrudEvent {
  @override
  String toString() => 'CreateSong';
  @override
  List<Object> get props => [];
}

class UpdateSong extends SongCrudEvent {
  final SNSong song;
  UpdateSong(this.song);
  @override
  String toString() => 'UpdateSong';
  @override
  List<Object> get props => [song];
}

class SubmitCreateSong extends SongCrudEvent {
  final SNSong song;
  SubmitCreateSong(this.song);
  @override
  String toString() => 'SubmitCreateSong';
  @override
  List<Object> get props => [song];
}

class SubmitUpdateSong extends SongCrudEvent {
  final SNSong song;
  SubmitUpdateSong(this.song);
  @override
  String toString() => 'SubmitUpdateSong';
  @override
  List<Object> get props => [song];
}

class DeleteSong extends SongCrudEvent {
  final SNSong song;
  DeleteSong(this.song);
  @override
  String toString() => 'DeleteSong';
  @override
  List<Object> get props => [song];
}

class DeleteMultipleSong extends SongCrudEvent {
  final List<SNSong> songs;
  DeleteMultipleSong(this.songs);
  @override
  String toString() => 'DeleteMultipleSong';
  @override
  List<Object> get props => [songs];
}
