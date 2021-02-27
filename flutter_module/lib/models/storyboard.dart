class SNStoryboard {
  String id;
  String name;
  String creatorId;
  String description;
  DateTime createdTime;

  String? songId;

  SNStoryboard(
      {required this.id,
      required this.name,
      required this.creatorId,
      required this.description,
      required this.createdTime,
      this.songId});

  factory SNStoryboard.fromMap(Map<String, dynamic> map, String id) {
    return SNStoryboard(
      id: id,
      name: map['name'],
      creatorId: map['creatorId'],
      description: map['description'],
      createdTime: DateTime.parse(map['createdTime']),
      songId: map['songId'],
    );
  }

  factory SNStoryboard.initialValue() => SNStoryboard(
      id: 'initial',
      name: '',
      creatorId: '',
      description: '',
      createdTime: DateTime.now(),
      songId: '');

  Map<String, dynamic> toMap() => {
        'name': name,
        'creatorId': creatorId,
        'description': description,
        'createdTime': createdTime.toString(),
        'songId': songId,
      };
}
