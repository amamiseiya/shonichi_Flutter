import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shonichi_flutter_module/controllers/formation.dart';
import 'package:shonichi_flutter_module/repositories/formation.dart';

import 'widgets/loading.dart';
import 'pages/home_page.dart';
import 'controllers/project.dart';
import 'controllers/song.dart';
import 'controllers/lyric.dart';
import 'controllers/storyboard.dart';
import 'controllers/shot.dart';
import 'controllers/movement.dart';
import 'controllers/data_migration.dart';
import 'repositories/project.dart';
import 'repositories/song.dart';
import 'repositories/lyric.dart';
import 'repositories/storyboard.dart';
import 'repositories/shot.dart';
import 'repositories/movement.dart';
import 'repositories/attachment.dart';
import 'utils/localization.dart';

//-------------------------main()-----------------------------
//------------------------------------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(GetMaterialApp(
    title: 'shonichi',
    home: HomePage(),
    translations: Messages(),
    locale: window.locale,
    fallbackLocale: Locale('en', 'US'),
  ));
}

Future<void> initServices() async {
  await Get.putAsync(() => APIService().init());

  final ProjectRepository projectRepository = ProjectRepository();
  final SongRepository songRepository = SongRepository();
  final LyricRepository lyricRepository = LyricRepository();
  final MovementRepository movementRepository = MovementRepository();
  final StoryboardRepository storyboardRepository = StoryboardRepository();
  final FormationRepository formationRepository = FormationRepository();
  final ShotRepository shotRepository = ShotRepository();
  final AttachmentRepository attachmentRepository = AttachmentRepository();

  Get.put(ProjectController(
      projectRepository, songRepository, attachmentRepository));
  Get.put(SongController(songRepository, attachmentRepository));
  Get.put(LyricController(lyricRepository, attachmentRepository));
  Get.put(StoryboardController(storyboardRepository));
  Get.put(ShotController(
      songRepository, lyricRepository, shotRepository, attachmentRepository));
  Get.put(FormationController(formationRepository));
  Get.put(MovementController(movementRepository, attachmentRepository));
  Get.put(MigratorController(projectRepository, songRepository, lyricRepository,
      storyboardRepository, shotRepository, attachmentRepository));
}

class APIService extends GetxService {
  Future<APIService> init() async {
    await Firebase.initializeApp();
    LeanCloud.initialize(
        'QLubFJnOVAq4nsON9K6SoV9X-gzGzoHsz', '6XtOUj6cgDICX6kVoHiO0qEs',
        server: 'https://qlubfjno.lc-cn-n1-shared.com',
        queryCache: new LCQueryCache());
    LCLogger.setLevel(LCLogger.DebugLevel);
    return this;
  }
}
