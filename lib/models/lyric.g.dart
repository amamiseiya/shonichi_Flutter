// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SNLyric _$SNLyricFromJson(Map<String, dynamic> json) {
  return SNLyric(
    startTime: SNLyric.durationFromJson(json['startTime'] as int?),
    endTime: SNLyric.durationFromJson(json['endTime'] as int?),
    text: json['text'] as String,
    songId: json['songId'] as String,
    characters: (json['characters'] as List<dynamic>)
        .map((e) => SNCharacter.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SNLyricToJson(SNLyric instance) => <String, dynamic>{
      'startTime': SNLyric.durationToJson(instance.startTime),
      'endTime': SNLyric.durationToJson(instance.endTime),
      'text': instance.text,
      'songId': instance.songId,
      'characters': instance.characters.map((e) => e.toJson()).toList(),
    };
