import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../controllers/formation.dart';
import '../models/project.dart';
import '../models/song.dart';
import '../models/lyric.dart';
import '../models/move.dart';
import '../models/character.dart';
import '../models/formation.dart';
import 'project.dart';
import 'song.dart';
import 'lyric.dart';
import '../repositories/asset.dart';
import '../repositories/move.dart';

class MoveController extends GetxController with StateMixin {
  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();
  final LyricController lyricController = Get.find();
  final FormationController formationController = Get.find();

  final MoveRepository moveRepository;
  final AssetRepository assetRepository;

  late Worker worker;
  Rx<List<SNMove>?> movesForFormation = Rx<List<SNMove>?>(null);

  Rx<SNCharacter?> characterFilter = Rx<SNCharacter>(null);
  Rx<Duration?> timeFilter = Rx<Duration>(null);
  Rx<KCurveType?> kCurveTypeFilter = Rx<KCurveType>(null);

  RxList<SNMove> movesForCharacter = RxList<SNMove>(null);
  RxList<SNMove> movesForTime = RxList<SNMove>(null);
  Rx<SNMove?> editingMove = Rx<SNMove>(null);
  Rx<List<Offset>?> editingKCurve = Rx<List<Offset>?>(null);

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    worker = ever(formationController.editingFormation,
        (SNFormation? newFormation) async {
      await retrieveForEditingFormation();
      print(
          '${movesForFormation.value?.length} move(s) retrieved -- listening to editingFormation');
    });
    print('onInit() completed');
  }

  int draggedPos = -1;
  int draggedPoint = -1;

  final programPainterSize = Size(480, 270);
  final kCurvePainterSize = Size(270, 270);

  MoveController(this.moveRepository, this.assetRepository)
      : assert(moveRepository != null),
        assert(assetRepository != null) {
    movesForCharacter.bindStream(rx.Rx.combineLatest2(
        movesForFormation.stream, characterFilter.stream,
        (List<SNMove>? stream, SNCharacter? filter) {
      if (stream == null) {
        return List.empty();
      } else if (stream != null && filter == null) {
        return stream;
      } else if (stream != null && filter != null) {
        return stream
            .where((move) => move.character.name == filter.name)
            .toList();
      } else {
        throw FormatException();
      }
    }));
    movesForTime.bindStream(
        rx.Rx.combineLatest2(movesForFormation.stream, timeFilter.stream,
            (List<SNMove>? stream, Duration? filter) {
      if (stream == null) {
        return List.empty();
      } else if (stream != null && filter == null) {
        return stream;
      } else if (stream != null && filter != null) {
        return stream
            .where((move) => move.startTime == filter)
            .toList();
      } else {
        throw FormatException();
      }
    }));
    // ? 不确定.first会不会带来问题
    editingMove.bindStream(rx.Rx.combineLatest3(
        movesForFormation.stream, characterFilter.stream, timeFilter.stream,
        (List<SNMove>? stream, SNCharacter? characterFilter,
            Duration? timeFilter) {
      if (stream == null) {
        return null;
      } else if (stream != null) {
        final Iterable<SNMove> m = stream
            .where(
                (move) => move.character.name == characterFilter?.name)
            .where((move) => move.startTime == timeFilter);
        if (m.isEmpty) {
          return null;
        } else if (m.length == 1) {
          return m.first;
        } else {
          throw FormatException('Multiple moves exist');
        }
      }
    }));
    editingKCurve.bindStream(
        rx.Rx.combineLatest2(editingMove.stream, kCurveTypeFilter.stream,
            (SNMove? move, KCurveType? kCurveType) {
      if (move == null || kCurveType == null) {
        return null;
      }
      if (move != null && kCurveType != null) {
        return List.generate(
          2,
          (i) => move.getMovePoint(kCurveType, i, kCurvePainterSize),
        );
      } else {
        throw FormatException();
      }
    }));
  }

  Future<void> retrieveForEditingFormation() async {
    try {
      print('Retrieving shots for editingFormation');
      if (formationController.editingFormation.value == null) {
        movesForFormation.nil();
        change(0, status: RxStatus.success());
      } else if (formationController.editingFormation.value != null) {
        movesForFormation(await moveRepository.retrieveForFormation(
            formationController.editingFormation.value!.id));
        change(0, status: RxStatus.success());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> create() async {
    try {
      bool isValid = true;
      if (characterFilter.value == null || timeFilter.value == null) {
        isValid = false;
      }
      movesForCharacter.forEach((SNMove move) {
        if (move.startTime == timeFilter.value) {
          isValid = false;
        }
      });
      if (isValid) {
        moveRepository.create(SNMove.initialValue(
            timeFilter.value!,
            characterFilter.value!,
            formationController.editingFormation.value!.id));
        await retrieveForEditingFormation();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete() async {
    try {
      moveRepository.delete(editingMove.value!.id);
      await retrieveForEditingFormation();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteForFormation(SNFormation formation) async {
    try {
      await moveRepository.deleteForFormation(formation.id);
    } catch (e) {
      print(e);
    }
  }

  void changeSliderValue(double sliderValue) async {
    try {
      // timeFilter(Duration(
      //     milliseconds:
      //         (sliderValue * lyricController.lyrics.last.endTime.inMilliseconds)
      //             .toInt()));
      timeFilter(Duration(milliseconds: sliderValue.round()));
      print('Added to timeFilter');
    } catch (e) {
      print(e);
    }
  }

  void changeTime(Duration startTime) async {
    try {
      timeFilter(startTime);
      print('Added to timeFilter');
    } catch (e) {
      print(e);
    }
  }

  void changeCharacter(SNCharacter character) async {
    try {
      if (characterFilter.value?.name == character.name) {
        characterFilter.nil();
      } else {
        characterFilter(character);
      }
    } catch (e) {
      print(e);
    }
  }

  void changeKCurveType(KCurveType kCurveType) async {
    try {
      if (kCurveTypeFilter.value == kCurveType) {
        return kCurveTypeFilter.nil();
      } else {
        kCurveTypeFilter(kCurveType);
      }
    } catch (e) {
      print(e);
    }
  }

  void onPanDownProgram(DragDownDetails details,
      List<SNMove> movesForTime, BuildContext context) async {
    print('OnPanDown');
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    for (int i = 0; i < movesForTime.length; i++) {
      Rect rect = Rect.fromCircle(
          center: movesForTime[i].getMovePos(programPainterSize),
          radius: 20);
      if (rect.contains(localPos)) {
        draggedPos = i;
        print('draggedPos = $draggedPos');
        return;
      }
    }
    draggedPos = -1;
    print('draggedPos = $draggedPos');
    return;
  }

  void onPanUpdateProgram(DragUpdateDetails details,
      List<SNMove> movesForTime, BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    print('Pos:${localPos.dx},${localPos.dy}');
    if (draggedPos != -1) {
      movesForTime[draggedPos].setMovePos(localPos, programPainterSize);
    }
  }

  void onPanEndProgram(DragEndDetails details,
      List<SNMove> movesForTime, BuildContext context) async {
    print('OnPanEnd');
    if (draggedPos != -1) {
      movesForTime[draggedPos].checkMovePos();
      print(
          '${movesForTime[draggedPos].posX},${movesForTime[draggedPos].posY}');
      await moveRepository.update(movesForTime[draggedPos]);
      await retrieveForEditingFormation();
    }
  }

  void onPanDownKCurve(DragDownDetails details, List<Offset> editingKCurve,
      BuildContext context) async {
    print('OnPanDown');
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    final Rect rect0 = Rect.fromCircle(center: editingKCurve[0], radius: 20);
    final Rect rect1 = Rect.fromCircle(center: editingKCurve[1], radius: 20);
    if (rect0.contains(localPos))
      draggedPoint = 0;
    else if (rect1.contains(localPos))
      draggedPoint = 1;
    else
      draggedPoint = -1;
    print('draggedPoint = $draggedPoint');
  }

  void onPanUpdateKCurve(DragUpdateDetails details, List<Offset> editingKCurve,
      BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    if (draggedPoint != -1) {
      editingMove.value!.setMovePoint(
          localPos, kCurveTypeFilter.value!, draggedPoint, kCurvePainterSize);
      print('Point:${localPos.dx},${localPos.dy}');
    }
  }

  void onPanEndKCurve(DragEndDetails details, List<Offset> editingKCurve,
      BuildContext context) async {
    print('OnPanEnd');
    if (draggedPoint != -1) {
      editingMove.value!.checkMovePoint(kCurveTypeFilter.value!);
      print(
          '${editingMove.value!.curveX1X},${editingMove.value!.curveX1Y},${editingMove.value!.curveX2X},${editingMove.value!.curveX2Y}');
      print(
          '${editingMove.value!.curveY1X},${editingMove.value!.curveY1Y},${editingMove.value!.curveY2X},${editingMove.value!.curveY2Y}');
      await moveRepository.update(editingMove.value!);
      await retrieveForEditingFormation();
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
