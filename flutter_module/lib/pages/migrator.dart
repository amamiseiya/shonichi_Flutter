import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import '../widgets/drawer.dart';
import '../widgets/loading.dart';
import '../controllers/migrator.dart';

class MigratorPage extends StatelessWidget {
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
        body: MarkdownExporter(),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            tooltip: 'Create'.tr, // used by assistive technologies
            child: Icon(Icons.add),
            heroTag: 'CreateFAB',
            onPressed: () {},
          ),
          FloatingActionButton(
              tooltip: 'Delete'.tr, // used by assistive technologies
              child: Icon(Icons.delete),
              heroTag: 'DeleteFAB',
              onPressed: () {}),
        ]));
  }
}

class MarkdownExporter extends GetView<MigratorController> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(flex: 2, child: Hero(tag: 'Preview', child: MarkdownPreview())),
      Expanded(
          flex: 1,
          child: Column(children: [
            GetBuilder(
                builder: (_) => CheckboxListTile(
                    title: Text('导入导出加密：'),
                    value: controller.needEncrypt,
                    onChanged: (newValue) {
                      controller.needEncrypt = newValue;
                      controller.update();
                    })),
            FlatButton(
              child: Text('导入Markdown'),
              onPressed: () async {
                if (controller.needEncrypt) {
                  await desKeyDialog(context)
                      .then((key) => controller.importMarkdown(key));
                } else {
                  controller.importMarkdown(null);
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
                                    controller.confirmImportMarkdown();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Submit'.tr))
                            ])
                          ],
                        ));
              },
            ),
            FlatButton(
              child: Text('生成Markdown'),
              onPressed: () {
                controller.previewMarkdown();
              },
            ),
            FlatButton(
              child: Text('写入文件'),
              onPressed: () {
                if (controller.needEncrypt) {
                  desKeyDialog(context).then(
                      (key) => controller.exportMarkdown(key),
                      onError: (_) {});
                } else {
                  controller.exportMarkdown(null);
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

class MarkdownPreview extends GetView<MigratorController> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: StreamBuilder(
            stream: controller.markdownText.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Markdown(data: snapshot.data);
              } else {
                return Text('No data.');
              }
            }));
  }
}
