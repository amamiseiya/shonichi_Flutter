import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/reg_exp.dart';

part 'character.g.dart';

enum CharacterSerializeMode { Normal, Abbreviation }

@JsonSerializable()
class SNCharacter {
  String name;
  String nameAbbr;
  String? romaji;

  @JsonKey(fromJson: colorFromString, toJson: colorToString)
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

  static Color? colorFromString(String? colorString) =>
      Color(int.parse('0xFF${colorString?.substring(1)}'));

  static String? colorToString(Color? color) =>
      '#${color?.value.toRadixString(16).padLeft(8, '0').substring(2)}';

  factory SNCharacter.fromJson(Map<String, dynamic> map) =>
      _$SNCharacterFromJson(map);

  Map<String, dynamic> toJson() => _$SNCharacterToJson(this);
}
