import 'package:json_annotation/json_annotation.dart';

part 'storyboard.g.dart';

enum ProjectSubject { Odottemita, Film }

@JsonSerializable()
class SNStoryboard {
  @JsonKey(ignore: true)
  String id;

  String name;
  String creatorId;
  String description;
  DateTime createdTime;
  ProjectSubject projectSubject;

  String? songId;

  SNStoryboard(
      {this.id = 'initial',
      required this.name,
      required this.creatorId,
      required this.description,
      required this.createdTime,
      required this.projectSubject,
      this.songId});

  factory SNStoryboard.initialValue() => SNStoryboard(
      id: 'initial',
      name: '',
      creatorId: '',
      description: '',
      createdTime: DateTime.now(),
      projectSubject: ProjectSubject.Odottemita,
      songId: '');

  factory SNStoryboard.fromJson(Object? map, String id) =>
      _$SNStoryboardFromJson(map as Map<String, dynamic>)..id = id;

  Map<String, dynamic> toJson() => _$SNStoryboardToJson(this);
}
