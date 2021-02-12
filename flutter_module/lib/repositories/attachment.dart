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
    String fileName = project.id + '.md';
    return await provider.readAsString('markdowns', fileName);
  }

  Future<String> importJsonFromAssets() async {
    return await rootBundle.loadString('assets/example.json');
  }

  Future<void> exportMarkdown(SNProject project, String text) async {
    String fileName = project.id + '.md';
    await provider.writeAsString(text, 'markdowns', fileName);
  }

  Future<void> exportJson(String text) async {
    final String fileName = 'export.json';
    await provider.writeAsString(text, 'jsons', fileName);
  }
}
