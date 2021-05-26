import 'dart:convert';

import 'package:get/get.dart';

import '../repositories/asset.dart';

class SNDebugController extends GetxController {
  final AssetRepository assetRepository;

  SNDebugController(this.assetRepository);

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
