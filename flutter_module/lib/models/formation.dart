import 'package:json_annotation/json_annotation.dart';

part 'formation.g.dart';

@JsonSerializable()
class SNFormation {
  @JsonKey(ignore: true)
  String id;

  String name;
  String creatorId;
  String description;
  DateTime createdTime;

  // String projectId; //这个关系不应该给它
  String? songId;

  SNFormation(
      {this.id = 'initial',
      required this.name,
      required this.creatorId,
      required this.description,
      required this.createdTime,
      this.songId});

  factory SNFormation.initialValue() => SNFormation(
      id: 'initial',
      name: '',
      creatorId: '',
      description: '',
      createdTime: DateTime.now(),
      songId: '');

  factory SNFormation.fromJson(Object? map, String id) =>
      _$SNFormationFromJson(map as Map<String, dynamic>)..id = id;

  Map<String, dynamic> toJson() => _$SNFormationToJson(this);
}
