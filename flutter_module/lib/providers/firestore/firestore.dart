import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../models/character.dart';
import '../../models/project.dart';
import '../../models/song.dart';
import '../../models/lyric.dart';
import '../../models/shot_table.dart';
import '../../models/shot.dart';
import '../../models/formation_table.dart';
import '../../models/formation.dart';

part 'attachment.dart';
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
