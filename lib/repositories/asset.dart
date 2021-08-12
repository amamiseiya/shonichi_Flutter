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
  // final databaseProvider = AssetFirestoreProvider();
  final storageProvider = AssetFirebaseProvider();

  // * -------- Simple Functions --------

  // 弃用。目前认为，不需要单独为每个资源添加一个数据库记录，需要的时候直接从存储里读就好了。
  // * -------- Asset CRUD --------
  // Future<List<SNAsset>> retrieveAssetsForSong(String songId) =>
  //     databaseProvider.retrieveAssetsForSong(songId);

  // Future<List<String?>> retrieveAssetForCharacters(
  //         List<SNCharacter> characters, SNAssetType type) =>
  //     databaseProvider.retrieveAssetForCharacters(characters, type);

  // * -------- Asset Loading --------

  // TODO:
  Future<String> importFromAssets(BuildContext context, String ref) {
    return DefaultAssetBundle.of(context).loadString(p.join('assets', ref));
  }

  // * -------- Data Migration --------

  Future<String> importMarkdown(SNProject project) {
    String fileName = project.id + '.md';
    return storageProvider.readAsString('markdowns', fileName);
  }

  Future<void> exportMarkdown(SNProject project, String text) async {
    String fileName = project.id + '.md';
    storageProvider.writeAsString(text, 'markdowns', fileName);
  }

  Future<void> exportJson(String text, String fileName) async {
    storageProvider.writeAsString(text, 'jsons', fileName);
  }
}
