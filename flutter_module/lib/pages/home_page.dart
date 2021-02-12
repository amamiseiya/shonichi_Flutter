import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/tutorial.dart';
import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';
import '../controllers/migrator.dart';
import '../controllers/project.dart';
import '../models/project.dart';

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
              tooltip: 'Search'.tr,
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
                  tooltip: 'Reset'.tr, // used by assistive technologies
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.refresh,
                  ),
                  heroTag: 'resetFAB',
                  onPressed: () => controller.importJson())),
          FloatingActionButton(
              tooltip: 'Add'.tr, // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'createFAB',
              onPressed: () => Get.dialog(ProjectUpsertDialog(null)).then(
                  (project) =>
                      controller.submitCreate(project))), //! 和Lyric页面的实现方式不同
          FloatingActionButton(
              tooltip: 'Edit'.tr, // used by assistive technologies
              child: Icon(Icons.edit),
              heroTag: 'editFAB',
              onPressed: () => Get.dialog(
                      ProjectUpsertDialog(controller.editingProject.value))
                  .then((project) => controller.submitUpdate(project))),
          FloatingActionButton(
              tooltip: 'Delete'.tr, // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'deleteFAB',
              onPressed: () =>
                  controller.delete(controller.editingProject.value)),
        ]));
  }
}

class Dashboard extends GetView<ProjectController> {
  final double _widthFactor = Get.context.isPhone ? 1 : 0.6;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.projects.value == null) {
        return LoadingAnimationLinear();
      } else if (controller.projects.isNotEmpty) {
        return FractionallySizedBox(
          alignment: Alignment.center,
          widthFactor: _widthFactor,
          heightFactor: 1.0,
          child: ListView(children: [
            Card(
                margin: EdgeInsets.all(10.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Text(
                  'Welcome back!'.tr,
                  textScaleFactor: 1.8,
                )),
            Container(
                margin: EdgeInsets.all(10.0),
                child: Material(
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
                            image:
                                NetworkImage(controller.editingCoverURL.value),
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
                        ]))),
            Card(
                margin: EdgeInsets.all(10.0),
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
                margin: EdgeInsets.all(10.0),
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

class ProjectUpsertDialog extends StatelessWidget {
  SNProject p;

  final TextEditingController _dancerNameController = TextEditingController();
  final TextEditingController _songIdController = TextEditingController();
  final TextEditingController _shotIdController = TextEditingController();
  final TextEditingController _formationIdController = TextEditingController();

  ProjectUpsertDialog(project) {
    p = project ?? SNProject.initialValue();
    _dancerNameController.text = p.dancerName;
    _songIdController.text = p.songId;
    _shotIdController.text = p.shotTableId;
    _formationIdController.text = p.formationTableId;
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text('Edit project'.tr),
        children: <Widget>[
          Column(children: [
            Form(
                child: Column(children: [
              FlatButton(
                onPressed: () => showDatePicker(
                  context: Get.context,
                  initialDate: p.createdTime,
                  firstDate: DateTime.now().subtract(Duration(days: 3650)),
                  lastDate: DateTime.now().add(Duration(days: 3650)),
                ).then((value) => p.createdTime = value),
                child: Text('选择创建日期'),
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
                controller: _shotIdController,
                decoration: InputDecoration(hintText: '输入分镜编号'),
                onEditingComplete: () {},
              ),
              TextFormField(
                controller: _formationIdController,
                decoration: InputDecoration(hintText: '输入队形编号'),
                onEditingComplete: () {},
              ),
            ])),
            SimpleDialogOption(
              onPressed: () {
                p.dancerName = _dancerNameController.text;
                p.songId = _songIdController.text;
                p.shotTableId = _shotIdController.text;
                p.formationTableId = _formationIdController.text;
                Get.back(result: p);
              },
              child: Text('Submit'.tr),
            ),
          ])
        ],
      );
}
