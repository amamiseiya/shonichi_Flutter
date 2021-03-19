import 'dart:math';
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'character.dart';
import '../utils/data_convert.dart';

part 'shot.g.dart';

@JsonSerializable(explicitToJson: true)
class SNShot {
  @JsonKey(ignore: true)
  String id;

  int sceneNumber;
  int shotNumber;
  Duration? startTime;
  Duration? endTime;
  String? lyric;
  String shotType;
  String shotMove;
  String shotAngle;
  String text;
  String imageURI;
  String comment;

  String storyboardId;
  List<SNCharacter> characters;

  SNShot(
      {this.id = 'initial',
      required this.sceneNumber,
      required this.shotNumber,
      this.startTime,
      this.endTime,
      this.lyric,
      required this.shotType,
      required this.shotMove,
      required this.shotAngle,
      required this.text,
      required this.imageURI,
      required this.comment,
      required this.storyboardId,
      required this.characters});

  factory SNShot.initialValue(String storyboardId) {
    // TODO: Implement
    return SNShot(
        id: 'initial',
        sceneNumber: 1010,
        shotNumber: 1,
        startTime: Duration(milliseconds: Random().nextInt(100000)),
        endTime: Duration(milliseconds: Random().nextInt(100000)),
        lyric: '',
        shotType: 'LONG_SHOT',
        shotMove: '',
        shotAngle: '',
        text: '',
        imageURI: '',
        comment: '',
        storyboardId: storyboardId,
        characters: []);
  }

  factory SNShot.fromJson(Map<String, dynamic> map, String id) =>
      _$SNShotFromJson(map)..id = id;

  Map<String, dynamic> toJson() => _$SNShotToJson(this);
}

Map<int, String> shotScenes = {
  1010: '正机位',
  1020: '一般稳定器运镜',
  1030: '一般航拍',
  1040: '特写短镜头',
  1050: '难度极大的镜头',
  1060: 'B-roll',
};

Map<String, String> shotTypes = {
  'CLOSEUP': '特写',
  'MEDIUM_CLOSEUP': '近景',
  'MEDIUM_SHOT': '中景',
  'LONG_SHOT': '全景',
  'VERY_LONG_SHOT': '远景',
};

List<String> shotMoves = [];

Map<String, String> shotAngles = {
  '1': '仰',
  '2': '俯',
  '3': '平',
};
