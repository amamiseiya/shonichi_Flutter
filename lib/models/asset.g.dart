// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SNAsset _$SNAssetFromJson(Map<String, dynamic> json) {
  return SNAsset(
    name: json['name'] as String,
    type: _$enumDecode(_$SNAssetTypeEnumMap, json['type']),
    uri: json['uri'] as String,
    dataId: json['dataId'] as String,
  );
}

Map<String, dynamic> _$SNAssetToJson(SNAsset instance) => <String, dynamic>{
      'name': instance.name,
      'type': _$SNAssetTypeEnumMap[instance.type],
      'uri': instance.uri,
      'dataId': instance.dataId,
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

const _$SNAssetTypeEnumMap = {
  SNAssetType.CharacterAvatar: 'CharacterAvatar',
  SNAssetType.CharacterFullLengthPhoto: 'CharacterFullLengthPhoto',
  SNAssetType.ShotImage: 'ShotImage',
  SNAssetType.SongVideo: 'SongVideo',
};
