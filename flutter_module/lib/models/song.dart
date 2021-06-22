import 'package:json_annotation/json_annotation.dart';

import '../utils/data_convert.dart';
import 'asset.dart';

part 'song.g.dart';

@JsonSerializable()
class SNSong {
  @JsonKey(ignore: true)
  String id;

  String name;
  String coverURI;
  Duration duration;
  int lyricOffset;

  String subordinateKikaku;

  SNSong({
    this.id = 'initial',
    required this.name,
    required this.coverURI,
    required this.duration,
    required this.lyricOffset,
    required this.subordinateKikaku,
  });

  factory SNSong.initialValue() => SNSong(
      id: 'initial',
      name: '',
      coverURI: '',
      duration: Duration(),
      lyricOffset: 0,
      subordinateKikaku: '');

  factory SNSong.fromJson(Object? map, String id) =>
      _$SNSongFromJson(map as Map<String, dynamic>)..id = id;

  Map<String, dynamic> toJson() => _$SNSongToJson(this);
}
