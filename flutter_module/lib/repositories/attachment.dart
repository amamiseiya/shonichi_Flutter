import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/attachment.dart';
import '../models/project.dart';
import '../models/song.dart';
import '../providers/firestore/firestore.dart';

class AttachmentRepository {
  final provider = AttachmentFirestoreProvider();

  // * -------- Simple Functions --------
  Future<String> getImageURI(String id) async => await provider.getImageURI(id);

  // * -------- Attachment For Song CRUD --------

  Future<List<SNAttachment>> retrieveAttachmentsForSong(String songId) async =>
      await provider.retrieveAttachmentsForSong(songId);

  // * -------- Asset Loading --------

  // TODO:
  Future<String> importFromAssets(String path) async {
    return await rootBundle.loadString('assets/' + path);
  }

  // * -------- Data Migration --------

  Future<String> importMarkdown(SNProject project) async {
    String fileName = project.id + '.md';
    return await provider.readAsString('markdowns', fileName);
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
