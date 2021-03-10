// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SNSong _$SNSongFromJson(Map<String, dynamic> json) {
  return SNSong(
    name: json['name'] as String,
    coverURI: json['coverURI'] as String,
    duration: Duration(microseconds: json['duration'] as int),
    lyricOffset: json['lyricOffset'] as int,
    subordinateKikaku: json['subordinateKikaku'] as String,
  );
}

Map<String, dynamic> _$SNSongToJson(SNSong instance) => <String, dynamic>{
      'name': instance.name,
      'coverURI': instance.coverURI,
      'duration': instance.duration.inMicroseconds,
      'lyricOffset': instance.lyricOffset,
      'subordinateKikaku': instance.subordinateKikaku,
    };
