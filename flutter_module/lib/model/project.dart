import 'package:leancloud_storage/leancloud.dart';

class SNProject {
  String id;
  String dancerName;
  DateTime createdTime;
  DateTime modifiedTime;

  String songId;
  String shotTableId;
  String formationTableId;

  SNProject(
      {this.id,
      this.dancerName,
      this.createdTime,
      this.modifiedTime,
      this.songId,
      this.shotTableId,
      this.formationTableId});

  factory SNProject.initialValue() => SNProject(
      dancerName: '',
      createdTime: DateTime.now(),
      modifiedTime: DateTime.now(),
      songId: '',
      shotTableId: '',
      formationTableId: '');

  factory SNProject.fromMap(Map<String, dynamic> map) {
    return SNProject(
      dancerName: map['dancerName'],
      createdTime: DateTime.parse(map['createdTime']),
      modifiedTime: DateTime.parse(map['modifiedTime']),
      songId: map['songId'],
      shotTableId: map['shotTableId'],
      formationTableId: map['formationTableId'],
    );
  }

  factory SNProject.fromLCObject(LCObject object) {
    return SNProject(
      dancerName: object['dancerName'],
      createdTime: object.createdAt,
      modifiedTime: object.updatedAt,
      songId: object['songId'],
      shotTableId: object['shotTableId'],
      formationTableId: object['formationTableId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dancerName': dancerName,
      'createdTime': createdTime.toString(),
      'modifiedTime': modifiedTime.toString(),
      'songId': songId,
      'shotTableId': shotTableId,
      'formationTableId': formationTableId,
    };
  }

  void toLCObject(LCObject object) {
    object['dancerName'] = dancerName;
    object['songId'] = songId;
    object['shotTableId'] = shotTableId;
    object['formationTableId'] = formationTableId;
  }
}
