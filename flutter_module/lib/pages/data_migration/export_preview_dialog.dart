part of 'data_migration.dart';

class ExportPreviewDialog extends GetView<DataMigrationController> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Confirm Export Content'.tr),
      children: <Widget>[
        Column(children: <Widget>[
          Hero(
            tag: 'Preview',
            child: MarkdownPreview(),
          ),
          Text('将导出的项目数据如上。确定是否继续？'),
          ElevatedButton(
            child: Text('Submit'.tr),
            onPressed: () {
              if (controller.needEncrypt) {
                Get.dialog(DesKeyDialog()).then(
                    (key) => controller.confirmExportMarkdown(key),
                    onError: (_) {});
              } else {
                controller.confirmExportMarkdown(null);
              }
              Get.back();
            },
          ),
        ])
      ],
    );
  }
}

class MarkdownPreview extends GetView<DataMigrationController> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 2 / 3,
            height: MediaQuery.of(context).size.height * 2 / 3,
            child: GetX<DataMigrationController>(builder: (_) {
              if (controller.markdownText.value == null) {
                return Text('No data.');
              }
              return Markdown(data: controller.markdownText.value!);
            })));
  }
}
