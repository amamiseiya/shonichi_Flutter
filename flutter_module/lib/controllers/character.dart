import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/character.dart';
import '../models/kikaku.dart';
import '../models/song.dart';
import 'project.dart';
import 'song.dart';
import '../repositories/asset.dart';
import '../utils/reg_exp.dart';
import '../utils/data_convert.dart';

enum CharacterOrdering {
  Grade,
}

class CharacterController extends GetxController {
  final SongController songController = Get.find();

  final AssetRepository assetRepository;

  late Worker worker;
  // 要么editingSong未初始化时值为null，要么加载到对应的角色，List为空则有异常
  Rx<List<SNCharacter>?> editingCharacters = Rx<List<SNCharacter>?>(null);
  CharacterController(this.assetRepository);

  void onInit() {
    super.onInit();
    worker = ever(songController.editingSong, (SNSong? song) async {
      if (song == null) {
        editingCharacters.nil();
      } else if (song != null) {
        editingCharacters(await retrieveForKikaku(
            Get.context, song.subordinateKikaku,
            orderBy: CharacterOrdering.Grade));
      }
    });
  }

  List<SNKikaku> get kikakus => [
        SNKikaku.ll(),
        SNKikaku.llss(),
        SNKikaku.nijigaku(),
        SNKikaku.shoujokageki(),
        SNKikaku.nananiji(),
        SNKikaku.akb48()
      ];

  Future<SNCharacter> retrieveFromString(BuildContext context,
      {String? name, String? nameAbbr, String? kikaku}) async {
    // ! 尽管能用，但并不该用
    final map = Map<String, List>.from(json.decode(await assetRepository
        .importFromAssets(context, 'character_data.json')));
    if (name != null && kikaku != null) {
      final result =
          map[kikaku]!.where((character) => character['name'] == name);
      if (result.length == 1) {
        return SNCharacter.fromMap(result.first);
      } else {
        throw FormatException();
      }
    } else if (nameAbbr != null && kikaku != null) {
      final result =
          map[kikaku]!.where((character) => character['nameAbbr'] == nameAbbr);
      if (result.length == 1) {
        return SNCharacter.fromMap(result.first);
      } else {
        throw FormatException();
      }
    } else {
      throw FormatException();
    }
  }

  Future<Map<SNCharacter, String?>> fetchImages(
      List<SNCharacter> characters) async {
    final images = await assetRepository.retrieveAssetForCharacters(characters);
    return Map.fromIterables(characters, images);
  }

  Future<List<SNCharacter>> retrieveForKikaku(
      BuildContext context, String kikaku,
      {CharacterOrdering? orderBy}) async {
    final map = Map<String, List>.from(json.decode(await assetRepository
        .importFromAssets(context, 'character_data.json')));
    if (map[kikaku] != null) {
      return map[kikaku]!.map((c) => SNCharacter.fromMap(c)).toList();
    } else {
      throw FormatException();
    }
  }

  void exportJson() async {
    final map = {
      '(undefined)': [],
      'ラブライブ！': [],
      'ラブライブ！サンシャイン!!': [],
      'ラブライブ！虹ヶ咲学園スクールアイドル同好会': [],
      '少女☆歌劇 レヴュー・スタァライト': [],
      '22/7': [],
      'AKB48': [],
    };

    await assetRepository.exportJson(
        json.encode(map), 'character_data_export.json');
  }
}
