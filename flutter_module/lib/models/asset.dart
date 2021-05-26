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
  // 暂时先不标注不serialize id了吧？ // 算了还是标上吧
  @JsonKey(ignore: true)
  String id;
  String name;
  SNAssetType type;
  String uri;

  String dataId;

  SNAsset(
      {this.id = 'initial',
      required this.name,
      required this.type,
      required this.uri,
      required this.dataId});

  factory SNAsset.fromJson(Map<String, dynamic> map, String id) =>
      _$SNAssetFromJson(map)..id = id;

  Map<String, dynamic> toJson() => _$SNAssetToJson(this);
}
