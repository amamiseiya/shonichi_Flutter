import 'package:flutter/material.dart';

enum KCurveType { X, Y, Z, Rotation, Camera }

class SNFormation {
  int id;
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
  int tableId;

  SNFormation(
      {this.id,
      this.startTime,
      this.posX,
      this.posY,
      this.curveX1X,
      this.curveX1Y,
      this.curveX2X,
      this.curveX2Y,
      this.curveY1X,
      this.curveY1Y,
      this.curveY2X,
      this.curveY2Y,
      this.characterName,
      this.tableId});

  factory SNFormation.fromMap(Map<String, dynamic> map) {
    return SNFormation(
        id: map['id'],
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

  // range: ±8 meters
  Offset getFormationPos(Size size) =>
      Offset((posX + 8) / 16 * size.width, (4.5 - posY) / 9 * size.height);

  void setFormationPos(Offset offset, Size size) {
    posX = (offset.dx / size.width * 16) - 8.0;
    posY = 4.5 - (offset.dy / size.height * 9);
  }

  void checkFormationPos() {
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

  Offset getFormationPoint(KCurveType kCurveType, int pointNumber, Size size) {
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
  }

  void setFormationPoint(
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

  void checkFormationPoint(KCurveType kCurveType) {
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
