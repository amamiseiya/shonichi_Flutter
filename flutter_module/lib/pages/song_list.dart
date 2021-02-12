import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';
import '../controllers/song.dart';
import '../models/kikaku.dart';
import '../models/song.dart';
import '../utils/data_convert.dart';

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
              heroTag: 'createFAB',
              onPressed: () => Get.dialog(SongUpsertDialog(null))
                  .then((song) => controller.submitCreate(song))),
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
                          Get.dialog(SongUpsertDialog(song))
                              .then((song) => controller.submitUpdate(song));
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

class SongUpsertDialog extends StatelessWidget {
  SNSong s;
  SongController songController = Get.find();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _coverIdController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _lyricOffsetController = TextEditingController();

  SongUpsertDialog(SNSong song) {
    s = song ?? SNSong.initialValue();
    _nameController.text = s.name;
    _coverIdController.text = s.coverId;
    _durationController.text = s.duration.inMilliseconds.toString();
    _lyricOffsetController.text = s.lyricOffset.toString();
  }

  Widget build(BuildContext context) => SimpleDialog(
        title: Text('编辑歌曲简介'),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Form(
                    child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: '输入歌曲名称'),
                    onEditingComplete: () {},
                  ),
                  DropdownButton(
                    value: s.subordinateKikaku,
                    icon: Icon(Icons.arrow_downward),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String value) {
                      (context as Element).markNeedsBuild(); // 妙啊，实在是妙
                      s.subordinateKikaku = value;
                    },
                    items: SNKikaku.kikakus
                        .map<DropdownMenuItem<String>>(
                            (SNKikaku kikaku) => DropdownMenuItem<String>(
                                  value: kikaku.name,
                                  child: Text(kikaku.name),
                                ))
                        .toList(),
                  ),
                  TextFormField(
                    controller: _coverIdController,
                    decoration: InputDecoration(hintText: '输入封面ID'),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(hintText: '输入歌曲编号'),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _lyricOffsetController,
                    decoration: InputDecoration(hintText: '输入歌词偏移'),
                    onEditingComplete: () {},
                  ),
                ])),
                SimpleDialogOption(
                  onPressed: () {
                    songController.delete(s); // ! song could be null
                    Get.back();
                  },
                  child: Text('Delete'.tr),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    s.name = _nameController.text;
                    s.coverId = _coverIdController.text;
                    s.duration = Duration(
                        milliseconds: int.parse(_durationController.text));
                    s.lyricOffset = int.parse(_lyricOffsetController.text);
                    Get.back(result: s);
                  },
                  child: Text('Submit'.tr),
                ),
              ]))
        ],
      );
}
