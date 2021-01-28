import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/project.dart';
import '../../model/song.dart';
import '../../model/lyric.dart';
import '../../model/formation.dart';
import '../../model/character.dart';
import '../project/project_selection_bloc.dart';
import '../song/song_crud_bloc.dart';
import '../lyric/lyric_crud_bloc.dart';
import '../../repository/attachment_repository.dart';
import '../../repository/formation_repository.dart';

part 'formation_crud_event.dart';
part 'formation_crud_state.dart';

class FormationCrudBloc extends Bloc<FormationCrudEvent, FormationCrudState> {
  final FormationRepository formationRepository;
  final AttachmentRepository attachmentRepository;

  final ProjectSelectionBloc projectSelectionBloc;
  final SongCrudBloc songBloc;
  final LyricCrudBloc lyricBloc;
  StreamSubscription projectSelectionBlocSubscription;
  StreamSubscription lyricBlocSubscription;
  StreamSubscription currentSongSubscription;
  SNProject currentProject;
  SNSong currentSong;

  List<SNLyric> lyrics;

  BehaviorSubject<List<SNFormation>> projectFormationsSubject =
      BehaviorSubject<List<SNFormation>>();
  BehaviorSubject<List<SNCharacter>> charactersSubject =
      BehaviorSubject<List<SNCharacter>>();

  BehaviorSubject<SNCharacter> characterFilterSubject =
      BehaviorSubject<SNCharacter>.seeded(SNCharacter());
  BehaviorSubject<Duration> frameFilterSubject =
      BehaviorSubject<Duration>.seeded(Duration(seconds: 0));
  BehaviorSubject<KCurveType> kCurveTypeFilterSubject =
      BehaviorSubject<KCurveType>();

  Stream<List<SNFormation>> characterFormationsStream;
  Stream<List<SNFormation>> frameStream;
  Stream<SNFormation> editingFormationStream = Stream.empty();
  Stream<List<Offset>> editingKCurveStream;

  SNCharacter selectedCharacter = SNCharacter();
  Duration selectedTime;
  KCurveType selectedKCurveType;
  SNFormation editingFormation;
  int draggedPos = -1;
  int draggedPoint = -1;

  final programPainterSize = Size(640, 360);
  final kCurvePainterSize = Size(360, 360);

  FormationCrudBloc(this.projectSelectionBloc, this.songBloc, this.lyricBloc,
      this.formationRepository, this.attachmentRepository)
      : assert(projectSelectionBloc != null),
        assert(songBloc != null),
        assert(lyricBloc != null),
        assert(formationRepository != null),
        assert(attachmentRepository != null),
        super(FormationUninitialized()) {
    lyricBlocSubscription = lyricBloc.listen((state) {
      if (state is LyricRetrieved) {
        lyrics = state.lyrics;
      }
    });
    projectSelectionBlocSubscription = projectSelectionBloc.listen((state) {
      if (state is ProjectSelected) {
        currentProject = state.project;
      }
    });
    currentSongSubscription = songBloc.currentSongSubject.listen((onData) {
      currentSong = onData;
    });
    frameFilterSubject.listen((duration) {
      selectedTime = duration;
    });
    kCurveTypeFilterSubject.listen((type) {
      selectedKCurveType = type;
    });
    editingFormationStream.listen((formation) {
      editingFormation = formation;
    });
    characterFormationsStream = Rx.combineLatest2(
        projectFormationsSubject,
        characterFilterSubject,
        (List<SNFormation> stream, SNCharacter filter) => (filter.name ==
                null) // ! 想要修改
            ? stream
            : stream
                .where((formation) => formation.characterName == filter.name)
                .toList());
    frameStream = Rx.combineLatest2(
        projectFormationsSubject,
        frameFilterSubject,
        (List<SNFormation> stream, Duration filter) => (filter.isNegative)
            ? stream
            : stream
                .where((formation) => formation.startTime == filter)
                .toList());
    editingFormationStream = Rx.combineLatest3(
        projectFormationsSubject,
        characterFilterSubject,
        frameFilterSubject,
        (List<SNFormation> stream, SNCharacter characterFilter,
                Duration frameFilter) =>
            stream
                .where((formation) =>
                    formation.characterName == characterFilter.name)
                .firstWhere((formation) => formation.startTime == frameFilter));
    editingKCurveStream = Rx.combineLatest2(
        editingFormationStream,
        kCurveTypeFilterSubject,
        (SNFormation formation, KCurveType kCurveType) => List.generate(
              2,
              (i) =>
                  formation.getFormationPoint(kCurveType, i, kCurvePainterSize),
            ));
  }

  @override
  Stream<FormationCrudState> mapEventToState(
    FormationCrudEvent event,
  ) async* {
    if (event is RetrieveFormation) {
      yield* mapRetrieveFormationToState();
    } else if (event is FinishRetrievingFormation) {
      print(event.toString());
      yield FormationRetrieved(event.formations, event.characters);
    } else if (event is ChangeSliderValue) {
      yield* mapChangeSliderValueToState(event.sliderValue);
    } else if (event is ChangeTime) {
      yield* mapChangeTimeToState(event.startTime);
    } else if (event is ChangeCharacter) {
      yield* mapChangeCharacterToState(event.character);
    } else if (event is ChangeKCurveType) {
      yield* mapChangeKCurveTypeToState(event.kCurveType);
    } else if (event is CreateFormation) {
      yield* mapCreateFormationToState();
    } else if (event is DeleteFormation) {
      yield* mapDeleteFormationToState();
    } else if (event is OnPanDownProgram) {
      yield* mapOnPanDownProgramToState(
          event.details, event.frame, event.context);
    } else if (event is OnPanUpdateProgram) {
      yield* mapOnPanUpdateProgramToState(
          event.details, event.frame, event.context);
    } else if (event is OnPanEndProgram) {
      yield* mapOnPanEndProgramToState(
          event.details, event.frame, event.context);
    } else if (event is OnPanDownKCurve) {
      yield* mapOnPanDownKCurveToState(
          event.details, event.editingKCurve, event.context);
    } else if (event is OnPanUpdateKCurve) {
      yield* mapOnPanUpdateKCurveToState(
          event.details, event.editingKCurve, event.context);
    } else if (event is OnPanEndKCurve) {
      yield* mapOnPanEndKCurveToState(
          event.details, event.editingKCurve, event.context);
    }
  }

  Stream<FormationCrudState> mapRetrieveFormationToState() async* {
    try {
      charactersSubject
          .add(SNCharacter.membersSortedByGrade(currentSong.subordinateKikaku));
      projectFormationsSubject.add(await formationRepository
          .retrieveForTable(currentProject.formationTableId));
      // projectFormationsSubject.listen(
      //     (onData) => add(FinishedRetrievingFormation(onData, characters)));
      lyricBloc.add(ReloadLyric());
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationCrudState> mapChangeSliderValueToState(
      double sliderValue) async* {
    try {
      // timeSubject.add(Duration(
      //     milliseconds:
      //         (sliderValue * lyrics[lyrics.length - 1].endTime.inMilliseconds)
      //             .toInt()));
      frameFilterSubject.add(Duration(milliseconds: sliderValue.round()));
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationCrudState> mapChangeTimeToState(Duration startTime) async* {
    try {
      frameFilterSubject.add(startTime);
      print('Added to frameFilterSubject');
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationCrudState> mapChangeCharacterToState(
      SNCharacter character) async* {
    try {
      selectedCharacter = (selectedCharacter.name == character.name)
          ? SNCharacter()
          : character;
      characterFilterSubject.add(selectedCharacter);
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationCrudState> mapChangeKCurveTypeToState(
      KCurveType kCurveType) async* {
    try {
      kCurveTypeFilterSubject.add(kCurveType);
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationCrudState> mapCreateFormationToState() async* {
    try {
      // bool isExist = false;
      // characterFormationsStream.listen((onData) {
      //   for (SNFormation formation in onData) {
      //     if (formation.startTime == startTime) {
      //       isExist = true;
      //     }
      //   }
      // });
      // if (!isExist) {
      formationRepository.create(SNFormation(
          id: Random().nextInt(10000),
          startTime: selectedTime,
          posX: 0.0,
          posY: 0.0,
          curveX1X: 0,
          curveX1Y: 0,
          curveX2X: 127,
          curveX2Y: 127,
          curveY1X: 0,
          curveY1Y: 0,
          curveY2X: 127,
          curveY2Y: 127,
          tableId: currentProject.formationTableId,
          characterName: selectedCharacter.name));
      add(RetrieveFormation());
      // }
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationCrudState> mapDeleteFormationToState() async* {
    try {
      formationRepository.delete(editingFormation);
      add(RetrieveFormation());
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationCrudState> mapOnPanDownProgramToState(DragDownDetails details,
      List<SNFormation> frame, BuildContext context) async* {
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

  Stream<FormationCrudState> mapOnPanUpdateProgramToState(
      DragUpdateDetails details,
      List<SNFormation> frame,
      BuildContext context) async* {
    final RenderBox renderBox = context.findRenderObject();
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    print('Pos:${localPos.dx},${localPos.dy}');
    if (draggedPos != -1) {
      frame[draggedPos].setFormationPos(localPos, programPainterSize);
    }
  }

  Stream<FormationCrudState> mapOnPanEndProgramToState(DragEndDetails details,
      List<SNFormation> frame, BuildContext context) async* {
    print('OnPanEnd');
    if (draggedPos != -1) {
      frame[draggedPos].checkFormationPos();
      print('${frame[draggedPos].posX},${frame[draggedPos].posY}');
      await formationRepository.update(frame[draggedPos]);
    }
    add(RetrieveFormation());
  }

  Stream<FormationCrudState> mapOnPanDownKCurveToState(DragDownDetails details,
      List<Offset> editingKCurve, BuildContext context) async* {
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

  Stream<FormationCrudState> mapOnPanUpdateKCurveToState(
      DragUpdateDetails details,
      List<Offset> editingKCurve,
      BuildContext context) async* {
    final RenderBox renderBox = context.findRenderObject();
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    if (draggedPoint != -1) {
      editingFormation.setFormationPoint(
          localPos, selectedKCurveType, draggedPoint, kCurvePainterSize);
      print('Point:${localPos.dx},${localPos.dy}');
    }
  }

  Stream<FormationCrudState> mapOnPanEndKCurveToState(DragEndDetails details,
      List<Offset> editingKCurve, BuildContext context) async* {
    print('OnPanEnd');
    if (draggedPoint != -1) {
      editingFormation.checkFormationPoint(selectedKCurveType);
      print(
          '${editingFormation.curveX1X},${editingFormation.curveX1Y},${editingFormation.curveX2X},${editingFormation.curveX2Y}');
      print(
          '${editingFormation.curveY1X},${editingFormation.curveY1Y},${editingFormation.curveY2X},${editingFormation.curveY2Y}');
      await formationRepository.update(editingFormation);
      add(RetrieveFormation());
    }
  }

  void dispose() {
    projectSelectionBlocSubscription.cancel();
    lyricBlocSubscription.cancel();
    currentSongSubscription.cancel();
    characterFilterSubject.close();
    frameFilterSubject.close();
    projectFormationsSubject.close();
    super.close();
  }
}
