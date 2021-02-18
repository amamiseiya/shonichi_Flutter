import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/home_page.dart';
import '../pages/storyboard.dart';
import '../pages/song_information.dart';
import '../pages/song_list.dart';
import '../pages/data_migration.dart';
import '../pages/formation.dart';

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
            Get.to(() => HomePage());
          },
        ),
        ListTile(
          title: Text('Storyboard'.tr),
          onTap: () {
            Get.to(() => StoryboardPage());
          },
        ),
        ListTile(
          title: Text('Song Information'.tr),
          onTap: () {
            Get.to(() => SongInformationPage());
          },
        ),
        ListTile(
          title: Text('Formation'.tr),
          onTap: () {
            Get.to(() => FormationPage());
          },
        ),
        ListTile(
          title: Text('Song List'.tr),
          onTap: () {
            Get.to(() => SongListPage());
          },
        ),
        ListTile(
          title: Text('Data Migration'.tr),
          onTap: () {
            Get.to(() => DataMigrationPage());
          },
        ),
      ],
    ));
  }
}
