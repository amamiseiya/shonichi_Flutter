class SNFormationTable {
  String id;
  String name;
  String description;
  String authorId;

  // String projectId; //这个关系不应该给它
  String songId;

  SNFormationTable(
      {this.id, this.name, this.description, this.authorId, this.songId});

  factory SNFormationTable.fromMap(Map<String, dynamic> map) {
    return SNFormationTable(
        name: map['name'],
        description: map['description'],
        authorId: map['authorId'],
        songId: map['songId']);
  }

  factory SNFormationTable.initialValue() =>
      SNFormationTable(name: '', description: '', authorId: '', songId: '');

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'authorId': authorId,
      'songId': songId
    };
  }
}
