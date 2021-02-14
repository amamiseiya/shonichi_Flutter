import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../widgets/character_selector.dart';
import '../models/shot_table.dart';
import '../models/shot.dart';
import '../models/character.dart';
import '../controllers/project.dart';
import '../controllers/song.dart';
import '../controllers/lyric.dart';
import '../controllers/shot_table.dart';
import '../controllers/shot.dart';
import '../utils/reg_exp.dart';
import '../utils/data_convert.dart';

class ShotEditorPage extends StatelessWidget {
  final ShotTableController shotTableController = Get.find();
  final ShotController shotController = Get.find();
  final SongController songController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   tooltip: 'Navigation menu',
          //   onPressed: () => Scaffold.of(context).openDrawer(),
          // ),
          title: Text('Shot Editor'.tr),
          actions: <Widget>[],
        ),
        drawer: MyDrawer(),
        // body is the majority of the screen.
        body: SlidingUpPanel(
            panel: _ShotFilterPanel(),
            body: GetX(
                initState: (_) async => await shotTableController.retrieve(),
                builder: (_) {
                  if (shotTableController.shotTablesForSong.value == null) {
                    return LoadingAnimationLinear();
                  }
                  if (shotTableController.shotTablesForSong.value.isEmpty) {}
                  return Column(children: [
                    Container(
                      height: 40,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: shotTableController.shotTablesForSong.value
                                  .map((st) => ActionChip(
                                        label: Text(st.name),
                                        onPressed: () =>
                                            shotTableController.select(st.id),
                                      ))
                                  .toList() +
                              [
                                ActionChip(
                                  label: Icon(Icons.add),
                                  onPressed: () =>
                                      Get.dialog(ShotTableUpsertDialog(null))
                                          .then((shotTable) =>
                                              shotTableController
                                                  .submitCreate(shotTable)),
                                )
                              ]),
                    ),
                    Obx(() {
                      if (shotController.shots.value != null) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ShotDataTable(),
                              ),
                              Expanded(
                                flex: 1,
                                child: ShotInspector(),
                              )
                            ]);
                      } else {
                        return LoadingAnimationLinear();
                      }
                    })
                  ]);
                })),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Create'.tr, // used by assistive technologies
            child: Icon(Icons.add),
            heroTag: 'CreateFAB',
            onPressed: () {
              shotController.create();
            },
          ),
          FloatingActionButton(
              tooltip: 'Delete'.tr, // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'DeleteFAB',
              onPressed: () {
                shotController.deleteMultiple(shotController.selectedShots);
              }),
        ]));
  }
}

//分镜表类
class ShotDataTable extends GetView<ShotController> {
  final SongController songController = Get.find();
  bool _sortAscending = true;
  int _sortColumnIndex;

  void _sort(int index, bool ascending) {
    if (ascending) {
      controller.shots.sort((a, b) => a.startTime.compareTo(b.startTime));
    } else {
      controller.shots.sort((a, b) => b.startTime.compareTo(a.startTime));
    }
    _sortColumnIndex = index;
    _sortAscending = ascending;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 24 - 56 - 56,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(children: [
              Row(
                children: List.generate(
                    SNShot.titles.length, (i) => Text(SNShot.titles[i])),
              ),
              Expanded(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 3,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        children: controller.shots
                            .map((shot) => Row(children: [
                                  Checkbox(
                                      value: controller.selectedShots
                                          .contains(shot),
                                      onChanged: (isSelected) {
                                        if (isSelected) {
                                          controller.selectedShots.add(shot);
                                          (context as Element).markNeedsBuild();
                                        } else {
                                          controller.selectedShots.remove(shot);
                                          (context as Element).markNeedsBuild();
                                        }
                                      }),
                                  Text('${shot.sceneNumber}'),
                                  Text('${shot.shotNumber}'),
                                  Text(simpleDurationRegExp
                                      .stringMatch(shot.startTime.toString())),
                                  Text(simpleDurationRegExp
                                      .stringMatch(shot.endTime.toString())),
                                  Text(shot.lyric),
                                  //   DropdownButton(
                                  //     value: shot.sceneNumber,
                                  //     icon: Icon(Icons.arrow_downward,
                                  //         size: 14),
                                  //     style: TextStyle(
                                  //         fontSize: 12,
                                  //         color: Colors.black),
                                  //     underline: Container(
                                  //       height: 2,
                                  //       color: Colors.deepPurpleAccent,
                                  //     ),
                                  //     onChanged: (newValue) {
                                  //       shot.sceneNumber = newValue;
                                  //       controller.updateShot(shot);
                                  //     },
                                  //     items: shotScenes
                                  //         .map((shotSceneMap) =>
                                  //             DropdownMenuItem<int>(
                                  //               value: shotSceneMap[
                                  //                   'shotSceneValue'],
                                  //               child: Text(shotSceneMap[
                                  //                   'shotSceneLabel']),
                                  //             ))
                                  //         .toList(),
                                  //   ),
                                  DropdownButton(
                                    value: shot.shotType,
                                    icon: Icon(Icons.arrow_downward),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (newValue) {
                                      shot.shotType = newValue;
                                      controller.updateShot(shot);
                                    },
                                    items: shotTypes
                                        .map((shotTypeMap) =>
                                            DropdownMenuItem<String>(
                                              value:
                                                  shotTypeMap['shotTypeValue'],
                                              child: Text(
                                                  shotTypeMap['shotTypeLabel']),
                                            ))
                                        .toList(),
                                  ),
                                  Text(shot.shotMovement),
                                  Text(shot.shotAngle),
                                  Expanded(
                                      child: TextField(
                                          controller: TextEditingController()
                                            ..text = shot.text,
                                          // maxLines: null,
                                          decoration: InputDecoration(),
                                          onChanged: (value) {
                                            shot.text = value;
                                          },
                                          onEditingComplete: () {
                                            controller.updateShot(shot);
                                          },
                                          // showEditIcon: true,
                                          onTap: null)),
                                  Text(shot.image),
                                  Text(shot.comment),
                                  CharacterSelector(
                                      editingShot: shot,
                                      updateShot: (shot) =>
                                          controller.updateShot(shot),
                                      editingSong:
                                          songController.editingSong.value)
                                ]))
                            .toList(),
                      )))
            ])));
  }
} // ShotsDataTableState Class

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
                  Text(songController.editingSong.value.subordinateKikaku),
                  Text('当前成员镜头数量：'),
                ]);
          }),
          StreamBuilder(
              stream: shotController.statisticsStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: snapshot.data.entries
                          .map<Widget>(
                              (entry) => Text('${entry.key}: ${entry.value}'))
                          .toList());
                } else {
                  return Container();
                }
              }),
          // StreamBuilder(
          //     stream: shotController.coverageStream,
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if (snapshot.hasData) {
          //         return LyricAnimator(snapshot.data);
          //       } else {
          //         return Container();
          //       }
          //     }),
          StreamBuilder(
              stream: shotController.coverageStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 600,
                        maxWidth: MediaQuery.of(context).size.width),
                    child: ListView(
                      // shrinkWrap: true,
                      // physics: ,
                      children: [
                        SelectableText.rich(
                          TextSpan(
                              children: List<TextSpan>.generate(
                                  snapshot.data.length, (i) {
                            TextStyle textStyle;
                            if (snapshot.data[i]['coverageCount'] == 0) {
                              textStyle = TextStyle(
                                color: Colors.black,
                              );
                            } else if (snapshot.data[i]['coverageCount'] == 1) {
                              textStyle = TextStyle(
                                  color: Colors.black,
                                  backgroundColor: Colors.blue.shade200);
                            } else if (snapshot.data[i]['coverageCount'] >= 2) {
                              textStyle = TextStyle(
                                  color: Colors.black,
                                  backgroundColor: Colors.blue.shade200);
                            }
                            return TextSpan(
                              // recognizer: TapGestureRecognizer()..onTap = () {},
                              text: snapshot.data[i]['lyricText'],
                              style: textStyle,
                            );
                          })),
                          showCursor: true,
                          toolbarOptions:
                              ToolbarOptions(copy: true, selectAll: true),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ]));
  }
}

// class LyricAnimator extends StatefulWidget {
//   final List<Map<String, dynamic>> lyricMaps;
//   const LyricAnimator(this.lyricMaps, {Key key}) : super(key: key);
//   @override
//   _LyricAnimatorState createState() => _LyricAnimatorState(lyricMaps);
// }

// class _LyricAnimatorState extends State<LyricAnimator>
//     with TickerProviderStateMixin {
//   //我参考的这个代码，似乎每次都会创建一个新的Controller，这样做真的好吗？

//   final lyricPainterSize = Size(250, 600);
//   final LyricController lyricController = Get.find();
//   final List<Map<String, dynamic>> lyricMaps;
//   AnimationController _lyricOffsetYController;
//   LyricPainter _lyricPainter;
//   int currentShotTime = 0;

//   _LyricAnimatorState(this.lyricMaps);

//   @override
//   void initState() {
//     super.initState();
//     _lyricPainter = LyricPainter(lyricMaps, currentShotTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: lyricPainterSize.width,
//         height: lyricPainterSize.height,
//         child: GestureDetector(
//             onVerticalDragUpdate: (details) {
//               _lyricPainter.offsetYBegin += details.delta.dy;
//             },
//             child: StreamBuilder(
//                 stream: shotBloc.currentShotTimeSubject,
//                 builder: (BuildContext context, AsyncSnapshot snapshot) {
//                   if (snapshot.hasData) {
//                     startAnimation(snapshot.data);
//                     return CustomPaint(
//                         painter: _lyricPainter, size: lyricPainterSize);
//                   } else {
//                     return Container();
//                   }
//                 })));
//   }

//   /// 开始下一行动画
//   void startAnimation(int currentShotTime) {
//     // 判断当前行和 customPaint 里的当前行是否一致，不一致才做动画
//     if (_lyricPainter.currentShotTime != currentShotTime) {
//       // 如果动画控制器不是空，那么则证明上次的动画未完成，
//       // 未完成的情况下直接 stop 当前动画，做下一次的动画
//       if (_lyricOffsetYController != null) {
//         _lyricOffsetYController.stop();
//       }

//       // 初始化动画控制器，切换歌词时间为300ms，并且添加状态监听，
//       // 如果为 completed，则消除掉当前controller，并且置为空。
//       _lyricOffsetYController = AnimationController(
//           vsync: this, duration: Duration(milliseconds: 300))
//         ..addStatusListener((status) {
//           if (status == AnimationStatus.completed) {
//             _lyricOffsetYController.dispose();
//             _lyricOffsetYController = null;
//           }
//         });
//       // 计算出来当前行的偏移量
//       // 起始为当前偏移量，结束点为计算出来的偏移量
//       Animation animation = Tween<double>(
//               begin: _lyricPainter.offsetYBegin,
//               end: _lyricPainter.getOffsetYEnd(currentShotTime) * -1)
//           .animate(_lyricOffsetYController);
//       // 添加监听，在动画做效果的时候给 offsetY 赋值
//       _lyricOffsetYController.addListener(() {
//         _lyricPainter.offsetYBegin = animation.value;
//       });
//       // 启动动画
//       _lyricOffsetYController.forward();
//       // 给 customPaint 赋值当前行
//       _lyricPainter.currentShotTime = currentShotTime;
//     }
//   }
// }

// class LyricPainter extends CustomPainter {
//   final double lyricSpacing = 20.0;

//   List<Map<String, dynamic>> lyricMaps;
//   int currentShotTime;

//   List<TextPainter> lyricPaints = [];
//   double offsetYBegin = 0.0;

//   // TextStyle
//   final TextStyle normalTextStyle = TextStyle(
//     color: Colors.black,
//   );
//   final TextStyle covered1TextStyle =
//       TextStyle(color: Colors.black, backgroundColor: Colors.blue.shade200);
//   final TextStyle covered2TextStyle =
//       TextStyle(color: Colors.black, backgroundColor: Colors.blue.shade200);
//   final TextStyle currentTextStyle = TextStyle(
//     color: Colors.grey.shade600,
//   );

//   LyricPainter(this.lyricMaps, this.currentShotTime) {
//     lyricPaints.addAll(lyricMaps
//         .map((lyricMap) => TextPainter(
//             text: TextSpan(
//                 text: lyricMap['lyricContent'], style: normalTextStyle),
//             textDirection: TextDirection.ltr))
//         .toList());
//     for (TextPainter lp in lyricPaints) {
//       lp.layout();
//     }
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     double y = offsetYBegin + size.height / 2 + lyricPaints[0].height / 2;
//     for (int i = 0; i < lyricMaps.length; i++) {
//       if (y > size.height || y < (0 - lyricPaints[i].height / 2)) {
//       } else {
//         if (currentShotTime == lyricMaps[i]['lyricTime']) {
//           lyricPaints[i].text = TextSpan(
//               text: lyricMaps[i]['lyricContent'], style: currentTextStyle);
//           lyricPaints[i].layout();
//         } else if (lyricMaps[i]['coverageCount'] == 0) {
//           lyricPaints[i].text = TextSpan(
//               text: lyricMaps[i]['lyricContent'], style: normalTextStyle);
//           lyricPaints[i].layout();
//         } else if (lyricMaps[i]['coverageCount'] == 1) {
//           lyricPaints[i].text = TextSpan(
//               text: lyricMaps[i]['lyricContent'], style: covered1TextStyle);
//           lyricPaints[i].layout();
//         } else if (lyricMaps[i]['coverageCount'] >= 2) {
//           lyricPaints[i].text = TextSpan(
//               text: lyricMaps[i]['lyricContent'], style: covered2TextStyle);
//           lyricPaints[i].layout();
//         }
//         lyricPaints[i].paint(
//           canvas,
//           Offset((size.width - lyricPaints[i].width) / 2, y),
//         );
//       }
//       // 计算偏移量
//       y += lyricPaints[i].height + lyricSpacing;
//     }
//   }

//   double getOffsetYEnd(int currentShotTime) {
//     int currentLine = 0;
//     for (int i = 0; i < lyricMaps.length; i++) {
//       if (currentShotTime == lyricMaps[i]['lyricTime']) {
//         currentLine = i;
//         break;
//       }
//     }
//     return (lyricPaints[0].height + lyricSpacing) * (currentLine + 1);
//   }

//   bool shouldRepaint(LyricPainter oldDelegate) =>
//       oldDelegate.offsetYBegin != offsetYBegin;
// }

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
        FlatButton(
            onPressed: () => lyricController.retrieveForSong(),
            child: Text('刷新歌词')),
        Obx(() {
          assert(songController.editingSong.value != null);
          return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Colors.pink,
              ),
              child: Slider(
                  value: (shotController.editingShot.value != null)
                      ? shotController
                              .editingShot.value.startTime.inMilliseconds /
                          songController
                              .editingSong.value.duration.inMilliseconds
                      : 0,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    print(value);
                  },
                  onChangeEnd: (value) =>
                      null // TODO: Implement editingShot focus on
                  ));
        }),
      ],
    ));
  }
}

class ShotTableUpsertDialog extends GetView<ShotTableController> {
  // 在dialog最终pop时才给对象赋值，不确定这样的方式是否合适
  SNShotTable st;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  ShotTableUpsertDialog(SNShotTable shotTable) {
    st = shotTable ?? SNShotTable.initialValue();
    _nameController.text = st.name;
    _descriptionController.text = st.description;
  }

  Widget build(BuildContext context) => SimpleDialog(
        title: Text('ShotTable Upsert Dialog'),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Form(
                    child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        InputDecoration(hintText: 'Input shotTable name'),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Input shotTable description'),
                    onEditingComplete: () {},
                  ),
                ])),
                SimpleDialogOption(
                  onPressed: () {
                    controller.delete(st); // ! shotTable could be null
                    Get.back();
                  },
                  child: Text('Delete'.tr),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    st.name = _nameController.text;
                    st.description = _descriptionController.text;
                    Get.back(result: st);
                  },
                  child: Text('Submit'.tr),
                ),
              ]))
        ],
      );
}
