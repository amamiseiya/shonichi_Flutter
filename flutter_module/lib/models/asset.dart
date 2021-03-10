class SNAsset {
  String id;
  String name;
  String uRI;

  String dataId;

  SNAsset(
      {required this.id,
      required this.name,
      required this.uRI,
      required this.dataId});

  factory SNAsset.fromJson(Map<String, dynamic> map, String id) {
    return SNAsset(
        id: id, name: map['name'], uRI: map['uRI'], dataId: map['dataId']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'uRI': uRI, 'dataId': dataId};
  }
}
