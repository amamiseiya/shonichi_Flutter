import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/home_page.dart';
import '../pages/shot_editor.dart';
import '../pages/song_information.dart';
import '../pages/song_list.dart';
import '../pages/migrator.dart';
import '../pages/formation_editor.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(accountName: Text('天海星夜'), accountEmail: null),
        ListTile(
          title: Text('Home Page'.tr),
          onTap: () {
            Get.to(HomePage());
          },
        ),
        ListTile(
          title: Text('Shot Editor'.tr),
          onTap: () {
            Get.to(ShotEditorPage());
          },
        ),
        ListTile(
          title: Text('Song Information'.tr),
          onTap: () {
            Get.to(SongInformationPage());
          },
        ),
        ListTile(
          title: Text('Formation Editor'.tr),
          onTap: () {
            Get.to(FormationEditorPage());
          },
        ),
        ListTile(
          title: Text('Song List'.tr),
          onTap: () {
            Get.to(SongListPage());
          },
        ),
        ListTile(
          title: Text('Migrator'.tr),
          onTap: () {
            Get.to(MigratorPage());
          },
        ),
      ],
    ));
  }
}
