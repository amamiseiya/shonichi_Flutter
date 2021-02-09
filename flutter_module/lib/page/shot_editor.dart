import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/drawer.dart';
import '../widget/loading.dart';
import '../widget/character_selector.dart';
import '../model/shot_table.dart';
import '../model/shot.dart';
import '../model/character.dart';
import '../controller/project.dart';
import '../controller/song.dart';
import '../controller/lyric.dart';
import '../controller/shot_table.dart';
import '../controller/shot.dart';
import '../util/reg_exp.dart';
import '../util/data_convert.dart';

class ShotEditorPage extends GetView<ShotController> {
  ShotTableController shotTableController = Get.find();

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
          title: Text('分镜脚本编辑'),
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
        body: GetX(
            initState: (_) => shotTableController.editingShotTable(SNShotTable(
                id: 'sn_shot_table_example_2',
                name: 'Default ShotTable for Star Diamond',
                authorId: '1',
                songId: 'sn_song_example_2')),
            builder: (_) {
              if (controller.shots.value != null) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            }),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Add', // used by assistive technologies
            child: Icon(Icons.add),
            heroTag: 'addFAB',
            onPressed: () {
              controller.create();
            },
          ),
          FloatingActionButton(
              tooltip: 'Delete', // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'deleteFAB',
              onPressed: () {
                controller.deleteMultiple(controller.selectedShots);
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
    return Obx(() {
      if (controller.shots.isNotEmpty) {
        return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  slivers: [
                    SliverList(
                        delegate: SliverChildListDelegate([
                      DataTable(
                        sortAscending: _sortAscending,
                        sortColumnIndex: _sortColumnIndex,
                        columnSpacing: 10,
                        columns: List.generate(
                          SNShot.titles.length,
                          (i) => DataColumn(
                            label: Text(SNShot.titles[i]),
                            onSort: (index, ascending) =>
                                _sort(index, ascending),
                          ),
                        ),
                        rows: controller.shots
                            .map((shot) => DataRow(
                                    selected:
                                        controller.selectedShots.contains(shot),
                                    onSelectChanged: (isSelected) {
                                      if (isSelected) {
                                        controller.selectedShots.add(shot);
                                      } else {
                                        controller.selectedShots.remove(shot);
                                      }
                                    },
                                    cells: [
                                      DataCell(Text('${shot.sceneNumber}')),
                                      DataCell(Text('${shot.shotNumber}')),
                                      DataCell(
                                        Text(simpleDurationRegExp.stringMatch(
                                            shot.startTime.toString())),
                                      ),
                                      DataCell(
                                        Text(simpleDurationRegExp.stringMatch(
                                            shot.endTime.toString())),
                                      ),
                                      DataCell(Text(shot.lyric)),
                                      // DataCell(
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
                                      // ),
                                      DataCell(
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
                                                    value: shotTypeMap[
                                                        'shotTypeValue'],
                                                    child: Text(shotTypeMap[
                                                        'shotTypeLabel']),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                      DataCell(Text(shot.shotMovement)),
                                      DataCell(Text(shot.shotAngle)),
                                      DataCell(
                                          TextField(
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
                                          ),
                                          // showEditIcon: true,
                                          onTap: null),
                                      DataCell(Text(shot.image)),
                                      DataCell(Text(shot.comment)),
                                      DataCell(Obx(() {
                                        if (songController.editingSong !=
                                            null) {
                                          return CharacterSelector(
                                              editingShot: shot,
                                              updateShot: (shot) =>
                                                  controller.updateShot(shot),
                                              editingSong: songController
                                                  .editingSong.value);
                                        } else {
                                          return Container();
                                        }
                                      })),
                                    ]))
                            .toList(),
                      ),
                    ])),
                  ],
                )));
      } else {
        return LoadingAnimationLinear();
      }
    });
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
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          FlatButton(
              onPressed: () => showBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                        height: 300,
                        child: Column(
                          children: <Widget>[
                            Text('这个Slider仅仅是用来测试的，所以只能选择前几段。'),
                            Obx(() {
                              if (shotController.editingShot != null) {
                                return SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      //   thumbShape: PaddleSliderValueIndicatorShape(),
                                      thumbColor: Colors.pink,
                                    ),
                                    child: Slider(
                                      value: shotController.editingShot.value
                                                  .startTime.inMilliseconds !=
                                              0
                                          ? [
                                              18100,
                                              22900,
                                              24200,
                                              30200,
                                              34800,
                                              36300
                                            ]
                                              .indexWhere((element) =>
                                                  element ==
                                                  shotController
                                                      .editingShot
                                                      .value
                                                      .startTime
                                                      .inMilliseconds)
                                              .toDouble()
                                          : 0.0,
                                      min: 0.0,
                                      max: 5.0,
                                      divisions: 5,
                                      onChanged: (value) {
                                        print(value);
                                      },
                                      onChangeEnd: (value) => shotController
                                              .editingShot.value =
                                          shotController.shots[
                                              value.toInt()], // ! Be careful
                                    ));
                              } else {
                                return Container();
                              }
                            }),
                          ],
                        ));
                  }),
              child: Text('Show ButtomSheet')),
          Obx(() {
            if (songController.editingSong != null) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('当前企划：'),
                    Text(songController.editingSong.value.subordinateKikaku),
                    Text('当前成员镜头数量：'),
                  ]);
            } else {
              return Container();
            }
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
