class SNShotTable {
  String id;
  String name;
  String authorId;

  String songId;

  SNShotTable({this.id, this.name, this.authorId, this.songId});

  factory SNShotTable.fromMap(Map<String, dynamic> map) {
    return SNShotTable(
      name: map['name'],
      authorId: map['authorId'],
      songId: map['songId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'authorId': authorId,
        'songId': songId,
      };
}
