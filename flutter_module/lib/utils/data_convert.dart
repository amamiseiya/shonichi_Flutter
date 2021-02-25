enum SerializeMode { Normal, Abbreviation }

String listToString(List<String> list) {
  String str = '';
  for (String record in list) {
    str += record + ',';
  }
  return str;
}

String intListToString(List<int> list) {
  String str = '';
  for (int record in list) {
    str += record.toString() + ',';
  }
  return str;
}

List<String> stringToList(String str) {
  return str
      .split(',')
      .where((row) => RegExp(r'\S+').hasMatch(row))
      .map((record) {
    return record;
  }).toList();
}

List<int> stringToIntList(String str) {
  return str
      .split(',')
      .where((row) => RegExp(r'\d+').hasMatch(row))
      .map((record) {
    return int.parse(record);
  }).toList();
}

Duration simpleDurationToDuration(String str) {
  final String minutes = RegExp(r'\d(?=:)').stringMatch(str)!;
  final String seconds = RegExp(r'\d\d(?=\.)').stringMatch(str)!;
  final String milliseconds = RegExp(r'(?<=\.)\d\d\d').stringMatch(str)!;
  return Duration(
      minutes: int.parse(minutes),
      seconds: int.parse(seconds),
      milliseconds: int.parse(milliseconds));
}
