class SNFormation {
  String id;
  String name;
  String description;
  DateTime createdTime;
  String creatorId;

  // String projectId; //这个关系不应该给它
  String? songId;

  SNFormation(
      {required this.id,
      required this.name,
      required this.description,
      required this.createdTime,
      required this.creatorId,
      this.songId});

  factory SNFormation.fromMap(Map<String, dynamic> map, String id) {
    return SNFormation(
        id: id,
        name: map['name'],
        description: map['description'],
        createdTime: DateTime.parse(map['createdTime']),
        creatorId: map['creatorId'],
        songId: map['songId']);
  }

  factory SNFormation.initialValue() => SNFormation(
      id: 'initial',
      name: '',
      description: '',
      createdTime: DateTime.now(),
      creatorId: '',
      songId: '');

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdTime': createdTime.toString(),
      'creatorId': creatorId,
      'songId': songId
    };
  }
}
