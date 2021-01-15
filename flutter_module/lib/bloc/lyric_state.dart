part of 'lyric_bloc.dart';

@immutable
abstract class LyricState extends Equatable {
  LyricState();
}

class LyricUninitialized extends LyricState {
  @override
  String toString() => 'LyricUninitialized';
  @override
  List<Object> get props => [];
}

class FetchingLyric extends LyricState {
  @override
  String toString() => 'FetchingLyric';
  @override
  List<Object> get props => [];
}

class LyricFetched extends LyricState {
  final List<Lyric> lyrics;
  LyricFetched(this.lyrics);
  @override
  String toString() => 'LyricFetched';
  @override
  List<Object> get props => [lyrics];
}
