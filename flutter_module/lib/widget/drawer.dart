import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../page/home_page.dart';
import '../page/shot_editor.dart';
import '../page/song_detail.dart';
import '../page/song_list.dart';
import '../page/migrator.dart';
import '../page/formation_editor.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(accountName: Text('天海星夜'), accountEmail: null),
        ListTile(
          title: Text('首页'),
          onTap: () {
            Get.to(HomePage());
          },
        ),
        ListTile(
          title: Text('分镜脚本编辑'),
          onTap: () {
            Get.to(ShotEditorPage());
          },
        ),
        ListTile(
          title: Text('歌曲信息查看'),
          onTap: () {
            Get.to(SongDetailPage());
          },
        ),
        ListTile(
          title: Text('舞蹈队形编辑'),
          onTap: () {
            Get.to(FormationEditorPage());
          },
        ),
        ListTile(
          title: Text('所有歌曲查看'),
          onTap: () {
            Get.to(SongListPage());
          },
        ),
        ListTile(
          title: Text('文档导出'),
          onTap: () {
            Get.to(MigratorPage());
          },
        ),
      ],
    ));
  }
}
