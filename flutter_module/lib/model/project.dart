import 'package:leancloud_storage/leancloud.dart';

class SNProject {
  int id;
  String dancerName;
  DateTime createdTime;
  DateTime modifiedTime;

  int songId;
  int shotTableId;
  int formationTableId;

  SNProject(
      {this.id,
      this.dancerName,
      this.createdTime,
      this.modifiedTime,
      this.songId,
      this.shotTableId,
      this.formationTableId});

  factory SNProject.initialValue() => SNProject(
      id: 114514,
      dancerName: '',
      createdTime: DateTime.now(),
      modifiedTime: DateTime.now(),
      songId: 114514,
      shotTableId: 114514,
      formationTableId: 114514);

  factory SNProject.fromMap(Map<String, dynamic> map) {
    return SNProject(
      id: map['id'],
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
      // id: object.objectId,
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
      'id': id,
      'dancerName': dancerName,
      'createdTime': createdTime.toString(),
      'modifiedTime': modifiedTime.toString(),
      'songId': songId,
      'shotTableId': shotTableId,
      'formationTableId': formationTableId,
    };
  }

  LCObject toLCObject(LCObject object) {
    object['dancerName'] = dancerName;
    object['songId'] = songId;
    object['shotTableId'] = shotTableId;
    object['formationTableId'] = formationTableId;

    return object;
  }
}
