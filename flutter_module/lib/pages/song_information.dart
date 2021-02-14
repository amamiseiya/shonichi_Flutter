import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:shonichi_flutter_module/widgets/error.dart';
import 'package:video_player/video_player.dart';

import '../models/project.dart';
import '../models/lyric.dart';
import '../models/song.dart';
import '../controllers/song.dart';
import '../controllers/lyric.dart';
import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../utils/reg_exp.dart';

class SongInformationPage extends GetView<LyricController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Song Information'.tr)),
        drawer: MyDrawer(),
        body: GetX(builder: (_) {
          if (controller.lyrics.value == null) {
            return LoadingAnimationLinear();
          }
          if (controller.lyrics.value.isEmpty) {
            return _EmptyPage();
          }
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LyricDataTable(),
                        ])),
                Expanded(
                  flex: 1,
                  child: LyricInspector(),
                )
              ]);
        }),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Create'.tr, // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'CreateFAB',
              onPressed: () => Get.dialog(ImportDialog())
                  .then((text) => controller.importLyric(text))),
        ]));
  }
}

//分镜表类
class LyricDataTable extends GetView<LyricController> {
  bool _sortAscending = true;
  int _sortColumnIndex;

  void _sort(int index, bool ascending) {
    if (ascending) {
      controller.lyrics.sort((a, b) => a.startTime.compareTo(b.startTime));
    } else {
      controller.lyrics.sort((a, b) => b.startTime.compareTo(a.startTime));
    }
    _sortColumnIndex = index;
    _sortAscending = ascending;
  }

  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 24 - 56 - 56,
        width: MediaQuery.of(context).size.width * 3 / 4,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                sortAscending: _sortAscending,
                sortColumnIndex: _sortColumnIndex,
                columns: [
                  DataColumn(
                    label: Text('Start time'.tr),
                    onSort: (index, ascending) {
                      _sort(index, ascending);
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  DataColumn(label: Text('End time'.tr)),
                  DataColumn(label: Text('Lyric text'.tr)),
                  DataColumn(label: Text('Solo Part'.tr)),
                ],
                rows: controller.lyrics
                    .map((lyric) => DataRow(
                            selected: controller.selectedLyrics.contains(lyric),
                            onSelectChanged: (isSelected) {
                              if (isSelected) {
                                controller.selectedLyrics.add(lyric);
                              } else {
                                controller.selectedLyrics.remove(lyric);
                              }
                            },
                            cells: [
                              DataCell(Text(simpleDurationRegExp
                                  .stringMatch(lyric.startTime.toString()))),
                              DataCell(Text(simpleDurationRegExp
                                  .stringMatch(lyric.endTime.toString()))),
                              DataCell(Text(lyric.text),
                                  showEditIcon: true, onTap: null),
                              DataCell(Text('')),
                            ]))
                    .toList(),
              ),
            )));
  }
}

class LyricInspector extends StatefulWidget {
  LyricInspector({Key key}) : super(key: key);
  @override
  LyricInspectorState createState() => LyricInspectorState();
}

class LyricInspectorState extends State<LyricInspector> {
  SongController songController = Get.find();

  List<SNLyric> lyrics;
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  Chewie playerWidget;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    // videoPlayerController.dispose();
    // chewieController.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // videoPlayerController = VideoPlayerController.file(File(ppath.join(
    //     appDocDir.path, currentSong.songName, currentSong.videoFileNames[0])));
    // chewieController = ChewieController(
    //   videoPlayerController: videoPlayerController,
    //   aspectRatio: 16 / 9,
    //   autoPlay: true,
    //   looping: false,
    //   placeholder: Container(
    //     color: Colors.grey,
    //   ),
    //   autoInitialize: false,
    // );
    // playerWidget = Chewie(
    //   controller: chewieController,
    // );
    // videoPlayerController.initialize().then((_) {
    //   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Obx(() {
            if (songController.editingSong != null) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('当前企划：'),
                    Text(songController.editingSong.value.subordinateKikaku),
                  ]);
            } else {
              return Container();
            }
          }),
          // FlatButton(
          //   onPressed: () {
          //     setState(() {
          //       videoPlayerController.value.isPlaying
          //           ? videoPlayerController.pause()
          //           : videoPlayerController.play();
          //     });
          //   },
          //   child: Icon(
          //     videoPlayerController.value.isPlaying
          //         ? Icons.pause
          //         : Icons.play_arrow,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _EmptyPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Text('Empty Page');
  }
}

class ImportDialog extends StatelessWidget {
  final TextEditingController _lyricTextController = TextEditingController();

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text('批量添加lrc歌词'),
        children: <Widget>[
          Column(children: [
            Form(
                child: Column(children: [
              // TextFormField(
              //   decoration: InputDecoration(hintText: '输入歌曲编号'),
              //   onEditingComplete: (value) {
              //     songId = int.parse(value);
              //   },
              // ),
              TextFormField(
                controller: _lyricTextController,
                decoration: InputDecoration(hintText: '歌词'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onEditingComplete: () {},
              ),
            ])),
            SimpleDialogOption(
              onPressed: () => Get.back(result: _lyricTextController.text),
              child: Text('Submit'.tr),
            ),
          ])
        ],
      );
}
