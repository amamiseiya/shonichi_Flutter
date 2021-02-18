class SNStoryboard {
  String id;
  String name;
  String description;
  DateTime createdTime;
  String authorId;

  String? songId;

  SNStoryboard(
      {required this.id,
      required this.name,
      required this.description,
      required this.createdTime,
      required this.authorId,
      this.songId});

  factory SNStoryboard.fromMap(Map<String, dynamic> map, String id) {
    return SNStoryboard(
      id: id,
      name: map['name'],
      description: map['description'],
      createdTime: DateTime.parse(map['createdTime']),
      authorId: map['authorId'],
      songId: map['songId'],
    );
  }

  factory SNStoryboard.initialValue() => SNStoryboard(
      id: 'initial',
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
