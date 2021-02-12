import 'dart:async';

import 'package:get/get.dart';

import '../models/song.dart';
import '../models/lyric.dart';
import 'song.dart';
import '../repositories/lyric.dart';
import '../repositories/attachment.dart';

class LyricController extends GetxController {
  final SongController songController = Get.find();

  final LyricRepository lyricRepository;
  final AttachmentRepository attachmentRepository;

  RxList<SNLyric> lyrics = RxList<SNLyric>(null);
  RxList<SNLyric> selectedLyrics = RxList<SNLyric>();

  LyricController(this.lyricRepository, this.attachmentRepository)
      : assert(lyricRepository != null),
        assert(attachmentRepository != null) {
    songController.editingSong.listen((newSong) async {
      await retrieveForSong();
      print('${lyrics.length} lyric(s) retrieved -- listening to editingSong');
    });
  }

  void retrieveForSong() async {
    try {
      print('Retrieving lyrics');
      lyrics(await lyricRepository
          .retrieveForSong(songController.editingSong.value.id));
    } catch (e) {
      print(e);
    }
  }

  void updateLyric(SNLyric lyric) async {
    try {
      await lyricRepository.update(lyric);
      retrieveForSong();
    } catch (e) {
      print(e);
    }
  }

  void importLyric(String lrcStr) async {
    try {
      if (lrcStr != null) {
        final lyrics = SNLyric.parseFromLrc(
            lrcStr,
            songController.editingSong.value.id,
            songController.editingSong.value.lyricOffset);
        for (SNLyric lyric in lyrics) {
          await lyricRepository.create(lyric);
        }
        retrieveForSong();
      }
    } catch (e) {
      print(e);
    }
  }

  void delete(SNLyric lyric) async {
    try {
      await lyricRepository.delete(lyric.id);
      retrieveForSong();
    } catch (e) {
      print(e);
    }
  }
}
