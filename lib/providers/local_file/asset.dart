import 'dart:convert' show utf8;
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AssetLocalFileProvider {
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
