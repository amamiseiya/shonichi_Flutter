import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../model/project.dart';
import '../model/song.dart';
import '../model/lyric.dart';
import '../model/formation.dart';
import '../model/character.dart';
import '../bloc/project_bloc.dart';
import '../bloc/song_bloc.dart';
import '../bloc/lyric_bloc.dart';
import '../repository/storage_repository.dart';
import '../repository/formation_repository.dart';

part 'formation_event.dart';
part 'formation_state.dart';

class FormationBloc extends Bloc<FormationEvent, FormationState> {
  final FormationRepository formationRepository;
  final StorageRepository storageRepository;

  final ProjectBloc projectBloc;
  final SongBloc songBloc;
  final LyricBloc lyricBloc;
  StreamSubscription projectBlocSubscription;
  StreamSubscription lyricBlocSubscription;
  StreamSubscription currentSongSubscription;
  Project currentProject;
  Song currentSong;

  List<Lyric> lyrics;

  BehaviorSubject<List<Formation>> projectFormationsSubject =
      BehaviorSubject<List<Formation>>();
  BehaviorSubject<List<Character>> charactersSubject =
      BehaviorSubject<List<Character>>();

  BehaviorSubject<Character> characterFilterSubject =
      BehaviorSubject<Character>.seeded(Character());
  BehaviorSubject<Duration> frameFilterSubject =
      BehaviorSubject<Duration>.seeded(Duration(seconds: 0));
  BehaviorSubject<KCurveType> kCurveTypeFilterSubject =
      BehaviorSubject<KCurveType>();

  Stream<List<Formation>> characterFormationsStream;
  Stream<List<Formation>> frameStream;
  Stream<Formation> editingFormationStream = Stream.empty();
  Stream<List<Offset>> editingKCurveStream;

  Character selectedCharacter = Character();
  Duration selectedTime;
  KCurveType selectedKCurveType;
  Formation editingFormation;
  int draggedPos = -1;
  int draggedPoint = -1;

  final programPainterSize = Size(640, 360);
  final kCurvePainterSize = Size(360, 360);

  FormationBloc(this.projectBloc, this.songBloc, this.lyricBloc,
      this.formationRepository, this.storageRepository)
      : assert(projectBloc != null),
        assert(songBloc != null),
        assert(lyricBloc != null),
        assert(formationRepository != null),
        assert(storageRepository != null),
        super(null) {
    lyricBlocSubscription = lyricBloc.listen((state) {
      if (state is LyricFetched) {
        lyrics = state.lyrics;
      }
    });
    projectBlocSubscription = projectBloc.listen((state) {
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
        (List<Formation> stream, Character filter) =>
            (filter.characterName == null)
                ? stream
                : stream
                    .where((formation) =>
                        formation.characterName == filter.characterName)
                    .toList()).asBroadcastStream();
    frameStream = Rx.combineLatest2(
        projectFormationsSubject,
        frameFilterSubject,
        (List<Formation> stream, Duration filter) => (filter.isNegative)
            ? stream
            : stream
                .where((formation) => formation.startTime == filter)
                .toList()).asBroadcastStream();
    editingFormationStream = Rx.combineLatest3(
        projectFormationsSubject,
        characterFilterSubject,
        frameFilterSubject,
        (List<Formation> stream, Character characterFilter,
                Duration frameFilter) =>
            stream
                .where((formation) =>
                    formation.characterName == characterFilter.characterName)
                .firstWhere((formation) =>
                    formation.startTime == frameFilter)).asBroadcastStream();
    editingKCurveStream = Rx.combineLatest2(
        editingFormationStream,
        kCurveTypeFilterSubject,
        (Formation formation, KCurveType kCurveType) => List.generate(
              2,
              (i) =>
                  formation.getFormationPoint(kCurveType, i, kCurvePainterSize),
            )).asBroadcastStream();
  }

  @override
  FormationState get initialState => FormationUninitialized();

  @override
  Stream<FormationState> mapEventToState(
    FormationEvent event,
  ) async* {
    if (event is FirstLoadFormation) {
      yield* mapReloadFormationToState();
    } else if (event is ReloadFormation) {
      print(event.toString());
      yield* mapReloadFormationToState();
    } else if (event is FinishFetchingFormation) {
      print(event.toString());
      yield FormationFetched(event.formations, event.characters);
    } else if (event is ChangeSliderValue) {
      yield* mapChangeSliderValueToState(event.sliderValue);
    } else if (event is ChangeTime) {
      yield* mapChangeTimeToState(event.startTime);
    } else if (event is ChangeCharacter) {
      yield* mapChangeCharacterToState(event.character);
    } else if (event is ChangeKCurveType) {
      yield* mapChangeKCurveTypeToState(event.kCurveType);
    } else if (event is PressAddFormation) {
      yield* mapPressAddFormationToState();
    } else if (event is PressDeleteFormation) {
      yield* mapPressDeleteFormationToState();
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

  Stream<FormationState> mapReloadFormationToState() async* {
    try {
      charactersSubject
          .add(Character.membersSortedByGrade(currentSong.subordinateKikaku));
      projectFormationsSubject.add(
          await formationRepository.fetchFormationsForProject(
              currentProject.songId, currentProject.formationVersion));
      // projectFormationsSubject.listen(
      //     (onData) => add(FinishedFetchingFormation(onData, characters)));
      lyricBloc.add(ReloadLyric());
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationState> mapChangeSliderValueToState(
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

  Stream<FormationState> mapChangeTimeToState(Duration startTime) async* {
    try {
      frameFilterSubject.add(startTime);
      print('Added to frameFilterSubject');
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationState> mapChangeCharacterToState(Character character) async* {
    try {
      selectedCharacter =
          (selectedCharacter.characterName == character.characterName)
              ? Character()
              : character;
      characterFilterSubject.add(selectedCharacter);
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationState> mapChangeKCurveTypeToState(
      KCurveType kCurveType) async* {
    try {
      kCurveTypeFilterSubject.add(kCurveType);
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationState> mapPressAddFormationToState() async* {
    try {
      // bool isExist = false;
      // characterFormationsStream.listen((onData) {
      //   for (Formation formation in onData) {
      //     if (formation.startTime == startTime) {
      //       isExist = true;
      //     }
      //   }
      // });
      // if (!isExist) {
      formationRepository.addFormation(Formation(
          songId: currentProject.songId,
          formationVersion: currentProject.formationVersion,
          characterName: selectedCharacter.characterName,
          memberColor: selectedCharacter.memberColor,
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
          curveY2Y: 127));
      add(ReloadFormation());
      // }
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationState> mapPressDeleteFormationToState() async* {
    try {
      formationRepository.deleteFormation(
          songId: currentProject.songId,
          formationVersion: currentProject.formationVersion,
          characterName: selectedCharacter.characterName,
          startTime: selectedTime);
      add(ReloadFormation());
    } catch (e) {
      print(e);
    }
  }

  Stream<FormationState> mapOnPanDownProgramToState(DragDownDetails details,
      List<Formation> frame, BuildContext context) async* {
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

  Stream<FormationState> mapOnPanUpdateProgramToState(DragUpdateDetails details,
      List<Formation> frame, BuildContext context) async* {
    final RenderBox renderBox = context.findRenderObject();
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    print('Pos:${localPos.dx},${localPos.dy}');
    if (draggedPos != -1) {
      frame[draggedPos].setFormationPos(localPos, programPainterSize);
    }
  }

  Stream<FormationState> mapOnPanEndProgramToState(DragEndDetails details,
      List<Formation> frame, BuildContext context) async* {
    print('OnPanEnd');
    if (draggedPos != -1) {
      frame[draggedPos].checkFormationPos();
      print('${frame[draggedPos].posX},${frame[draggedPos].posY}');
      await formationRepository.updateFormation(frame[draggedPos]);
    }
    add(ReloadFormation());
  }

  Stream<FormationState> mapOnPanDownKCurveToState(DragDownDetails details,
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

  Stream<FormationState> mapOnPanUpdateKCurveToState(DragUpdateDetails details,
      List<Offset> editingKCurve, BuildContext context) async* {
    final RenderBox renderBox = context.findRenderObject();
    final Offset localPos = renderBox.globalToLocal(details.globalPosition);
    if (draggedPoint != -1) {
      editingFormation.setFormationPoint(
          localPos, selectedKCurveType, draggedPoint, kCurvePainterSize);
      print('Point:${localPos.dx},${localPos.dy}');
    }
  }

  Stream<FormationState> mapOnPanEndKCurveToState(DragEndDetails details,
      List<Offset> editingKCurve, BuildContext context) async* {
    print('OnPanEnd');
    if (draggedPoint != -1) {
      editingFormation.checkFormationPoint(selectedKCurveType);
      print(
          '${editingFormation.curveX1X},${editingFormation.curveX1Y},${editingFormation.curveX2X},${editingFormation.curveX2Y}');
      print(
          '${editingFormation.curveY1X},${editingFormation.curveY1Y},${editingFormation.curveY2X},${editingFormation.curveY2Y}');
      await formationRepository.updateFormation(editingFormation);
      add(ReloadFormation());
    }
  }

  void dispose() {
    projectBlocSubscription.cancel();
    lyricBlocSubscription.cancel();
    currentSongSubscription.cancel();
    characterFilterSubject.close();
    frameFilterSubject.close();
    projectFormationsSubject.close();
    super.close();
  }
}
