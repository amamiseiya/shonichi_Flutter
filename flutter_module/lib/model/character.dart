import 'package:flutter/material.dart';

import '../util/reg_exp.dart';

class Character {
  String characterName;
  String characterNameAbbr;
  Color memberColor;
  String subordinateKikaku;
  String grade;
  String group;

  Character(
      {this.characterName,
      this.characterNameAbbr,
      this.memberColor,
      this.subordinateKikaku,
      this.grade,
      this.group});

  // 返回按年级排列的企划成员
  static List<Character> membersSortedByGrade(String kikaku) {
    switch (kikaku) {
      case 'μ\'s':
        return [
          Character.rin(),
          Character.maki(),
          Character.hanayo(),
          Character.honoka(),
          Character.kotori(),
          Character.umi(),
          Character.eli(),
          Character.nozomi(),
          Character.nico()
        ];
      case 'Aqours':
        return [
          Character.yoshiko(),
          Character.hanamaru(),
          Character.ruby(),
          Character.chika(),
          Character.riko(),
          Character.you(),
          Character.kanan(),
          Character.dia(),
          Character.mari()
        ];
      case 'スタァライト九九組':
        return [
          Character.karen(),
          Character.hikari(),
          Character.maya(),
          Character.junna(),
          Character.mahiru(),
          Character.nana(),
          Character.kuro(),
          Character.futaba(),
          Character.kaoruko()
        ];
    }
    return [];
  }

  // 输入全名返回角色
  factory Character.fromString(String str) {
    switch (str) {
      case '高坂 穂乃果':
        return Character.honoka();
      case '絢瀬 絵里':
        return Character.eli();
      case '南 ことり':
        return Character.kotori();
      case '園田 海未':
        return Character.umi();
      case '星空 凛':
        return Character.rin();
      case '西木野 真姫':
        return Character.maki();
      case '東條 希':
        return Character.nozomi();
      case '小泉 花陽':
        return Character.hanayo();
      case '矢澤 にこ':
        return Character.nico();
      case '高海 千歌':
        return Character.chika();
      case '桜内 梨子':
        return Character.riko();
      case '松浦 果南':
        return Character.kanan();
      case '黒澤 ダイヤ':
        return Character.dia();
      case '渡辺 曜':
        return Character.you();
      case '津島 善子':
        return Character.yoshiko();
      case '国木田 花丸':
        return Character.hanamaru();
      case '小原 鞠莉':
        return Character.mari();
      case '黒澤 ルビィ':
        return Character.ruby();
      case '愛城 華恋':
        return Character.karen();
      case '神楽 ひかり':
        return Character.hikari();
      case '天堂 真矢':
        return Character.maya();
      case '星見 純那':
        return Character.junna();
      case '露崎 まひる':
        return Character.mahiru();
      case '大場 なな':
        return Character.nana();
      case '西條 クロディーヌ':
        return Character.kuro();
      case '石動 双葉':
        return Character.futaba();
      case '花柳 香子':
        return Character.kaoruko();
    }
    return null;
  }

  factory Character.fromAbbrString(String str, String kikaku) {
    switch (kikaku) {
      case 'μ\'s':
        switch (str) {
          case '果':
            return Character.honoka();
          case '绘':
            return Character.eli();
          case '鸟':
            return Character.kotori();
          case '海':
            return Character.umi();
          case '凛':
            return Character.rin();
          case '姬':
            return Character.maki();
          case '希':
            return Character.nozomi();
          case '花':
            return Character.hanayo();
          case '妮':
            return Character.nico();
        }
        break;
      case 'Aqours':
        switch (str) {
          case '千':
            return Character.chika();
          case '梨':
            return Character.riko();
          case '南':
            return Character.kanan();
          case '黛':
            return Character.dia();
          case '曜':
            return Character.you();
          case '善':
            return Character.yoshiko();
          case '丸':
            return Character.hanamaru();
          case '鞠':
            return Character.mari();
          case '露':
            return Character.ruby();
        }
        break;
      case 'スタァライト九九組':
        switch (str) {
          case '恋':
            return Character.karen();
          case '光':
            return Character.hikari();
          case '真':
            return Character.maya();
          case '纯':
            return Character.junna();
          case '露':
            return Character.mahiru();
          case '蕉':
            return Character.nana();
          case '克':
            return Character.kuro();
          case '叶':
            return Character.futaba();
          case '花':
            return Character.kaoruko();
        }
        break;
    }
    return null;
  }

  // 输入角色列表返回String
  static String listToString(List<Character> list) {
    String str = '';
    for (Character character in list) {
      str += character.characterName + ',';
    }
    return str;
  }

  static String listToAbbrString(List<Character> characterList) {
    String str = '';
    for (Character character in characterList) {
      str += character.characterNameAbbr + ',';
    }
    return str;
  }

  // 输入String返回角色列表
  static List<Character> stringToList(String str) {
    if (str != null) {
      return str
          .split(',')
          .where((row) => characterNameRegExp.hasMatch(row))
          .map((record) => Character.fromString(record))
          .toList();
    } else
      return [];
  }

  static List<Character> abbrStringToList(String str, String kikaku) {
    if (str != null) {
      return str
          .split(',')
          .where((row) => chineseCharRegExp.hasMatch(row))
          .map((record) => Character.fromAbbrString(record, kikaku))
          .toList();
    } else
      return [];
  }

  Character.honoka()
      : this(
            characterName: '高坂 穂乃果',
            characterNameAbbr: '果',
            memberColor: Color(0xFFFFA500),
            subordinateKikaku: 'μ\'s',
            grade: '2年生',
            group: 'Printemps');
  Character.eli()
      : this(
            characterName: '絢瀬 絵里',
            characterNameAbbr: '绘',
            memberColor: Color(0xFF00FFFF),
            subordinateKikaku: 'μ\'s',
            grade: '3年生',
            group: 'BiBi');
  Character.kotori()
      : this(
            characterName: '南 ことり',
            characterNameAbbr: '鸟',
            memberColor: Color(0xFF808080),
            subordinateKikaku: 'μ\'s',
            grade: '2年生',
            group: 'Printemps');
  Character.umi()
      : this(
            characterName: '園田 海未',
            characterNameAbbr: '海',
            memberColor: Color(0xFF0000FF),
            subordinateKikaku: 'μ\'s',
            grade: '2年生',
            group: 'lily white');
  Character.rin()
      : this(
            characterName: '星空 凛',
            characterNameAbbr: '凛',
            memberColor: Color(0xFFFFFF00),
            subordinateKikaku: 'μ\'s',
            grade: '1年生',
            group: 'lily white');
  Character.maki()
      : this(
            characterName: '西木野 真姫',
            characterNameAbbr: '姬',
            memberColor: Color(0xFFFF0000),
            subordinateKikaku: 'μ\'s',
            grade: '1年生',
            group: 'BiBi');
  Character.nozomi()
      : this(
            characterName: '東條 希',
            characterNameAbbr: '希',
            memberColor: Color(0xFF800080),
            subordinateKikaku: 'μ\'s',
            grade: '3年生',
            group: 'lily white');
  Character.hanayo()
      : this(
            characterName: '小泉 花陽',
            characterNameAbbr: '花',
            memberColor: Color(0xFF008000),
            subordinateKikaku: 'μ\'s',
            grade: '1年生',
            group: 'Printemps');
  Character.nico()
      : this(
            characterName: '矢澤 にこ',
            characterNameAbbr: '妮',
            memberColor: Color(0xFFFFC0CB),
            subordinateKikaku: 'μ\'s',
            grade: '3年生',
            group: 'BiBi');
  Character.chika()
      : this(
            characterName: '高海 千歌',
            characterNameAbbr: '千',
            memberColor: Color(0xFFF08300),
            subordinateKikaku: 'Aqours',
            grade: '2年生',
            group: 'CYaRon!');
  Character.riko()
      : this(
            characterName: '桜内 梨子',
            characterNameAbbr: '梨',
            memberColor: Color(0xFFFF9999),
            subordinateKikaku: 'Aqours',
            grade: '2年生',
            group: 'Guilty Kiss');
  Character.kanan()
      : this(
            characterName: '松浦 果南',
            characterNameAbbr: '南',
            memberColor: Color(0xFF229977),
            subordinateKikaku: 'Aqours',
            grade: '3年生',
            group: 'AZALEA');
  Character.dia()
      : this(
            characterName: '黒澤 ダイヤ',
            characterNameAbbr: '黛',
            memberColor: Color(0xFFFF4A4A),
            subordinateKikaku: 'Aqours',
            grade: '3年生',
            group: 'AZALEA');
  Character.you()
      : this(
            characterName: '渡辺 曜',
            characterNameAbbr: '曜',
            memberColor: Color(0xFF68D1FF),
            subordinateKikaku: 'Aqours',
            grade: '2年生',
            group: 'CYaRon!');
  Character.yoshiko()
      : this(
            characterName: '津島 善子',
            characterNameAbbr: '善',
            memberColor: Color(0xFF7A7A7A),
            subordinateKikaku: 'Aqours',
            grade: '1年生',
            group: 'Guilty Kiss');
  Character.hanamaru()
      : this(
            characterName: '国木田 花丸',
            characterNameAbbr: '丸',
            memberColor: Color(0xFFDBB623),
            subordinateKikaku: 'Aqours',
            grade: '1年生',
            group: 'AZALEA');
  Character.mari()
      : this(
            characterName: '小原 鞠莉',
            characterNameAbbr: '鞠',
            memberColor: Color(0xFFD47AFF),
            subordinateKikaku: 'Aqours',
            grade: '3年生',
            group: 'Guilty Kiss');
  Character.ruby()
      : this(
            characterName: '黒澤 ルビィ',
            characterNameAbbr: '露',
            memberColor: Color(0xFFFF5599),
            subordinateKikaku: 'Aqours',
            grade: '1年生',
            group: 'CYaRon!');
  Character.karen()
      : this(
          characterName: '愛城 華恋',
          characterNameAbbr: '恋',
          memberColor: Color(0xFFFB5458),
          subordinateKikaku: 'スタァライト九九組',
        );
  Character.hikari()
      : this(
          characterName: '神楽 ひかり',
          characterNameAbbr: '光',
          memberColor: Color(0xFF6292E9),
          subordinateKikaku: 'スタァライト九九組',
        );
  Character.maya()
      : this(
          characterName: '天堂 真矢',
          characterNameAbbr: '真',
          memberColor: Color(0xFFCBC6CC),
          subordinateKikaku: 'スタァライト九九組',
        );
  Character.junna()
      : this(
          characterName: '星見 純那',
          characterNameAbbr: '纯',
          memberColor: Color(0xFF95CAEE),
          subordinateKikaku: 'スタァライト九九組',
        );
  Character.mahiru()
      : this(
          characterName: '露崎 まひる',
          characterNameAbbr: '露',
          memberColor: Color(0xFF61BF99),
          subordinateKikaku: 'スタァライト九九組',
        );
  Character.nana()
      : this(
          characterName: '大場 なな',
          characterNameAbbr: '蕉',
          memberColor: Color(0xFFFDD162),
          subordinateKikaku: 'スタァライト九九組',
        );

  Character.kuro()
      : this(
          characterName: '西條 クロディーヌ',
          characterNameAbbr: '克',
          memberColor: Color(0xFFFE9952),
          subordinateKikaku: 'スタァライト九九組',
        );
  Character.futaba()
      : this(
          characterName: '石動 双葉',
          characterNameAbbr: '叶',
          memberColor: Color(0xFF8C67AA),
          subordinateKikaku: 'スタァライト九九組',
        );
  Character.kaoruko()
      : this(
          characterName: '花柳 香子',
          characterNameAbbr: '花',
          memberColor: Color(0xFFE08696),
          subordinateKikaku: 'スタァライト九九組',
        );

  //? Character('Koizumi Hanayo', 0x008000, 'μ\'s'); //这样写会怎么样？

}
