import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/attachment.dart';
import '../../models/character.dart';
import '../../models/project.dart';
import '../../models/song.dart';
import '../../models/lyric.dart';
import '../../models/storyboard.dart';
import '../../models/shot.dart';
import '../../models/formation.dart';
import '../../models/movement.dart';

part 'attachment.dart';
part 'project.dart';
part 'song.dart';
part 'lyric.dart';
part 'storyboard.dart';
part 'shot.dart';
part 'formation.dart';
part 'movement.dart';

abstract class FirestoreProvider {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
}
