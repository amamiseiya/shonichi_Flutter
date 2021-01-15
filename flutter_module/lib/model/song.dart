import '../util/data_convert.dart';

class Song {
  int songId;
  String songName;
  String subordinateKikaku;
  int lyricOffset;
  String coverFileName;
  List<String> videoIntros;
  List<String> videoFileNames;
  List<int> videoOffsets;

  static List<String> titles = ['起始时间', '歌词内容', 'Solo Part'];

  Song(
      {this.songId,
      this.songName,
      this.subordinateKikaku,
      this.lyricOffset,
      this.coverFileName,
      this.videoIntros,
      this.videoFileNames,
      this.videoOffsets});

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
        songId: map['songId'],
        songName: map['songName'],
        subordinateKikaku: map['subordinateKikaku'],
        lyricOffset: map['lyricOffset'],
        coverFileName: map['coverFileName'],
        videoIntros: stringToList(map['videoIntros']),
        videoFileNames: stringToList(map['videoFileNames']),
        videoOffsets: stringToIntList(map['videoOffsets']));
  }

  Map<String, dynamic> toMap() {
    return {
      'songId': songId,
      'songName': songName,
      'subordinateKikaku': subordinateKikaku,
      'lyricOffset': lyricOffset,
      'coverFileName': coverFileName,
      'videoIntros': listToString(videoIntros),
      'videoFileNames': listToString(videoFileNames),
      'videoOffsets': intListToString(videoOffsets)
    };
  }
}
