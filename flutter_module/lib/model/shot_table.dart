class SNShotTable {
  int id;
  String name;
  int authorId;

  int songId;

  SNShotTable({this.id, this.name, this.authorId, this.songId});

  factory SNShotTable.fromMap(Map<String, dynamic> map) {
    return SNShotTable(
      id: map['id'],
      name: map['name'],
      authorId: map['authorId'],
      songId: map['songId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'authorId': authorId,
        'songId': songId,
      };
}
