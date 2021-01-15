import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../model/project.dart';
import '../model/song.dart';
import '../repository/project_repository.dart';
import '../repository/song_repository.dart';
import '../repository/storage_repository.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final StorageRepository storageRepository;

  ProjectBloc(
      this.projectRepository, this.songRepository, this.storageRepository)
      : assert(projectRepository != null),
        assert(songRepository != null),
        assert(storageRepository != null),
        super(null);

  @override
  ProjectState get initialState => ProjectUninitialized();

  @override
  Stream<ProjectState> mapEventToState(
    ProjectEvent event,
  ) async* {
    if (event is InitializeApp) {
      yield* mapReloadProjectToState();
    } else if (event is ReloadProject) {
      yield* mapReloadProjectToState();
    } else if (event is AddProject) {
      yield AddingProject();
    } else if (event is UpdateProject) {
      yield UpdatingProject(event.project);
    } else if (event is DeleteProject) {
      yield* mapDeleteProjectToState(event.project);
    } else if (event is ConfirmAddProject) {
      yield* mapConfirmAddProjectToState(event.project);
    } else if (event is ConfirmUpdateProject) {
      yield* mapConfirmUpdateProjectToState(event.project);
    } else if (event is SelectAProject) {
      yield* mapSelectAProjectToState(event.projectId);
    }
  }

  Stream<ProjectState> mapReloadProjectToState() async* {
    try {
      yield FetchingProjects();
      final projects = await projectRepository.fetch4Projects();
      if (projects.isNotEmpty) {
        final Song song =
            await songRepository.fetchSpecifiedSong(projects[0].songId);
        yield ProjectFetched(
            projects, await storageRepository.getSongCoverFile(song));
      } else {
        yield NoProjectFetched();
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<ProjectState> mapConfirmAddProjectToState(Project project) async* {
    try {
      if (project != null) {
        await projectRepository.addProject(project);
      }
      add(ReloadProject());
    } catch (e) {
      print(e);
    }
  }

  Stream<ProjectState> mapConfirmUpdateProjectToState(Project project) async* {
    try {
      if (project != null) {
        await projectRepository.updateProject(project);
      }
      add(ReloadProject());
    } catch (e) {
      print(e);
    }
  }

  Stream<ProjectState> mapDeleteProjectToState(Project project) async* {
    try {
      await projectRepository.deleteProject(project);
      add(ReloadProject());
    } catch (e) {
      print(e);
    }
  }

  Stream<ProjectState> mapSelectAProjectToState(int projectId) async* {
    try {
      // yield FetchingProjects();
      final projects = await projectRepository.fetch4Projects();
      if (projects.isNotEmpty) {
        final Song song =
            await songRepository.fetchSpecifiedSong(projects[0].songId);
        final currentProject =
            await projectRepository.fetchSpecifiedProject(projectId);
        yield ProjectSelected(projects,
            await storageRepository.getSongCoverFile(song), currentProject);
      }
    } catch (e) {
      print(e);
    }
  }

  void dispose() async {
    super.close();
  }
}
