class Project {
  int projectId;
  DateTime projectDate;
  String dancerName;
  int songId;
  int shotVersion;
  int formationVersion;

  Project(
      {this.projectId,
      this.projectDate,
      this.dancerName,
      this.songId,
      this.shotVersion,
      this.formationVersion});

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      projectId: map['projectId'],
      projectDate: DateTime.parse(map['projectDate']),
      dancerName: map['dancerName'],
      songId: map['songId'],
      shotVersion: map['shotVersion'],
      formationVersion: map['formationVersion'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'projectDate': projectDate.toString(),
      'dancerName': dancerName,
      'songId': songId,
      'shotVersion': shotVersion,
      'formationVersion': formationVersion,
    };
  }
}
