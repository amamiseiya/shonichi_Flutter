part of 'shot_bloc.dart';

@immutable
abstract class ShotEvent extends Equatable {
  const ShotEvent();
}

class StartFetchingShot extends ShotEvent {
  @override
  String toString() => 'StartFetchingShot';
  @override
  List<Object> get props => [];
}

class ReloadShot extends ShotEvent {
  @override
  String toString() => 'ReloadShot';
  @override
  List<Object> get props => [];
}

class FinishFetchingShot extends ShotEvent {
  final List<Shot> shots;
  FinishFetchingShot(this.shots);
  @override
  String toString() => 'FinishFetchingShot';
  @override
  List<Object> get props => [shots];
}

class ChangeShotData extends ShotEvent {
  final Shot shot;
  ChangeShotData(this.shot);
  @override
  String toString() => 'ChangeShotData';
  @override
  List<Object> get props => [shot];
}

class AddShot extends ShotEvent {
  @override
  String toString() => 'AddShot';
  @override
  List<Object> get props => [];
}

class DeleteShot extends ShotEvent {
  final Shot shot;
  DeleteShot(this.shot);
  @override
  String toString() => 'DeleteShot';
  @override
  List<Object> get props => [shot];
}

class DeleteSelectedShot extends ShotEvent {
  final List<Shot> shots;
  DeleteSelectedShot(this.shots);
  @override
  String toString() => 'DeleteSelectedShot';
  @override
  List<Object> get props => [shots];
}
