part of 'project_selection_bloc.dart';

@immutable
abstract class ProjectSelectionState {}

class ProjectUnselected extends ProjectSelectionState {
  @override
  String toString() => 'ProjectUnselected';
  @override
  List<Object> get props => [];
}

class ProjectSelected extends ProjectSelectionState {
  final SNProject project;
  ProjectSelected(this.project);
  @override
  String toString() => 'ProjectSelected';
  @override
  List<Object> get props => [project];
}
