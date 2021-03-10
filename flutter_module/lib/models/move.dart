import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/character.dart';

part 'move.g.dart';

enum KCurveType { X, Y, Z, Rotation, Camera }

@JsonSerializable(explicitToJson: true)
class SNMove {
  @JsonKey(ignore: true)
  String id;

  Duration startTime;
  double posX;
  double posY;
  int curveX1X;
  int curveX1Y;
  int curveX2X;
  int curveX2Y;
  int curveY1X;
  int curveY1Y;
  int curveY2X;
  int curveY2Y;

  SNCharacter character;
  String formationId;

  SNMove(
      {this.id = 'initial',
      required this.startTime,
      required this.posX,
      required this.posY,
      required this.curveX1X,
      required this.curveX1Y,
      required this.curveX2X,
      required this.curveX2Y,
      required this.curveY1X,
      required this.curveY1Y,
      required this.curveY2X,
      required this.curveY2Y,
      required this.character,
      required this.formationId});

  factory SNMove.initialValue(
          Duration startTime, SNCharacter character, String formationId) =>
      SNMove(
          id: 'initial',
          startTime: startTime,
          posX: 0.0,
          posY: 0.0,
          curveX1X: 0,
          curveX1Y: 0,
          curveX2X: 127,
          curveX2Y: 127,
          curveY1X: 0,
          curveY1Y: 0,
          curveY2X: 127,
          curveY2Y: 127,
          character: character,
          formationId: formationId);

  factory SNMove.fromJson(Map<String, dynamic> map, String id) =>
      _$SNMoveFromJson(map)..id = id;

  Map<String, dynamic> toJson() => _$SNMoveToJson(this);

  // range: ±8 meters
  Offset getMovePos(Size size) =>
      Offset((posX + 8) / 16 * size.width, (4.5 - posY) / 9 * size.height);

  void setMovePos(Offset offset, Size size) {
    posX = (offset.dx / size.width * 16) - 8.0;
    posY = 4.5 - (offset.dy / size.height * 9);
  }

  void checkMovePos() {
    if (posX < -8) {
      posX = -8;
    }
    if (posX > 8) {
      posX = 8;
    }
    if (posY < -4.5) {
      posY = -4.5;
    }
    if (posY > 4.5) {
      posY = 4.5;
    }
  }

  Offset getMovePoint(KCurveType kCurveType, int pointNumber, Size size) {
    if (kCurveType == KCurveType.X) {
      if (pointNumber == 0) {
        return Offset((curveX1X + 1) / 128 * size.width,
            (128 - curveX1Y) / 128 * size.height);
      } else if (pointNumber == 1) {
        return Offset((curveX2X + 1) / 128 * size.width,
            (128 - curveX2Y) / 128 * size.height);
      }
    } else if (kCurveType == KCurveType.Y) {
      if (pointNumber == 0) {
        return Offset((curveY1X + 1) / 128 * size.width,
            (128 - curveY1Y) / 128 * size.height);
      } else if (pointNumber == 1) {
        return Offset((curveY2X + 1) / 128 * size.width,
            (128 - curveY2Y) / 128 * size.height);
      }
    }
    throw FormatException('This KCurveType is not supported now');
  }

  void setMovePoint(
      Offset offset, KCurveType kCurveType, int pointNumber, Size size) {
    if (kCurveType == KCurveType.X) {
      if (pointNumber == 0) {
        curveX1X = (offset.dx / size.width * 128).toInt();
        curveX1Y = 128 - (offset.dy / size.width * 128).toInt();
      } else if (pointNumber == 1) {
        curveX2X = (offset.dx / size.width * 128).toInt();
        curveX2Y = 128 - (offset.dy / size.width * 128).toInt();
      }
    } else if (kCurveType == KCurveType.Y) {
      if (pointNumber == 0) {
        curveY1X = (offset.dx / size.width * 128).toInt();
        curveY1Y = 128 - (offset.dy / size.width * 128).toInt();
      } else if (pointNumber == 1) {
        curveY2X = (offset.dx / size.width * 128).toInt();
        curveY2Y = 128 - (offset.dy / size.width * 128).toInt();
      }
    }
  }

  void checkMovePoint(KCurveType kCurveType) {
    if (kCurveType == KCurveType.X) {
      if (curveX1X < 0) {
        curveX1X = 0;
      }
      if (curveX1Y < 0) {
        curveX1Y = 0;
      }
      if (curveX2X < 0) {
        curveX2X = 0;
      }
      if (curveX2Y < 0) {
        curveX2Y = 0;
      }
      if (curveX1X > 127) {
        curveX1X = 127;
      }
      if (curveX1Y > 127) {
        curveX1Y = 127;
      }
      if (curveX2X > 127) {
        curveX2X = 127;
      }
      if (curveX2Y > 127) {
        curveX2Y = 127;
      }
    } else if (kCurveType == KCurveType.Y) {
      if (curveY1X < 0) {
        curveY1X = 0;
      }
      if (curveY1Y < 0) {
        curveY1Y = 0;
      }
      if (curveY2X < 0) {
        curveY2X = 0;
      }
      if (curveY2Y < 0) {
        curveY2Y = 0;
      }
      if (curveY1X > 127) {
        curveY1X = 127;
      }
      if (curveY1Y > 127) {
        curveY1Y = 127;
      }
      if (curveY2X > 127) {
        curveY2X = 127;
      }
      if (curveY2Y > 127) {
        curveY2Y = 127;
      }
    }
  }
}
