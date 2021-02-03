import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/project.dart';
import '../provider/sqlite/sqlite.dart';

class TutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
          child: Center(
              child: Column(children: [
        FlatButton(
          onPressed: () => null,
          child: Text('Create New SNProject'),
        ),
        FlatButton(
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
      FlatButton(
        onPressed: () => null,
        child: Text('Create New SNProject'),
      ),
      FlatButton(
        child: Icon(
          Icons.refresh,
        ),
        onPressed: () {
          SQLiteProvider.cheatCodeReset();
          controller.retrieve();
        },
      )
    ]))));
  }
}
