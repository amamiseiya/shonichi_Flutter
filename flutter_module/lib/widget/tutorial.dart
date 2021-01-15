import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/project_bloc.dart';
import '../provider/provider_sqlite.dart';

Future<void> showTutorial(BuildContext context) {
  final ProjectBloc projectBloc = BlocProvider.of<ProjectBloc>(context);

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            child: Center(
                child: Column(children: [
          FlatButton(
            onPressed: () => projectBloc.add(AddProject()),
            child: Text('Create New Project'),
          ),
          FlatButton(
            child: Icon(
              Icons.refresh,
            ),
            onPressed: () {
              ProviderSqlite.supermutekiniubireset();
              projectBloc.add(ReloadProject());
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
  ProjectBloc projectBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    projectBloc = BlocProvider.of<ProjectBloc>(context);
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
        onPressed: () => projectBloc.add(AddProject()),
        child: Text('Create New Project'),
      ),
      FlatButton(
        child: Icon(
          Icons.refresh,
        ),
        onPressed: () {
          ProviderSqlite.supermutekiniubireset();
          projectBloc.add(ReloadProject());
        },
      )
    ]))));
  }
}
