import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/drawer.dart';
import '../widget/loading.dart';
import '../widget/error.dart';
import '../bloc/song/song_crud_bloc.dart';
import '../model/song.dart';
import '../util/data_convert.dart';

Future<SNSong> songEditorDialog(BuildContext context, SNSong song) {
  int id = (song != null) ? song.id : 114514;
  String name = (song != null) ? song.name : '';
  String coverFileName = (song != null) ? song.coverFileName : '';
  int lyricOffset = (song != null) ? song.lyricOffset : 0;
  String subordinateKikaku = (song != null) ? song.subordinateKikaku : '';
  TextEditingController _idController = TextEditingController()
    ..text = id.toString();
  TextEditingController _nameController = TextEditingController()..text = name;
  TextEditingController _lyricOffsetController = TextEditingController()
    ..text = lyricOffset.toString();
  TextEditingController _coverFileNameController = TextEditingController()
    ..text = coverFileName;

  return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: Text('编辑歌曲简介'),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: [
                      Form(
                          child: Column(children: [
                        TextFormField(
                          controller: _idController,
                          decoration: InputDecoration(hintText: '输入歌曲编号'),
                          onChanged: (value) {
                            id = int.parse(value);
                          },
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(hintText: '输入歌曲名称'),
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                        DropdownButton(
                          value: subordinateKikaku,
                          icon: Icon(Icons.arrow_downward),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String value) {
                            setState(() {
                              subordinateKikaku = value;
                            });
                          },
                          items: <String>['', 'μ\'s', 'Aqours', 'スタァライト九九組']
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                              .toList(),
                        ),
                        TextFormField(
                          controller: _lyricOffsetController,
                          decoration: InputDecoration(hintText: '输入歌词偏移'),
                          onChanged: (value) {
                            lyricOffset = int.parse(value);
                          },
                        ),
                        TextFormField(
                          controller: _coverFileNameController,
                          decoration: InputDecoration(hintText: '输入封面文件名'),
                          onChanged: (value) {
                            coverFileName = value;
                          },
                        ),
                        // TextFormField(
                        //   controller: _videoIntrosController,
                        //   decoration: InputDecoration(hintText: '输入视频简介'),
                        //   onChanged: (value) {
                        //     videoIntros = stringToList(value);
                        //   },
                        // ),
                        // TextFormField(
                        //   controller: _videoFileNamesController,
                        //   decoration: InputDecoration(hintText: '输入视频文件名'),
                        //   onChanged: (value) {
                        //     videoFileNames = stringToList(value);
                        //   },
                        // ),
                        // TextFormField(
                        //   controller: _videoOffsetsController,
                        //   decoration: InputDecoration(hintText: '输入视频偏移'),
                        //   onChanged: (value) {
                        //     videoOffsets = stringToIntList(value);
                        //   },
                        // ),
                      ])),
                      SimpleDialogOption(
                        onPressed: () {
                          BlocProvider.of<SongCrudBloc>(context)
                              .add(DeleteSong(song));
                          Navigator.pop(context);
                        },
                        child: Text('删除'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(
                            context,
                            SNSong(
                                id: id,
                                name: name,
                                subordinateKikaku: subordinateKikaku,
                                lyricOffset: lyricOffset,
                                coverFileName: coverFileName)),
                        child: Text('完成'),
                      ),
                    ]))
              ],
            );
          }));
}

class SongsDataTable extends StatefulWidget {
  SongsDataTable({Key key}) : super(key: key);
  @override
  SongsDataTableState createState() => SongsDataTableState();
}

class SongsDataTableState extends State<SongsDataTable> {
  SongCrudBloc songBloc;
  List<SNSong> songs;
  bool _sortAscending = true;
  int _sortColumnIndex;

  @override
  void initState() {
    super.initState();
    songBloc = BlocProvider.of<SongCrudBloc>(context);
    songBloc.add(RetrieveSong());
  }

  void _sort(int index, bool ascending) {
    if (ascending) {
      songs.sort((a, b) => a.name.compareTo(b.name));
    } else {
      songs.sort((a, b) => b.name.compareTo(a.name));
    }
    setState(() {
      _sortColumnIndex = index;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongCrudBloc, SongCrudState>(builder: (context, state) {
      if (state is SongRetrieved) {
        songs = state.songs;
      } else if (state is CreatingSong || state is UpdatingSong) {
      } else {
        return LoadingAnimationLinear();
      }
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
                label: Text('歌曲名称'),
                onSort: (index, ascending) => _sort(index, ascending),
              ),
              DataColumn(label: Text('所属企划')),
            ],
            rows: songs
                .map((song) => DataRow(cells: [
                      DataCell(Text(song.name), onTap: () {
                        print('Pressed from DataCell');
                        songBloc.add(UpdateSong(song));
                      }),
                      DataCell(Text(song.subordinateKikaku)),
                    ]))
                .toList(),
          )
        ],
      ));
    });
  }
}

class SongListPage extends StatefulWidget {
  @override
  SongListPageState createState() => SongListPageState();
}

class SongListPageState extends State<SongListPage> {
  final GlobalKey<SongsDataTableState> _songListDataTableKey =
      GlobalKey<SongsDataTableState>();
  // final GlobalKey<SongInspectorState> _songInspectorKey =
  //     GlobalKey<SongInspectorState>();
  SongCrudBloc songBloc;
  List<SNSong> songs;

  @override
  void initState() {
    super.initState();
    print('New ShotListPage created!');
    songBloc = BlocProvider.of<SongCrudBloc>(context);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   songBloc = BlocProvider.of<SongCrudBloc>(context);
  //   songBloc.add(RequiredReloadingSongs());
  // }

  @override
  void dispose() {
    songBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('所有歌曲查看')),
        drawer: MyDrawer(),
        body: BlocListener<SongCrudBloc, SongCrudState>(
            listener: (context, state) {
              if (state is CreatingSong) {
                songEditorDialog(context, null)
                    .then((song) => songBloc.add(SubmitCreateSong(song)));
              } else if (state is UpdatingSong) {
                print(state.toString() + ' from listener');
                songEditorDialog(context, state.song)
                    .then((newSong) => songBloc.add(SubmitUpdateSong(newSong)));
              }
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 3,
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SongsDataTable(key: _songListDataTableKey),
                          ])),
                  // Expanded(
                  //   flex: 1,
                  //   child: SongInspector(key: _songInspectorKey),
                  // ),
                ])),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Add', // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'addFAB',
              onPressed: () => songBloc.add(CreateSong())),
        ]));
  }
}
