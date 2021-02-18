import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:leancloud_storage/leancloud.dart';

enum KCurveType { X, Y, Z, Rotation, Camera }

class SNMovement {
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

  String characterName;
  String tableId;

  SNMovement(
      {required this.id,
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
      required this.characterName,
      required this.tableId});

  factory SNMovement.initialValue(
          Duration startTime, String characterName, String formationId) =>
      SNMovement(
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
          characterName: characterName,
          tableId: formationId);

  factory SNMovement.fromMap(Map<String, dynamic> map, String id) {
    return SNMovement(
        id: id,
        startTime: Duration(milliseconds: map['startTime']),
        posX: map['posX'],
        posY: map['posY'],
        curveX1X: map['curveX1X'],
        curveX1Y: map['curveX1Y'],
        curveX2X: map['curveX2X'],
        curveX2Y: map['curveX2Y'],
        curveY1X: map['curveY1X'],
        curveY1Y: map['curveY1Y'],
        curveY2X: map['curveY2X'],
        curveY2Y: map['curveY2Y'],
        characterName: map['characterName'],
        tableId: map['tableId']);
  }

  // factory SNMovement.fromLCObject(LCObject object) {
  //   return SNMovement(
  //       id: object.objectId,
  //       startTime: Duration(milliseconds: object['startTime']),
  //       posX: object['posX'],
  //       posY: object['posY'],
  //       curveX1X: object['curveX1X'],
  //       curveX1Y: object['curveX1Y'],
  //       curveX2X: object['curveX2X'],
  //       curveX2Y: object['curveX2Y'],
  //       curveY1X: object['curveY1X'],
  //       curveY1Y: object['curveY1Y'],
  //       curveY2X: object['curveY2X'],
  //       curveY2Y: object['curveY2Y'],
  //       characterName: object['characterName'],
  //       tableId: object['tableId']);
  // }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.inMilliseconds,
      'posX': posX,
      'posY': posY,
      'curveX1X': curveX1X,
      'curveX1Y': curveX1Y,
      'curveX2X': curveX2X,
      'curveX2Y': curveX2Y,
      'curveY1X': curveY1X,
      'curveY1Y': curveY1Y,
      'curveY2X': curveY2X,
      'curveY2Y': curveY2Y,
      'characterName': characterName,
      'tableId': tableId
    };
  }

  // void toLCObject(LCObject object) {
  //   object['startTime'] = startTime.inMilliseconds;
  //   object['posX'] = posX;
  //   object['posY'] = posY;
  //   object['curveX1X'] = curveX1X;
  //   object['curveX1Y'] = curveX1Y;
  //   object['curveX2X'] = curveX2X;
  //   object['curveX2Y'] = curveX2Y;
  //   object['curveY1X'] = curveY1X;
  //   object['curveY1Y'] = curveY1Y;
  //   object['curveY2X'] = curveY2X;
  //   object['curveY2Y'] = curveY2Y;
  //   object['characterName'] = characterName;
  //   object['tableId'] = tableId;
  // }

  // range: ±8 meters
  Offset getMovementPos(Size size) =>
      Offset((posX + 8) / 16 * size.width, (4.5 - posY) / 9 * size.height);

  void setMovementPos(Offset offset, Size size) {
    posX = (offset.dx / size.width * 16) - 8.0;
    posY = 4.5 - (offset.dy / size.height * 9);
  }

  void checkMovementPos() {
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

  Offset getMovementPoint(KCurveType kCurveType, int pointNumber, Size size) {
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

  void setMovementPoint(
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

  void checkMovementPoint(KCurveType kCurveType) {
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
