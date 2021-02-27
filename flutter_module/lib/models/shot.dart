import 'dart:math';
import 'dart:convert';

import 'character.dart';
import '../utils/data_convert.dart';

class SNShot {
  String id;
  int sceneNumber;
  int shotNumber;
  Duration startTime;
  Duration endTime;
  String lyric;
  String shotType;
  String shotMovement;
  String shotAngle;
  String text;
  String imageURI;
  String comment;

  String storyboardId;
  List<SNCharacter> characters;

  static List<String> titles = [
    '场号',
    '镜号',
    '起始时间',
    '结束时间',
    '歌词',
    '景别',
    '运动',
    '角度',
    '拍摄内容',
    '画面',
    '备注',
    '角色',
  ];

  SNShot(
      {required this.id,
      required this.sceneNumber,
      required this.shotNumber,
      required this.startTime,
      required this.endTime,
      required this.lyric,
      required this.shotType,
      required this.shotMovement,
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
        shotMovement: '',
        shotAngle: '',
        text: '',
        imageURI: '',
        comment: '',
        storyboardId: storyboardId,
        characters: []);
  }

  factory SNShot.fromMap(Map<String, dynamic> map, String id) {
    return SNShot(
      id: id,
      sceneNumber: map['sceneNumber'],
      shotNumber: map['shotNumber'],
      startTime: Duration(milliseconds: map['startTime']),
      endTime: Duration(milliseconds: map['endTime']),
      lyric: map['lyric'],
      shotType: map['shotType'],
      shotMovement: map['shotMovement'],
      shotAngle: map['shotAngle'],
      text: map['text'],
      imageURI: map['imageURI'],
      comment: map['comment'],
      storyboardId: map['storyboardId'],
      characters: map['characters']
          .map<SNCharacter>((cm) => SNCharacter.fromMap(cm))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'sceneNumber': sceneNumber,
        'shotNumber': shotNumber,
        'startTime': startTime.inMilliseconds,
        'endTime': endTime.inMilliseconds,
        'lyric': lyric,
        'shotType': shotType,
        'shotMovement': shotMovement,
        'shotAngle': shotAngle,
        'text': text,
        'imageURI': imageURI,
        'comment': comment,
        'storyboardId': storyboardId,
        'characters': characters.map((character) => character.toMap()).toList(),
      };
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
