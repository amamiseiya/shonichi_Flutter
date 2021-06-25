// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SNProject _$SNProjectFromJson(Map<String, dynamic> json) {
  return SNProject(
    creatorId: json['creatorId'] as String,
    dancerName: json['dancerName'] as String,
    createdTime: DateTime.parse(json['createdTime'] as String),
    modifiedTime: DateTime.parse(json['modifiedTime'] as String),
    songId: json['songId'] as String?,
    storyboardId: json['storyboardId'] as String?,
    formationId: json['formationId'] as String?,
  );
}

Map<String, dynamic> _$SNProjectToJson(SNProject instance) => <String, dynamic>{
      'creatorId': instance.creatorId,
      'dancerName': instance.dancerName,
      'createdTime': instance.createdTime.toIso8601String(),
      'modifiedTime': instance.modifiedTime.toIso8601String(),
      'songId': instance.songId,
      'storyboardId': instance.storyboardId,
      'formationId': instance.formationId,
    };
