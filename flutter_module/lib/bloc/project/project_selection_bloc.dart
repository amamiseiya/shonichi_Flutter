import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/project.dart';
import '../../model/song.dart';
import '../../repository/project_repository.dart';
import '../../repository/song_repository.dart';
import '../../repository/storage_repository.dart';

part 'project_selection_event.dart';
part 'project_selection_state.dart';

class ProjectSelectionBloc
    extends Bloc<ProjectSelectionEvent, ProjectSelectionState> {
  final ProjectRepository projectRepository;

  ProjectSelectionBloc(this.projectRepository)
      : assert(projectRepository != null),
        super(ProjectUnselected());

  @override
  Stream<ProjectSelectionState> mapEventToState(
    ProjectSelectionEvent event,
  ) async* {
    if (event is SelectProject) {
      print(event.toString());
      yield* mapSelectProjectToState(event.id);
    }
  }

  Stream<ProjectSelectionState> mapSelectProjectToState(int id) async* {
    try {
      final currentProject = await projectRepository.retrieve(id);
      yield ProjectSelected(currentProject);
      print(state.toString());
    } catch (e) {
      print(e);
    }
  }
}
