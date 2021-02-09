import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../widget/drawer.dart';
import '../widget/loading.dart';
import '../widget/error.dart';
import '../controller/song.dart';
import '../model/song.dart';
import '../util/data_convert.dart';

class SongListPage extends GetView<SongController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('所有歌曲查看')),
        drawer: MyDrawer(),
        body: GetX(
            initState: (_) => controller.retrieve(),
            builder: (_) {
              if (controller.songs.value != null) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SongDataTable(),
                              ])),
                      // Expanded(
                      //   flex: 1,
                      //   child: SongInspector(key: _songInspectorKey),
                      // ),
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
              onPressed: () => showSongEditorDialog(null)),
        ]));
  }
}

class SongDataTable extends GetView<SongController> {
  bool _sortAscending = true;
  int _sortColumnIndex;

  void _sort(int index, bool ascending) {
    if (ascending) {
      controller.songs.sort((a, b) => a.name.compareTo(b.name));
    } else {
      controller.songs.sort((a, b) => b.name.compareTo(a.name));
    }
    _sortColumnIndex = index;
    _sortAscending = ascending;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.songs.value.isNotEmpty) {
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
              rows: controller.songs
                  .map((song) => DataRow(cells: [
                        DataCell(Text(song.name), onTap: () {
                          print('Pressed from DataCell');
                          showSongEditorDialog(song);
                        }),
                        DataCell(Text(song.subordinateKikaku)),
                      ]))
                  .toList(),
            )
          ],
        ));
      } else {
        return LoadingAnimationLinear();
      }
    });
  }
}

Future<void> showSongEditorDialog(SNSong song) async {
  SongController songController = Get.find();
  SNSong s = (song != null) ? song : SNSong.initialValue();

  TextEditingController _idController = TextEditingController()
    ..text = s.id.toString();
  TextEditingController _nameController = TextEditingController()
    ..text = s.name;
  TextEditingController _coverFileNameController = TextEditingController()
    ..text = s.coverFileName;
  TextEditingController _lyricOffsetController = TextEditingController()
    ..text = s.lyricOffset.toString();

  final _future = await Get.dialog(SimpleDialog(
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
                onEditingComplete: () {
                  s.id = _idController.text;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: '输入歌曲名称'),
                onEditingComplete: () {
                  s.name = _nameController.text;
                },
              ),
              DropdownButton(
                value: s.subordinateKikaku,
                icon: Icon(Icons.arrow_downward),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String value) {
                  (Get.context as Element).markNeedsBuild(); //! doesn't work
                  s.subordinateKikaku = value;
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
                onEditingComplete: () {
                  s.lyricOffset = int.parse(_lyricOffsetController.text);
                },
              ),
              TextFormField(
                controller: _coverFileNameController,
                decoration: InputDecoration(hintText: '输入封面文件名'),
                onEditingComplete: () {
                  s.coverFileName = _coverFileNameController.text;
                },
              ),
              // TextFormField(
              //   controller: _videoIntrosController,
              //   decoration: InputDecoration(hintText: '输入视频简介'),
              //   onEditingComplete: () {
              //     videoIntros = stringToList(value);
              //   },
              // ),
              // TextFormField(
              //   controller: _videoFileNamesController,
              //   decoration: InputDecoration(hintText: '输入视频文件名'),
              //   onEditingComplete: () {
              //     videoFileNames = stringToList(value);
              //   },
              // ),
              // TextFormField(
              //   controller: _videoOffsetsController,
              //   decoration: InputDecoration(hintText: '输入视频偏移'),
              //   onEditingComplete: (value) {
              //     videoOffsets = stringToIntList(value);
              //   },
              // ),
            ])),
            SimpleDialogOption(
              onPressed: () {
                songController.delete(song);
                Get.back();
              },
              child: Text('删除'),
            ),
            SimpleDialogOption(
              onPressed: () => Get.back(result: s),
              child: Text('完成'),
            ),
          ]))
    ],
  ));
  if (_future != null && song != null) {
    songController.submitUpdate(_future);
  } else if (_future != null && song == null) {
    songController.submitCreate(_future);
  }
}
