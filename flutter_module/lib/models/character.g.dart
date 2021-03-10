// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SNCharacter _$SNCharacterFromJson(Map<String, dynamic> json) {
  return SNCharacter(
    name: json['name'] as String,
    nameAbbr: json['nameAbbr'] as String,
    romaji: json['romaji'] as String?,
    memberColor: SNCharacter.colorFromString(json['memberColor'] as String?),
    officialOrder: json['officialOrder'] as int?,
    grade: json['grade'] as String?,
    group: json['group'] as String?,
    teamName: json['teamName'] as String?,
    subordinateKikaku: json['subordinateKikaku'] as String?,
  );
}

Map<String, dynamic> _$SNCharacterToJson(SNCharacter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nameAbbr': instance.nameAbbr,
      'romaji': instance.romaji,
      'memberColor': SNCharacter.colorToString(instance.memberColor),
      'officialOrder': instance.officialOrder,
      'grade': instance.grade,
      'group': instance.group,
      'teamName': instance.teamName,
      'subordinateKikaku': instance.subordinateKikaku,
    };
