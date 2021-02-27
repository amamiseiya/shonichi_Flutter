// @dart=2.9
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
// import 'package:leancloud_storage/leancloud.dart';

import 'widgets/loading.dart';
import 'pages/login.dart';
import 'controllers/auth.dart';
import 'controllers/character.dart';
import 'controllers/project.dart';
import 'controllers/song.dart';
import 'controllers/lyric.dart';
import 'controllers/storyboard.dart';
import 'controllers/shot.dart';
import 'controllers/formation.dart';
import 'controllers/movement.dart';
import 'controllers/data_migration.dart';
import 'repositories/auth.dart';
import 'repositories/project.dart';
import 'repositories/song.dart';
import 'repositories/lyric.dart';
import 'repositories/storyboard.dart';
import 'repositories/shot.dart';
import 'repositories/movement.dart';
import 'repositories/formation.dart';
import 'repositories/asset.dart';
import 'utils/localization.dart';
import 'utils/theme.dart';

//-------------------------main()-----------------------------
//------------------------------------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(GetMaterialApp(
    title: 'shonichi',
    home: LoginPage(),
    theme: NananijiTheme.theme,
    translations: Messages(),
    locale: window.locale,
    fallbackLocale: Locale('en', 'US'),
  ));
}

Future<void> initServices() async {
  await Get.putAsync(() => APIService().init());

  final AuthRepository authRepository = AuthRepository();
  final ProjectRepository projectRepository = ProjectRepository();
  final SongRepository songRepository = SongRepository();
  final LyricRepository lyricRepository = LyricRepository();
  final MovementRepository movementRepository = MovementRepository();
  final StoryboardRepository storyboardRepository = StoryboardRepository();
  final FormationRepository formationRepository = FormationRepository();
  final ShotRepository shotRepository = ShotRepository();
  final AssetRepository assetRepository = AssetRepository();

  Get.put(AuthController(authRepository));
  Get.put(
      ProjectController(projectRepository, songRepository, assetRepository));
  Get.put(SongController(songRepository, assetRepository));
  Get.put(CharacterController(assetRepository));
  Get.put(LyricController(lyricRepository, assetRepository));
  Get.put(StoryboardController(storyboardRepository));
  Get.put(ShotController(
      songRepository, lyricRepository, shotRepository, assetRepository));
  Get.put(FormationController(formationRepository));
  Get.put(MovementController(movementRepository, assetRepository));
  Get.put(DataMigrationController(projectRepository, songRepository,
      lyricRepository, storyboardRepository, shotRepository, assetRepository));
}

class APIService extends GetxService {
  Future<APIService> init() async {
    await Firebase.initializeApp();
    // LeanCloud.initialize(
    //     'QLubFJnOVAq4nsON9K6SoV9X-gzGzoHsz', '6XtOUj6cgDICX6kVoHiO0qEs',
    //     server: 'https://qlubfjno.lc-cn-n1-shared.com',
    //     queryCache: new LCQueryCache());
    // LCLogger.setLevel(LCLogger.DebugLevel);
    return this;
  }
}
