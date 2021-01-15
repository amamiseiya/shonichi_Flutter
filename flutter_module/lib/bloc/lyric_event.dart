part of 'lyric_bloc.dart';

@immutable
abstract class LyricEvent extends Equatable {
  const LyricEvent();
}

class StartFetchingLyric extends LyricEvent {
  @override
  String toString() => 'StartFetchingLyric';
  @override
  List<Object> get props => [];
}

class ReloadLyric extends LyricEvent {
  @override
  String toString() => 'ReloadLyric';
  @override
  List<Object> get props => [];
}

class FinishFetchingLyric extends LyricEvent {
  final List<Lyric> lyrics;
  FinishFetchingLyric(this.lyrics);
  @override
  String toString() => 'FinishFetchingLyric';
  @override
  List<Object> get props => [lyrics];
}

class ChangeLyricData extends LyricEvent {
  final Lyric lyric;
  ChangeLyricData(this.lyric);
  @override
  String toString() => 'ChangeLyricData';
  @override
  List<Object> get props => [lyric];
}

class ImportLyric extends LyricEvent {
  final String lrcStr;
  ImportLyric(this.lrcStr);
  @override
  String toString() => 'ImportLyric';
  @override
  List<Object> get props => [lrcStr];
}

class PressDelete extends LyricEvent {
  final Lyric lyric;
  PressDelete(this.lyric);
  @override
  String toString() => 'PressDelete';
  @override
  List<Object> get props => [lyric];
}
