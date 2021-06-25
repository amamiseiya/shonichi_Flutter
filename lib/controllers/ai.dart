import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'auth.dart';
import '../models/project.dart';
import '../models/shot.dart';
import '../models/song.dart';
import '../models/lyric.dart';
import '../repositories/project.dart';
import '../repositories/song.dart';
import '../repositories/asset.dart';

enum SuggestionType { SameCharacter }

class ShotSuggestion {
  String description;

  ShotSuggestion({required this.description});
}

class ShotSuggestionController extends GetxController {
  ShotSuggestion suggest(SNShot shot, SNLyric lyric) {
    if (shot.characters == lyric.characters) {
      return ShotSuggestion(description: 'SameCharacter');
    }
    throw Exception('');
  }

  Future<ShotSuggestion> suggest2(SNShot shot, SNLyric lyric) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sn_shot')
        .where('shotType', isEqualTo: 'LONGSHOT')
        .get();
    if (snapshot.docs.length < 3) {
      return ShotSuggestion(description: 'MostPopular');
    }
    throw Exception('');
  }
}
