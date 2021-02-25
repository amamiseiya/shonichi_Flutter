import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/attachment.dart';
import '../models/project.dart';
import '../models/song.dart';
import '../providers/firestore/firestore.dart';
import '../providers/firebase/attachment.dart';

class AttachmentRepository {
  final databaseProvider = AttachmentFirestoreProvider();
  final storageProvider = AttachmentFirebaseProvider();

  // * -------- Simple Functions --------
  Future<String> getImageURI(String id) async =>
      await storageProvider.getImageURI(id);

  // * -------- Attachment For Song CRUD --------

  Future<List<SNAttachment>> retrieveAttachmentsForSong(String songId) async =>
      await databaseProvider.retrieveAttachmentsForSong(songId);

  // * -------- Asset Loading --------

  // TODO:
  Future<String> importFromAssets(String ref) async {
    return await rootBundle.loadString(p.join('assets', ref));
  }

  // * -------- Data Migration --------

  Future<String> importMarkdown(SNProject project) async {
    String fileName = project.id + '.md';
    return await storageProvider.readAsString('markdowns', fileName);
  }

  Future<void> exportMarkdown(SNProject project, String text) async {
    String fileName = project.id + '.md';
    await storageProvider.writeAsString(text, 'markdowns', fileName);
  }

  Future<void> exportJson(String text, String fileName) async {
    await storageProvider.writeAsString(text, 'jsons', fileName);
  }
}
