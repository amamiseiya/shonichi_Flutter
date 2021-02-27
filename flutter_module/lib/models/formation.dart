class SNFormation {
  String id;
  String name;
  String creatorId;
  String description;
  DateTime createdTime;

  // String projectId; //这个关系不应该给它
  String? songId;

  SNFormation(
      {required this.id,
      required this.name,
      required this.creatorId,
      required this.description,
      required this.createdTime,
      this.songId});

  factory SNFormation.fromMap(Map<String, dynamic> map, String id) {
    return SNFormation(
        id: id,
        name: map['name'],
        creatorId: map['creatorId'],
        description: map['description'],
        createdTime: DateTime.parse(map['createdTime']),
        songId: map['songId']);
  }

  factory SNFormation.initialValue() => SNFormation(
      id: 'initial',
      name: '',
      creatorId: '',
      description: '',
      createdTime: DateTime.now(),
      songId: '');

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'creatorId': creatorId,
      'description': description,
      'createdTime': createdTime.toString(),
      'songId': songId
    };
  }
}
