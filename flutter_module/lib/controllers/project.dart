import 'dart:io';

import 'package:get/get.dart';

import '../models/project.dart';
import '../models/song.dart';
import '../repositories/project.dart';
import '../repositories/song.dart';
import '../repositories/attachment.dart';

class ProjectController extends GetxController {
  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final AttachmentRepository attachmentRepository;

  RxList<SNProject> projects = RxList<SNProject>(null);
  Rx<SNProject> editingProject = Rx<SNProject>(null);
  RxString editingCoverURL = RxString(null);

  ProjectController(
      this.projectRepository, this.songRepository, this.attachmentRepository)
      : assert(projectRepository != null),
        assert(songRepository != null),
        assert(attachmentRepository != null);

  Future<void> retrieve() async {
    try {
      final ps = await projectRepository.retrieveLatestN(4);
      if (ps.isNotEmpty) {
        final SNSong song = await songRepository.retrieveById(ps[0].songId);
        editingCoverURL.value =
            await attachmentRepository.getImageURL(song.coverId);
        projects(ps);
      } else {
        editingCoverURL = null;
        projects(ps);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> submitCreate(SNProject project) async {
    try {
      if (project != null) {
        await projectRepository.create(project);
        retrieve();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> submitUpdate(SNProject project) async {
    try {
      if (project != null) {
        await projectRepository.update(project);
      }
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNProject project) async {
    try {
      await projectRepository.delete(project.id);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> select(String id) async {
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
