part of 'project_selection_bloc.dart';

@immutable
abstract class ProjectSelectionEvent {}

class SelectProject extends ProjectSelectionEvent {
  final int id;
  SelectProject(this.id);
  @override
  String toString() => 'SelectProject';
  @override
  List<Object> get props => [id];
}

// class UnselectProject extends ProjectSelectionEvent {
//   final int id;
//   UnselectProject(this.id);
//   @override
//   String toString() => 'UnselectProject';
//   @override
//   List<Object> get props => [id];
// }
