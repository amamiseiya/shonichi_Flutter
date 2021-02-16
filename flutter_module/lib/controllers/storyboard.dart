import 'package:get/get.dart';

import '../models/storyboard.dart';
import 'song.dart';
import '../repositories/storyboard.dart';

class StoryboardController extends GetxController {
  SongController songController = Get.find();

  final StoryboardRepository storyboardRepository;

  RxList<SNStoryboard> storyboardsForSong = RxList<SNStoryboard>(null);
  Rx<SNStoryboard> editingStoryboard = Rx<SNStoryboard>(null);

  StoryboardController(this.storyboardRepository)
      : assert(storyboardRepository != null);

  void submitCreate(SNStoryboard storyboard) async {
    try {
      if (storyboard == null) {
        throw FormatException('Null value passed in');
      }
      storyboard.authorId = '1';
      storyboard.songId = songController.editingSong.value.id;
      await storyboardRepository.create(storyboard);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieve() async {
    try {
      print('Retrieving storyboards');
      storyboardsForSong(await (storyboardRepository
          .retrieveForSong(songController.editingSong.value.id)));
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNStoryboard storyboard) async {
    try {
      await storyboardRepository.delete(storyboard.id);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> select(String id) async {
    try {
      if (editingStoryboard == Rx<SNStoryboard>(null) ||
          editingStoryboard.value.id != id) {
        editingStoryboard(await storyboardRepository.retrieveById(id));
        print('editingStoryboard is ${editingStoryboard.value.id}');
      } else if (editingStoryboard.value.id == id) {
        editingStoryboard.nil();
        print('editingStoryboard is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
