// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SNMove _$SNMoveFromJson(Map<String, dynamic> json) {
  return SNMove(
    startTime: Duration(microseconds: json['startTime'] as int),
    posX: (json['posX'] as num).toDouble(),
    posY: (json['posY'] as num).toDouble(),
    curveX1X: json['curveX1X'] as int,
    curveX1Y: json['curveX1Y'] as int,
    curveX2X: json['curveX2X'] as int,
    curveX2Y: json['curveX2Y'] as int,
    curveY1X: json['curveY1X'] as int,
    curveY1Y: json['curveY1Y'] as int,
    curveY2X: json['curveY2X'] as int,
    curveY2Y: json['curveY2Y'] as int,
    character: SNCharacter.fromJson(json['character'] as Map<String, dynamic>),
    formationId: json['formationId'] as String,
  );
}

Map<String, dynamic> _$SNMoveToJson(SNMove instance) => <String, dynamic>{
      'startTime': instance.startTime.inMicroseconds,
      'posX': instance.posX,
      'posY': instance.posY,
      'curveX1X': instance.curveX1X,
      'curveX1Y': instance.curveX1Y,
      'curveX2X': instance.curveX2X,
      'curveX2Y': instance.curveX2Y,
      'curveY1X': instance.curveY1X,
      'curveY1Y': instance.curveY1Y,
      'curveY2X': instance.curveY2X,
      'curveY2Y': instance.curveY2Y,
      'character': instance.character.toJson(),
      'formationId': instance.formationId,
    };
