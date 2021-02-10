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
  String image;
  String comment;

  String tableId;
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
      {this.id,
      this.sceneNumber,
      this.shotNumber,
      this.startTime,
      this.endTime,
      this.lyric,
      this.shotType,
      this.shotMovement,
      this.shotAngle,
      this.text,
      this.image,
      this.comment,
      this.tableId,
      this.characters});

  factory SNShot.fromMap(Map<String, dynamic> map) {
    return SNShot(
      sceneNumber: map['sceneNumber'],
      shotNumber: map['shotNumber'],
      startTime: Duration(milliseconds: map['startTime']),
      endTime: Duration(milliseconds: map['endTime']),
      lyric: map['lyric'],
      shotType: map['shotType'],
      shotMovement: map['shotMovement'],
      shotAngle: map['shotAngle'],
      text: map['text'],
      image: map['image'],
      comment: map['comment'],
      tableId: map['tableId'],
      characters: SNCharacter.stringToList(map['characters']),
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
        'image': image,
        'comment': comment,
        'tableId': tableId,
        'characters': SNCharacter.listToString(characters),
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
