import 'character.dart';
import '../util/data_convert.dart';

class Shot {
  int songId;
  int shotVersion;
  String shotName;
  Duration startTime;
  Duration endTime;
  int shotNumber;
  String shotLyric;
  int shotScene;
  List<Character> shotCharacters;
  String shotType;
  String shotMovement;
  String shotAngle;
  String shotContent;
  String shotImage;
  String shotComment;

  static List<String> titles = [
    '镜号',
    '起始时间',
    '歌词内容',
    '场号',
    '角色',
    '景别',
    '运动',
    '角度',
    '拍摄内容',
    '画面',
    '备注'
  ];

  Shot(
      {this.songId,
      this.shotVersion,
      this.shotName,
      this.startTime,
      this.endTime,
      this.shotNumber,
      this.shotLyric,
      this.shotScene,
      this.shotCharacters,
      this.shotType,
      this.shotMovement,
      this.shotAngle,
      this.shotContent,
      this.shotImage,
      this.shotComment});

  factory Shot.fromMap(Map<String, dynamic> map) {
    return Shot(
      songId: map['songId'],
      shotVersion: map['shotVersion'],
      shotName: map['shotName'],
      startTime: Duration(milliseconds: map['startTime']),
      endTime: Duration(milliseconds: map['endTime']),
      shotNumber: map['shotNumber'],
      shotLyric: map['shotLyric'],
      shotScene: map['shotScene'],
      shotCharacters: Character.stringToList(map['shotCharacters']),
      shotType: map['shotType'],
      shotMovement: map['shotMovement'],
      shotAngle: map['shotAngle'],
      shotContent: map['shotContent'],
      shotImage: map['shotImage'],
      shotComment: map['shotComment'],
    );
  }

  Map<String, dynamic> toMap() => {
        'songId': songId,
        'shotVersion': shotVersion,
        'shotName': shotName,
        'startTime': startTime.inMilliseconds,
        'endTime': endTime.inMilliseconds,
        'shotNumber': shotNumber,
        'shotLyric': shotLyric,
        'shotScene': shotScene,
        'shotCharacters': Character.listToString(shotCharacters),
        'shotType': shotType,
        'shotMovement': shotMovement,
        'shotAngle': shotAngle,
        'shotContent': shotContent,
        'shotImage': shotImage,
        'shotComment': shotComment,
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
