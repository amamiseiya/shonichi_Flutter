part of 'shot_bloc.dart';

@immutable
abstract class ShotState extends Equatable {
  const ShotState();
}

class ShotUninitialized extends ShotState {
  @override
  String toString() => 'ShotUninitialized';
  @override
  List<Object> get props => [];
}

class FetchingShot extends ShotState {
  @override
  String toString() => 'FetchingShot';
  @override
  List<Object> get props => [];
}

class ShotFetched extends ShotState {
  final List<Shot> shots;
  ShotFetched(this.shots);
  @override
  String toString() => 'ShotFetched';
  @override
  List<Object> get props => [shots];
}
