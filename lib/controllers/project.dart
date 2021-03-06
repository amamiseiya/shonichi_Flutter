import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'auth.dart';
import '../models/project.dart';
import '../models/song.dart';
import '../repositories/project.dart';
import '../repositories/song.dart';
import '../repositories/asset.dart';

class ProjectController extends GetxController {
  final AuthController authController = Get.find();

  final ProjectRepository projectRepository;
  final SongRepository songRepository;
  final AssetRepository assetRepository;

  Rxn<List<SNProject>> projects = Rxn<List<SNProject>>(null);
  Rxn<SNProject> editingProject = Rxn<SNProject>(null);

  ProjectController(
      this.projectRepository, this.songRepository, this.assetRepository)
      : assert(projectRepository != null),
        assert(songRepository != null),
        assert(assetRepository != null) {
    // projects.bindStream(projectRepository.projectsStream);
  }

  Future<void> retrieve() async {
    try {
      projects(await projectRepository.retrieveLatestN(
          authController.user.value!.uid, 4));
    } catch (e) {
      print(e);
    }
  }

  Future<void> submitCreate(SNProject? project) async {
    try {
      if (project != null) {
        project.creatorId = authController.user.value!.uid;
        final DocumentReference docRef = await projectRepository.create(project);
        await retrieve();
        await select(docRef.id);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> submitUpdate(SNProject? project) async {
    try {
      if (project != null) {
        await projectRepository.update(project);
        retrieve();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNProject? project) async {
    try {
      if (project != null) {
        await projectRepository.delete(project.id);
        retrieve();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> select(String id) async {
    try {
      if (editingProject.value == null || editingProject.value!.id != id) {
        editingProject(await projectRepository.retrieveById(id));
        print('editingProject is ${editingProject.value!.id}');
      } else if (editingProject.value!.id == id) {
        editingProject();
        print('editingProject is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
