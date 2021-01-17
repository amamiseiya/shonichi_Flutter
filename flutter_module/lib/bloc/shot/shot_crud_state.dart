part of 'shot_crud_bloc.dart';

@immutable
abstract class ShotCrudState extends Equatable {}

class ShotUninitialized extends ShotCrudState {
  @override
  String toString() => 'ShotUninitialized';
  @override
  List<Object> get props => [];
}

class RetrievingShot extends ShotCrudState {
  @override
  String toString() => 'RetrievingShot';
  @override
  List<Object> get props => [];
}

class ShotRetrieved extends ShotCrudState {
  final List<SNShot> shots;
  ShotRetrieved(this.shots);
  @override
  String toString() => 'ShotRetrieved';
  @override
  List<Object> get props => [shots];
}
