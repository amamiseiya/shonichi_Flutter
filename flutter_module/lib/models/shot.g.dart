// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SNShot _$SNShotFromJson(Map<String, dynamic> json) {
  return SNShot(
    sceneNumber: json['sceneNumber'] as int,
    shotNumber: json['shotNumber'] as int,
    startTime: json['startTime'] == null
        ? null
        : Duration(microseconds: json['startTime'] as int),
    endTime: json['endTime'] == null
        ? null
        : Duration(microseconds: json['endTime'] as int),
    lyric: json['lyric'] as String?,
    shotType: json['shotType'] as String,
    shotMove: json['shotMove'] as String,
    shotAngle: json['shotAngle'] as String,
    text: json['text'] as String,
    imageURI: json['imageURI'] as String,
    comment: json['comment'] as String,
    storyboardId: json['storyboardId'] as String,
    characters: (json['characters'] as List<dynamic>)
        .map((e) => SNCharacter.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SNShotToJson(SNShot instance) => <String, dynamic>{
      'sceneNumber': instance.sceneNumber,
      'shotNumber': instance.shotNumber,
      'startTime': instance.startTime?.inMicroseconds,
      'endTime': instance.endTime?.inMicroseconds,
      'lyric': instance.lyric,
      'shotType': instance.shotType,
      'shotMove': instance.shotMove,
      'shotAngle': instance.shotAngle,
      'text': instance.text,
      'imageURI': instance.imageURI,
      'comment': instance.comment,
      'storyboardId': instance.storyboardId,
      'characters': instance.characters.map((e) => e.toJson()).toList(),
    };
