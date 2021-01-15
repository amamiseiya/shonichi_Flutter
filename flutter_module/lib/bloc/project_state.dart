part of 'project_bloc.dart';

@immutable
abstract class ProjectState extends Equatable {
  const ProjectState();
}

class ProjectUninitialized extends ProjectState {
  @override
  String toString() => 'ProjectUninitialized';
  @override
  List<Object> get props => [];
}

class FetchingProjects extends ProjectState {
  @override
  String toString() => 'FetchingProjects';
  @override
  List<Object> get props => [];
}

class AddingProject extends ProjectState {
  @override
  String toString() => 'AddingProject';
  @override
  List<Object> get props => [];
}

class UpdatingProject extends ProjectState {
  final Project project;
  UpdatingProject(this.project);
  @override
  String toString() => 'UpdatingProject';
  @override
  List<Object> get props => [project];
}

class NoProjectFetched extends ProjectState {
  @override
  String toString() => 'NoProjectFetched';
  @override
  List<Object> get props => [];
}

class ProjectFetched extends ProjectState {
  final List<Project> projects;
  final File firstProjectCoverFile;
  ProjectFetched(this.projects, this.firstProjectCoverFile);
  @override
  String toString() => 'ProjectFetched';
  @override
  List<Object> get props =>
      [projects, firstProjectCoverFile]; // pass all properties to props
}

class ProjectSelected extends ProjectState {
  final List<Project> projects;
  final File firstProjectCoverFile;
  final Project project;
  ProjectSelected(this.projects, this.firstProjectCoverFile, this.project);
  @override
  String toString() => 'ProjectSelected';
  @override
  List<Object> get props => [projects, firstProjectCoverFile, project];
}
