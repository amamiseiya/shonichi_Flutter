// import 'package:leancloud_storage/leancloud.dart';

import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class SNProject {
  @JsonKey(ignore: true)
  String id;

  String creatorId;
  String dancerName;
  DateTime createdTime;
  DateTime modifiedTime;

  String? songId;
  String? storyboardId;
  String? formationId;

  SNProject(
      {this.id = 'initial',
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

  factory SNProject.fromJson(Map<String, dynamic> map, String id) =>
      _$SNProjectFromJson(map)..id = id;

  Map<String, dynamic> toJson() => _$SNProjectToJson(this);
}
