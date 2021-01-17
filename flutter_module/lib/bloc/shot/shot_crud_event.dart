part of 'shot_crud_bloc.dart';

@immutable
abstract class ShotCrudEvent extends Equatable {}

class RetrieveShot extends ShotCrudEvent {
  @override
  String toString() => 'RetrieveShot';
  @override
  List<Object> get props => [];
}

// class FinishRetrievingShot extends ShotCrudEvent {
//   final List<SNShot> shots;
//   FinishRetrievingShot(this.shots);
//   @override
//   String toString() => 'FinishRetrievingShot';
//   @override
//   List<Object> get props => [shots];
// }

class UpdateShot extends ShotCrudEvent {
  final SNShot shot;
  UpdateShot(this.shot);
  @override
  String toString() => 'UpdateShot';
  @override
  List<Object> get props => [shot];
}

class CreateShot extends ShotCrudEvent {
  @override
  String toString() => 'CreateShot';
  @override
  List<Object> get props => [];
}

class DeleteShot extends ShotCrudEvent {
  final SNShot shot;
  DeleteShot(this.shot);
  @override
  String toString() => 'DeleteShot';
  @override
  List<Object> get props => [shot];
}

class DeleteMultipleShot extends ShotCrudEvent {
  final List<SNShot> shots;
  DeleteMultipleShot(this.shots);
  @override
  String toString() => 'DeleteMultipleShot';
  @override
  List<Object> get props => [shots];
}
