import 'character.dart';

class SNLyric {
  static List<String> titles = ['起始时间', '歌词内容', 'Solo Part'];

  String id;
  Duration startTime;
  Duration endTime;
  String text;

  String songId;
  List<SNCharacter> soloPart;

  SNLyric(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.text,
      required this.songId,
      required this.soloPart});

  factory SNLyric.fromMap(Map<String, dynamic> map, String id) {
    return SNLyric(
        id: id,
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
            soloPart: []);
      }).toList();

      for (int i = 0; i < result.length - 1; i++) {
        result[i].endTime = result[i + 1].startTime;
      }
      result[result.length - 1].endTime =
          result[result.length - 1].startTime + Duration(seconds: 10);
      return result;
    } catch (e) {
      print(e);
      throw FormatException();
    }
  }
}
