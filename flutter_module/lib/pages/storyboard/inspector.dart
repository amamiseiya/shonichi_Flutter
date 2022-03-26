part of 'storyboard.dart';

class ShotInspector extends StatelessWidget {
  final ProjectController projectController = Get.find();
  final SongController songController = Get.find();
  final LyricController lyricController = Get.find();
  final ShotController shotController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height - 24 - 56 - 56,
        padding: EdgeInsets.all(10.0),
        child: ListView(children: <Widget>[
          Obx(() {
            if (songController.editingSong.value == null) {
              return Container();
            }
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('当前企划：'),
                  Text(songController.editingSong.value!.subordinateKikaku),
                  Text('当前成员镜头数量：'),
                ]);
          }),
          StreamBuilder(
              stream: shotController.statisticsStream,
              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: snapshot.data!.entries
                          .map<Widget>(
                              (entry) => Text('${entry.key}: ${entry.value}'))
                          .toList());
                } else {
                  return Container();
                }
              }),
          Obx(() {
            if (shotController.coverageStream.value == null ||
                shotController.coverageStream.value!.isEmpty) {
              return Container();
            }
            return LyricAnimator();
          }),
        ]));
  }
}

class LyricAnimator extends StatefulWidget {
  final ShotController shotController = Get.find();
  final LyricController lyricController = Get.find();

  @override
  _LyricAnimatorState createState() => _LyricAnimatorState();
}

class _LyricAnimatorState extends State<LyricAnimator>
    with TickerProviderStateMixin {
  //我参考的这个代码，似乎每次都会创建一个新的Controller，这样做真的好吗？

  final lyricPainterSize = Size(250, 600);
  AnimationController? _lyricOffsetYController;
  late LyricPainter _lyricPainter;
  int currentShotTime = 0;

  @override
  void initState() {
    super.initState();
    _lyricPainter = LyricPainter(
        widget.shotController.coverageStream.value!, currentShotTime);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: lyricPainterSize.width,
        height: lyricPainterSize.height,
        child: GestureDetector(
            onVerticalDragUpdate: (details) {
              _lyricPainter.offsetYBegin += details.delta.dy;
            },
            child:
            CustomPaint(painter: _lyricPainter, size: lyricPainterSize)));
  }

  /// 开始下一行动画
  void startAnimation(int currentShotTime) {
    // 判断当前行和 customPaint 里的当前行是否一致，不一致才做动画
    if (_lyricPainter.currentShotTime != currentShotTime) {
      // 如果动画控制器不是空，那么则证明上次的动画未完成，
      // 未完成的情况下直接 stop 当前动画，做下一次的动画
      if (_lyricOffsetYController != null) {
        _lyricOffsetYController!.stop();
      }

      // 初始化动画控制器，切换歌词时间为300ms，并且添加状态监听，
      // 如果为 completed，则消除掉当前controller，并且置为空。
      _lyricOffsetYController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 300))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _lyricOffsetYController!.dispose();
            _lyricOffsetYController = null;
          }
        });
      // 计算出来当前行的偏移量
      // 起始为当前偏移量，结束点为计算出来的偏移量
      Animation animation = Tween<double>(
          begin: _lyricPainter.offsetYBegin,
          end: _lyricPainter.getOffsetYEnd(currentShotTime) * -1)
          .animate(_lyricOffsetYController!);
      // 添加监听，在动画做效果的时候给 offsetY 赋值
      _lyricOffsetYController!.addListener(() {
        _lyricPainter.offsetYBegin = animation.value;
      });
      // 启动动画
      _lyricOffsetYController!.forward();
      // 给 customPaint 赋值当前行
      _lyricPainter.currentShotTime = currentShotTime;
    }
  }
}

class LyricPainter extends CustomPainter {
  final double lyricSpacing = 20.0;

  List<Map<String, dynamic>> lyricMaps;
  int currentShotTime;

  List<TextPainter> lyricPaints = [];
  double offsetYBegin = 0.0;

  // TextStyle
  final TextStyle normalTextStyle = TextStyle(
    color: Colors.black,
  );
  final TextStyle covered1TextStyle =
  TextStyle(color: Colors.black, backgroundColor: Colors.blue.shade200);
  final TextStyle covered2TextStyle =
  TextStyle(color: Colors.black, backgroundColor: Colors.blue.shade200);
  final TextStyle currentTextStyle = TextStyle(
    color: Colors.grey.shade600,
  );

  LyricPainter(this.lyricMaps, this.currentShotTime) {
    lyricPaints.addAll(lyricMaps
        .map((lyricMap) => TextPainter(
        text: TextSpan(text: lyricMap['lyricText'], style: normalTextStyle),
        textDirection: TextDirection.ltr))
        .toList());
    for (TextPainter lp in lyricPaints) {
      lp.layout();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double y = offsetYBegin + size.height / 2 + lyricPaints[0].height / 2;
    for (int i = 0; i < lyricMaps.length; i++) {
      if (y > size.height || y < (0 - lyricPaints[i].height / 2)) {
      } else {
        if (currentShotTime == lyricMaps[i]['lyricTime']) {
          lyricPaints[i].text = TextSpan(
              text: lyricMaps[i]['lyricText'], style: currentTextStyle);
          lyricPaints[i].layout();
        } else if (lyricMaps[i]['coverageCount'] == 0) {
          lyricPaints[i].text =
              TextSpan(text: lyricMaps[i]['lyricText'], style: normalTextStyle);
          lyricPaints[i].layout();
        } else if (lyricMaps[i]['coverageCount'] == 1) {
          lyricPaints[i].text = TextSpan(
              text: lyricMaps[i]['lyricText'], style: covered1TextStyle);
          lyricPaints[i].layout();
        } else if (lyricMaps[i]['coverageCount'] >= 2) {
          lyricPaints[i].text = TextSpan(
              text: lyricMaps[i]['lyricText'], style: covered2TextStyle);
          lyricPaints[i].layout();
        }
        lyricPaints[i].paint(
          canvas,
          Offset((size.width - lyricPaints[i].width) / 2, y),
        );
      }
      // 计算偏移量
      y += lyricPaints[i].height + lyricSpacing;
    }
  }

  double getOffsetYEnd(int currentShotTime) {
    int currentLine = 0;
    for (int i = 0; i < lyricMaps.length; i++) {
      if (currentShotTime == lyricMaps[i]['lyricTime']) {
        currentLine = i;
        break;
      }
    }
    return (lyricPaints[0].height + lyricSpacing) * (currentLine + 1);
  }

  bool shouldRepaint(LyricPainter oldDelegate) =>
      oldDelegate.offsetYBegin != offsetYBegin;
}

class _ShotFilterPanel extends StatelessWidget {
  final ShotController shotController = Get.find();
  final SongController songController = Get.find();
  final LyricController lyricController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
        child: Column(
          children: <Widget>[
            Divider(),
            Text('数据表格处理菜单'),
            ElevatedButton(
                onPressed: () => lyricController.retrieveForEditingSong(),
                child: Text('刷新歌词')),
            Obx(() {
              // assert(songController.editingSong.value != null);
              return SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: Colors.pink,
                  ),
                  child: Slider(
                      value: (shotController.editingShotIndex.value != null)
                          ? shotController
                          .shots
                          .value![shotController.editingShotIndex.value!]
                          .startTime!
                          .inMilliseconds /
                          songController
                              .editingSong.value!.duration.inMilliseconds
                          : 0,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (value) {
                        print(value);
                      },
                      onChangeEnd: (value) {
                        shotController.selectShot(value);
                      } // editingShotIndex focus on
                  ));
            }),
          ],
        ));
  }
}