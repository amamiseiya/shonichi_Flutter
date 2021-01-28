import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/tutorial.dart';
import '../widget/drawer.dart';
import '../widget/loading.dart';
import '../widget/error.dart';
import '../controller/project_controller.dart';
import '../model/project.dart';
import '../provider/sqlite_provider.dart';

class HomePage extends GetView<ProjectController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   tooltip: 'Navigation menu',
          //   onPressed: () => Scaffold.of(context).openDrawer(),
          // ),
          title: Text('主界面'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: null,
            ),
          ],
        ),
        drawer: MyDrawer(),
        // body is the majority of the screen.
        body: GetBuilder(
            initState: (_) async {
              await controller.retrieve();
              print('New HomePage created!');
            },
            builder: (_) => Dashboard()),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Reset', // used by assistive technologies
              backgroundColor: Colors.red,
              child: Icon(
                Icons.refresh,
              ),
              heroTag: 'resetFAB',
              onPressed: () => SQLiteProvider.cheatCodeReset()),
          FloatingActionButton(
              tooltip: 'Add', // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'addFAB',
              onPressed: () =>
                  Get.to(showProjectEditorDialog(null))), //! 和Lyric页面的实现方式不同
          FloatingActionButton(
              tooltip: 'Edit', // used by assistive technologies
              child: Icon(Icons.edit),
              heroTag: 'editFAB',
              onPressed: () => Get.to(
                  showProjectEditorDialog(controller.editingProject.value))),
          FloatingActionButton(
              tooltip: 'Delete', // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'deleteFAB',
              onPressed: () =>
                  controller.delete(controller.editingProject.value)),
        ]));
  }
}

class Dashboard extends GetView<ProjectController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.projects.value == null) {
        return LoadingAnimationLinear();
      } else if (controller.projects.isNotEmpty) {
        return FractionallySizedBox(
          alignment: Alignment.center,
          widthFactor: 0.5,
          heightFactor: 1.0,
          child: ListView(children: [
            Card(
                // margin: EdgeInsets.all(10.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Text(
                  'お帰りなさい♪',
                  textScaleFactor: 1.8,
                )),
            Material(
                // margin: EdgeInsets.all(10.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                clipBehavior: Clip.antiAlias,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '当前项目：',
                        textScaleFactor: 1.2,
                      ),
                      Ink.image(
                        image: FileImage(controller.editingCover.value),
                        fit: BoxFit.fitWidth,
                        // width: 300,
                        height: 300,
                        child: InkWell(
                          onTap: () {
                            controller.select(controller.projects[0].id);
                          },
                        ),
                      ),
                      Text(
                        controller.projects[0].songId.toString(),
                        textScaleFactor: 1.5,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text('at:' +
                          controller.projects[0].createdTime.toString()),
                      Text('with:' + controller.projects[0].dancerName),
                    ])),
            Card(
                // margin: EdgeInsets.all(10.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(children: <Widget>[
                  Text(
                    '或是选择其它项目：',
                    textScaleFactor: 1.2,
                  ),
                  Column(
                      children: List.generate(
                          3,
                          (i) => (controller.projects.length >= i + 2)
                              ? (ListTile(
                                  title: Text(controller.projects[i + 1].songId
                                      .toString()),
                                  subtitle: Text('with:' +
                                      controller.projects[i + 1].dancerName),
                                  onTap: () {
                                    controller
                                        .select(controller.projects[i + 1].id);
                                  },
                                ))
                              : Container()))
                ])),
            Card(
                // margin: EdgeInsets.all(10.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(children: [
                  Text(
                    '您也可以自行输入项目ID：',
                    textScaleFactor: 1.2,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        fillColor: Colors.blue.shade100, filled: true),
                    onSubmitted: (value) {
                      controller.select(int.parse(value));
                    },
                  )
                ])),
          ]),
        );
      } else {
        return ErrorAnimation();
      }
    });
  }
}

Widget showProjectEditorDialog(SNProject project) {
  SNProject p = (project != null) ? project : SNProject.initialValue();
  TextEditingController _idController = TextEditingController()
    ..text = p.id.toString();
  TextEditingController _dancerNameController = TextEditingController()
    ..text = p.dancerName;
  TextEditingController _songIdController = TextEditingController()
    ..text = p.songId.toString();
  TextEditingController _shotVersionController = TextEditingController()
    ..text = p.shotTableId.toString();
  TextEditingController _formationVersionController = TextEditingController()
    ..text = p.formationTableId.toString();
  return SimpleDialog(
    title: Text('编辑项目'),
    children: <Widget>[
      Column(children: [
        Form(
            child: Column(children: [
          TextFormField(
            controller: _idController,
            decoration: InputDecoration(hintText: '输入项目编号'),
            onEditingComplete: () {
              p.id = int.parse(_idController.text);
            },
          ),
          FlatButton(
            onPressed: () => showDatePicker(
              context: Get.context,
              initialDate: p.createdTime,
              firstDate: DateTime.now().subtract(Duration(days: 3650)),
              lastDate: DateTime.now().add(Duration(days: 3650)),
            ).then((value) => p.createdTime = value),
            child: Text('选择日期'),
          ),
          TextFormField(
            controller: _dancerNameController,
            decoration: InputDecoration(hintText: '输入舞团名称'),
            onEditingComplete: () {
              p.dancerName = _dancerNameController.text;
            },
          ),
          TextFormField(
            controller: _songIdController,
            decoration: InputDecoration(hintText: '输入歌曲编号'),
            onEditingComplete: () {
              p.songId = int.parse(_songIdController.text);
            },
          ),
          TextFormField(
            controller: _shotVersionController,
            decoration: InputDecoration(hintText: '输入分镜编号'),
            onEditingComplete: () {
              p.shotTableId = int.parse(_shotVersionController.text);
            },
          ),
          TextFormField(
            controller: _formationVersionController,
            decoration: InputDecoration(hintText: '输入队形编号'),
            onEditingComplete: () {
              p.formationTableId = int.parse(_formationVersionController.text);
            },
          ),
        ])),
        SimpleDialogOption(
          onPressed: () => Get.back(result: p),
          child: Text('完成'),
        ),
      ])
    ],
  );
}
