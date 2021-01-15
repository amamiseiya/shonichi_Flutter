import 'dart:io';
import 'dart:convert';

import 'package:path/path.dart' as ppath;
import 'package:path_provider/path_provider.dart';

import '../model/project.dart';
import '../model/song.dart';

class StorageRepository {
  Future<File> getSongCoverFile(Song song) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    return File(ppath.join(appDocDir.path, song.songName, song.coverFileName));
  }

  Future<String> importMarkdown(Project project) async {
    String fileName = project.projectId.toString() +
        '_' +
        project.songId.toString() +
        '_' +
        project.dancerName +
        '.md';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File file = File(ppath.join(appDocDir.path, fileName));
    return file.readAsString(encoding: utf8);
  }

  Future<void> exportMarkdown(Project project, String text) async {
    String fileName = project.projectId.toString() +
        '_' +
        project.songId.toString() +
        '_' +
        project.dancerName +
        '.md';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File file = File(ppath.join(appDocDir.path, fileName));
    await file.writeAsString(text, encoding: utf8);
  }
}
