part of 'project_crud_bloc.dart';

@immutable
abstract class ProjectCrudState extends Equatable {}

class ProjectUninitialized extends ProjectCrudState {
  @override
  String toString() => 'ProjectUninitialized';
  @override
  List<Object> get props => [];
}

class RetrievingProject extends ProjectCrudState {
  @override
  String toString() => 'RetrievingProject';
  @override
  List<Object> get props => [];
}

class CreatingProject extends ProjectCrudState {
  @override
  String toString() => 'CreatingProject';
  @override
  List<Object> get props => [];
}

class UpdatingProject extends ProjectCrudState {
  final SNProject project;
  UpdatingProject(this.project);
  @override
  String toString() => 'UpdatingProject';
  @override
  List<Object> get props => [project];
}

class NoProjectRetrieved extends ProjectCrudState {
  @override
  String toString() => 'NoProjectRetrieved';
  @override
  List<Object> get props => [];
}

class ProjectRetrieved extends ProjectCrudState {
  final List<SNProject> projects;
  final File firstProjectCoverFile;
  ProjectRetrieved(this.projects, this.firstProjectCoverFile);
  @override
  String toString() => 'ProjectRetrieved';
  @override
  List<Object> get props =>
      [projects, firstProjectCoverFile]; // pass all properties to props
}
