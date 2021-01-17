class SNFormationTable {
  int id;
  String name;
  int authorId;

  // int projectId; //这个关系不应该给它
  int songId;

  SNFormationTable({this.id, this.name, this.authorId, this.songId});
}
