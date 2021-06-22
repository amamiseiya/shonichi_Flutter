import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/storyboard.dart';
import 'auth.dart';
import 'project.dart';
import 'song.dart';
import 'shot.dart';
import '../repositories/storyboard.dart';

class StoryboardController extends GetxController {
  late final AuthController authController = Get.find();
  late final ProjectController projectController = Get.find();
  late final SongController songController = Get.find();
  late final ShotController shotController = Get.find();

  final StoryboardRepository storyboardRepository;

  Rxn<List<SNStoryboard>> storyboardsForSong = Rxn<List<SNStoryboard>>(null);
  Rxn<SNStoryboard> editingStoryboard = Rxn<SNStoryboard>(null);

  StoryboardController(this.storyboardRepository)
      : assert(storyboardRepository != null);

  Future<SNStoryboard> submitCreate(SNStoryboard? storyboard) async {
    try {
      if (storyboard != null) {
        storyboard.creatorId = authController.user.value!.uid;
        storyboard.songId = songController.editingSong.value!.id;
        final DocumentReference docRef =
            await storyboardRepository.create(storyboard);
        await retrieve();
        await select(docRef.id);
        return docRef
            .get()
            .then((value) => SNStoryboard.fromJson(value.data(), value.id));
      } else {
        throw FormatException('Storyboard is null');
      }
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  void submitUpdate(SNStoryboard? storyboard) async {
    try {
      if (storyboard != null) {
        await storyboardRepository.update(storyboard);
        retrieve();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieve() async {
    try {
      print('Retrieving storyboards');
      if (authController.user.value == null ||
          songController.editingSong.value == null) {
        storyboardsForSong();
      } else if (authController.user.value != null &&
          songController.editingSong.value != null) {
        storyboardsForSong(await (storyboardRepository.retrieveForSong(
            authController.user.value!.uid,
            songController.editingSong.value!.id)));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNStoryboard? storyboard) async {
    try {
      if (storyboard != null) {
        await shotController.deleteForStoryboard(storyboard);
        await storyboardRepository.delete(storyboard.id);
        if (storyboard == editingStoryboard.value) {
          editingStoryboard();
        }
        retrieve();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> select(String id) async {
    try {
      if (editingStoryboard.value == null ||
          editingStoryboard.value!.id != id) {
        final newStoryboard = await storyboardRepository.retrieveById(id);
        editingStoryboard(newStoryboard);
        projectController.editingProject.value!.storyboardId = id;
        print('editingStoryboard is ${editingStoryboard.value!.id}');
      } else if (editingStoryboard.value!.id == id) {
        editingStoryboard();
        projectController.editingProject.value!.storyboardId = null;
        print('editingStoryboard is null');
      }
      projectController.submitUpdate(projectController.editingProject.value!);
    } catch (e) {
      print(e);
    }
  }
}
