import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shonichi_flutter_module/pages/kikaku_information.dart';

import '../controllers/auth.dart';
import '../pages/login.dart';
import '../pages/user_information.dart';
import '../pages/home_page/home_page.dart';
import '../pages/storyboard/storyboard.dart';
import '../pages/song_information/song_information.dart';
import '../pages/song_list/song_list.dart';
import '../pages/data_migration/data_migration.dart';
import '../pages/formation/formation.dart';

class MyDrawer extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: Text(authController.user.value?.displayName ?? ''),
            accountEmail:
                Obx(() => Text(authController.user.value?.email ?? '')),
            onDetailsPressed: (() => Get.off(() => UserInformationPage()))),
        ListTile(
          title: Text('Home Page'.tr),
          onTap: () {
            Get.off(() => HomePage());
          },
        ),
        ListTile(
          title: Text('Storyboard'.tr),
          onTap: () {
            Get.off(() => StoryboardPage());
          },
        ),
        ListTile(
          title: Text('Formation'.tr),
          onTap: () {
            Get.off(() => FormationPage());
          },
        ),
        ListTile(
          title: Text('Song Information'.tr),
          onTap: () {
            Get.off(() => SongInformationPage());
          },
        ),
        ListTile(
          title: Text('Song List'.tr),
          onTap: () {
            Get.off(() => SongListPage());
          },
        ),
        ListTile(
          title: Text('Information about Kikakus'.tr),
          onTap: () {
            Get.off(() => KikakuInformationPage());
          },
        ),
        ListTile(
          title: Text('Data Migration'.tr),
          onTap: () {
            Get.off(() => DataMigrationPage());
          },
        ),
        Divider(),
        Align(alignment: Alignment.bottomCenter,child: ListTile(
          title: Text('Sign out'.tr),
          onTap: () {
            authController.signOut().then((_) => Get.off(() => LoginPage()));
          },
        )),
      ],
    ));
  }
}
