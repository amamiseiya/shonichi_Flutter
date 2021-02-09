import 'dart:async';

import 'package:get/get.dart';

import '../model/project.dart';
import '../model/song.dart';
import 'project.dart';
import '../repository/song.dart';
import '../repository/attachment.dart';

class SongController extends GetxController {
  final ProjectController projectController = Get.find();

  final SongRepository songRepository;
  final AttachmentRepository attachmentRepository;

  RxList<SNSong> songs = RxList<SNSong>(null);
  Rx<SNSong> editingSong = Rx<SNSong>(null);

  SongController(this.songRepository, this.attachmentRepository)
      : assert(songRepository != null),
        assert(attachmentRepository != null) {
    projectController.editingProject.listen((newProject) async {
      editingSong.value = await songRepository.retrieveById(newProject.songId);
      print('editingSong is ${editingSong.value.id}');
    });
  }

  void retrieve() async {
    try {
      print('Retrieving songs');
      songs(await songRepository.retrieveAll());
      print('Songs retrieved');
    } catch (e) {
      print(e);
    }
  }

  void submitCreate(SNSong song) async {
    try {
      if (song != null) {
        await songRepository.create(song);
      }
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  void submitUpdate(SNSong song) async {
    try {
      if (song != null) {
        await songRepository.update(song);
      }
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  void delete(SNSong song) async {
    try {
      await songRepository.delete(song.id);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  void deleteMultiple(List<SNSong> songs) async {
    try {
      await songRepository
          .deleteMultiple(List.generate(songs.length, (i) => songs[i].id));
      retrieve();
    } catch (e) {
      print(e);
    }
  }
}
