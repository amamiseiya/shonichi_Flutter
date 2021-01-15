part of 'project_bloc.dart';

@immutable
abstract class ProjectEvent extends Equatable {
  const ProjectEvent();
}

class InitializeApp extends ProjectEvent {
  @override
  String toString() => 'InitializeApp';
  @override
  List<Object> get props => [];
}

class ReloadProject extends ProjectEvent {
  @override
  String toString() => 'ReloadProject';
  @override
  List<Object> get props => [];
}

class AddProject extends ProjectEvent {
  @override
  String toString() => 'AddProject';
  @override
  List<Object> get props => [];
}

class UpdateProject extends ProjectEvent {
  final Project project;
  UpdateProject(this.project);
  @override
  String toString() => 'UpdateProject';
  @override
  List<Object> get props => [project];
}

class ConfirmAddProject extends ProjectEvent {
  final Project project;
  ConfirmAddProject(this.project);
  @override
  String toString() => 'ConfirmAddProject';
  @override
  List<Object> get props => [project];
}

class ConfirmUpdateProject extends ProjectEvent {
  final Project project;
  ConfirmUpdateProject(this.project);
  @override
  String toString() => 'ConfirmUpdateProject';
  @override
  List<Object> get props => [project];
}

class DeleteProject extends ProjectEvent {
  final Project project;
  DeleteProject(this.project);
  @override
  String toString() => 'DeleteProject';
  @override
  List<Object> get props => [project];
}

class SelectAProject extends ProjectEvent {
  final int projectId;
  SelectAProject(this.projectId);
  @override
  String toString() => 'SelectAProject';
  @override
  List<Object> get props => [projectId];
}
