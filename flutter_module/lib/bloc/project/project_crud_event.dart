part of 'project_crud_bloc.dart';

@immutable
abstract class ProjectCrudEvent extends Equatable {}

class InitializeApp extends ProjectCrudEvent {
  @override
  String toString() => 'InitializeApp';
  @override
  List<Object> get props => [];
}

class RetrieveProject extends ProjectCrudEvent {
  @override
  String toString() => 'RetrieveProject';
  @override
  List<Object> get props => [];
}

class CreateProject extends ProjectCrudEvent {
  @override
  String toString() => 'CreateProject';
  @override
  List<Object> get props => [];
}

class UpdateProject extends ProjectCrudEvent {
  final SNProject project;
  UpdateProject(this.project);
  @override
  String toString() => 'UpdateProject';
  @override
  List<Object> get props => [project];
}

class SubmitCreateProject extends ProjectCrudEvent {
  final SNProject project;
  SubmitCreateProject(this.project);
  @override
  String toString() => 'SubmitCreateProject';
  @override
  List<Object> get props => [project];
}

class SubmitUpdateProject extends ProjectCrudEvent {
  final SNProject project;
  SubmitUpdateProject(this.project);
  @override
  String toString() => 'SubmitUpdateProject';
  @override
  List<Object> get props => [project];
}

class DeleteProject extends ProjectCrudEvent {
  final SNProject project;
  DeleteProject(this.project);
  @override
  String toString() => 'DeleteProject';
  @override
  List<Object> get props => [project];
}
