import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/asset.dart';
import '../models/character.dart';
import '../models/project.dart';
import '../providers/firestore/firestore.dart';
import '../providers/firebase/asset.dart';

class AssetRepository {
  final databaseProvider = AssetFirestoreProvider();
  final storageProvider = AssetFirebaseProvider();

  // * -------- Simple Functions --------
  Future<String> getImageURI(String id) async =>
      await storageProvider.getImageURI(id);

  // * -------- Asset CRUD --------

  Future<List<SNAsset>> retrieveAssetsForSong(String songId) async =>
      await databaseProvider.retrieveAssetsForSong(songId);

  Future<List<String?>> retrieveAssetForCharacters(
          List<SNCharacter> characters) async =>
      await databaseProvider.retrieveAssetForCharacters(characters);

  // * -------- Asset Loading --------

  // TODO:
  Future<String> importFromAssets(BuildContext context, String ref) async {
    return await DefaultAssetBundle.of(context)
        .loadString(p.join('assets', ref));
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
