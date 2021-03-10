import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';
import '../controllers/character.dart';
import '../controllers/lyric.dart';
import '../controllers/formation.dart';
import '../controllers/move.dart';
import '../models/formation.dart';
import '../models/move.dart';
import '../models/character.dart';
import '../utils/reg_exp.dart';

class FormationPage extends StatelessWidget {
  final FormationController formationController = Get.find();
  final MoveController moveController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   tooltip: 'Navigation menu',
          //   onPressed: () => Scaffold.of(context).openDrawer(),
          // ),
          title: Text('舞蹈队形编辑'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: null,
            ),
          ],
        ),
        drawer: MyDrawer(),
        // body is the majority of the screen.
        body: GetX(initState: (_) {
          formationController.retrieve();
        }, builder: (_) {
          if (formationController.formationsForSong.value == null) {
            return LoadingAnimationLinear();
          }
          if (formationController.formationsForSong.value!.isEmpty) {
            return _EmptyFormationPage();
          }
          return Column(children: [
            _FormationChipSelector(),
            Obx(() {
              if (moveController.movesForFormation.value == null) {
                return LoadingAnimationLinear();
              }
              if (moveController.movesForFormation.value!.isEmpty) {
                // return _EmptyMovePage();
              }
              return MoveEditor();
            })
          ]);
        }),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Create'.tr, // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'CreateFAB',
              onPressed: () => moveController.create()),
          FloatingActionButton(
              tooltip: 'Update'.tr, // used by assistive technologies
              child: Icon(Icons.edit),
              heroTag: 'UpdateFAB',
              onPressed: () {}),
          FloatingActionButton(
              tooltip: 'Delete'.tr, // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'DeleteFAB',
              onPressed: () => moveController.delete()),
        ]));
  }
}

class _EmptyFormationPage extends GetView<FormationController> {
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Empty Formation Page'),
      ElevatedButton(
        child: Text('Create new'.tr),
        onPressed: () => Get.dialog(_FormationUpsertDialog(null))
            .then((formation) => controller.submitCreate(formation)),
      )
    ]);
  }
}

class _FormationChipSelector extends GetView<FormationController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
              child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.formationsForSong.value!.length,
            itemBuilder: (BuildContext context, int index) {
              return Obx(() => ChoiceChip(
                    label:
                        Text(controller.formationsForSong.value![index].name),
                    tooltip: '',
                    selected: controller.editingFormation.value?.id ==
                        controller.formationsForSong.value![index].id,
                    selectedColor: Colors.orange.shade100,
                    onSelected: (_) => controller
                        .select(controller.formationsForSong.value![index].id),
                  ));
            },
          )),
          Flexible(
              child: Row(children: [
            ActionChip(
              label: Icon(Icons.add),
              tooltip: '',
              onPressed: () => Get.dialog(_FormationUpsertDialog(null))
                  .then((formation) => controller.submitCreate(formation)),
            ),
            ActionChip(
              label: Icon(Icons.edit),
              tooltip: '',
              onPressed: () => Get.dialog(
                      _FormationUpsertDialog(controller.editingFormation.value))
                  .then((formation) => controller.submitUpdate(formation)),
            ),
            ActionChip(
              label: Icon(Icons.delete),
              tooltip: '',
              onPressed: () =>
                  Get.dialog(_ConfirmDeleteDialog()).then((confirm) {
                if (confirm == null || confirm! == false) {
                  return;
                }
                if (confirm! == true) {
                  controller.delete(controller.editingFormation.value);
                }
              }),
            ),
          ]))
        ]));
  }
}

class _FormationUpsertDialog extends GetView<FormationController> {
  // 在dialog最终pop时才给对象赋值，不确定这样的方式是否合适

  late SNFormation f;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  _FormationUpsertDialog(SNFormation? formation) {
    f = formation ?? SNFormation.initialValue();
    _nameController.text = f.name;
    _descriptionController.text = f.description;
  }

  Widget build(BuildContext context) => SimpleDialog(
        title: Text('Formation upsert dialog'),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Form(
                    child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        InputDecoration(labelText: 'Input formation name'),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Input formation description'),
                    onEditingComplete: () {},
                  ),
                ])),
                SimpleDialogOption(
                  onPressed: () {
                    controller.delete(f); // ! formation could be null
                    Get.back();
                  },
                  child: Text('Delete'.tr),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    f.name = _nameController.text;
                    f.description = _descriptionController.text;
                    Get.back(result: f);
                  },
                  child: Text('Submit'.tr),
                ),
              ]))
        ],
      );
}

class _ConfirmDeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Text(
            'Are you sure that you want to delete this formation? All moves will be deleted as well!'
                .tr),
      ),
      actions: [
        ElevatedButton(
            child: Text('Cancel'.tr), onPressed: () => Get.back(result: false)),
        ElevatedButton(
            child: Text('OK'.tr), onPressed: () => Get.back(result: true))
      ],
    );
  }
}

class MoveEditor extends GetView<MoveController> {
  @override
  Widget build(BuildContext context) {
    print('New MoveEditor rebuilded!');
    return Card(
        margin: EdgeInsets.all(10.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(children: [
          TimeSlider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CharacterFilterButton(),
                    KCurveFilterButton(),
                    SizedBox(
                        width: controller.programPainterSize.width,
                        height: controller.programPainterSize.height,
                        child: StreamBuilder(
                            stream: controller.movesForTime.stream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return ProgramAnimator(
                                    movesForTime: snapshot.data,
                                    size: controller.programPainterSize);
                              } else {
                                return LoadingAnimationLinear();
                              }
                            })),
                    StreamBuilder(
                        stream: controller.editingKCurve.stream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return GestureDetector(
                                onPanDown: (details) =>
                                    controller.onPanDownKCurve(
                                        details, snapshot.data, context),
                                onPanUpdate: (details) =>
                                    controller.onPanUpdateKCurve(
                                        details, snapshot.data, context),
                                onPanEnd: (details) =>
                                    controller.onPanEndKCurve(
                                        details, snapshot.data, context),
                                child: CustomPaint(
                                  size: controller.kCurvePainterSize,
                                  painter: KCurvePainter(snapshot.data),
                                ));
                          } else {
                            return LoadingAnimationLinear();
                          }
                        }),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('sliderValue:' + sliderValue.toString()),
                        // Text('sliderTime:' + sliderTime.toString()),
                        SizedBox(
                          // width:MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 50,
                          child: StreamBuilder(
                              stream: controller.movesForCharacter.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return LoadingAnimationLinear();
                                }
                                return ListView(
                                    children: snapshot.data
                                        .map<Widget>((SNMove move) =>
                                            ListTile(
                                              selected: false,
                                              onTap: () =>
                                                  controller.changeTime(
                                                      move.startTime),
                                              leading: CircleAvatar(
                                                  backgroundColor: move
                                                      .character.memberColor,
                                                  child: Text(
                                                      characterNameFirstNameRegExp
                                                          .stringMatch(move
                                                              .character
                                                              .name)!)),
                                              title: Text(simpleDurationRegExp
                                                  .stringMatch(move
                                                      .startTime
                                                      .toString())!),
                                              subtitle: Text(
                                                  move.posX.toString() +
                                                      ' , ' +
                                                      move.posY.toString()),
                                            ))
                                        .toList());
                              }),
                        )
                      ]))
            ],
          )
        ]));
  }
}

class _EmptyMovePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Text('Empty Move Page');
  }
}

class TimeSlider extends GetView<MoveController> {
  final LyricController lyricController = Get.find();

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: controller.timeFilter.stream,
      initialData: Duration(seconds: 0),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          double sliderValue = snapshot.data.inMilliseconds.toDouble();
          return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                //   thumbShape: PaddleSliderValueIndicatorShape(),
                thumbColor: Colors.pink,
              ),
              child: Obx(() => Slider(
                    value: (lyricController.lyrics.value != null)
                        ? sliderValue
                        : 0.0,
                    // label: 'yeah tiger',
                    // value: currentTime.inSeconds.toDouble(),
                    min: 0.0,
                    max: (lyricController.lyrics.value != null)
                        ? lyricController
                            .lyrics.value!.last.endTime.inMilliseconds
                            .toDouble()
                        : 1.0,
                    divisions: (lyricController.lyrics.value != null)
                        ? lyricController
                                .lyrics.value!.last.endTime.inMilliseconds ~/
                            100
                        : null,
                    onChanged: (value) {
                      sliderValue = value;
                      print(sliderValue);
                    },
                    onChangeEnd: (value) => controller.changeSliderValue(value),
                  )));
        } else {
          return Column(
              children: [LoadingAnimationLinear(), Text('TimeSlider')]);
        }
      });
}

class CharacterFilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      GetX<CharacterController>(builder: (characterController) {
        if (characterController.editingCharacters.value == null) {
          return LoadingAnimationLinear();
        }
        if (characterController.editingCharacters.value!.isEmpty) {}
        return Wrap(
          children: characterController.editingCharacters.value!
              .map<Widget>((character) => GetX<MoveController>(
                  builder: (moveController) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: (moveController
                                        .characterFilter.value?.name ==
                                    character.name)
                                ? Colors.blueAccent.shade100
                                : Colors.grey.shade300),
                        onPressed: () =>
                            moveController.changeCharacter(character),
                        child: Text(characterNameFirstNameRegExp
                            .stringMatch(character.name)!),
                      )))
              .toList(),
        );
      });
}

class KCurveFilterButton extends GetView<MoveController> {
  @override
  Widget build(BuildContext context) => Obx(() => Column(
      children: KCurveType.values
          .sublist(0, 2)
          .map<Widget>((type) => TextButton(
              style: ElevatedButton.styleFrom(
                  onPrimary: (controller.kCurveTypeFilter.value == type)
                      ? Colors.blueAccent.shade100
                      : Colors.grey.shade300),
              onPressed: () => controller.changeKCurveType(type),
              child: Text(type.toString())))
          .toList()));
}

class ProgramAnimator extends StatefulWidget {
  final List<SNMove> movesForTime;
  final Size size;
  ProgramAnimator({required this.movesForTime, required this.size});
  @override
  _ProgramAnimatorState createState() => _ProgramAnimatorState();
}

class _ProgramAnimatorState extends State<ProgramAnimator>
    with SingleTickerProviderStateMixin {
  final MoveController moveController = Get.find();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanDown: (details) => moveController.onPanDownProgram(
            details, widget.movesForTime, context),
        onPanUpdate: (details) => moveController.onPanUpdateProgram(
            details, widget.movesForTime, context),
        onPanEnd: (details) => moveController.onPanEndProgram(
            details, widget.movesForTime, context),
        child: CustomPaint(
          size: widget.size,
          painter: ProgramPainter(widget.movesForTime),
        ));
  }
}

class ProgramPainter extends CustomPainter {
  final MoveController moveController = Get.find();
  final List<SNMove> movesForTime;
  ProgramPainter(this.movesForTime);

  @override
  void paint(Canvas canvas, Size size) {
    for (SNMove characterMove in movesForTime) {
      canvas.drawCircle(
          characterMove
              .getMovePos(moveController.programPainterSize),
          20,
          Paint()
            ..color = characterMove.character.memberColor!
            ..strokeWidth = 5
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(ProgramPainter oldDelegate) =>
      movesForTime != oldDelegate.movesForTime;
}

class KCurvePainter extends CustomPainter {
  final List<Offset> editingKCurve;
  KCurvePainter(this.editingKCurve)
      : assert(editingKCurve != null),
        assert(editingKCurve[0] != null),
        assert(editingKCurve[1] != null);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(
        PointMode.points,
        editingKCurve.sublist(0, 1),
        Paint()
          ..isAntiAlias = !true
          ..strokeWidth = 10
          ..color = Colors.orange
          ..style = PaintingStyle.stroke);
    canvas.drawPoints(
        PointMode.points,
        editingKCurve.sublist(1, 2),
        Paint()
          ..isAntiAlias = !true
          ..strokeWidth = 10
          ..color = Colors.green
          ..style = PaintingStyle.stroke);

    canvas.drawPoints(
        PointMode.lines,
        List.generate(
            50,
            (int index) =>
                Offset(0.0, size.height) * pow(1 - index * 0.02, 3).toDouble() +
                editingKCurve[0] *
                    3 *
                    (index * 0.02) *
                    pow(1 - index * 0.02, 2).toDouble() +
                editingKCurve[1] *
                    3 *
                    pow(index * 0.02, 2).toDouble() *
                    (1 - index * 0.02) +
                Offset(size.width, 0.0) * pow(index * 0.02, 3).toDouble()),
        Paint()
          ..isAntiAlias = !true
          ..strokeWidth = 5
          ..color = Colors.blueAccent.shade200
          ..style = PaintingStyle.stroke);

    // canvas.drawPath(
    //     Path()
    //       ..moveTo(0.0, size.height)
    //       ..quadraticBezierTo(getMovePoint1(move, size).dx,
    //           getMovePoint1(move, size).dy, size.width, 0.0),
    //     Paint()
    //       ..isAntiAlias = !true
    //       ..color = Colors.blueAccent.shade400
    //       ..strokeWidth = 5
    //       ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(KCurvePainter oldDelegate) =>
      oldDelegate.editingKCurve != editingKCurve;
}
