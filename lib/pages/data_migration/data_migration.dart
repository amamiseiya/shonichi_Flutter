import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import '../../widgets/drawer.dart';
import '../../widgets/loading.dart';
import '../../controllers/data_migration.dart';

part 'des_key_dialog.dart';

part 'export_preview_dialog.dart';

part 'import_preview_dialog.dart';

class DataMigrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   tooltip: 'Navigation menu',
          //   onPressed: () => Scaffold.of(context).openDrawer(),
          // ),
          title: Text('Data Migration'.tr),
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

class MarkdownExporter extends GetView<DataMigrationController> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: GetBuilder<DataMigrationController>(
              builder: (_) => CheckboxListTile(
                  title: Text('导入导出加密：'),
                  value: controller.needEncrypt,
                  onChanged: (bool? newValue) {
                    controller.needEncrypt = newValue!;
                    (context as Element).markNeedsBuild();
                  }))),
      Row(children: [
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: Column(children: [
                  ElevatedButton(
                    child: Text('Import Markdown'.tr),
                    onPressed: () async {
                      if (controller.needEncrypt) {
                        Get.dialog(DesKeyDialog()).then(
                            (key) => controller.previewImportMarkdown(key));
                      } else {
                        controller.previewImportMarkdown(null);
                      }
                      await Get.dialog(ImportPreviewDialog());
                    },
                  ),
                  ElevatedButton(
                    child: Text('Import JSON'.tr),
                    onPressed: () async {},
                  ),
                ]))),
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                child: Column(children: [
                  ElevatedButton(
                    child: Text('Export Markdown'.tr),
                    onPressed: () async {
                      controller.previewExportMarkdown();
                      await Get.dialog(ExportPreviewDialog());
                    },
                  ),
                  ElevatedButton(
                    child: Text('Export JSON'.tr),
                    onPressed: () async {},
                  ),
                ]))),
      ])
    ]);
  }
}
