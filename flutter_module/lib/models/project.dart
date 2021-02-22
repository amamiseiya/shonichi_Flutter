// import 'package:leancloud_storage/leancloud.dart';

class SNProject {
  String id;
  String creatorId;
  String dancerName;
  DateTime createdTime;
  DateTime modifiedTime;

  String? songId;
  String? storyboardId;
  String? formationId;

  SNProject(
      {required this.id,
      required this.creatorId,
      required this.dancerName,
      required this.createdTime,
      required this.modifiedTime,
      this.songId,
      this.storyboardId,
      this.formationId});

  factory SNProject.initialValue() => SNProject(
      id: 'initial',
      creatorId: '',
      dancerName: '',
      createdTime: DateTime.now(),
      modifiedTime: DateTime.now(),
      songId: '',
      storyboardId: '',
      formationId: '');

  factory SNProject.fromMap(Map<String, dynamic> map, String id) {
    return SNProject(
      id: id,
      creatorId: map['creatorId'],
      dancerName: map['dancerName'],
      createdTime: DateTime.parse(map['createdTime']),
      modifiedTime: DateTime.parse(map['modifiedTime']),
      songId: map['songId'],
      storyboardId: map['storyboardId'],
      formationId: map['formationId'],
    );
  }

  // factory SNProject.fromLCObject(LCObject object) {
  //   return SNProject(
  //     id: object.objectId,
  //     dancerName: object['dancerName'],
  //     createdTime: object.createdAt,
  //     modifiedTime: object.updatedAt,
  //     songId: object['songId'],
  //     storyboardId: object['storyboardId'],
  //     formationId: object['formationId'],
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'creatorId': creatorId,
      'dancerName': dancerName,
      'createdTime': createdTime.toString(),
      'modifiedTime': modifiedTime.toString(),
      'songId': songId,
      'storyboardId': storyboardId,
      'formationId': formationId,
    };
  }

  // void toLCObject(LCObject object) {
  //   object['dancerName'] = dancerName;
  //   object['songId'] = songId;
  //   object['storyboardId'] = storyboardId;
  //   object['formationId'] = formationId;
  // }
}
