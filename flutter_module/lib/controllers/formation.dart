import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../models/project.dart';
import '../models/song.dart';
import '../models/lyric.dart';
import '../models/formation.dart';
import '../models/character.dart';
import 'project.dart';
import 'song.dart';
import 'lyric.dart';
import '../repositories/attachment.dart';
import '../repositories/formation.dart';

class FormationController extends GetxController with StateMixin {
  final FormationRepository formationRepository;
  final AttachmentRepository attachmentRepository;

  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();
  final LyricController lyricController = Get.find();

  RxList<SNFormation> formationsForTable = RxList<SNFormation>(null);
  RxList<SNCharacter> characters = RxList<SNCharacter>(null);

  Rx<SNCharacter> characterFilter = Rx<SNCharacter>(SNCharacter());
  Rx<Duration> timeFilter = Rx<Duration>(Duration(seconds: 0));
  Rx<KCurveType> kCurveTypeFilter = Rx<KCurveType>(null);

  RxList<SNFormation> formationsForCharacter = RxList<SNFormation>(null);
  RxList<SNFormation> formationsForTime = RxList<SNFormation>(null);
  Rx<SNFormation> editingFormation = Rx<SNFormation>(null);
  RxList<Offset> editingKCurve = RxList<Offset>(null);

  @override
  void onInit() {
    change(null, status: RxStatus.loading());
    print('onInit() completed');
    super.onInit();
  }

  int draggedPos = -1;
  int draggedPoint = -1;

  final programPainterSize = Size(480, 270);
  final kCurvePainterSize = Size(270, 270);

  FormationController(this.formationRepository, this.attachmentRepository)
      : assert(formationRepository != null),
        assert(attachmentRepository != null) {
    formationsForCharacter.bindStream(rx.Rx.combineLatest2(
        formationsForTable.stream,
        characterFilter.stream,
        (List<SNFormation> stream, SNCharacter filter) => (filter.name == null)
            ? stream
            : stream
                .where((formation) => formation.characterName == filter.name)
                .toList()));
    formationsForTime.bindStream(rx.Rx.combineLatest2(
        formationsForTable.stream,
        timeFilter.stream,
        (List<SNFormation> stream, Duration filter) => (filter.isNegative)
            ? stream
            : stream
                .where((formation) => formation.startTime == filter)
                .toList()));
    editingFormation.bindStream(rx.Rx.combineLatest3(
        formationsForTable.stream,
        characterFilter.stream,
        timeFilter.stream,
        (List<SNFormation> stream, SNCharacter characterFilter,
                Duration timeFilter) =>
            stream
                .where((formation) =>
                    formation.characterName == characterFilter.name)
                .firstWhere((formation) => formation.startTime == timeFilter,
                    orElse: () => null)));
    editingKCurve.bindStream(
        rx.Rx.combineLatest2(editingFormation.stream, kCurveTypeFilter.stream,
            (SNFormation formation, KCurveType kCurveType) {
      if (formation != null) {
        return List.generate(
          2,
          (i) => formation.getFormationPoint(kCurveType, i, kCurvePainterSize),
        );
      } else {
        return null;
      }
    }));
  }

  void retrieveFormationsForTable() async {
    try {
      characters(SNCharacter.membersSortedByGrade(
          songController.editingSong.value.subordinateKikaku));
      formationsForTable(await formationRepository.retrieveForTable(
          projectController.editingProject.value.formationTableId));
      change(0, status: RxStatus.success());
      print('characters: $characters');
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
      characterFilter((characterFilter.value.name == character.name)
          ? SNCharacter()
          : character);
    } catch (e) {
      print(e);
    }
  }

  void changeKCurveType(KCurveType kCurveType) async {
    try {
      kCurveTypeFilter(
          (kCurveTypeFilter.value == kCurveType) ? null : kCurveType);
    } catch (e) {
      print(e);
    }
  }

  void createFormation() async {
    try {
      bool isValid = true;
      if (characterFilter.value.name == null) isValid = false;
      formationsForCharacter.forEach((SNFormation formation) {
        if (formation.startTime == timeFilter.value) {
          isValid = false;
        }
      });
      if (isValid) {
        formationRepository.create(SNFormation.initialValue(
            timeFilter.value, characterFilter.value.name, '2'));
        // TODO: Implement SNFormationTable selection
        retrieveFormationsForTable();
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteFormation() async {
    try {
      formationRepository.delete(editingFormation.value.id);
      retrieveFormationsForTable();
    } catch (e) {
      print(e);
    }
  }

  void onPanDownProgram(DragDownDetails details, List<SNFormation> frame,
      BuildContext context) async {
    print('OnPanDown');
    final RenderBox renderBox = context.findRenderObject();
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    for (int i = 0; i < frame.length; i++) {
      Rect rect = Rect.fromCircle(
          center: frame[i].getFormationPos(programPainterSize), radius: 20);
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

  void onPanUpdateProgram(DragUpdateDetails details, List<SNFormation> frame,
      BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject();
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    print('Pos:${localPos.dx},${localPos.dy}');
    if (draggedPos != -1) {
      frame[draggedPos].setFormationPos(localPos, programPainterSize);
    }
  }

  void onPanEndProgram(DragEndDetails details, List<SNFormation> frame,
      BuildContext context) async {
    print('OnPanEnd');
    if (draggedPos != -1) {
      frame[draggedPos].checkFormationPos();
      print('${frame[draggedPos].posX},${frame[draggedPos].posY}');
      await formationRepository.update(frame[draggedPos]);
    }
    retrieveFormationsForTable();
  }

  void onPanDownKCurve(DragDownDetails details, List<Offset> editingKCurve,
      BuildContext context) async {
    print('OnPanDown');
    final RenderBox renderBox = context.findRenderObject();
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
    final RenderBox renderBox = context.findRenderObject();
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    if (draggedPoint != -1) {
      editingFormation.value.setFormationPoint(
          localPos, kCurveTypeFilter.value, draggedPoint, kCurvePainterSize);
      print('Point:${localPos.dx},${localPos.dy}');
    }
  }

  void onPanEndKCurve(DragEndDetails details, List<Offset> editingKCurve,
      BuildContext context) async {
    print('OnPanEnd');
    if (draggedPoint != -1) {
      editingFormation.value.checkFormationPoint(kCurveTypeFilter.value);
      print(
          '${editingFormation.value.curveX1X},${editingFormation.value.curveX1Y},${editingFormation.value.curveX2X},${editingFormation.value.curveX2Y}');
      print(
          '${editingFormation.value.curveY1X},${editingFormation.value.curveY1Y},${editingFormation.value.curveY2X},${editingFormation.value.curveY2Y}');
      await formationRepository.update(editingFormation.value);
      retrieveFormationsForTable();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
