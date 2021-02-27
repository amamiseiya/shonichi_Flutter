import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../controllers/formation.dart';
import '../models/project.dart';
import '../models/song.dart';
import '../models/lyric.dart';
import '../models/movement.dart';
import '../models/character.dart';
import '../models/formation.dart';
import 'project.dart';
import 'song.dart';
import 'lyric.dart';
import '../repositories/asset.dart';
import '../repositories/movement.dart';

class MovementController extends GetxController with StateMixin {
  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();
  final LyricController lyricController = Get.find();
  final FormationController formationController = Get.find();

  final MovementRepository movementRepository;
  final AssetRepository assetRepository;

  late Worker worker;
  Rx<List<SNMovement>?> movementsForFormation = Rx<List<SNMovement>?>(null);

  Rx<SNCharacter?> characterFilter = Rx<SNCharacter>(null);
  Rx<Duration?> timeFilter = Rx<Duration>(null);
  Rx<KCurveType?> kCurveTypeFilter = Rx<KCurveType>(null);

  RxList<SNMovement> movementsForCharacter = RxList<SNMovement>(null);
  RxList<SNMovement> movementsForTime = RxList<SNMovement>(null);
  Rx<SNMovement?> editingMovement = Rx<SNMovement>(null);
  Rx<List<Offset>?> editingKCurve = Rx<List<Offset>?>(null);

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    worker = ever(formationController.editingFormation,
        (SNFormation? newFormation) async {
      await retrieveForEditingFormation();
      print(
          '${movementsForFormation.value?.length} movement(s) retrieved -- listening to editingFormation');
    });
    print('onInit() completed');
  }

  int draggedPos = -1;
  int draggedPoint = -1;

  final programPainterSize = Size(480, 270);
  final kCurvePainterSize = Size(270, 270);

  MovementController(this.movementRepository, this.assetRepository)
      : assert(movementRepository != null),
        assert(assetRepository != null) {
    movementsForCharacter.bindStream(rx.Rx.combineLatest2(
        movementsForFormation.stream, characterFilter.stream,
        (List<SNMovement>? stream, SNCharacter? filter) {
      if (stream == null) {
        return List.empty();
      } else if (stream != null && filter == null) {
        return stream;
      } else if (stream != null && filter != null) {
        return stream
            .where((movement) => movement.character.name == filter.name)
            .toList();
      } else {
        throw FormatException();
      }
    }));
    movementsForTime.bindStream(
        rx.Rx.combineLatest2(movementsForFormation.stream, timeFilter.stream,
            (List<SNMovement>? stream, Duration? filter) {
      if (stream == null) {
        return List.empty();
      } else if (stream != null && filter == null) {
        return stream;
      } else if (stream != null && filter != null) {
        return stream
            .where((movement) => movement.startTime == filter)
            .toList();
      } else {
        throw FormatException();
      }
    }));
    // ? 不确定.first会不会带来问题
    editingMovement.bindStream(rx.Rx.combineLatest3(
        movementsForFormation.stream, characterFilter.stream, timeFilter.stream,
        (List<SNMovement>? stream, SNCharacter? characterFilter,
            Duration? timeFilter) {
      if (stream == null) {
        return null;
      } else if (stream != null) {
        final Iterable<SNMovement> m = stream
            .where(
                (movement) => movement.character.name == characterFilter?.name)
            .where((movement) => movement.startTime == timeFilter);
        if (m.isEmpty) {
          return null;
        } else if (m.length == 1) {
          return m.first;
        } else {
          throw FormatException('Multiple movements exist');
        }
      }
    }));
    editingKCurve.bindStream(
        rx.Rx.combineLatest2(editingMovement.stream, kCurveTypeFilter.stream,
            (SNMovement? movement, KCurveType? kCurveType) {
      if (movement == null || kCurveType == null) {
        return null;
      }
      if (movement != null && kCurveType != null) {
        return List.generate(
          2,
          (i) => movement.getMovementPoint(kCurveType, i, kCurvePainterSize),
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
        movementsForFormation.nil();
        change(0, status: RxStatus.success());
      } else if (formationController.editingFormation.value != null) {
        movementsForFormation(await movementRepository.retrieveForFormation(
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
      movementsForCharacter.forEach((SNMovement movement) {
        if (movement.startTime == timeFilter.value) {
          isValid = false;
        }
      });
      if (isValid) {
        movementRepository.create(SNMovement.initialValue(
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
      movementRepository.delete(editingMovement.value!.id);
      await retrieveForEditingFormation();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteForFormation(SNFormation formation) async {
    try {
      await movementRepository.deleteForFormation(formation.id);
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
      List<SNMovement> movementsForTime, BuildContext context) async {
    print('OnPanDown');
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    for (int i = 0; i < movementsForTime.length; i++) {
      Rect rect = Rect.fromCircle(
          center: movementsForTime[i].getMovementPos(programPainterSize),
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
      List<SNMovement> movementsForTime, BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    print('Pos:${localPos.dx},${localPos.dy}');
    if (draggedPos != -1) {
      movementsForTime[draggedPos].setMovementPos(localPos, programPainterSize);
    }
  }

  void onPanEndProgram(DragEndDetails details,
      List<SNMovement> movementsForTime, BuildContext context) async {
    print('OnPanEnd');
    if (draggedPos != -1) {
      movementsForTime[draggedPos].checkMovementPos();
      print(
          '${movementsForTime[draggedPos].posX},${movementsForTime[draggedPos].posY}');
      await movementRepository.update(movementsForTime[draggedPos]);
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
      editingMovement.value!.setMovementPoint(
          localPos, kCurveTypeFilter.value!, draggedPoint, kCurvePainterSize);
      print('Point:${localPos.dx},${localPos.dy}');
    }
  }

  void onPanEndKCurve(DragEndDetails details, List<Offset> editingKCurve,
      BuildContext context) async {
    print('OnPanEnd');
    if (draggedPoint != -1) {
      editingMovement.value!.checkMovementPoint(kCurveTypeFilter.value!);
      print(
          '${editingMovement.value!.curveX1X},${editingMovement.value!.curveX1Y},${editingMovement.value!.curveX2X},${editingMovement.value!.curveX2Y}');
      print(
          '${editingMovement.value!.curveY1X},${editingMovement.value!.curveY1Y},${editingMovement.value!.curveY2X},${editingMovement.value!.curveY2Y}');
      await movementRepository.update(editingMovement.value!);
      await retrieveForEditingFormation();
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
