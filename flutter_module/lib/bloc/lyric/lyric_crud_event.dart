part of 'lyric_crud_bloc.dart';

@immutable
abstract class LyricCrudEvent extends Equatable {
  const LyricCrudEvent();
}

class StartRetrievingLyric extends LyricCrudEvent {
  @override
  String toString() => 'StartRetrievingLyric';
  @override
  List<Object> get props => [];
}

class ReloadLyric extends LyricCrudEvent {
  @override
  String toString() => 'ReloadLyric';
  @override
  List<Object> get props => [];
}

class FinishRetrievingLyric extends LyricCrudEvent {
  final List<SNLyric> lyrics;
  FinishRetrievingLyric(this.lyrics);
  @override
  String toString() => 'FinishRetrievingLyric';
  @override
  List<Object> get props => [lyrics];
}

class ChangeLyricData extends LyricCrudEvent {
  final SNLyric lyric;
  ChangeLyricData(this.lyric);
  @override
  String toString() => 'ChangeLyricData';
  @override
  List<Object> get props => [lyric];
}

class ImportLyric extends LyricCrudEvent {
  final String lrcStr;
  ImportLyric(this.lrcStr);
  @override
  String toString() => 'ImportLyric';
  @override
  List<Object> get props => [lrcStr];
}

class PressDelete extends LyricCrudEvent {
  final SNLyric lyric;
  PressDelete(this.lyric);
  @override
  String toString() => 'PressDelete';
  @override
  List<Object> get props => [lyric];
}
