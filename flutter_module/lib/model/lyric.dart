import 'character.dart';

class SNLyric {
  String id;
  Duration startTime;
  Duration endTime;
  String text;

  String songId;
  List<SNCharacter> soloPart;

  SNLyric(
      {this.id,
      this.startTime,
      this.endTime,
      this.text,
      this.songId,
      this.soloPart});

  factory SNLyric.fromMap(Map<String, dynamic> map) {
    return SNLyric(
        startTime: Duration(milliseconds: map['startTime']),
        endTime: Duration(milliseconds: map['endTime']),
        text: map['text'],
        songId: map['songId'],
        soloPart: map['soloPart']);
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.inMilliseconds,
      'endTime': endTime.inMilliseconds,
      'text': text,
      'songId': songId,
      'soloPart': soloPart
    };
  }

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
