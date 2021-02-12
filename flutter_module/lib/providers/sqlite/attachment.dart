part of 'sqlite.dart';

class AttachmentSQLiteProvider extends SQLiteProvider {
  Future<void> writeAsString(
      String text, String folder, String fileName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(appDocDir.path, folder, fileName));
    await file.writeAsString(text, encoding: utf8);
  }

  Future<String> readAsString(
      String text, String folder, String fileName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(appDocDir.path, folder, fileName));
    return file.readAsString(encoding: utf8);
  }
}
