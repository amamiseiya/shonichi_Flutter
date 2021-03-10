import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../models/project.dart';
import '../models/lyric.dart';
import '../models/song.dart';
import '../controllers/song.dart';
import '../controllers/lyric.dart';
import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../widgets/character_selector.dart';
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
          if (controller.lyrics.value!.isEmpty) {
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

class LyricDataTable extends StatefulWidget {

  static const List<String> titles = ['起始时间', '歌词内容', 'Solo Part'];

  @override
  State<LyricDataTable> createState() => _LyricDataTableState();
}

class _LyricDataTableState extends State<LyricDataTable> {
  final LyricController lyricController = Get.find();

  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  void _sort(int index, bool ascending) {
    if (ascending) {
      lyricController.lyrics.value!
          .sort((a, b) => a.startTime.compareTo(b.startTime));
    } else {
      lyricController.lyrics.value!
          .sort((a, b) => b.startTime.compareTo(a.startTime));
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
                rows: lyricController.lyrics.value!
                    .map((lyric) => DataRow(
                            selected:
                                lyricController.selectedLyrics.contains(lyric),
                            onSelectChanged: (bool? isSelected) {
                              if (isSelected!) {
                                lyricController.selectedLyrics.add(lyric);
                              } else {
                                lyricController.selectedLyrics.remove(lyric);
                              }
                              (context as Element).markNeedsBuild();
                            },
                            cells: [
                              DataCell(Text(simpleDurationRegExp
                                  .stringMatch(lyric.startTime.toString())!)),
                              DataCell(Text(simpleDurationRegExp
                                  .stringMatch(lyric.endTime.toString())!)),
                              DataCell(Text(lyric.text),
                                  showEditIcon: true, onTap: null),
                              DataCell(CharacterSelector(
                                  editingData: lyric,
                                  updateData: () =>
                                      lyricController.updateLyric(lyric))),
                            ]))
                    .toList(),
              ),
            )));
  }
}

class LyricInspector extends StatefulWidget {
  @override
  LyricInspectorState createState() => LyricInspectorState();
}

class LyricInspectorState extends State<LyricInspector> {
  SongController songController = Get.find();
  LyricController lyricController = Get.find();

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    // songController.retrieveSongVideo();
    initializePlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    videoPlayerController =
        VideoPlayerController.network(songController.videoURI.value!);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: false,
    );
    setState(() {});
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
                    Text(songController.editingSong.value!.subordinateKikaku),
                  ]);
            } else {
              return Container();
            }
          }),
          (chewieController == null ||
                  !chewieController.videoPlayerController.value.isInitialized)
              ? Container()
              : Column(children: [
                  SizedBox(
                      height: 300, child: Chewie(controller: chewieController)),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        videoPlayerController.value.isPlaying
                            ? videoPlayerController.pause()
                            : videoPlayerController.play();
                      });
                    },
                    child: Icon(
                      videoPlayerController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  )
                ]),
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
              //   decoration: InputDecoration(labelText: '输入歌曲编号'),
              //   onEditingComplete: (value) {
              //     songId = int.parse(value);
              //   },
              // ),
              TextFormField(
                controller: _lyricTextController,
                decoration: InputDecoration(labelText: '歌词'),
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
