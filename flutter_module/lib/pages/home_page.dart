import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shonichi_flutter_module/controllers/migrator.dart';

import '../widgets/tutorial.dart';
import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';
import '../controllers/project.dart';
import '../models/project.dart';
import '../providers/sqlite/sqlite.dart';

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
          title: Text('Home Page'.tr),
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
          GetBuilder<MigratorController>(
              builder: (controller) => FloatingActionButton(
                  tooltip: 'Reset', // used by assistive technologies
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.refresh,
                  ),
                  heroTag: 'resetFAB',
                  onPressed: () => controller.importJson())),
          FloatingActionButton(
              tooltip: 'Add', // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'addFAB',
              onPressed: () => Get.dialog(ProjectEditorDialog(null)).then(
                  (project) =>
                      controller.submitCreate(project))), //! 和Lyric页面的实现方式不同
          FloatingActionButton(
              tooltip: 'Edit', // used by assistive technologies
              child: Icon(Icons.edit),
              heroTag: 'editFAB',
              onPressed: () => Get.dialog(
                      ProjectEditorDialog(controller.editingProject.value))
                  .then((project) => controller.submitUpdate(project))),
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
                  'Welcome back!'.tr,
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
                        'Current project:'.tr,
                        textScaleFactor: 1.2,
                      ),
                      Ink.image(
                        image: NetworkImage(controller.editingCoverURL.value),
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
                    'Or another project:'.tr,
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
                    'Input project ID:'.tr,
                    textScaleFactor: 1.2,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        fillColor: Colors.blue.shade100, filled: true),
                    onSubmitted: (value) {
                      controller.select(value);
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

class ProjectEditorDialog extends StatelessWidget {
  SNProject p;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _dancerNameController = TextEditingController();
  final TextEditingController _songIdController = TextEditingController();
  final TextEditingController _shotVersionController = TextEditingController();
  final TextEditingController _formationVersionController =
      TextEditingController();

  ProjectEditorDialog(project) {
    p = (project != null) ? project : SNProject.initialValue();
    _idController.text = p.id.toString();
    _dancerNameController.text = p.dancerName;
    _songIdController.text = p.songId.toString();
    _shotVersionController.text = p.shotTableId.toString();
    _formationVersionController.text = p.formationTableId.toString();
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text('编辑项目'),
        children: <Widget>[
          Column(children: [
            Form(
                child: Column(children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(hintText: '输入项目编号'),
                onEditingComplete: () {
                  p.id = _idController.text;
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
                onEditingComplete: () {},
              ),
              TextFormField(
                controller: _songIdController,
                decoration: InputDecoration(hintText: '输入歌曲编号'),
                onEditingComplete: () {},
              ),
              TextFormField(
                controller: _shotVersionController,
                decoration: InputDecoration(hintText: '输入分镜编号'),
                onEditingComplete: () {},
              ),
              TextFormField(
                controller: _formationVersionController,
                decoration: InputDecoration(hintText: '输入队形编号'),
                onEditingComplete: () {},
              ),
            ])),
            SimpleDialogOption(
              onPressed: () {
                p.dancerName = _dancerNameController.text;
                p.songId = _songIdController.text;
                p.shotTableId = _shotVersionController.text;
                p.formationTableId = _formationVersionController.text;
                Get.back(result: p);
              },
              child: Text('Submit'.tr),
            ),
          ])
        ],
      );
}
