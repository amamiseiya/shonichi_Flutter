import '../utils/data_convert.dart';
import 'asset.dart';

class SNSong {
  String id;
  String name;
  String coverURI;
  Duration duration;
  int lyricOffset;

  String subordinateKikaku;

  SNSong({
    required this.id,
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

  factory SNSong.fromMap(Map<String, dynamic> map, String id) {
    return SNSong(
      id: id,
      name: map['name'],
      coverURI: map['coverURI'],
      duration: Duration(milliseconds: map['duration']),
      lyricOffset: map['lyricOffset'],
      subordinateKikaku: map['subordinateKikaku'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'coverURI': coverURI,
      'duration': duration.inMilliseconds,
      'lyricOffset': lyricOffset,
      'subordinateKikaku': subordinateKikaku,
    };
  }
}
