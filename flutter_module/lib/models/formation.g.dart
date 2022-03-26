// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SNFormation _$SNFormationFromJson(Map<String, dynamic> json) {
  return SNFormation(
    name: json['name'] as String,
    creatorId: json['creatorId'] as String,
    description: json['description'] as String,
    createdTime: DateTime.parse(json['createdTime'] as String),
    songId: json['songId'] as String?,
  );
}

Map<String, dynamic> _$SNFormationToJson(SNFormation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'creatorId': instance.creatorId,
      'description': instance.description,
      'createdTime': instance.createdTime.toIso8601String(),
      'songId': instance.songId,
    };
