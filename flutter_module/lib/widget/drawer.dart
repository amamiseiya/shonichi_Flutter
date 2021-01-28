import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../page/home_page.dart';
import '../page/shot_editor_page.dart';
import '../page/song_detail_page.dart';
import '../page/song_list_page.dart';
import '../page/migrator_page.dart';
import '../page/formation_editor_page.dart';

class MyDrawer extends StatelessWidget {
  // final HomePage homePage = HomePage();
  // final ShotEditorPage shotEditorPage = ShotEditorPage();
  // final SongInfoPage songInfoPage = SongInfoPage();
  // final FormationEditorPage formationEditorPage = formationEditorPage();
  // final SongListPage songListPage = SongListPage();
  // final MigratorPage migratorPage = MigratorPage();
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
