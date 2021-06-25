// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storyboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SNStoryboard _$SNStoryboardFromJson(Map<String, dynamic> json) {
  return SNStoryboard(
    name: json['name'] as String,
    creatorId: json['creatorId'] as String,
    description: json['description'] as String,
    createdTime: DateTime.parse(json['createdTime'] as String),
    projectSubject:
        _$enumDecode(_$ProjectSubjectEnumMap, json['projectSubject']),
    songId: json['songId'] as String?,
  );
}

Map<String, dynamic> _$SNStoryboardToJson(SNStoryboard instance) =>
    <String, dynamic>{
      'name': instance.name,
      'creatorId': instance.creatorId,
      'description': instance.description,
      'createdTime': instance.createdTime.toIso8601String(),
      'projectSubject': _$ProjectSubjectEnumMap[instance.projectSubject],
      'songId': instance.songId,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ProjectSubjectEnumMap = {
  ProjectSubject.Odottemita: 'Odottemita',
  ProjectSubject.Film: 'Film',
};
