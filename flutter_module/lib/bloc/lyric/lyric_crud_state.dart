part of 'lyric_crud_bloc.dart';

@immutable
abstract class LyricCrudState extends Equatable {
  LyricCrudState();
}

class LyricUninitialized extends LyricCrudState {
  @override
  String toString() => 'LyricUninitialized';
  @override
  List<Object> get props => [];
}

class RetrievingLyric extends LyricCrudState {
  @override
  String toString() => 'RetrievingLyric';
  @override
  List<Object> get props => [];
}

class LyricRetrieved extends LyricCrudState {
  final List<SNLyric> lyrics;
  LyricRetrieved(this.lyrics);
  @override
  String toString() => 'LyricRetrieved';
  @override
  List<Object> get props => [lyrics];
}
