part of 'data_migration.dart';


class MarkdownPreview extends GetView<DataMigrationController> {
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
