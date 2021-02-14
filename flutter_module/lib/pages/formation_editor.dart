import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';
import '../controllers/lyric.dart';
import '../controllers/formation_table.dart';
import '../controllers/formation.dart';
import '../models/formation_table.dart';
import '../models/formation.dart';
import '../models/character.dart';
import '../utils/reg_exp.dart';

class FormationEditorPage extends GetView<FormationController> {
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
          Future.delayed(Duration(seconds: 1))
              .then((_) => controller.retrieveFormationsForTable());
          print('New FormationEditorPage created!');
        }, builder: (_) {
          if (controller.formationsForTable.value == null) {
            return LoadingAnimationLinear();
          } else {
            return FormationEditor();
          }
        }),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Create'.tr, // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'CreateFAB',
              onPressed: () => controller.create()),
          FloatingActionButton(
              tooltip: 'Update'.tr, // used by assistive technologies
              child: Icon(Icons.edit),
              heroTag: 'UpdateFAB',
              onPressed: () {}),
          FloatingActionButton(
              tooltip: 'Delete'.tr, // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'DeleteFAB',
              onPressed: () => controller.delete()),
        ]));
  }
}

class FormationEditor extends GetView<FormationController> {
  @override
  Widget build(BuildContext context) {
    print('New FormationEditor rebuilded!');
    return FractionallySizedBox(
      alignment: Alignment.center,
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: Card(
          margin: EdgeInsets.all(10.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Column(children: [
            TimeSlider(),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CharacterFilterButton(),
                      SizedBox(
                          width: controller.programPainterSize.width,
                          height: controller.programPainterSize.height,
                          child: StreamBuilder(
                              stream: controller.formationsForTime.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ProgramAnimator(
                                      formationsForTime: snapshot.data,
                                      size: controller.programPainterSize);
                                } else {
                                  return LoadingAnimationLinear();
                                }
                              })),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(
                                width: controller.kCurvePainterSize.width,
                                height: controller.kCurvePainterSize.height,
                                child: StreamBuilder(
                                    stream: controller.editingKCurve.stream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return GestureDetector(
                                            onPanDown: (details) =>
                                                controller.onPanDownKCurve(
                                                    details,
                                                    snapshot.data,
                                                    context),
                                            onPanUpdate: (details) =>
                                                controller.onPanUpdateKCurve(
                                                    details,
                                                    snapshot.data,
                                                    context),
                                            onPanEnd: (details) =>
                                                controller.onPanEndKCurve(
                                                    details,
                                                    snapshot.data,
                                                    context),
                                            child: CustomPaint(
                                              size:
                                                  controller.kCurvePainterSize,
                                              painter:
                                                  KCurvePainter(snapshot.data),
                                            ));
                                      } else {
                                        return LoadingAnimationLinear();
                                      }
                                    })),
                            KCurveFilterButton()
                          ]),
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
                            height: MediaQuery.of(context).size.height / 2,
                            child: StreamBuilder(
                                stream:
                                    controller.formationsForCharacter.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return LoadingAnimationLinear();
                                  }
                                  return ListView(
                                      children: snapshot.data
                                          .map<Widget>((formation) => ListTile(
                                                selected: false,
                                                onTap: () =>
                                                    controller.changeTime(
                                                        formation.startTime),
                                                leading: CircleAvatar(
                                                    backgroundColor: SNCharacter
                                                            .fromString(formation
                                                                .characterName)
                                                        .memberColor,
                                                    child: Text(
                                                        characterNameFirstNameRegExp
                                                            .stringMatch(formation
                                                                .characterName))),
                                                title: Text(simpleDurationRegExp
                                                    .stringMatch(formation
                                                        .startTime
                                                        .toString())),
                                                subtitle: Text(formation.posX
                                                        .toString() +
                                                    ' , ' +
                                                    formation.posY.toString()),
                                              ))
                                          .toList());
                                }),
                          )
                        ]))
              ],
            )
          ])),
    );
  }
}

class TimeSlider extends GetView<FormationController> {
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
                        ? lyricController.lyrics.last.endTime.inMilliseconds
                            .toDouble()
                        : 1.0,
                    divisions: (lyricController.lyrics.value != null)
                        ? lyricController.lyrics.last.endTime.inMilliseconds ~/
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

class CharacterFilterButton extends GetView<FormationController> {
  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: controller.characters.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Wrap(
            children: snapshot.data
                .map<Widget>((character) => Obx(() => FlatButton(
                      color: (controller.characterFilter.value.name ==
                              character.name)
                          ? Colors.blueAccent.shade100
                          : Colors.grey.shade300,
                      onPressed: () => controller.changeCharacter(character),
                      child: Text(characterNameFirstNameRegExp
                          .stringMatch(character.name)),
                    )))
                .toList(),
          );
        } else {
          return LoadingAnimationLinear();
        }
      });
}

class KCurveFilterButton extends GetView<FormationController> {
  @override
  Widget build(BuildContext context) => SizedBox(
      child: Obx(() => Column(
          children: KCurveType.values
              .sublist(0, 2)
              .map<Widget>((type) => FlatButton(
                  color: (controller.kCurveTypeFilter.value == type)
                      ? Colors.blueAccent.shade100
                      : Colors.grey.shade300,
                  onPressed: () => controller.changeKCurveType(type),
                  child: Text(type.toString())))
              .toList())));
}

class ProgramAnimator extends StatefulWidget {
  final List<SNFormation> formationsForTime;
  final Size size;
  ProgramAnimator({this.formationsForTime, this.size});
  @override
  _ProgramAnimatorState createState() => _ProgramAnimatorState();
}

class _ProgramAnimatorState extends State<ProgramAnimator>
    with SingleTickerProviderStateMixin {
  final FormationController formationController = Get.find();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanDown: (details) => formationController.onPanDownProgram(
            details, widget.formationsForTime, context),
        onPanUpdate: (details) => formationController.onPanUpdateProgram(
            details, widget.formationsForTime, context),
        onPanEnd: (details) => formationController.onPanEndProgram(
            details, widget.formationsForTime, context),
        child: CustomPaint(
          size: widget.size,
          painter: ProgramPainter(widget.formationsForTime),
        ));
  }
}

//! 在Size不够的情况下会有问题
class ProgramPainter extends CustomPainter {
  final List<SNFormation> formationsForTime;
  ProgramPainter(this.formationsForTime);

  @override
  void paint(Canvas canvas, Size size) {
    for (SNFormation characterFormation in formationsForTime) {
      canvas.drawCircle(
          characterFormation.getFormationPos(size),
          20,
          Paint()
            ..isAntiAlias = !true
            ..color = SNCharacter.fromString(characterFormation.characterName)
                .memberColor
            ..strokeWidth = 5
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(ProgramPainter oldDelegate) =>
      formationsForTime != oldDelegate.formationsForTime;
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
                Offset(0.0, size.height) * pow(1 - index * 0.02, 3) +
                editingKCurve[0] *
                    3 *
                    (index * 0.02) *
                    pow(1 - index * 0.02, 2) +
                editingKCurve[1] *
                    3 *
                    pow(index * 0.02, 2) *
                    (1 - index * 0.02) +
                Offset(size.width, 0.0) * pow(index * 0.02, 3)),
        Paint()
          ..isAntiAlias = !true
          ..strokeWidth = 5
          ..color = Colors.blueAccent.shade200
          ..style = PaintingStyle.stroke);

    // canvas.drawPath(
    //     Path()
    //       ..moveTo(0.0, size.height)
    //       ..quadraticBezierTo(getFormationPoint1(formation, size).dx,
    //           getFormationPoint1(formation, size).dy, size.width, 0.0),
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

class FormationTableUpsertDialog extends GetView<FormationTableController> {
  // 在dialog最终pop时才给对象赋值，不确定这样的方式是否合适

  SNFormationTable ft;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  FormationTableUpsertDialog(SNFormationTable formationTable) {
    ft = formationTable ?? SNFormationTable.initialValue();
    _nameController.text = ft.name;
    _descriptionController.text = ft.description;
  }

  Widget build(BuildContext context) => SimpleDialog(
        title: Text('FormationTable upsert dialog'),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Form(
                    child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        InputDecoration(hintText: 'Input formationTable name'),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Input formationTable description'),
                    onEditingComplete: () {},
                  ),
                ])),
                SimpleDialogOption(
                  onPressed: () {
                    controller.delete(ft); // ! formationTable could be null
                    Get.back();
                  },
                  child: Text('Delete'.tr),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    ft.name = _nameController.text;
                    ft.description = _descriptionController.text;
                    Get.back(result: ft);
                  },
                  child: Text('Submit'.tr),
                ),
              ]))
        ],
      );
}
