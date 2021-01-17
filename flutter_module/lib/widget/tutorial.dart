import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/project/project_crud_bloc.dart';
import '../provider/sqlite_provider.dart';

Future<void> showTutorial(BuildContext context) {
  final ProjectCrudBloc projectCrudBloc =
      BlocProvider.of<ProjectCrudBloc>(context);

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            child: Center(
                child: Column(children: [
          FlatButton(
            onPressed: () => projectCrudBloc.add(CreateProject()),
            child: Text('Create New SNProject'),
          ),
          FlatButton(
            child: Icon(
              Icons.refresh,
            ),
            onPressed: () {
              SQLiteProvider.cheatCodeReset();
              projectCrudBloc.add(RetrieveProject());
            },
          )
        ])));
      });
}

class Tutorial extends StatefulWidget {
  Tutorial({Key key}) : super(key: key);
  @override
  TutorialState createState() => TutorialState();
}

class TutorialState extends State<Tutorial> with WidgetsBindingObserver {
  ProjectCrudBloc projectBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    projectBloc = BlocProvider.of<ProjectCrudBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: Column(children: [
      FlatButton(
        onPressed: () => projectBloc.add(CreateProject()),
        child: Text('Create New SNProject'),
      ),
      FlatButton(
        child: Icon(
          Icons.refresh,
        ),
        onPressed: () {
          SQLiteProvider.cheatCodeReset();
          projectBloc.add(RetrieveProject());
        },
      )
    ]))));
  }
}
