import 'package:flutter/material.dart';

import '../page/homepage.dart';
import '../page/shoteditorpage.dart';
import '../page/songinfopage.dart';
import '../page/songlistpage.dart';
import '../page/migratorpage.dart';
import '../page/formationeditor.dart';

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
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        ListTile(
          title: Text('分镜脚本编辑'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ShotEditorPage()));
          },
        ),
        ListTile(
          title: Text('歌曲信息查看'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SongInfoPage()));
          },
        ),
        ListTile(
          title: Text('舞蹈队形编辑'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => FormationEditorPage()));
          },
        ),
        ListTile(
          title: Text('所有歌曲查看'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SongListPage()));
          },
        ),
        ListTile(
          title: Text('文档导出'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MigratorPage()));
          },
        ),
      ],
    ));
  }
}
