import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../models/shot.dart';
import '../models/lyric.dart';
import '../models/character.dart';
import 'project.dart';
import 'song.dart';
import 'lyric.dart';
import 'storyboard.dart';
import '../repositories/song.dart';
import '../repositories/lyric.dart';
import '../repositories/shot.dart';
import '../repositories/attachment.dart';

class ShotController extends GetxController {
  // Controller
  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();
  final LyricController lyricController = Get.find();
  final StoryboardController storyboardController = Get.find();

  // Repository
  final SongRepository songRepository;
  final LyricRepository lyricRepository;
  final ShotRepository shotRepository;
  final AttachmentRepository attachmentRepository;

  // 生成的Stream
  RxList<Map<String, dynamic>> coverageStream = RxList<Map<String, dynamic>>();
  Stream<Map<String, int>> statisticsStream = Stream.empty();

  // 控制的变量
  RxList<SNShot> shots = RxList<SNShot>();
  RxList<SNShot> selectedShots = RxList<SNShot>();
  Rx<int?> editingShotIndex = Rx<int>(null);

  ShotController(this.songRepository, this.lyricRepository, this.shotRepository,
      this.attachmentRepository)
      : assert(songRepository != null),
        assert(lyricRepository != null),
        assert(shotRepository != null),
        assert(attachmentRepository != null) {
    storyboardController.editingStoryboard.listen((newStoryboard) async {
      if (newStoryboard != null) {
        await retrieveForTable();
      }
      print(
          '${shots.length} shot(s) retrieved -- listening to editingStoryboard');
    });

    coverageStream.bindStream(
        rx.Rx.combineLatest2(shots.stream, lyricController.lyrics.stream,
            (List<SNShot> shots, List<SNLyric> lyrics) {
      return List.generate(lyrics.length, (i) {
        int count = 0;
        for (SNShot shot in shots) {
          if (shot.startTime == lyrics[i].startTime) {
            count++;
          }
        }
        return {
          'lyricTime': lyrics[i].startTime.inMilliseconds,
          'lyricText': lyrics[i].text,
          'coverageCount': count
        };
      });
    }));

    statisticsStream = shots.stream.asyncMap((List<SNShot> shots) {
      Map<String, int> characterCountMap = Map.fromIterable(
          SNCharacter.membersSortedByGrade(
              songController.editingSong.value.subordinateKikaku),
          key: (character) => character.name,
          value: (_) => 0);
      for (SNShot shot in shots) {
        for (SNCharacter character in shot.characters) {
          // ! 野蛮
          characterCountMap[character.name] =
              characterCountMap[character.name]! + 1;
        }
      }
      return characterCountMap;
    });
  }

  Future<void> retrieveForTable() async {
    try {
      print('Retrieving shots');
      shots(await shotRepository
          .retrieveForTable(storyboardController.editingStoryboard.value!.id));
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateShot(SNShot shot) async {
    try {
      await shotRepository.update(shot);
      await retrieveForTable();
    } catch (e) {
      print(e);
    }
  }

  Future<void> create() async {
    try {
      await shotRepository.create(SNShot.initialValue(
          storyboardController.editingStoryboard.value!.id));
      await retrieveForTable();
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNShot shot) async {
    try {
      await shotRepository.delete(shot.id);
      await retrieveForTable();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteMultiple(List<SNShot> shots) async {
    try {
      await shotRepository
          .deleteMultiple(List.generate(shots.length, (i) => shots[i].id));
      await retrieveForTable();
    } catch (e) {
      print(e);
    }
  }

  int? selectShot(double value) {
    final ms = value * songController.editingSong.value.duration.inMilliseconds;
    if (shots.length == 1) {
      return editingShotIndex(0);
    } else if (shots.first.startTime.inMilliseconds > ms) {
      return editingShotIndex(0);
    } else if (shots.last.startTime.inMilliseconds < ms) {
      return editingShotIndex(shots.length - 1);
    } else if (shots.length == 2) {
      return ms - shots[0].startTime.inMilliseconds >
              shots[1].startTime.inMilliseconds - ms
          ? editingShotIndex(1)
          : editingShotIndex(0);
    }
    int left = 0;
    int right = shots.length - 1;
    int mid = 0;
    while (left <= right) {
      mid = (left + right) ~/ 2;
      if (shots[mid].startTime.inMilliseconds < ms) {
        left = mid + 1;
      } else if (shots[mid].startTime.inMilliseconds > ms) {
        right = mid - 1;
      } else {
        break;
      }
    }
    if (left <= right) {
      return editingShotIndex(mid);
    }
    if (shots[mid].startTime.inMilliseconds < ms) {
      return ms - shots[mid].startTime.inMilliseconds >
              shots[mid + 1].startTime.inMilliseconds - ms
          ? editingShotIndex(mid + 1)
          : editingShotIndex(mid);
    } else {
      return shots[mid].startTime.inMilliseconds - ms >
              ms - shots[mid - 1].startTime.inMilliseconds
          ? editingShotIndex(mid - 1)
          : editingShotIndex(mid);
    }
  }
}
