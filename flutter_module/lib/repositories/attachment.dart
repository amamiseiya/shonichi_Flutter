import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/project.dart';
import '../models/song.dart';
import '../providers/firestore/firestore.dart';

class AttachmentRepository {
  final provider = AttachmentFirestoreProvider();

  Future<String> getImageURL(String id) async => await provider.getImageURL(id);

  Future<String> importMarkdown(SNProject project) async {
    String fileName = project.id.toString() +
        '_' +
        project.songId.toString() +
        '_' +
        project.dancerName +
        '.md';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(appDocDir.path, fileName));
    return file.readAsString(encoding: utf8);
  }

  Future<String> importJsonFromAssets() async {
    return await rootBundle.loadString('assets/example.json');
  }

  Future<void> exportMarkdown(SNProject project, String text) async {
    String fileName = project.id.toString() +
        '_' +
        project.songId.toString() +
        '_' +
        project.dancerName +
        '.md';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(appDocDir.path, fileName));
    await file.writeAsString(text, encoding: utf8);
  }

  Future<void> exportJson(String text) async {
    String fileName = 'export.json';
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(appDocDir.path, fileName));
    await file.writeAsString(text, encoding: utf8);
  }
}
