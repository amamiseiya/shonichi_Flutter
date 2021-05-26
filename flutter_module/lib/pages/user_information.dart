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
          return ListView(children: [
            Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  ListTile(
                    onTap: () => Get.dialog(EmailDetailDialog()),
                    leading: Text('Email:'.tr),
                    trailing: Obx(() => Text.rich(TextSpan(children: [
                          TextSpan(text: controller.user.value.email ?? ''),
                          (controller.user.value.emailVerified)
                              ? TextSpan(
                                  text: '(Verified)'.tr,
                                  style: TextStyle(color: Colors.green))
                              : TextSpan(
                                  text: '(Not verified)'.tr,
                                  style: TextStyle(color: Colors.red))
                        ]))),
                  ),
                ]))
          ]);
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

class EmailDetailDialog extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text('Email Settings'.tr),
        children: [
          Builder(
            builder: (context) {
              if (!authController.user.value!.emailVerified) {
                return Column(children: [
                  Text('Your email hasn\'t been verified yet.'.tr),
                  Text('Would you like to resend a verification email?'.tr),
                  ElevatedButton(
                      onPressed: () =>
                          authController.user.value!.sendEmailVerification(),
                      child: Text('Resend'.tr)),
                ]);
              } else if (authController.user.value!.emailVerified) {
                return Column(children: [
                  Text('Your email address has already been verified.'.tr)
                ]);
              } else {
                throw Exception('Unknown error');
              }
            },
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end,children:[SimpleDialogOption(
            onPressed: () {
              Get.back();
            },
            child: Text('OK'.tr),
          )])
        ],
      );
}
