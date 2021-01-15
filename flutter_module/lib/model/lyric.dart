import 'character.dart';
import 'formation.dart';

class Lyric {
  int songId;
  Duration startTime;
  Duration endTime;
  String lyricContent;
  List<Character> soloCharacters;

  Lyric(
      {this.songId,
      this.startTime,
      this.endTime,
      this.lyricContent,
      this.soloCharacters});

  factory Lyric.fromMap(Map<String, dynamic> map) {
    return Lyric(
        songId: map['songId'],
        startTime: Duration(milliseconds: map['startTime']),
        endTime: Duration(milliseconds: map['endTime']),
        lyricContent: map['lyricContent'],
        soloCharacters: map['soloCharacters']);
  }

  Map<String, dynamic> toMap() {
    return {
      'songId': songId,
      'startTime': startTime.inMilliseconds,
      'endTime': endTime.inMilliseconds,
      'lyricContent': lyricContent,
      'soloCharacters': soloCharacters
    };
  }

  static List<Lyric> parseFromLrc(String lrcStr, int songId, int lyricOffset) {
    try {
      // assert(lyricOffset % 100 == 0);
      List<Lyric> result = lrcStr
          .split('\n')
          .where((row) => RegExp(r'^\[\d{2}').hasMatch(row))
          .map((record) {
        String lyricContent = record.substring(record.indexOf(']') + 1);
        String time = record.substring(1, record.indexOf(']'));
        return Lyric(
          songId: songId,
          lyricContent: lyricContent,
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
        );
      }).toList();

      for (int i = 0; i < result.length - 1; i++) {
        result[i].endTime = result[i + 1].startTime;
        if (result[i].startTime == result[i + 1].startTime) {
          result[i + 1].startTime += Duration(milliseconds: 100);
        }
      }
      result[result.length - 1].endTime =
          result[result.length - 1].startTime + Duration(minutes: 1);
      return result;
    } catch (e) {
      print(e);
    }
  }
}
