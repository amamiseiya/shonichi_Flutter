import 'dart:math';
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'character.dart';
import '../utils/data_convert.dart';

part 'shot.g.dart';

@JsonSerializable()
class SNShot {
  @JsonKey(ignore: true)
  String id;

  int sceneNumber;
  int shotNumber;
  Duration startTime;
  Duration endTime;
  String lyric;
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
      required this.startTime,
      required this.endTime,
      required this.lyric,
      required this.shotType,
      required this.shotMove,
      required this.shotAngle,
      required this.text,
      required this.imageURI,
      required this.comment,
      required this.storyboardId,
      required this.characters});

  factory SNShot.initialValue(String storyboardId) {
    return SNShot(
        id: 'initial',
        sceneNumber: 1010,
        shotNumber: 1,
        startTime: Duration(milliseconds: Random().nextInt(100000)),
        endTime: Duration(milliseconds: Random().nextInt(100000)),
        lyric: '',
        shotType: 'VERYLONGSHOT',
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

List<Map<String, dynamic>> shotScenes = [
  {
    'shotSceneLabel': '正机位',
    'shotSceneValue': 1010,
  },
  {
    'shotSceneLabel': '一般稳定器运镜',
    'shotSceneValue': 1020,
  },
  {
    'shotSceneLabel': '一般航拍',
    'shotSceneValue': 1030,
  },
  {
    'shotSceneLabel': '特写短镜头',
    'shotSceneValue': 1040,
  },
  {
    'shotSceneLabel': '难度极大的镜头',
    'shotSceneValue': 1050,
  },
  {
    'shotSceneLabel': 'B-roll',
    'shotSceneValue': 1060,
  },
];

List<Map<String, String>> shotTypes = [
  {'shotTypeLabel': '特写', 'shotTypeValue': 'CLOSEUP'},
  {'shotTypeLabel': '近景', 'shotTypeValue': 'MEDIUMCLOSEUP'},
  {'shotTypeLabel': '中景', 'shotTypeValue': 'MEDIUMSHOT'},
  {'shotTypeLabel': '全景', 'shotTypeValue': 'LONGSHOT'},
  {'shotTypeLabel': '远景', 'shotTypeValue': 'VERYLONGSHOT'},
];
