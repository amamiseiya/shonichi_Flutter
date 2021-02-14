class SNShotTable {
  String id;
  String name;
  String description;
  DateTime createdTime;
  String authorId;

  String songId;

  SNShotTable(
      {this.id,
      this.name,
      this.description,
      this.createdTime,
      this.authorId,
      this.songId});

  factory SNShotTable.fromMap(Map<String, dynamic> map) {
    return SNShotTable(
      name: map['name'],
      description: map['description'],
      createdTime: DateTime.parse(map['createdTime']),
      authorId: map['authorId'],
      songId: map['songId'],
    );
  }

  factory SNShotTable.initialValue() => SNShotTable(
      name: '',
      description: '',
      createdTime: DateTime.now(),
      authorId: '',
      songId: '');

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'createdTime': createdTime.toString(),
        'authorId': authorId,
        'songId': songId,
      };
}
