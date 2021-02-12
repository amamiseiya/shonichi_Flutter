import '../utils/data_convert.dart';
import 'attachment.dart';

class SNSong {
  String id;
  String name;
  String coverId;
  Duration duration;
  int lyricOffset;

  String subordinateKikaku;

  SNSong({
    this.id,
    this.name,
    this.coverId,
    this.duration,
    this.lyricOffset,
    this.subordinateKikaku,
  });

  factory SNSong.initialValue() => SNSong(
      name: '',
      coverId: '',
      duration: Duration(),
      lyricOffset: 0,
      subordinateKikaku: '');

  factory SNSong.fromMap(Map<String, dynamic> map) {
    return SNSong(
      name: map['name'],
      coverId: map['coverId'],
      duration: Duration(milliseconds: map['duration']),
      lyricOffset: map['lyricOffset'],
      subordinateKikaku: map['subordinateKikaku'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'coverId': coverId,
      'duration': duration.inMilliseconds,
      'lyricOffset': lyricOffset,
      'subordinateKikaku': subordinateKikaku,
    };
  }
}
