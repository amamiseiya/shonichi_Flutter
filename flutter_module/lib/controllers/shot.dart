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
import 'shot_table.dart';
import '../repositories/song.dart';
import '../repositories/lyric.dart';
import '../repositories/shot.dart';
import '../repositories/attachment.dart';

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
  RxList<SNShot> shots = RxList<SNShot>();
  RxList<SNShot> selectedShots = RxList<SNShot>();
  Rx<SNShot> editingShot = Rx<SNShot>(null);

  ShotController(this.songRepository, this.lyricRepository, this.shotRepository,
      this.attachmentRepository)
      : assert(songRepository != null),
        assert(lyricRepository != null),
        assert(shotRepository != null),
        assert(attachmentRepository != null) {
    selectedShots.listen((shots) {
      if (shots.length == 1) {
        editingShot(shots.first);
      }
    });

    shotTableController.editingShotTable.listen((newShotTable) async {
      if (newShotTable != null) {
        await retrieveForTable();
      }
      print(
          '${shots.length} shot(s) retrieved -- listening to editingShotTable');
    });

    coverageStream =
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
    });

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
  }

  Future<void> retrieveForTable() async {
    try {
      print('Retrieving shots');
      shots(await shotRepository
          .retrieveForTable(shotTableController.editingShotTable.value.id));
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
      final shot = SNShot(
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
}
