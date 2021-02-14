import 'dart:async';

import 'package:get/get.dart';

import '../models/project.dart';
import '../models/song.dart';
import 'project.dart';
import '../repositories/song.dart';
import '../repositories/attachment.dart';

class SongController extends GetxController {
  final ProjectController projectController = Get.find();

  final SongRepository songRepository;
  final AttachmentRepository attachmentRepository;

  RxList<SNSong> songs = RxList<SNSong>(null);
  Rx<SNSong> editingSong = Rx<SNSong>(null);
  RxString firstCoverURL = RxString(null);

  SongController(this.songRepository, this.attachmentRepository)
      : assert(songRepository != null),
        assert(attachmentRepository != null) {
    projectController.projects.listen((projects) async {
      if (projects.isNotEmpty) {
        final SNSong firstSong =
            await songRepository.retrieveById(projects[0].songId);
        firstCoverURL(
            await attachmentRepository.getImageURL(firstSong.coverId));
      } else {
        firstCoverURL = null;
      }
    });

    projectController.editingProject.listen((newProject) async {
      editingSong.value = await songRepository.retrieveById(newProject.songId);
      print(
          'editingSong changed to ${editingSong.value.id} -- listening to editingProject');
    });

    // songs.bindStream(songRepository.songsStream);
  }

  Future<void> submitCreate(SNSong song) async {
    try {
      if (song != null) {
        await songRepository.create(song);
      }
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieve() async {
    try {
      print('Retrieving songs');
      songs(await songRepository.retrieveAll());
    } catch (e) {
      print(e);
    }
  }

  Future<void> submitUpdate(SNSong song) async {
    try {
      if (song != null) {
        await songRepository.update(song);
      }
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNSong song) async {
    try {
      await songRepository.delete(song.id);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteMultiple(List<SNSong> songs) async {
    try {
      await songRepository
          .deleteMultiple(List.generate(songs.length, (i) => songs[i].id));
      retrieve();
    } catch (e) {
      print(e);
    }
  }
}
