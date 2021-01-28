import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/project.dart';
import '../../model/song.dart';
import '../../repository/project_repository.dart';
import '../../repository/song_repository.dart';
import '../../repository/attachment_repository.dart';

part 'project_crud_event.dart';
part 'project_crud_state.dart';

class ProjectCrudBloc extends Bloc<ProjectCrudEvent, ProjectCrudState> {
  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final AttachmentRepository attachmentRepository;

  ProjectCrudBloc(
      this.projectRepository, this.songRepository, this.attachmentRepository)
      : assert(projectRepository != null),
        assert(songRepository != null),
        assert(attachmentRepository != null),
        super(ProjectUninitialized());

  @override
  Stream<ProjectCrudState> mapEventToState(
    ProjectCrudEvent event,
  ) async* {
    if (event is InitializeApp) {
      yield* mapRetrieveProjectToState();
    } else if (event is RetrieveProject) {
      yield* mapRetrieveProjectToState();
    } else if (event is CreateProject) {
      yield CreatingProject();
    } else if (event is UpdateProject) {
      yield UpdatingProject(event.project);
    } else if (event is DeleteProject) {
      yield* mapDeleteProjectToState(event.project);
    } else if (event is SubmitCreateProject) {
      yield* mapSubmitCreateProjectToState(event.project);
    } else if (event is SubmitUpdateProject) {
      yield* mapSubmitUpdateProjectToState(event.project);
    }
  }

  Stream<ProjectCrudState> mapRetrieveProjectToState() async* {
    try {
      yield RetrievingProject();
      final projects = await projectRepository.retrieveLatestN(4);
      if (projects.isNotEmpty) {
        final SNSong song =
            await songRepository.retrieveById(projects[0].songId);
        yield ProjectRetrieved(
            projects, await attachmentRepository.getSongCoverFile(song));
      } else {
        yield NoProjectRetrieved();
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<ProjectCrudState> mapSubmitCreateProjectToState(
      SNProject project) async* {
    try {
      if (project != null) {
        await projectRepository.create(project);
      }
      add(RetrieveProject());
    } catch (e) {
      print(e);
    }
  }

  Stream<ProjectCrudState> mapSubmitUpdateProjectToState(
      SNProject project) async* {
    try {
      if (project != null) {
        await projectRepository.update(project);
      }
      add(RetrieveProject());
    } catch (e) {
      print(e);
    }
  }

  Stream<ProjectCrudState> mapDeleteProjectToState(SNProject project) async* {
    try {
      await projectRepository.delete(project);
      add(RetrieveProject());
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
