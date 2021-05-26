import 'package:json_annotation/json_annotation.dart';

import 'character.dart';

part 'lyric.g.dart';

@JsonSerializable(explicitToJson: true)
class SNLyric {
  @JsonKey(ignore: true)
  String id;

  @JsonKey(fromJson: durationFromJson, toJson: durationToJson)
  Duration startTime;
  @JsonKey(fromJson: durationFromJson, toJson: durationToJson)
  Duration endTime;
  String text;

  String songId;
  List<SNCharacter> characters;

  SNLyric(
      {this.id = 'initial',
      required this.startTime,
      required this.endTime,
      required this.text,
      required this.songId,
      required this.characters});

  factory SNLyric.fromJson(Map<String, dynamic> map, String id) =>
      _$SNLyricFromJson(map)..id = id;

  Map<String, dynamic> toJson() => _$SNLyricToJson(this);

  static Duration durationFromJson(int? ms) => Duration(milliseconds: ms ?? 0);

  static int? durationToJson(Duration? duration) => duration?.inMilliseconds;

  static List<SNLyric> parseFromLrc(
      String lrcStr, String songId, int lyricOffset) {
    try {
      // assert(lyricOffset % 100 == 0);
      List<SNLyric> result = lrcStr
          .split('\n')
          .where((row) => RegExp(r'^\[\d{2}').hasMatch(row))
          .map((record) {
        String text = record.substring(record.indexOf(']') + 1);
        String time = record.substring(1, record.indexOf(']'));
        return SNLyric(
            id: 'initial',
            songId: songId,
            text: text,
            startTime: Duration(
              minutes: int.parse(
                time.substring(0, time.indexOf(':')),
              ),
              seconds: int.parse(
                  time.substring(time.indexOf(':') + 1, time.indexOf('.'))),
              milliseconds: int.parse(time.substring(
                          time.indexOf('.') + 1, time.indexOf('.') + 2)) *
                      100 +
                  lyricOffset ~/ 100 * 100,
            ),
            endTime: Duration(),
            characters: []);
      }).toList();

      for (int i = 0; i < result.length - 1; i++) {
        result[i].endTime = result[i + 1].startTime;
      }
      result[result.length - 1].endTime =
          result[result.length - 1].startTime + Duration(seconds: 10);
      return result;
    } catch (e) {
      print(e);
      throw Exception();
    }
  }
}
