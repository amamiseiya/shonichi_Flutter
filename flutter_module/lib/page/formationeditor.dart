import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/drawer.dart';
import '../widget/loading.dart';
import '../widget/error.dart';
import '../bloc/formation_bloc.dart';
import '../model/formation.dart';
import '../util/reg_exp.dart';

Future<Formation> formationEditorDialog(
    BuildContext context, Formation formation) {
  return showDialog(context: context, builder: (context) => Container());
}

class FormationEditorPage extends StatefulWidget {
  @override
  FormationEditorPageState createState() => FormationEditorPageState();
}

class FormationEditorPageState extends State<FormationEditorPage> {
  final GlobalKey<FormationEditorState> _formationEditorKey =
      GlobalKey<FormationEditorState>();
  FormationBloc formationBloc;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formationBloc = BlocProvider.of<FormationBloc>(context);
  }

  @override
  void dispose() {
    formationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('New FormationEditorPage created!');
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
        body: FormationEditor(key: _formationEditorKey),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Add', // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'addFAB',
              onPressed: () => formationBloc.add(PressAddFormation())),
          FloatingActionButton(
              tooltip: 'Edit', // used by assistive technologies
              child: Icon(Icons.edit),
              heroTag: 'editFAB',
              onPressed: () {}),
          FloatingActionButton(
              tooltip: 'Delete', // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'deleteFAB',
              onPressed: () => formationBloc.add(PressDeleteFormation())),
        ]));
  }
}

class FormationEditor extends StatefulWidget {
  FormationEditor({Key key}) : super(key: key);
  @override
  FormationEditorState createState() => FormationEditorState();
}

class FormationEditorState extends State<FormationEditor> {
  FormationBloc formationBloc;

  @override
  void initState() {
    formationBloc = BlocProvider.of<FormationBloc>(context);
    formationBloc.add(ReloadFormation());
    super.initState();
  }

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
                          width: formationBloc.programPainterSize.width,
                          height: formationBloc.programPainterSize.height,
                          child: StreamBuilder(
                              stream: formationBloc.frameStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ProgramAnimator(
                                      frame: snapshot.data,
                                      size: formationBloc.programPainterSize);
                                } else {
                                  return LoadingAnimationLinear();
                                }
                              })),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(
                                width: formationBloc.kCurvePainterSize.width,
                                height: formationBloc.kCurvePainterSize.height,
                                child: StreamBuilder(
                                    stream: formationBloc.editingKCurveStream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return GestureDetector(
                                            onPanDown: (details) =>
                                                formationBloc.add(
                                                    OnPanDownKCurve(
                                                        details,
                                                        snapshot.data,
                                                        context)),
                                            onPanUpdate: (details) =>
                                                formationBloc.add(
                                                    OnPanUpdateKCurve(
                                                        details,
                                                        snapshot.data,
                                                        context)),
                                            onPanEnd: (details) => formationBloc
                                                .add(OnPanEndKCurve(details,
                                                    snapshot.data, context)),
                                            child: CustomPaint(
                                              size: formationBloc
                                                  .kCurvePainterSize,
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
                                stream: formationBloc.characterFormationsStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return LoadingAnimationLinear();
                                  }
                                  return ListView(
                                      children: snapshot.data
                                          .map<Widget>((formation) => ListTile(
                                                selected: false,
                                                onTap: () => formationBloc.add(
                                                    ChangeTime(
                                                        formation.startTime)),
                                                leading: CircleAvatar(
                                                    backgroundColor:
                                                        formation.memberColor,
                                                    child: Text(RegExp(
                                                            r'(?<= ).+')
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

class TimeSlider extends StatefulWidget {
  @override
  _TimeSliderState createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  FormationBloc formationBloc;

  @override
  void initState() {
    formationBloc = BlocProvider.of<FormationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: formationBloc.frameFilterSubject,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          double sliderValue = snapshot.data.inMilliseconds.toDouble();
          return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                //   thumbShape: PaddleSliderValueIndicatorShape(),
                thumbColor: Colors.pink,
              ),
              child: Slider(
                value: (formationBloc.lyrics != null) ? sliderValue : 0.0,
                // label: 'yeah tiger',
                // value: currentTime.inSeconds.toDouble(),
                min: 0.0,
                max: (formationBloc.lyrics != null)
                    ? formationBloc.lyrics.last.endTime.inMilliseconds
                        .toDouble()
                    : 1.0,
                divisions: (formationBloc.lyrics != null)
                    ? formationBloc.lyrics.last.endTime.inMilliseconds ~/ 100
                    : null,
                onChanged: (value) {
                  setState(() => sliderValue = value);
                  print(sliderValue);
                },
                onChangeEnd: (value) =>
                    formationBloc.add(ChangeSliderValue(value)),
              ));
        } else {
          return LoadingAnimationLinear();
        }
      });
}

class CharacterFilterButton extends StatefulWidget {
  @override
  _CharacterFilterButtonState createState() => _CharacterFilterButtonState();
}

class _CharacterFilterButtonState extends State<CharacterFilterButton> {
  FormationBloc formationBloc;

  @override
  void initState() {
    formationBloc = BlocProvider.of<FormationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: formationBloc.charactersSubject,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Wrap(
            children: snapshot.data
                .map<Widget>((character) => FlatButton(
                      color: (formationBloc.selectedCharacter.characterName ==
                              character.characterName)
                          ? Colors.blueAccent.shade100
                          : Colors.grey.shade300,
                      onPressed: () => setState(
                          () => formationBloc.add(ChangeCharacter(character))),
                      child: Text(character.characterName),
                    ))
                .toList(),
          );
        } else {
          return LoadingAnimationLinear();
        }
      });
}

class ProgramAnimator extends StatefulWidget {
  final List<Formation> frame;
  final Size size;
  ProgramAnimator({Key key, this.frame, this.size}) : super(key: key);
  @override
  _ProgramAnimatorState createState() => _ProgramAnimatorState(frame, size);
}

class _ProgramAnimatorState extends State<ProgramAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  FormationBloc formationBloc;
  final List<Formation> frame;
  final Size size;

  _ProgramAnimatorState(this.frame, this.size);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController();
    formationBloc = BlocProvider.of<FormationBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanDown: (details) =>
            formationBloc.add(OnPanDownProgram(details, frame, context)),
        onPanUpdate: (details) =>
            formationBloc.add(OnPanUpdateProgram(details, frame, context)),
        onPanEnd: (details) =>
            formationBloc.add(OnPanEndProgram(details, frame, context)),
        child: CustomPaint(
          size: size,
          painter: ProgramPainter(frame),
        ));
  }
}

class ProgramPainter extends CustomPainter {
  final List<Formation> frame;
  ProgramPainter(this.frame);

  @override
  void paint(Canvas canvas, Size size) {
    for (Formation characterFormation in frame) {
      canvas.drawCircle(
          characterFormation.getFormationPos(size),
          20,
          Paint()
            ..isAntiAlias = !true
            ..color = characterFormation.memberColor
            ..strokeWidth = 5
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(ProgramPainter oldDelegate) => frame != oldDelegate.frame;
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

class KCurveFilterButton extends StatefulWidget {
  @override
  _KCurveFilterButtonState createState() => _KCurveFilterButtonState();
}

class _KCurveFilterButtonState extends State<KCurveFilterButton> {
  FormationBloc formationBloc;

  @override
  void initState() {
    formationBloc = BlocProvider.of<FormationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      width: 200,
      height: 40,
      child: Row(children: <Widget>[
        FlatButton(
            color: (formationBloc.selectedKCurveType == KCurveType.X)
                ? Colors.blueAccent.shade100
                : Colors.grey.shade300,
            onPressed: () => setState(
                () => formationBloc.add(ChangeKCurveType(KCurveType.X))),
            child: Text('X')),
        FlatButton(
            color: (formationBloc.selectedKCurveType == KCurveType.Y)
                ? Colors.blueAccent.shade100
                : Colors.grey.shade300,
            onPressed: () => setState(
                () => formationBloc.add(ChangeKCurveType(KCurveType.Y))),
            child: Text('Y')),
      ]));
}
