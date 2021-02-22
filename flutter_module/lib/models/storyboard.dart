class SNStoryboard {
  String id;
  String name;
  String description;
  DateTime createdTime;
  String creatorId;

  String? songId;

  SNStoryboard(
      {required this.id,
      required this.name,
      required this.description,
      required this.createdTime,
      required this.creatorId,
      this.songId});

  factory SNStoryboard.fromMap(Map<String, dynamic> map, String id) {
    return SNStoryboard(
      id: id,
      name: map['name'],
      description: map['description'],
      createdTime: DateTime.parse(map['createdTime']),
      creatorId: map['creatorId'],
      songId: map['songId'],
    );
  }

  factory SNStoryboard.initialValue() => SNStoryboard(
      id: 'initial',
      name: '',
      description: '',
      createdTime: DateTime.now(),
      creatorId: '',
      songId: '');

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'createdTime': createdTime.toString(),
        'creatorId': creatorId,
        'songId': songId,
      };
}
