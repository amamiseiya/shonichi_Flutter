import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../../widgets/drawer.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../controllers/character.dart';
import '../../controllers/song.dart';
import '../../models/kikaku.dart';
import '../../models/song.dart';
import '../../utils/data_convert.dart';
import '../../utils/theme.dart';

part 'upsert_dialog.dart';

class SongListPage extends GetView<SongController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('All Song List'.tr)),
        drawer: MyDrawer(),
        body: GetX<SongController>(
            initState: (_) => controller.retrieveAll(),
            builder: (_) {
              if (controller.songs.value == null) {
                return LoadingAnimationLinear();
              }
              if (controller.songs.value!.isEmpty) {
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
  int _sortColumnIndex = 0;

  void _sort(int index, bool ascending) {
    if (ascending) {
      songController.songs.value!.sort((a, b) => a.name.compareTo(b.name));
    } else {
      songController.songs.value!.sort((a, b) => b.name.compareTo(a.name));
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
          rows: songController.songs.value!
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
