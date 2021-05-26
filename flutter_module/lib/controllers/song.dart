import 'dart:async';

import 'package:get/get.dart';

import '../models/project.dart';
import '../models/song.dart';
import 'project.dart';
import '../repositories/asset.dart';
import '../repositories/song.dart';

class SongController extends GetxController {
  final ProjectController projectController = Get.find();

  final SongRepository songRepository;
  final AssetRepository assetRepository;
  late Workers workers;

  Rx<List<SNSong>?> songs = Rx<List<SNSong>?>(null);
  Rx<SNSong?> editingSong = Rx<SNSong>(null);
  Rx<String?> firstCoverURI = Rx<String>(null);
  Rx<String?> videoURI = Rx<String>(
      'https://assets.mixkit.co/videos/preview/mixkit-landscape-from-the-top-of-a-cloudy-mountain-range-39703-large.mp4');

  SongController(this.songRepository, this.assetRepository)
      : assert(songRepository != null),
        assert(assetRepository != null);

  void onInit() {
    super.onInit();
    workers = Workers([
      ever(projectController.projects, (List<SNProject>? projects) async {
        if (projects == null || projects.isEmpty) {
          firstCoverURI.nil();
        } else if (projects.isNotEmpty) {
          final SNSong firstSong =
              await songRepository.retrieveById(projects[0].songId!);
          firstCoverURI(firstSong.coverURI);
        } else {
          throw FormatException();
        }
      }),
      ever(projectController.editingProject, (SNProject? newProject) async {
        if (newProject == null) {
          editingSong.nil();
          print('editingSong changed to null -- listening to editingProject');
        } else if (newProject != null) {
          await select(newProject.songId!);
          print(
              'editingSong changed to ${editingSong.value!.id} -- listening to editingProject');
        } else {
          throw FormatException();
        }
      })
    ]);
  }

  Future<void> retrieveSongVideo() async {
    assetRepository
        .retrieveAssetsForSong(editingSong.value!.id)
        .then((a) => videoURI(a.first.uri));
  }

  Future<void> submitCreate(SNSong song) async {
    try {
      if (song != null) {
        await songRepository.create(song);
      }
      retrieveAll();
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieveAll() async {
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
      retrieveAll();
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNSong song) async {
    try {
      await songRepository.delete(song.id);
      retrieveAll();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteMultiple(List<SNSong> songs) async {
    try {
      await songRepository
          .deleteMultiple(List.generate(songs.length, (i) => songs[i].id));
      retrieveAll();
    } catch (e) {
      print(e);
    }
  }

  Future<void> select(String id) async {
    try {
      editingSong(await songRepository.retrieveById(id));
      print('editingSong is ${editingSong.value!.id}');
    } catch (e) {
      print(e);
    }
  }
}
