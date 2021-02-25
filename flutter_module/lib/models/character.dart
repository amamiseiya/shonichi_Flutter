import 'package:flutter/material.dart';

import '../utils/reg_exp.dart';

enum CharacterSerializeMode { Normal, Abbreviation }

class SNCharacter {
  String name;
  String nameAbbr;
  Color? memberColor;
  int? officialOrder;
  String? grade;
  String? group;
  String? teamName;
  String? subordinateKikaku;

  SNCharacter(
      {required this.name,
      required this.nameAbbr,
      this.memberColor,
      this.officialOrder,
      this.grade,
      this.group,
      this.teamName,
      this.subordinateKikaku});

  factory SNCharacter.fromMap(Map<String, dynamic> map) {
    return SNCharacter(
        name: map['name'],
        nameAbbr: map['nameAbbr'],
        memberColor: Color(int.parse(map['memberColor'])),
        officialOrder: map['officialOrder'],
        grade: map['grade'],
        group: map['group'],
        teamName: map['teamName'],
        subordinateKikaku: map['subordinateKikaku']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameAbbr': nameAbbr,
      'memberColor':
          '0x${memberColor?.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      'officialOrder': officialOrder,
      'grade': grade,
      'group': group,
      'teamName': teamName,
      'subordinateKikaku': subordinateKikaku
    };
  }
}
