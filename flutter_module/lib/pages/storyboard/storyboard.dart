import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../widgets/drawer.dart';
import '../../widgets/loading.dart';
import '../../widgets/character_selector.dart';
import '../../models/storyboard.dart';
import '../../models/shot.dart';
import '../../models/character.dart';
import '../../controllers/project.dart';
import '../../controllers/song.dart';
import '../../controllers/lyric.dart';
import '../../controllers/storyboard.dart';
import '../../controllers/shot.dart';
import '../../controllers/intro.dart';
import '../../utils/reg_exp.dart';
import '../../utils/data_convert.dart';

part 'data_table.dart';
part 'inspector.dart';

class StoryboardPage extends StatelessWidget {
  final StoryboardController storyboardController = Get.find();
  final ShotController shotController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   tooltip: 'Navigation menu',
          //   onPressed: () => Scaffold.of(context).openDrawer(),
          // ),
          title: Text('Storyboard'.tr),
          actions: <Widget>[],
        ),
        drawer: MyDrawer(),
        // body is the majority of the screen.
        body: SlidingUpPanel(
            panel: _ShotFilterPanel(),
            body: GetX(
                initState: (_) async => await storyboardController.retrieve(),
                builder: (_) {
                  if (storyboardController.storyboardsForSong.value == null) {
                    return LoadingAnimationLinear();
                  }
                  if (storyboardController.storyboardsForSong.value!.isEmpty) {
                    return _EmptyStoryboardPage();
                  }
                  return Column(children: [
                    _StoryboardChipSelector(),
                    Obx(() {
                      if (shotController.shots.value == null) {
                        return LoadingAnimationLinear();
                      }
                      if (shotController.shots.value!.isEmpty) {
                        return _EmptyShotPage();
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ShotDataTable(),
                            ),
                            Expanded(
                              flex: 1,
                              child: ShotInspector(),
                            )
                          ]);
                    })
                  ]);
                })),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Create'.tr, // used by assistive technologies
            child: Icon(Icons.add),
            heroTag: 'CreateFAB',
            onPressed: () {
              shotController.create();
            },
          ),
          FloatingActionButton(
              tooltip: 'Delete'.tr, // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'DeleteFAB',
              onPressed: () {
                shotController.deleteMultiple(shotController.selectedShots);
              }),
        ]));
  }
}

class _EmptyStoryboardPage extends GetView<StoryboardController> {
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Empty Storyboard Page'),
      ElevatedButton(
        child: Text('Create new'.tr),
        onPressed: () => Get.dialog(_StoryboardUpsertDialog(null))
            .then((storyboard) => controller.submitCreate(storyboard)),
      )
    ]);
  }
}

class _StoryboardChipSelector extends GetView<StoryboardController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.storyboardsForSong.value!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Obx(() => InputChip(
                        label: Text(
                            controller.storyboardsForSong.value![index].name),
                        tooltip: '',
                        selected: controller.editingStoryboard.value?.id ==
                            controller.storyboardsForSong.value![index].id,
                        selectedColor: Colors.orange.shade100,
                        onSelected: (_) => controller.select(
                            controller.storyboardsForSong.value![index].id),
                      ));
                })),
        Flexible(
            child: Row(children: [
          GetBuilder<IntroController>(
              builder: (introController) => ActionChip(
                    key: introController.intro.keys[3],
                    label: Icon(Icons.add),
                    tooltip: '',
                    onPressed: () => Get.dialog(_StoryboardUpsertDialog(null))
                        .then((storyboard) =>
                            controller.submitCreate(storyboard)),
                  )),
          ActionChip(
            label: Icon(Icons.edit),
            tooltip: '',
            onPressed: () => Get.dialog(
                    _StoryboardUpsertDialog(controller.editingStoryboard.value))
                .then((storyboard) => controller.submitUpdate(storyboard)),
          ),
          ActionChip(
            label: Icon(Icons.delete),
            tooltip: '',
            onPressed: () => Get.dialog(_ConfirmDeleteDialog()).then((confirm) {
              if (confirm == null || confirm! == false) {
                return;
              }
              if (confirm! == true) {
                controller.delete(controller.editingStoryboard.value);
              }
            }),
          ),
        ]))
      ]),
    );
  }
}

class _StoryboardUpsertDialog extends GetView<StoryboardController> {
  // 在dialog最终pop时才给对象赋值，不确定这样的方式是否合适
  late SNStoryboard s;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  _StoryboardUpsertDialog(SNStoryboard? storyboard) {
    s = storyboard ?? SNStoryboard.initialValue();
    _nameController.text = s.name;
    _descriptionController.text = s.description;
  }

  Widget build(BuildContext context) => SimpleDialog(
        title: Text('Storyboard Upsert Dialog'),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Form(
                    child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        InputDecoration(labelText: 'Input storyboard name'),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Input storyboard description'),
                    onEditingComplete: () {},
                  ),
                ])),
                SimpleDialogOption(
                  onPressed: () {
                    controller.delete(s); // ! storyboard could be null
                    Get.back();
                  },
                  child: Text('Delete'.tr),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    s.name = _nameController.text;
                    s.description = _descriptionController.text;
                    Get.back(result: s);
                  },
                  child: Text('Submit'.tr),
                ),
              ]))
        ],
      );
}

class _ConfirmDeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Text(
            'Are you sure that you want to delete this storyboard? All shots will be deleted as well!'
                .tr),
      ),
      actions: [
        ElevatedButton(
            child: Text('Cancel'.tr), onPressed: () => Get.back(result: false)),
        ElevatedButton(
            child: Text('OK'.tr), onPressed: () => Get.back(result: true))
      ],
    );
  }
}

class _EmptyShotPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Text('Empty Shot Page');
  }
}



