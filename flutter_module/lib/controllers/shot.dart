import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../controllers/character.dart';
import '../models/storyboard.dart';
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
import '../repositories/asset.dart';

class ShotController extends GetxController {
  // Controller
  final CharacterController characterController = Get.find();
  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();
  final LyricController lyricController = Get.find();
  final StoryboardController storyboardController = Get.find();

  // Repository
  final SongRepository songRepository;
  final LyricRepository lyricRepository;
  final ShotRepository shotRepository;
  final AssetRepository assetRepository;

  // 生成的Stream
  late Worker worker;
  RxList<Map<String, dynamic>> coverageStream =
      RxList<Map<String, dynamic>>(null);
  Stream<Map<String, int>> statisticsStream = Stream.empty();

  // 控制的变量
  Rx<List<SNShot>?> shots = Rx<List<SNShot>>(null);
  RxList<SNShot> selectedShots = RxList<SNShot>(List.empty());
  Rx<int?> editingShotIndex = Rx<int>(null);

  ShotController(this.songRepository, this.lyricRepository, this.shotRepository,
      this.assetRepository)
      : assert(songRepository != null),
        assert(lyricRepository != null),
        assert(shotRepository != null),
        assert(assetRepository != null) {
    coverageStream.bindStream(
        rx.Rx.combineLatest2(shots.stream, lyricController.lyrics.stream,
            (List<SNShot>? shots, List<SNLyric>? lyrics) {
      if (shots == null || lyrics == null) {
        return List.empty();
      } else if (shots != null && lyrics != null) {
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
      } else {
        throw FormatException();
      }
    }));

    statisticsStream = shots.stream.asyncMap((List<SNShot>? shots) {
      if (shots == null) {
        return Map();
      } else {
        Map<String, int> characterCountMap = Map.fromIterable(
            characterController.editingCharacters.value!,
            key: (character) => character?.name,
            value: (_) => 0);
        for (SNShot shot in shots) {
          shot.characters.forEach((SNCharacter character) {
            // ! 野蛮
            if (characterCountMap[character.name] != null) {
              characterCountMap[character.name] =
                  characterCountMap[character.name]! + 1;
            }
          });
        }
        return characterCountMap;
      }
    });
  }

  void onInit() {
    super.onInit();
    worker = ever(storyboardController.editingStoryboard,
        (SNStoryboard? newStoryboard) async {
      await retrieveForEditingStoryboard();
      print(
          '${shots.value?.length} shot(s) retrieved -- listening to editingStoryboard');
    });
  }

  Future<void> retrieveForEditingStoryboard() async {
    try {
      print('Retrieving shots for editingStoryboard');
      if (storyboardController.editingStoryboard.value == null) {
        shots.nil();
      } else if (storyboardController.editingStoryboard.value != null) {
        shots(await shotRepository.retrieveForStoryboard(
            storyboardController.editingStoryboard.value!.id));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateShot(SNShot shot) async {
    try {
      await shotRepository.update(shot);
      await retrieveForEditingStoryboard();
    } catch (e) {
      print(e);
    }
  }

  Future<void> create() async {
    try {
      await shotRepository.create(SNShot.initialValue(
          storyboardController.editingStoryboard.value!.id));
      await retrieveForEditingStoryboard();
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNShot shot) async {
    try {
      await shotRepository.delete(shot.id);
      await retrieveForEditingStoryboard();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteMultiple(List<SNShot> shots) async {
    try {
      await shotRepository
          .deleteMultiple(List.generate(shots.length, (i) => shots[i].id));
      await retrieveForEditingStoryboard();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteForStoryboard(SNStoryboard storyboard) async {
    try {
      await shotRepository.deleteForStoryboard(storyboard.id);
    } catch (e) {
      print(e);
    }
  }

  int? selectShot(double value) {
    if (shots.value != null) {
      final ms =
          value * songController.editingSong.value!.duration.inMilliseconds;
      if (shots.value!.length == 1) {
        return editingShotIndex(0);
      } else if (shots.value!.first.startTime.inMilliseconds > ms) {
        return editingShotIndex(0);
      } else if (shots.value!.last.startTime.inMilliseconds < ms) {
        return editingShotIndex(shots.value!.length - 1);
      } else if (shots.value!.length == 2) {
        return ms - shots.value![0].startTime.inMilliseconds >
                shots.value![1].startTime.inMilliseconds - ms
            ? editingShotIndex(1)
            : editingShotIndex(0);
      }
      int left = 0;
      int right = shots.value!.length - 1;
      int mid = 0;
      while (left <= right) {
        mid = (left + right) ~/ 2;
        if (shots.value![mid].startTime.inMilliseconds < ms) {
          left = mid + 1;
        } else if (shots.value![mid].startTime.inMilliseconds > ms) {
          right = mid - 1;
        } else {
          break;
        }
      }
      if (left <= right) {
        return editingShotIndex(mid);
      }
      if (shots.value![mid].startTime.inMilliseconds < ms) {
        return ms - shots.value![mid].startTime.inMilliseconds >
                shots.value![mid + 1].startTime.inMilliseconds - ms
            ? editingShotIndex(mid + 1)
            : editingShotIndex(mid);
      } else {
        return shots.value![mid].startTime.inMilliseconds - ms >
                ms - shots.value![mid - 1].startTime.inMilliseconds
            ? editingShotIndex(mid - 1)
            : editingShotIndex(mid);
      }
    } else {
      return 0;
    }
  }
}
