import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/tutorial.dart';
import '../widget/drawer.dart';
import '../widget/loading.dart';
import '../widget/error.dart';
import '../bloc/project_bloc.dart';
import '../model/project.dart';
import '../provider/provider_sqlite.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<DashboardState> _dashboardKey = GlobalKey<DashboardState>();
  ProjectBloc projectBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    projectBloc = BlocProvider.of<ProjectBloc>(context);
  }

  @override
  void dispose() {
    projectBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('New HomePage created!');
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   tooltip: 'Navigation menu',
          //   onPressed: () => Scaffold.of(context).openDrawer(),
          // ),
          title: Text('主界面'),
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
        body: BlocListener<ProjectBloc, ProjectState>(
            listener: (context, state) {
              if (state is NoProjectFetched) {
                showTutorial(context);
              } else if (state is AddingProject) {
                projectEditorDialog(context, null).then(
                    (project) => projectBloc.add(ConfirmAddProject(project)));
              } else if (state is UpdatingProject) {
                projectEditorDialog(context, state.project).then((newProject) =>
                    projectBloc.add(ConfirmUpdateProject(newProject)));
              }
            },
            child: Dashboard(key: _dashboardKey)),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              tooltip: 'Reset', // used by assistive technologies
              backgroundColor: Colors.red,
              child: Icon(
                Icons.refresh,
              ),
              heroTag: 'resetFAB',
              onPressed: () => ProviderSqlite.supermutekiniubireset()),
          FloatingActionButton(
              tooltip: 'Add', // used by assistive technologies
              child: Icon(Icons.add),
              heroTag: 'addFAB',
              onPressed: () => projectBloc.add(AddProject())),
          FloatingActionButton(
              tooltip: 'Edit', // used by assistive technologies
              child: Icon(Icons.edit),
              heroTag: 'editFAB',
              onPressed: () => projectBloc.add(
                  UpdateProject(_dashboardKey.currentState.currentProject))),
          FloatingActionButton(
              tooltip: 'Delete', // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'deleteFAB',
              onPressed: () => projectBloc.add(
                  DeleteProject(_dashboardKey.currentState.currentProject))),
        ]));
  }
}

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  ProjectBloc projectBloc;
  List<Project> projects;
  Project currentProject;
  File firstProjectCoverFile;

  @override
  void initState() {
    projectBloc = BlocProvider.of<ProjectBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(builder: (context, state) {
      if (state is FetchingProjects) {
        return LoadingAnimationLinear();
      } else if (state is ProjectFetched) {
        projects = state.projects;
        firstProjectCoverFile = state.firstProjectCoverFile;
      } else if (state is ProjectSelected) {
        projects = state.projects;
        firstProjectCoverFile = state.firstProjectCoverFile;
        currentProject = state.project;
      } else if (state is AddingProject || state is UpdatingProject) {
      } else {
        return ErrorAnimation();
      }
      return FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 0.5,
        heightFactor: 1.0,
        child: ListView(children: [
          Card(
              // margin: EdgeInsets.all(10.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Text(
                'お帰りなさい♪',
                textScaleFactor: 1.8,
              )),
          Material(
              // margin: EdgeInsets.all(10.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              clipBehavior: Clip.antiAlias,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '当前项目：',
                      textScaleFactor: 1.2,
                    ),
                    Ink.image(
                      image: FileImage(firstProjectCoverFile),
                      fit: BoxFit.fitWidth,
                      // width: 300,
                      height: 300,
                      child: InkWell(
                        onTap: () {
                          projectBloc
                              .add(SelectAProject(projects[0].projectId));
                        },
                      ),
                    ),
                    Text(
                      projects[0].songId.toString(),
                      textScaleFactor: 1.5,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('at:' + projects[0].projectDate.toString()),
                    Text('with:' + projects[0].dancerName),
                  ])),
          Card(
              // margin: EdgeInsets.all(10.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(children: <Widget>[
                Text(
                  '或是选择其它项目：',
                  textScaleFactor: 1.2,
                ),
                Column(
                    children: List.generate(
                        3,
                        (i) => (projects.length >= i + 2)
                            ? (ListTile(
                                title: Text(projects[i + 1].songId.toString()),
                                subtitle:
                                    Text('with:' + projects[i + 1].dancerName),
                                onTap: () {
                                  projectBloc.add(SelectAProject(
                                      projects[i + 1].projectId));
                                },
                              ))
                            : Container()))
              ])),
          Card(
              // margin: EdgeInsets.all(10.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(children: [
                Text(
                  '还特么没有你要的？自己输入吧。',
                  textScaleFactor: 1.2,
                ),
                TextField(
                  decoration: InputDecoration(
                      fillColor: Colors.blue.shade100, filled: true),
                  onSubmitted: (value) async {
                    projectBloc.add(SelectAProject(int.parse(value)));
                  },
                )
              ])),
        ]),
      );
    });
  }
}

Future<Project> projectEditorDialog(BuildContext context, Project project) {
  int projectId = (project != null) ? project.projectId : 114514;
  DateTime projectDate =
      (project != null) ? project.projectDate : DateTime.now();
  String dancerName = (project != null) ? project.dancerName : '';
  int songId = (project != null) ? project.songId : 114514;
  int shotVersion = (project != null) ? project.shotVersion : 114514;
  int formationVersion = (project != null) ? project.formationVersion : 114514;
  TextEditingController _projectIdController = TextEditingController()
    ..text = projectId.toString();
  TextEditingController _dancerNameController = TextEditingController()
    ..text = dancerName;
  TextEditingController _songIdController = TextEditingController()
    ..text = songId.toString();
  TextEditingController _shotVersionController = TextEditingController()
    ..text = shotVersion.toString();
  TextEditingController _formationVersionController = TextEditingController()
    ..text = formationVersion.toString();
  return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: Text('编辑项目'),
              children: <Widget>[
                Column(children: [
                  Form(
                      child: Column(children: [
                    TextFormField(
                      controller: _projectIdController,
                      decoration: InputDecoration(hintText: '输入项目编号'),
                      onChanged: (value) {
                        projectId = int.parse(value);
                      },
                    ),
                    FlatButton(
                      onPressed: () => showDatePicker(
                        context: context,
                        initialDate: projectDate,
                        firstDate:
                            DateTime.now().subtract(Duration(days: 3650)),
                        lastDate: DateTime.now().add(Duration(days: 3650)),
                      ).then((value) => projectDate = value),
                      child: Text('选择日期'),
                    ),
                    TextFormField(
                      controller: _dancerNameController,
                      decoration: InputDecoration(hintText: '输入舞团名称'),
                      onChanged: (value) {
                        dancerName = value;
                      },
                    ),
                    TextFormField(
                      controller: _songIdController,
                      decoration: InputDecoration(hintText: '输入歌曲编号'),
                      onChanged: (value) {
                        songId = int.parse(value);
                      },
                    ),
                    TextFormField(
                      controller: _shotVersionController,
                      decoration: InputDecoration(hintText: '输入分镜编号'),
                      onChanged: (value) {
                        shotVersion = int.parse(value);
                      },
                    ),
                    TextFormField(
                      controller: _formationVersionController,
                      decoration: InputDecoration(hintText: '输入队形编号'),
                      onChanged: (value) {
                        formationVersion = int.parse(value);
                      },
                    ),
                  ])),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(
                        context,
                        Project(
                            projectId: projectId,
                            projectDate: projectDate,
                            dancerName: dancerName,
                            songId: songId,
                            shotVersion: shotVersion,
                            formationVersion: formationVersion)),
                    child: Text('完成'),
                  ),
                ])
              ],
            );
          }));
}
