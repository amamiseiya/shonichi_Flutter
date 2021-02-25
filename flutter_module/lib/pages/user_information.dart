import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth.dart';
import '../pages/login.dart';
import '../widgets/drawer.dart';
import '../widgets/loading.dart';

class UserInformationPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('User Information'.tr)),
        drawer: MyDrawer(),
        body: GetX(builder: (_) {
          if (controller.user.value == null) {
            return LoadingAnimationLinear();
          }
          return Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                ListTile(
                  leading: Text('Email:'.tr),
                  trailing: Obx(() => Text(controller.user.value.email ?? '')),
                ),
              ]));
        }),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Exit'.tr, // used by assistive technologies
              child: Icon(Icons.exit_to_app),
              heroTag: 'ExitFAB',
              onPressed: () =>
                  controller.signOut().then((_) => Get.off(() => LoginPage()))),
        ]));
  }
}
