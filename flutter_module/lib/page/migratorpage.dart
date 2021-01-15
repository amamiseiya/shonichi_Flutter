import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../widget/drawer.dart';
import '../widget/loading.dart';
import '../model/project.dart';
import '../model/song.dart';
import '../bloc/project_bloc.dart';
import '../bloc/song_bloc.dart';
import '../bloc/shot_bloc.dart';
import '../bloc/lyric_bloc.dart';
import '../bloc/migrator_bloc.dart';

class MigratorPage extends StatelessWidget {
  final GlobalKey<ExporterMarkdownState> _documentExporterKey =
      GlobalKey<ExporterMarkdownState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   tooltip: 'Navigation menu',
          //   onPressed: () => Scaffold.of(context).openDrawer(),
          // ),
          title: Text('文档导出'),
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
        body: ExporterMarkdown(key: _documentExporterKey),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Add', // used by assistive technologies
            child: Icon(Icons.add),
            heroTag: 'addFAB',
            onPressed: () {},
          ),
          FloatingActionButton(
              tooltip: 'Delete', // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'deleteFAB',
              onPressed: () {}),
        ]));
  }
}

class ExporterMarkdown extends StatefulWidget {
  ExporterMarkdown({Key key}) : super(key: key);
  @override
  ExporterMarkdownState createState() => ExporterMarkdownState();
}

class ExporterMarkdownState extends State<ExporterMarkdown> {
  ProjectBloc projectBloc;
  SongBloc songBloc;
  LyricBloc lyricBloc;
  ShotBloc shotBloc;
  MigratorBloc migratorBloc;
  Project currentProject;
  Song currentSong;
  bool needEncrypt = false;

  @override
  void initState() {
    projectBloc = BlocProvider.of<ProjectBloc>(context);
    lyricBloc = BlocProvider.of<LyricBloc>(context);
    songBloc = BlocProvider.of<SongBloc>(context);
    shotBloc = BlocProvider.of<ShotBloc>(context);
    migratorBloc = BlocProvider.of<MigratorBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(flex: 2, child: Hero(tag: 'Preview', child: MarkdownPreview())),
      Expanded(
          flex: 1,
          child: Column(children: [
            CheckboxListTile(
                title: Text('导入导出加密：'),
                value: needEncrypt,
                onChanged: (value) =>
                    setState(() => needEncrypt = !needEncrypt)),
            FlatButton(
              child: Text('导入Markdown'),
              onPressed: () async {
                if (needEncrypt) {
                  await desKeyDialog(context)
                      .then((value) => migratorBloc.add(ImportMarkdown(value)));
                } else {
                  migratorBloc.add(ImportMarkdown(null));
                }
                await showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          title: Text('确认内容'),
                          children: <Widget>[
                            Column(children: <Widget>[
                              Hero(
                                tag: 'Preview',
                                child: Container(),
                              ),
                              Text('将导入的项目数据如上。确定是否继续？'),
                              FlatButton(
                                  onPressed: () {
                                    migratorBloc.add(ConfirmImportMarkdown());
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('确认'))
                            ])
                          ],
                        ));
              },
            ),
            FlatButton(
              child: Text('生成Markdown'),
              onPressed: () {
                migratorBloc.add(PreviewMarkdown());
              },
            ),
            FlatButton(
              child: Text('写入文件'),
              onPressed: () {
                if (needEncrypt) {
                  desKeyDialog(context)
                      .then((value) => migratorBloc.add(ExportMarkdown(value)));
                } else {
                  migratorBloc.add(ExportMarkdown(null));
                }
              },
            ),
          ])),
    ]);
  }
}

Future<String> desKeyDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        String key;
        return SimpleDialog(
          title: Text('设定密钥'),
          children: <Widget>[
            Column(children: <Widget>[
              Text('请设定密钥：'),
              TextField(
                onChanged: (value) {
                  key = value;
                },
                controller: TextEditingController()..text = key,
                // inputFormatters: [
                //   WhitelistingTextInputFormatter(
                //       RegExp(r'\S{8}'))
                // ],
                decoration: InputDecoration(hintText: '请输入8位字符。'),
                maxLength: 8,
                maxLengthEnforced: true,
              ),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(key),
                  child: Text('确定'))
            ])
          ],
        );
      });
}

class MarkdownPreview extends StatefulWidget {
  @override
  _MarkdownPreviewState createState() => _MarkdownPreviewState();
}

class _MarkdownPreviewState extends State<MarkdownPreview> {
  MigratorBloc migratorBloc;

  @override
  void initState() {
    migratorBloc = BlocProvider.of<MigratorBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: StreamBuilder(
            stream: migratorBloc.markdownSubject,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Markdown(data: snapshot.data);
              } else {
                return Text('No data.');
              }
            }));
  }
}
