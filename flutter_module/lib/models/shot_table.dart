class SNShotTable {
  String id;
  String name;
  String description;
  String authorId;

  String songId;

  SNShotTable(
      {this.id, this.name, this.description, this.authorId, this.songId});

  factory SNShotTable.fromMap(Map<String, dynamic> map) {
    return SNShotTable(
      name: map['name'],
      description: map['description'],
      authorId: map['authorId'],
      songId: map['songId'],
    );
  }

  factory SNShotTable.initialValue() =>
      SNShotTable(name: '', description: '', authorId: '', songId: '');

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'authorId': authorId,
        'songId': songId,
      };
}
