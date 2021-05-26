part of 'data_migration.dart';

class ImportPreviewDialog extends GetView<DataMigrationController> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Confirm Import Content'.tr),
      children: <Widget>[
        Column(children: <Widget>[
          Hero(
            tag: 'Preview',
            child: MarkdownPreview(),
          ),
          Text('将导入的项目数据如上。确定是否继续？'),
          ElevatedButton(
            child: Text('Submit'.tr),
            onPressed: () {
              controller.confirmImportMarkdown();
              Get.back();
            },
          )
        ])
      ],
    );
  }
}
