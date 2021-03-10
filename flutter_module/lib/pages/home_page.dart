import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';
import '../controllers/data_migration.dart';
import '../controllers/project.dart';
import '../controllers/song.dart';
import '../controllers/intro.dart';
import '../models/project.dart';

class HomePage extends GetView<ProjectController> {
  final IntroController introController = Get.find();

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
              onPressed: () => null,
            ),
          ],
        ),
        drawer: MyDrawer(),
        // body is the majority of the screen.
        body: GetX(initState: (_) {
          controller.retrieve();
          Future.delayed(Duration(seconds: 3))
              .then((_) => introController.startIntro(context));
        }, builder: (_) {
          if (controller.projects.value == null) {
            return LoadingAnimationLinear();
          }
          if (controller.projects.value!.isEmpty) {
            return _EmptyPage();
          }
          return _Dashboard();
        }),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          GetBuilder<DataMigrationController>(
              builder: (controller) => FloatingActionButton(
                  tooltip: 'Reset'.tr,
                  // used by assistive technologies
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.refresh,
                  ),
                  heroTag: 'ResetFAB',
                  onPressed: () => controller.importJson(context))),
          FloatingActionButton(
              key: introController.intro.keys[1],
              tooltip: 'Create'.tr,
              // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'CreateFAB',
              onPressed: () => Get.dialog(ProjectUpsertDialog(null))
                  .then((project) => controller.submitCreate(project))),
          //几个UpsertDialog保持一致
          FloatingActionButton(
              tooltip: 'Update'.tr, // used by assistive technologies
              child: Icon(Icons.edit),
              heroTag: 'UpdateFAB',
              onPressed: () => Get.dialog(
                      ProjectUpsertDialog(controller.editingProject.value))
                  .then((project) => controller.submitUpdate(project))),
          FloatingActionButton(
              tooltip: 'Delete'.tr, // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'DeleteFAB',
              onPressed: () =>
                  controller.delete(controller.editingProject.value)),
        ]));
  }
}

class _Dashboard extends GetView<ProjectController> {
  final double _widthFactor = Get.context.isPhone ? 1 : 0.6;

  final SongController songController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.center,
      widthFactor: _widthFactor,
      heightFactor: 1.0,
      child: ListView(children: [
        GetBuilder<IntroController>(
            builder: (introController) => Card(
                key: introController.intro.keys[0],
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Welcome back!'.tr,
                      textScaleFactor: 1.8,
                    )))),
        Obx(() {
          if (songController.firstCoverURI.value == null) {
            return Container();
          }
          return Card(
              margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current project:'.tr,
                          textScaleFactor: 1.2,
                        ),
                        Ink.image(
                          image:
                              NetworkImage(songController.firstCoverURI.value!),
                          fit: BoxFit.fitWidth,
                          // width: 300,
                          height: 300,
                          child: InkWell(
                            onTap: () {
                              controller
                                  .select(controller.projects.value![0].id);
                            },
                          ),
                        ),
                        Text(
                          controller.projects.value![0].songId.toString(),
                          textScaleFactor: 1.5,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('At: '.tr +
                            controller.projects.value![0].createdTime
                                .toString()),
                        Text('With: '.tr +
                            controller.projects.value![0].dancerName),
                      ])));
        }),
        Card(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Or another project:'.tr,
                        textScaleFactor: 1.2,
                      ),
                      Column(
                          children: List.generate(
                              3,
                              (i) =>
                                  (controller.projects.value!.length >= i + 2)
                                      ? (ListTile(
                                          title: Text(controller
                                              .projects.value![i + 1].songId
                                              .toString()),
                                          subtitle: Text('With: ' +
                                              controller.projects.value![i + 1]
                                                  .dancerName),
                                          onTap: () {
                                            controller.select(controller
                                                .projects.value![i + 1].id);
                                          },
                                        ))
                                      : Container()))
                    ]))),
        Card(
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Input project ID:'.tr,
                        textScaleFactor: 1.2,
                      ),
                      TextField(
                        onSubmitted: (value) {
                          controller.select(value);
                        },
                      )
                    ]))),
      ]),
    );
  }
}

class _EmptyPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Text('Empty Page');
  }
}

class ProjectUpsertDialog extends StatelessWidget {
  late SNProject _p;

  final TextEditingController _dancerNameController = TextEditingController();
  final TextEditingController _songIdController = TextEditingController();
  final TextEditingController _storyboardIdController = TextEditingController();
  final TextEditingController _formationIdController = TextEditingController();

  ProjectUpsertDialog(SNProject? project) {
    _p = project ?? SNProject.initialValue();
    _dancerNameController.text = _p.dancerName;
    _songIdController.text = _p.songId ?? '';
    _storyboardIdController.text = _p.storyboardId ?? '';
    _formationIdController.text = _p.formationId ?? '';
  }

  void submit() {
  _p.dancerName = _dancerNameController.text;
  _p.songId = _songIdController.text;
  _p.storyboardId = _storyboardIdController.text;
  _p.formationId = _formationIdController.text;
  Get.back(result: _p);
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text('Create or Update Project'.tr),
        children: <Widget>[
          Column(children: [
            Form(
                child: Column(children: [
              ElevatedButton(
                onPressed: () => showDatePicker(
                  context: Get.context,
                  initialDate: _p.createdTime,
                  firstDate: DateTime.now().subtract(Duration(days: 3650)),
                  lastDate: DateTime.now().add(Duration(days: 3650)),
                ).then((value) {
                  if (value != null) {
                    _p.createdTime = value;
                  }
                }),
                child: Text('Created time'.tr),
              ),
              TextFormField(
                controller: _dancerNameController,
                decoration: InputDecoration(labelText: 'Dancer name'.tr),
                onEditingComplete: () {},
              ),
              TextFormField(
                controller: _songIdController,
                decoration: InputDecoration(labelText: 'Song ID'.tr),
                onEditingComplete: () {},
              ),
              TextFormField(
                controller: _storyboardIdController,
                decoration: InputDecoration(labelText: 'Storyboard ID'.tr),
                onEditingComplete: () {},
              ),
              TextFormField(
                controller: _formationIdController,
                decoration: InputDecoration(labelText: 'Formation ID'.tr),
                onEditingComplete: () {},
              ),
            ])),
            GetBuilder<IntroController>(builder:(controller)=>SimpleDialogOption(
              key: controller.intro.keys[2],
              onPressed: submit,
              child: Text('Submit'.tr),
            )),
          ])
        ],
      );
}
