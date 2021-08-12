part of 'formation.dart';

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
                                        .map<Widget>((SNMove move) => ListTile(
                                              selected: false,
                                              onTap: () => controller
                                                  .changeTime(move.startTime),
                                              leading: CircleAvatar(
                                                  backgroundColor: move
                                                      .character.memberColor,
                                                  child: Text(
                                                      characterNameFirstNameRegExp
                                                          .stringMatch(move
                                                              .character
                                                              .name)!)),
                                              title: Text(simpleDurationRegExp
                                                  .stringMatch(move.startTime
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
                            primary:
                                (moveController.characterFilter.value?.name ==
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
          characterMove.getMovePos(moveController.programPainterSize),
          20,
          Paint()
            ..color = characterMove.character.memberColor!
            ..strokeWidth = 5
            ..style = PaintingStyle.stroke);
    }
    canvas.drawRect(
        Rect.fromLTWH(0, 0, 480, 270),
        Paint()
          ..color = Colors.blueAccent.shade100
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke);
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

    canvas.drawRect(
        Rect.fromLTWH(0, 0, 270, 270),
        Paint()
          ..color = Colors.blueAccent.shade100
          ..strokeWidth = 3
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
