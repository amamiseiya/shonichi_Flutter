import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/project.dart';
import '../providers/sqlite/sqlite.dart';

class TutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
          child: Center(
              child: Column(children: [
        ElevatedButton(
          onPressed: () => null,
          child: Text('Create New SNProject'),
        ),
        ElevatedButton(
          child: Icon(
            Icons.refresh,
          ),
          onPressed: () {},
        )
      ])));
}

class TutorialPage extends GetView<ProjectController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: Column(children: [
      ElevatedButton(
        onPressed: () => null,
        child: Text('Create New SNProject'),
      ),
      ElevatedButton(
        child: Icon(
          Icons.refresh,
        ),
        onPressed: () {
          // controller.retrieve();
        },
      )
    ]))));
  }
}
