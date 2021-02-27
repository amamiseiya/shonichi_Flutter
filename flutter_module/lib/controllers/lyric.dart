import 'dart:async';

import 'package:get/get.dart';

import '../models/song.dart';
import '../models/lyric.dart';
import 'song.dart';
import '../repositories/lyric.dart';
import '../repositories/asset.dart';

class LyricController extends GetxController {
  final SongController songController = Get.find();

  final LyricRepository lyricRepository;
  final AssetRepository assetRepository;

  late Worker worker;

  Rx<List<SNLyric>?> lyrics = Rx<List<SNLyric>?>(null);
  RxList<SNLyric> selectedLyrics = RxList<SNLyric>(List.empty());

  LyricController(this.lyricRepository, this.assetRepository)
      : assert(lyricRepository != null),
        assert(assetRepository != null);

  void onInit() {
    super.onInit();
    worker = ever(songController.editingSong, (SNSong? newSong) async {
      await retrieveForEditingSong();
      print(
          '${lyrics.value?.length} lyric(s) retrieved -- listening to editingSong');
    });
  }

  Future<void> retrieveForEditingSong() async {
    try {
      print('Retrieving lyrics for editingSong');
      if (songController.editingSong.value == null) {
        lyrics.nil();
      } else if (songController.editingSong.value != null) {
        lyrics(await lyricRepository
            .retrieveForSong(songController.editingSong.value!.id));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateLyric(SNLyric lyric) async {
    try {
      await lyricRepository.update(lyric);
      await retrieveForEditingSong();
    } catch (e) {
      print(e);
    }
  }

  Future<void> importLyric(String lrcStr) async {
    try {
      if (lrcStr != null) {
        final lyrics = SNLyric.parseFromLrc(
            lrcStr,
            songController.editingSong.value!.id,
            songController.editingSong.value!.lyricOffset);
        for (SNLyric lyric in lyrics) {
          await lyricRepository.create(lyric);
        }
        await retrieveForEditingSong();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNLyric lyric) async {
    try {
      await lyricRepository.delete(lyric.id);
      await retrieveForEditingSong();
    } catch (e) {
      print(e);
    }
  }
}
