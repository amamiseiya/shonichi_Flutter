import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/storyboard.dart';
import 'auth.dart';
import 'song.dart';
import 'shot.dart';
import '../repositories/storyboard.dart';

class StoryboardController extends GetxController {
  final AuthController authController = Get.find();
  final SongController songController = Get.find();
  late ShotController shotController = Get.find();

  final StoryboardRepository storyboardRepository;

  Rx<List<SNStoryboard>?> storyboardsForSong = Rx<List<SNStoryboard>>(null);
  Rx<SNStoryboard?> editingStoryboard = Rx<SNStoryboard>(null);

  StoryboardController(this.storyboardRepository)
      : assert(storyboardRepository != null);

  void submitCreate(SNStoryboard? storyboard) async {
    try {
      if (storyboard != null) {
        storyboard.creatorId = authController.user.value!.uid;
        storyboard.songId = songController.editingSong.value!.id;
        final DocumentReference docRef =  await storyboardRepository.create(storyboard);
        await retrieve();
        await select(docRef.id);
      }
    } catch (e) {
      print(e);
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
        storyboardsForSong.nil();
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
          editingStoryboard.nil();
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
        editingStoryboard(await storyboardRepository.retrieveById(id));
        print('editingStoryboard is ${editingStoryboard.value!.id}');
      } else if (editingStoryboard.value!.id == id) {
        editingStoryboard.nil();
        print('editingStoryboard is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
