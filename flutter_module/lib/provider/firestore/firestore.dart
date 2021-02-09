import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/character.dart';
import '../../model/project.dart';
import '../../model/song.dart';
import '../../model/lyric.dart';
import '../../model/shot_table.dart';
import '../../model/shot.dart';
import '../../model/formation.dart';

part 'project.dart';
part 'song.dart';
part 'lyric.dart';
part 'shot_table.dart';
part 'shot.dart';
part 'formation_table.dart';
part 'formation.dart';

abstract class FirestoreProvider {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
}
