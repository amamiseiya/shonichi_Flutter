import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

enum SNAssetType {
  CharacterAvatar,
  CharacterFullLengthPhoto,
  CharacterHalfLengthPhoto,
  ShotImage,
  SongVideo
}

@JsonSerializable()
class SNAsset {
  // 弃用。目前认为，不需要单独为每个资源添加一个数据库记录，需要的时候直接从存储里读就好了。
  // // 暂时先不标注不serialize id了吧？ // 算了还是标上吧
  // @JsonKey(ignore: true)
  // String id;
  // String name;
  // SNAssetType type;
  // String uri;

  // String dataId;

  // SNAsset(
  //     {this.id = 'initial',
  //     required this.name,
  //     required this.type,
  //     required this.uri,
  //     required this.dataId});

  // factory SNAsset.fromJson(Object? map, String id) =>
  //     _$SNAssetFromJson(map as Map<String, dynamic>)..id = id;

  // Map<String, dynamic> toJson() => _$SNAssetToJson(this);
}
