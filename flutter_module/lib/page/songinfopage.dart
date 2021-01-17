import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../bloc/project/project_crud_bloc.dart';
import '../model/project.dart';
import '../bloc/lyric/lyric_crud_bloc.dart';
import '../model/lyric.dart';
import '../bloc/song/song_crud_bloc.dart';
import '../model/song.dart';
import '../widget/drawer.dart';
import '../widget/loading.dart';
import '../util/reg_exp.dart';

class SongInfoPage extends StatefulWidget {
  @override
  SongInfoPageState createState() => SongInfoPageState();
}

class SongInfoPageState extends State<SongInfoPage> {
  final GlobalKey<LyricsDataTableState> _lyricsDataTableKey =
      GlobalKey<LyricsDataTableState>();
  final GlobalKey<LyricInspectorState> _lyricInspectorKey =
      GlobalKey<LyricInspectorState>();
  LyricCrudBloc lyricBloc;

  @override
  void initState() {
    super.initState();
    lyricBloc = BlocProvider.of<LyricCrudBloc>(context);
    lyricBloc.add(StartRetrievingLyric());
  }

  @override
  void dispose() {
    lyricBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('歌曲信息查看')),
        drawer: MyDrawer(),
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              flex: 3,
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LyricsDataTable(key: _lyricsDataTableKey),
                  ])),
          Expanded(
            flex: 1,
            child: LyricInspector(key: _lyricInspectorKey),
          )
        ]),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Add', // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'addFAB',
              onPressed: () => addLyricFromLrc(context)),
        ]));
  }
}

class LyricsDataTable extends StatefulWidget {
  LyricsDataTable({Key key}) : super(key: key);
  @override
  LyricsDataTableState createState() => LyricsDataTableState();
}

//分镜表类
class LyricsDataTableState extends State<LyricsDataTable> {
  LyricCrudBloc lyricBloc;
  List<SNLyric> lyrics;
  List<SNLyric> lyricsSelected = [];
  bool _sortAscending = true;
  int _sortColumnIndex;

  @override
  void initState() {
    super.initState();
    lyricBloc = BlocProvider.of<LyricCrudBloc>(context);
  }

  void _sort(int index, bool ascending) {
    if (ascending) {
      lyrics.sort((a, b) => a.startTime.compareTo(b.startTime));
    } else {
      lyrics.sort((a, b) => b.startTime.compareTo(a.startTime));
    }
    setState(() {
      _sortColumnIndex = index;
      _sortAscending = ascending;
    });
  }

  Widget build(BuildContext context) {
    return BlocBuilder<LyricCrudBloc, LyricCrudState>(
      builder: (context, state) {
        if (state is LyricRetrieved) {
          lyrics = state.lyrics;
          return Flexible(
              child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              DataTable(
                sortAscending: _sortAscending,
                sortColumnIndex: _sortColumnIndex,
                columns: [
                  DataColumn(
                    label: Text('开始时间'),
                    onSort: (index, ascending) => _sort(index, ascending),
                  ),
                  // DataColumn(label: Text('结束时间')),
                  DataColumn(label: Text('歌词内容')),
                  DataColumn(label: Text('Solo Part')),
                ],
                rows: lyrics
                    .map((lyric) => DataRow(
                            selected: lyricsSelected.contains(lyric),
                            onSelectChanged: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  lyricsSelected.add(lyric);
                                } else {
                                  lyricsSelected.remove(lyric);
                                }
                              });
                            },
                            cells: [
                              DataCell(Text(simpleDurationRegExp
                                  .stringMatch(lyric.startTime.toString()))),
                              DataCell(Text(lyric.text),
                                  showEditIcon: true, onTap: null),
                              DataCell(Text('')),
                            ]))
                    .toList(),
              ),
            ],
          ));
        } else {
          return LoadingAnimationLinear();
        }
      },
    );
  }
}

class LyricInspector extends StatefulWidget {
  LyricInspector({Key key}) : super(key: key);
  @override
  LyricInspectorState createState() => LyricInspectorState();
}

class LyricInspectorState extends State<LyricInspector> {
  ProjectCrudBloc projectBloc;
  SongCrudBloc songBloc;
  LyricCrudBloc lyricBloc;
  SNProject currentProject;
  SNSong currentSong;
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
    projectBloc = BlocProvider.of<ProjectCrudBloc>(context);
    lyricBloc = BlocProvider.of<LyricCrudBloc>(context);
    songBloc = BlocProvider.of<SongCrudBloc>(context);
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
          StreamBuilder(
              stream: songBloc.currentSongSubject,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('当前企划：'),
                        Text(snapshot.data.subordinateKikaku),
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

Future<void> addLyricFromLrc(BuildContext context) async {
  final _future = await showDialog(
      context: context,
      builder: (context) {
        String lrcStr;
        return SimpleDialog(
          title: Text('批量添加lrc歌词'),
          children: <Widget>[
            Column(children: [
              Form(
                  child: Column(children: [
                // TextFormField(
                //   decoration: InputDecoration(hintText: '输入歌曲编号'),
                //   onChanged: (value) {
                //     songId = int.parse(value);
                //   },
                // ),
                TextFormField(
                  decoration: InputDecoration(hintText: '歌词'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    lrcStr = value;
                  },
                ),
              ])),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, lrcStr),
                child: Text('完成'),
              ),
            ])
          ],
        );
      });
  BlocProvider.of<LyricCrudBloc>(context).add(ImportLyric(_future));
}
