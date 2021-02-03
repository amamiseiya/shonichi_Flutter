import 'dart:io';

import 'package:get/get.dart';

import '../model/project.dart';
import '../model/song.dart';
import '../repository/project.dart';
import '../repository/song.dart';
import '../repository/attachment.dart';

class ProjectController extends GetxController {
  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final AttachmentRepository attachmentRepository;

  RxList<SNProject> projects = RxList<SNProject>(null);
  Rx<SNProject> editingProject = Rx<SNProject>(null);
  Rx<File> editingCover = Rx<File>(null);

  ProjectController(
      this.projectRepository, this.songRepository, this.attachmentRepository)
      : assert(projectRepository != null),
        assert(songRepository != null),
        assert(attachmentRepository != null);

  void retrieve() async {
    try {
      projects(await projectRepository.retrieveLatestN(4));
      if (projects.isNotEmpty) {
        final SNSong song =
            await songRepository.retrieveById(projects[0].songId);
        editingCover.value = await attachmentRepository.getSongCoverFile(song);
      } else {
        editingCover = null;
      }
    } catch (e) {
      print(e);
    }
  }

  void submitCreate(SNProject project) async {
    try {
      if (project != null) {
        await projectRepository.create(project);
        retrieve();
      }
    } catch (e) {
      print(e);
    }
  }

  void submitUpdate(SNProject project) async {
    try {
      if (project != null) {
        await projectRepository.update(project);
      }
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  void delete(SNProject project) async {
    try {
      await projectRepository.delete(project);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  void select(int id) async {
    try {
      if (editingProject == Rx<SNProject>(null) ||
          editingProject.value.id != id) {
        editingProject.value = await projectRepository.retrieveById(id);
        print('editingProject is ${editingProject.value.id}');
      } else if (editingProject.value.id == id) {
        editingProject.value = null;
        print('editingProject is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
