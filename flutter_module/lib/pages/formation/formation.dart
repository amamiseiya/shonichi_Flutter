import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/drawer.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../controllers/character.dart';
import '../../controllers/lyric.dart';
import '../../controllers/formation.dart';
import '../../controllers/move.dart';
import '../../models/formation.dart';
import '../../models/move.dart';
import '../../models/character.dart';
import '../../utils/reg_exp.dart';

part 'move_editor.dart';
part 'upsert_dialog.dart';

class FormationPage extends StatelessWidget {
  final FormationController formationController = Get.find();
  final MoveController moveController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   tooltip: 'Navigation menu',
          //   onPressed: () => Scaffold.of(context).openDrawer(),
          // ),
          title: Text('舞蹈队形编辑'),
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
        body: GetX(initState: (_) {
          formationController.retrieve();
        }, builder: (_) {
          if (formationController.formationsForSong.value == null) {
            return LoadingAnimationLinear();
          }
          if (formationController.formationsForSong.value!.isEmpty) {
            return _EmptyFormationPage();
          }
          return Column(children: [
            _FormationChipSelector(),
            Obx(() {
              if (moveController.movesForFormation.value == null) {
                return LoadingAnimationLinear();
              }
              if (moveController.movesForFormation.value!.isEmpty) {
                // return _EmptyMovePage();
              }
              return MoveEditor();
            })
          ]);
        }),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Create'.tr, // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'CreateFAB',
              onPressed: () => moveController.create()),
          FloatingActionButton(
              tooltip: 'Update'.tr, // used by assistive technologies
              child: Icon(Icons.edit),
              heroTag: 'UpdateFAB',
              onPressed: () {}),
          FloatingActionButton(
              tooltip: 'Delete'.tr, // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'DeleteFAB',
              onPressed: () => moveController.delete()),
        ]));
  }
}

class _EmptyFormationPage extends GetView<FormationController> {
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Empty Formation Page'),
      ElevatedButton(
        child: Text('Create new'.tr),
        onPressed: () => Get.dialog(_FormationUpsertDialog(null))
            .then((formation) => controller.submitCreate(formation)),
      )
    ]);
  }
}

class _FormationChipSelector extends GetView<FormationController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
              child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.formationsForSong.value!.length,
            itemBuilder: (BuildContext context, int index) {
              return Obx(() => ChoiceChip(
                    label:
                        Text(controller.formationsForSong.value![index].name),
                    tooltip: '',
                    selected: controller.editingFormation.value?.id ==
                        controller.formationsForSong.value![index].id,
                    selectedColor: Colors.orange.shade100,
                    onSelected: (_) => controller
                        .select(controller.formationsForSong.value![index].id),
                  ));
            },
          )),
          Flexible(
              child: Row(children: [
            ActionChip(
              label: Icon(Icons.add),
              tooltip: '',
              onPressed: () => Get.dialog(_FormationUpsertDialog(null))
                  .then((formation) => controller.submitCreate(formation)),
            ),
            ActionChip(
              label: Icon(Icons.edit),
              tooltip: '',
              onPressed: () => Get.dialog(
                      _FormationUpsertDialog(controller.editingFormation.value))
                  .then((formation) => controller.submitUpdate(formation)),
            ),
            ActionChip(
              label: Icon(Icons.delete),
              tooltip: '',
              onPressed: () =>
                  Get.dialog(_ConfirmDeleteDialog()).then((confirm) {
                if (confirm == null || confirm! == false) {
                  return;
                }
                if (confirm! == true) {
                  controller.delete(controller.editingFormation.value);
                }
              }),
            ),
          ]))
        ]));
  }
}



class _ConfirmDeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Text(
            'Are you sure that you want to delete this formation? All moves will be deleted as well!'
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
