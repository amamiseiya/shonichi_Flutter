import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/reg_exp.dart';

part 'character.g.dart';

enum SNCharacterSerializeMode { Normal, Abbreviation }

@JsonSerializable()
class SNCharacter {
  String name;
  String nameAbbr;
  String? romaji;

  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  Color? memberColor;

  int? officialOrder;
  String? grade;
  String? group;
  String? teamName;
  String? subordinateKikaku;

  SNCharacter(
      {required this.name,
      required this.nameAbbr,
      this.romaji,
      this.memberColor,
      this.officialOrder,
      this.grade,
      this.group,
      this.teamName,
      this.subordinateKikaku});

  static Color? colorFromJson(String? colorString) =>
      Color(int.parse('0xFF${colorString?.substring(1)}'));

  static String? colorToJson(Color? color) =>
      '#${color?.value.toRadixString(16).padLeft(8, '0').substring(2)}';

  factory SNCharacter.fromJson(Map<String, dynamic> map) =>
      _$SNCharacterFromJson(map);

  Map<String, dynamic> toJson() => _$SNCharacterToJson(this);
}

// 输入角色列表返回String
extension CharacterListToText on List<SNCharacter> {
  String toText({required SNCharacterSerializeMode mode}) {
    String _text = '';
    if (this.isNotEmpty) {
      this.forEach((character) {
        if (mode == SNCharacterSerializeMode.Normal) {
          _text += character.name + ', ';
        }
        if (mode == SNCharacterSerializeMode.Abbreviation) {
          _text += character.nameAbbr + ', ';
        }
      });
      _text = _text.substring(0, _text.lastIndexOf(', '));
    }
    return _text;
  }
}

extension TextToCharacterList on String {
  List<SNCharacter> fromText() {
    return this.split(', ').map((characterName) {
      return SNCharacter(name: characterName, nameAbbr: '');
    }).toList();
  }

// 输入String返回角色列表
// List<SNCharacter> unserializeCharacters(BuildContext context, String str,
//     {required SNCharacterSerializeMode mode}) {
//   if (str != null) {
//     final Iterable<String> csi =
//     str.split(', ').where((row) => characterNameRegExp.hasMatch(row));
//     final List<SNCharacter> cl = [];
//     if (mode == SNCharacterSerializeMode.Normal) {
//       csi.forEach((cs) async {
//         cl.add(await characterController.retrieveFromString(context,
//             name: cs,
//             kikaku: songController.editingSong.value!.subordinateKikaku));
//       });
//       return cl;
//     } else if (mode == SNCharacterSerializeMode.Abbreviation) {
//       csi.forEach((cs) async {
//         cl.add(await characterController.retrieveFromString(context,
//             nameAbbr: cs,
//             kikaku: songController.editingSong.value!.subordinateKikaku));
//       });
//       return cl;
//     } else {
//       throw FormatException();
//     }
//   } else {
//     return [];
//   }
// }
}
