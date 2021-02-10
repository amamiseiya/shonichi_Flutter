import '../utils/data_convert.dart';
import 'attachment.dart';

class SNSong {
  String id;
  String name;
  String coverId;
  int lyricOffset;

  String subordinateKikaku;

  static List<String> titles = ['起始时间', '歌词内容', 'Solo Part'];

  SNSong({
    this.id,
    this.name,
    this.coverId,
    this.lyricOffset,
    this.subordinateKikaku,
    // this.videoIntros,
    // this.videoFileNames,
    // this.videoOffsets
  });

  factory SNSong.initialValue() =>
      SNSong(name: '', coverId: '', lyricOffset: 0, subordinateKikaku: '');

  factory SNSong.fromMap(Map<String, dynamic> map) {
    return SNSong(
      name: map['name'],
      coverId: map['coverId'],
      lyricOffset: map['lyricOffset'],
      subordinateKikaku: map['subordinateKikaku'],
      // videoIntros: stringToList(map['videoIntros']),
      // videoFileNames: stringToList(map['videoFileNames']),
      // videoOffsets: stringToIntList(map['videoOffsets'])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'coverId': coverId,
      'lyricOffset': lyricOffset,
      'subordinateKikaku': subordinateKikaku,
      // 'videoIntros': listToString(videoIntros),
      // 'videoFileNames': listToString(videoFileNames),
      // 'videoOffsets': intListToString(videoOffsets)
    };
  }
}
