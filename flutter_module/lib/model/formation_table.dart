class SNFormationTable {
  int id;
  String name;
  int authorId;

  // int projectId; //这个关系不应该给它
  int songId;

  SNFormationTable({this.id, this.name, this.authorId, this.songId});

  factory SNFormationTable.fromMap(Map<String, dynamic> map) {
    return SNFormationTable(
        id: map['id'], name: map['name'], authorId: map['authorId']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'authorId': authorId};
  }
}
