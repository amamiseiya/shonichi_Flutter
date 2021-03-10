import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:get/get.dart';

import '../controllers/project.dart';
import '../models/project.dart';
import '../pages/home_page.dart';
import '../pages/storyboard.dart';

class IntroController extends GetxController {
  final ProjectController projectController = Get.find();

  late final Intro intro;
  late final ProjectUpsertDialog projectUpsertDialog;
  late final Future<SNProject> dialog;

  IntroController() {
    projectUpsertDialog = ProjectUpsertDialog(SNProject(
        id: 'tutorial',
        creatorId: '',
        dancerName: 'tutorial',
        createdTime: DateTime.now(),
        modifiedTime: DateTime.now(),
        songId: 'sn_song_example_1',
        storyboardId: '',
        formationId: ''));
    intro = Intro(
      stepCount: 4,
      widgetBuilder: navigateWithDefaultTheme(
          texts: [
            'Welcome!'.tr,
            'Tap here to create your first project.'.tr,
            'Tap Submit'.tr,
            'Create a new storyboard.'.tr
          ],
          buttonTextBuilder: (current, total) {
            return current < total - 1 ? 'Next'.tr : 'Finish'.tr;
          },
          maskClosable: true),
    );
  }

  void startIntro(BuildContext context) {
    if (projectController.projects.value != null &&
        projectController.projects.value!.length <= 2) {
      intro.start(context);
    }
  }

  // TODO: Implement completion callback
  void onPressed(StepWidgetParams stepWidgetParams, int currentStepIndex,
      int stepCount) async {
    switch (currentStepIndex) {
      // 一句问候
      case 0:
        return stepWidgetParams.onNext();
      // 点击右下角添加项目
      case 1:
        dialog = Get.dialog(projectUpsertDialog);
        return Future.delayed(Duration(seconds: 1))
            .then((_) => stepWidgetParams.onNext());
      case 2:
        projectUpsertDialog.submit();
        dialog
            .then((project) => projectController.submitCreate(project))
            .then((_) => Future.delayed(Duration(seconds: 2)))
            .then((_) => Get.to(() => StoryboardPage()));
        return Future.delayed(Duration(seconds: 5))
            .then((_) => stepWidgetParams.onNext());

      case 3:
        return stepWidgetParams.onFinish();
    }
  }

  Map _smartGetPosition({
    required Size size,
    required Size screenSize,
    required Offset offset,
  }) {
    double height = size.height;
    double width = size.width;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double bottomArea = screenHeight - offset.dy - height;
    double topArea = screenHeight - height - bottomArea;
    double rightArea = screenWidth - offset.dx - width;
    double leftArea = screenWidth - width - rightArea;
    Map position = Map();
    position['crossAxisAlignment'] = CrossAxisAlignment.start;
    if (topArea > bottomArea) {
      position['bottom'] = bottomArea + height + 16;
    } else {
      position['top'] = offset.dy + height + 12;
    }
    if (leftArea > rightArea) {
      position['right'] = rightArea <= 0 ? 16.0 : rightArea;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min(leftArea + width - 16, screenWidth * 0.618);
    } else {
      position['left'] = offset.dx <= 0 ? 16.0 : offset.dx;
      position['width'] = min(rightArea + width - 16, screenWidth * 0.618);
    }

    /// The distance on the right side is very large, it is more beautiful on the right side
    if (rightArea > 0.8 * topArea && rightArea > 0.8 * bottomArea) {
      position['left'] = offset.dx + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['right'] = null;
      position['width'] = min<double>(position['width'], rightArea * 0.8);
    }

    /// The distance on the left is large, it is more beautiful on the left side
    if (leftArea > 0.8 * topArea && leftArea > 0.8 * bottomArea) {
      position['right'] = rightArea + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['left'] = null;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min<double>(position['width'], leftArea * 0.8);
    }
    return position;
  }

  /// Use default theme.
  ///
  /// * [texts] is an array of text on the guide page.
  /// * [buttonTextBuilder] is the method of generating button text.
  /// * [maskClosable] click on whether the mask is allowed to be closed.
  /// the parameters are the current page index and the total number of pages in sequence.
  Widget Function(StepWidgetParams params) navigateWithDefaultTheme({
    required List<String> texts,
    required String Function(int currentStepIndex, int stepCount)
        buttonTextBuilder,
    bool maskClosable = false,
  }) {
    return (StepWidgetParams stepWidgetParams) {
      int currentStepIndex = stepWidgetParams.currentStepIndex;
      int stepCount = stepWidgetParams.stepCount;
      Offset offset = stepWidgetParams.offset;

      Map position = _smartGetPosition(
        screenSize: stepWidgetParams.screenSize,
        size: stepWidgetParams.size,
        offset: offset,
      );

      return GestureDetector(
        onTap: () {
          if (maskClosable) {
            onPressed(stepWidgetParams, currentStepIndex, stepCount);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: position['width'],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: position['crossAxisAlignment'],
                  children: [
                    Text(
                      currentStepIndex > texts.length - 1
                          ? ''
                          : texts[currentStepIndex],
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: 28,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(64),
                            ),
                          ),
                          side: BorderSide(color: Colors.white),
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => onPressed(
                            stepWidgetParams, currentStepIndex, stepCount),
                        child: Text(
                          buttonTextBuilder(currentStepIndex, stepCount),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              left: position['left'],
              top: position['top'],
              bottom: position['bottom'],
              right: position['right'],
            ),
          ],
        ),
      );
    };
  }
}
