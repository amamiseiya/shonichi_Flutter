class SNFormationTable {
  String id;
  String name;
  String authorId;

  // String projectId; //这个关系不应该给它
  String songId;

  SNFormationTable({this.id, this.name, this.authorId, this.songId});

  factory SNFormationTable.fromMap(Map<String, dynamic> map) {
    return SNFormationTable(
        name: map['name'], authorId: map['authorId'], songId: map['songId']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'authorId': authorId, 'songId': songId};
  }
}
