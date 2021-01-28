import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

import '../model/shot.dart';
import '../model/lyric.dart';
import '../model/character.dart';
import 'project_controller.dart';
import 'song_controller.dart';
import 'lyric_controller.dart';
import 'shot_table_controller.dart';
import '../repository/song_repository.dart';
import '../repository/lyric_repository.dart';
import '../repository/shot_repository.dart';
import '../repository/attachment_repository.dart';

class ShotController extends GetxController {
  // Controller
  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();
  final LyricController lyricController = Get.find();
  final ShotTableController shotTableController = Get.find();

  // Repository
  final SongRepository songRepository;
  final LyricRepository lyricRepository;
  final ShotRepository shotRepository;
  final AttachmentRepository attachmentRepository;

  // 生成的Stream
  Stream<List<Map<String, dynamic>>> coverageStream = Stream.empty();
  Stream<Map<String, int>> statisticsStream = Stream.empty();

  // 控制的变量
  RxList<SNShot> shots = RxList<SNShot>(null);
  RxList<SNShot> selectedShots = RxList<SNShot>();
  Rx<SNShot> editingShot = Rx<SNShot>(null);

  double sliderMaxValue = 1.0;

  ShotController(this.songRepository, this.lyricRepository, this.shotRepository,
      this.attachmentRepository)
      : assert(songRepository != null),
        assert(lyricRepository != null),
        assert(shotRepository != null),
        assert(attachmentRepository != null) {
    shotTableController.editingShotTable.listen((newShotTable) async {
      await retrieveForTable();
      print(
          'listening to editingShotTable and ${shots.length} shots retrieved');
    });

    coverageStream = shots.stream.asyncMap(
        (List<SNShot> shots) => lyricController.lyrics.map((SNLyric lyric) {
              int count = 0;
              for (SNShot shot in shots) {
                if (shot.startTime == lyric.startTime) {
                  count++;
                }
              }
              return {
                'lyricTime': lyric.startTime.inMilliseconds,
                'lyricText': lyric.text,
                'coverageCount': count
              };
            }).toList());

    statisticsStream = shots.stream.asyncMap((List<SNShot> shots) {
      Map<String, int> characterCountMap = Map.fromIterable(
          SNCharacter.membersSortedByGrade(
              songController.editingSong.value.subordinateKikaku),
          key: (character) => character.name,
          value: (_) => 0);
      for (SNShot shot in shots) {
        for (SNCharacter character in shot.characters) {
          characterCountMap[character.name]++;
        }
      }
      return characterCountMap;
    });

    lyricController.lyrics.listen((lyrics) =>
        sliderMaxValue = lyrics.last.endTime.inMilliseconds.toDouble());
  }

  void retrieveForTable() async {
    try {
      print('Retrieving shots');
      shots(await shotRepository
          .retrieveForTable(shotTableController.editingShotTable.value.id));
      print('${shots.length} shots retrieved');
    } catch (e) {
      print(e);
    }
  }

  void updateShot(SNShot shot) async {
    try {
      await shotRepository.update(shot);
      retrieveForTable();
    } catch (e) {
      print(e);
    }
  }

  void create() async {
    try {
      final shot = SNShot(
          id: Random().nextInt(1000),
          sceneNumber: 1010,
          shotNumber: 1,
          startTime: Duration(milliseconds: Random().nextInt(100000)),
          endTime: Duration(milliseconds: Random().nextInt(100000)),
          lyric: '',
          shotType: 'VERYLONGSHOT',
          shotMovement: '',
          shotAngle: '',
          text: '',
          image: '',
          comment: '',
          tableId: shotTableController.editingShotTable.value.id,
          characters: []);
      await shotRepository.create(shot);
      retrieveForTable();
    } catch (e) {
      print(e);
    }
  }

  void delete(SNShot shot) async {
    try {
      await shotRepository.delete(shot);
      retrieveForTable();
    } catch (e) {
      print(e);
    }
  }

  void deleteMultiple(List<SNShot> shots) async {
    try {
      await shotRepository.deleteMultiple(shots);
      retrieveForTable();
    } catch (e) {
      print(e);
    }
  }
}
