class SNAttachment {
  String id;
  String name;
  String uRI;

  String? songId;

  SNAttachment(
      {required this.id, required this.name, required this.uRI, this.songId});

  factory SNAttachment.fromMap(Map<String, dynamic> map, String id) {
    return SNAttachment(
        id: id, name: map['name'], uRI: map['uRI'], songId: map['songId']);
  }
}
