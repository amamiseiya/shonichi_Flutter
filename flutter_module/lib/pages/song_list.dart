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
        appBar: AppBar(title: Text('All Song List'.tr)),
        drawer: MyDrawer(),
        body: GetX(
            initState: (_) => controller.retrieve(),
            builder: (_) {
              if (controller.songs.value == null) {
                return LoadingAnimationLinear();
              }
              if (controller.songs.value.isEmpty) {
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
                              SongDataTable(),
                            ])),
                  ]);
            }),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Create'.tr, // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'CreateFAB',
              onPressed: () => Get.dialog(SongUpsertDialog(null))
                  .then((song) => controller.submitCreate(song))),
        ]));
  }
}

class SongDataTable extends StatefulWidget {
  @override
  State<SongDataTable> createState() => _SongDataTableState();
}

class _SongDataTableState extends State<SongDataTable> {
  final SongController songController = Get.find();

  bool _sortAscending = true;
  late int _sortColumnIndex = 0;

  void _sort(int index, bool ascending) {
    if (ascending) {
      songController.songs.sort((a, b) => a.name.compareTo(b.name));
    } else {
      songController.songs.sort((a, b) => b.name.compareTo(a.name));
    }
    _sortColumnIndex = index;
    _sortAscending = ascending;
  }

  @override
  Widget build(BuildContext context) {
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
              label: Text('Song name'.tr),
              onSort: (index, ascending) {
                _sort(index, ascending);
                (context as Element).markNeedsBuild();
              },
            ),
            DataColumn(label: Text('Subordinates'.tr)),
          ],
          rows: songController.songs
              .map((song) => DataRow(cells: [
                    DataCell(Text(song.name), onTap: () {
                      print('Pressed from DataCell');
                      Get.dialog(SongUpsertDialog(song))
                          .then((song) => songController.submitUpdate(song));
                    }),
                    DataCell(Text(song.subordinateKikaku)),
                  ]))
              .toList(),
        )
      ],
    ));
  }
}

class _EmptyPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Text('Empty Page');
  }
}

class SongUpsertDialog extends StatelessWidget {
  late SNSong s;
  SongController songController = Get.find();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _coverIdController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _lyricOffsetController = TextEditingController();

  SongUpsertDialog(SNSong? song) {
    s = song ?? SNSong.initialValue();
    _nameController.text = s.name;
    _coverIdController.text = s.coverURI;
    _durationController.text = s.duration.inMilliseconds.toString();
    _lyricOffsetController.text = s.lyricOffset.toString();
  }

  Widget build(BuildContext context) => SimpleDialog(
        title: Text('Create or Update Song'.tr),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Form(
                    child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Song name'.tr),
                    onEditingComplete: () {},
                  ),
                  DropdownButton(
                    value: s.subordinateKikaku,
                    icon: Icon(Icons.arrow_downward),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      (context as Element).markNeedsBuild(); // 妙啊，实在是妙
                      s.subordinateKikaku = value!;
                    },
                    items: [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text('(not set)'.tr),
                          )
                        ] +
                        SNKikaku.kikakus
                            .map<DropdownMenuItem<String>>(
                                (SNKikaku kikaku) => DropdownMenuItem<String>(
                                      value: kikaku.name,
                                      child: Text(kikaku.name),
                                    ))
                            .toList(),
                  ),
                  TextFormField(
                    controller: _coverIdController,
                    decoration: InputDecoration(hintText: 'Cover ID'.tr),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(hintText: 'Song duration'.tr),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _lyricOffsetController,
                    decoration: InputDecoration(hintText: 'Lyric offset'.tr),
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
                    s.coverURI = _coverIdController.text;
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
