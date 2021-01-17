import 'package:flutter/material.dart';

import '../util/reg_exp.dart';

class SNCharacter {
  String name;
  String nameAbbr;
  Color memberColor;
  String grade;
  String group;

  String teamName;

  SNCharacter(
      {this.name,
      this.nameAbbr,
      this.memberColor,
      this.grade,
      this.group,
      this.teamName});

  // 返回按年级排列的企划成员
  static List<SNCharacter> membersSortedByGrade(String teamName) {
    switch (teamName) {
      case 'μ\'s':
        return [
          SNCharacter.rin(),
          SNCharacter.maki(),
          SNCharacter.hanayo(),
          SNCharacter.honoka(),
          SNCharacter.kotori(),
          SNCharacter.umi(),
          SNCharacter.eli(),
          SNCharacter.nozomi(),
          SNCharacter.nico()
        ];
      case 'Aqours':
        return [
          SNCharacter.yoshiko(),
          SNCharacter.hanamaru(),
          SNCharacter.ruby(),
          SNCharacter.chika(),
          SNCharacter.riko(),
          SNCharacter.you(),
          SNCharacter.kanan(),
          SNCharacter.dia(),
          SNCharacter.mari()
        ];
      case 'スタァライト九九組':
        return [
          SNCharacter.karen(),
          SNCharacter.hikari(),
          SNCharacter.maya(),
          SNCharacter.junna(),
          SNCharacter.mahiru(),
          SNCharacter.nana(),
          SNCharacter.kuro(),
          SNCharacter.futaba(),
          SNCharacter.kaoruko()
        ];
    }
    return [];
  }

  // 输入全名返回角色
  factory SNCharacter.fromString(String name) {
    switch (name) {
      case '高坂 穂乃果':
        return SNCharacter.honoka();
      case '絢瀬 絵里':
        return SNCharacter.eli();
      case '南 ことり':
        return SNCharacter.kotori();
      case '園田 海未':
        return SNCharacter.umi();
      case '星空 凛':
        return SNCharacter.rin();
      case '西木野 真姫':
        return SNCharacter.maki();
      case '東條 希':
        return SNCharacter.nozomi();
      case '小泉 花陽':
        return SNCharacter.hanayo();
      case '矢澤 にこ':
        return SNCharacter.nico();
      case '高海 千歌':
        return SNCharacter.chika();
      case '桜内 梨子':
        return SNCharacter.riko();
      case '松浦 果南':
        return SNCharacter.kanan();
      case '黒澤 ダイヤ':
        return SNCharacter.dia();
      case '渡辺 曜':
        return SNCharacter.you();
      case '津島 善子':
        return SNCharacter.yoshiko();
      case '国木田 花丸':
        return SNCharacter.hanamaru();
      case '小原 鞠莉':
        return SNCharacter.mari();
      case '黒澤 ルビィ':
        return SNCharacter.ruby();
      case '愛城 華恋':
        return SNCharacter.karen();
      case '神楽 ひかり':
        return SNCharacter.hikari();
      case '天堂 真矢':
        return SNCharacter.maya();
      case '星見 純那':
        return SNCharacter.junna();
      case '露崎 まひる':
        return SNCharacter.mahiru();
      case '大場 なな':
        return SNCharacter.nana();
      case '西條 クロディーヌ':
        return SNCharacter.kuro();
      case '石動 双葉':
        return SNCharacter.futaba();
      case '花柳 香子':
        return SNCharacter.kaoruko();
    }
    return null;
  }

  factory SNCharacter.fromAbbrString(String nameAbbr, String teamName) {
    switch (teamName) {
      case 'μ\'s':
        switch (nameAbbr) {
          case '果':
            return SNCharacter.honoka();
          case '绘':
            return SNCharacter.eli();
          case '鸟':
            return SNCharacter.kotori();
          case '海':
            return SNCharacter.umi();
          case '凛':
            return SNCharacter.rin();
          case '姬':
            return SNCharacter.maki();
          case '希':
            return SNCharacter.nozomi();
          case '花':
            return SNCharacter.hanayo();
          case '妮':
            return SNCharacter.nico();
        }
        break;
      case 'Aqours':
        switch (nameAbbr) {
          case '千':
            return SNCharacter.chika();
          case '梨':
            return SNCharacter.riko();
          case '南':
            return SNCharacter.kanan();
          case '黛':
            return SNCharacter.dia();
          case '曜':
            return SNCharacter.you();
          case '善':
            return SNCharacter.yoshiko();
          case '丸':
            return SNCharacter.hanamaru();
          case '鞠':
            return SNCharacter.mari();
          case '露':
            return SNCharacter.ruby();
        }
        break;
      case 'スタァライト九九組':
        switch (nameAbbr) {
          case '恋':
            return SNCharacter.karen();
          case '光':
            return SNCharacter.hikari();
          case '真':
            return SNCharacter.maya();
          case '纯':
            return SNCharacter.junna();
          case '露':
            return SNCharacter.mahiru();
          case '蕉':
            return SNCharacter.nana();
          case '克':
            return SNCharacter.kuro();
          case '叶':
            return SNCharacter.futaba();
          case '花':
            return SNCharacter.kaoruko();
        }
        break;
    }
    return null;
  }

  // 输入角色列表返回String
  static String listToString(List<SNCharacter> list) {
    String str = '';
    for (SNCharacter character in list) {
      str += character.name + ',';
    }
    return str;
  }

  static String listToAbbrString(List<SNCharacter> characterList) {
    String str = '';
    for (SNCharacter character in characterList) {
      str += character.nameAbbr + ',';
    }
    return str;
  }

  // 输入String返回角色列表
  static List<SNCharacter> stringToList(String str) {
    if (str != null) {
      return str
          .split(',')
          .where((row) => characterNameRegExp.hasMatch(row))
          .map((record) => SNCharacter.fromString(record))
          .toList();
    } else
      return [];
  }

  static List<SNCharacter> abbrStringToList(String str, String teamName) {
    if (str != null) {
      return str
          .split(',')
          .where((row) => chineseCharRegExp.hasMatch(row))
          .map((record) => SNCharacter.fromAbbrString(record, teamName))
          .toList();
    } else
      return [];
  }

  SNCharacter.honoka()
      : this(
            name: '高坂 穂乃果',
            nameAbbr: '果',
            memberColor: Color(0xFFFFA500),
            grade: '2年生',
            group: 'Printemps',
            teamName: 'μ\'s');
  SNCharacter.eli()
      : this(
            name: '絢瀬 絵里',
            nameAbbr: '绘',
            memberColor: Color(0xFF00FFFF),
            grade: '3年生',
            group: 'BiBi',
            teamName: 'μ\'s');
  SNCharacter.kotori()
      : this(
            name: '南 ことり',
            nameAbbr: '鸟',
            memberColor: Color(0xFF808080),
            grade: '2年生',
            group: 'Printemps',
            teamName: 'μ\'s');
  SNCharacter.umi()
      : this(
            name: '園田 海未',
            nameAbbr: '海',
            memberColor: Color(0xFF0000FF),
            grade: '2年生',
            group: 'lily white',
            teamName: 'μ\'s');
  SNCharacter.rin()
      : this(
            name: '星空 凛',
            nameAbbr: '凛',
            memberColor: Color(0xFFFFFF00),
            grade: '1年生',
            group: 'lily white',
            teamName: 'μ\'s');
  SNCharacter.maki()
      : this(
            name: '西木野 真姫',
            nameAbbr: '姬',
            memberColor: Color(0xFFFF0000),
            grade: '1年生',
            group: 'BiBi',
            teamName: 'μ\'s');
  SNCharacter.nozomi()
      : this(
            name: '東條 希',
            nameAbbr: '希',
            memberColor: Color(0xFF800080),
            grade: '3年生',
            group: 'lily white',
            teamName: 'μ\'s');
  SNCharacter.hanayo()
      : this(
            name: '小泉 花陽',
            nameAbbr: '花',
            memberColor: Color(0xFF008000),
            grade: '1年生',
            group: 'Printemps',
            teamName: 'μ\'s');
  SNCharacter.nico()
      : this(
            name: '矢澤 にこ',
            nameAbbr: '妮',
            memberColor: Color(0xFFFFC0CB),
            grade: '3年生',
            group: 'BiBi',
            teamName: 'μ\'s');
  SNCharacter.chika()
      : this(
            name: '高海 千歌',
            nameAbbr: '千',
            memberColor: Color(0xFFF08300),
            grade: '2年生',
            group: 'CYaRon!',
            teamName: 'Aqours');
  SNCharacter.riko()
      : this(
            name: '桜内 梨子',
            nameAbbr: '梨',
            memberColor: Color(0xFFFF9999),
            grade: '2年生',
            group: 'Guilty Kiss',
            teamName: 'Aqours');
  SNCharacter.kanan()
      : this(
            name: '松浦 果南',
            nameAbbr: '南',
            memberColor: Color(0xFF229977),
            grade: '3年生',
            group: 'AZALEA',
            teamName: 'Aqours');
  SNCharacter.dia()
      : this(
            name: '黒澤 ダイヤ',
            nameAbbr: '黛',
            memberColor: Color(0xFFFF4A4A),
            grade: '3年生',
            group: 'AZALEA',
            teamName: 'Aqours');
  SNCharacter.you()
      : this(
            name: '渡辺 曜',
            nameAbbr: '曜',
            memberColor: Color(0xFF68D1FF),
            grade: '2年生',
            group: 'CYaRon!',
            teamName: 'Aqours');
  SNCharacter.yoshiko()
      : this(
            name: '津島 善子',
            nameAbbr: '善',
            memberColor: Color(0xFF7A7A7A),
            grade: '1年生',
            group: 'Guilty Kiss',
            teamName: 'Aqours');
  SNCharacter.hanamaru()
      : this(
            name: '国木田 花丸',
            nameAbbr: '丸',
            memberColor: Color(0xFFDBB623),
            grade: '1年生',
            group: 'AZALEA',
            teamName: 'Aqours');
  SNCharacter.mari()
      : this(
            name: '小原 鞠莉',
            nameAbbr: '鞠',
            memberColor: Color(0xFFD47AFF),
            grade: '3年生',
            group: 'Guilty Kiss',
            teamName: 'Aqours');
  SNCharacter.ruby()
      : this(
            name: '黒澤 ルビィ',
            nameAbbr: '露',
            memberColor: Color(0xFFFF5599),
            grade: '1年生',
            group: 'CYaRon!',
            teamName: 'Aqours');
  SNCharacter.karen()
      : this(
          name: '愛城 華恋',
          nameAbbr: '恋',
          memberColor: Color(0xFFFB5458),
          teamName: 'スタァライト九九組',
        );
  SNCharacter.hikari()
      : this(
          name: '神楽 ひかり',
          nameAbbr: '光',
          memberColor: Color(0xFF6292E9),
          teamName: 'スタァライト九九組',
        );
  SNCharacter.maya()
      : this(
          name: '天堂 真矢',
          nameAbbr: '真',
          memberColor: Color(0xFFCBC6CC),
          teamName: 'スタァライト九九組',
        );
  SNCharacter.junna()
      : this(
          name: '星見 純那',
          nameAbbr: '纯',
          memberColor: Color(0xFF95CAEE),
          teamName: 'スタァライト九九組',
        );
  SNCharacter.mahiru()
      : this(
          name: '露崎 まひる',
          nameAbbr: '露',
          memberColor: Color(0xFF61BF99),
          teamName: 'スタァライト九九組',
        );
  SNCharacter.nana()
      : this(
          name: '大場 なな',
          nameAbbr: '蕉',
          memberColor: Color(0xFFFDD162),
          teamName: 'スタァライト九九組',
        );

  SNCharacter.kuro()
      : this(
          name: '西條 クロディーヌ',
          nameAbbr: '克',
          memberColor: Color(0xFFFE9952),
          teamName: 'スタァライト九九組',
        );
  SNCharacter.futaba()
      : this(
          name: '石動 双葉',
          nameAbbr: '叶',
          memberColor: Color(0xFF8C67AA),
          teamName: 'スタァライト九九組',
        );
  SNCharacter.kaoruko()
      : this(
          name: '花柳 香子',
          nameAbbr: '花',
          memberColor: Color(0xFFE08696),
          teamName: 'スタァライト九九組',
        );

  //? SNCharacter('Koizumi Hanayo', 0x008000, 'μ\'s'); //这样写会怎么样？

}
