import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'widget/loading.dart';
import 'page/home_page.dart';
import 'controller/project.dart';
import 'controller/song.dart';
import 'controller/lyric.dart';
import 'controller/shot_table.dart';
import 'controller/shot.dart';
import 'controller/formation.dart';
import 'controller/migrator.dart';
import 'repository/project.dart';
import 'repository/song.dart';
import 'repository/lyric.dart';
import 'repository/shot_table.dart';
import 'repository/shot.dart';
import 'repository/formation.dart';
import 'repository/attachment.dart';
import 'util/localization.dart';

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
  final FormationRepository formationRepository = FormationRepository();
  final ShotTableRepository shotTableRepository = ShotTableRepository();
  final ShotRepository shotRepository = ShotRepository();
  final AttachmentRepository attachmentRepository = AttachmentRepository();

  Get.put(ProjectController(
      projectRepository, songRepository, attachmentRepository));
  Get.put(SongController(songRepository, attachmentRepository));
  Get.put(LyricController(lyricRepository, attachmentRepository));
  Get.put(ShotTableController());
  Get.put(ShotController(
      songRepository, lyricRepository, shotRepository, attachmentRepository));
  Get.put(FormationController(formationRepository, attachmentRepository));
  Get.put(MigratorController(projectRepository, songRepository, lyricRepository,
      shotTableRepository, shotRepository, attachmentRepository));
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
