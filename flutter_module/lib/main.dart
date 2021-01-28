import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shonichi_flutter_module/repository/shot_table_repository.dart';

import 'l10n/localization_intl.dart';
import 'widget/loading.dart';
import 'page/home_page.dart';
import 'controller/project_controller.dart';
import 'controller/song_controller.dart';
import 'controller/lyric_controller.dart';
import 'controller/shot_table_controller.dart';
import 'controller/shot_controller.dart';
import 'controller/formation_controller.dart';
import 'controller/migrator_controller.dart';
import 'repository/project_repository.dart';
import 'repository/song_repository.dart';
import 'repository/lyric_repository.dart';
import 'repository/shot_table_repository.dart';
import 'repository/shot_repository.dart';
import 'repository/formation_repository.dart';
import 'repository/attachment_repository.dart';

//-------------------------main()-----------------------------
//------------------------------------------------------------
Future<void> main() async {
  await initServices();
  runApp(GetMaterialApp(
    title: 'shonichi',
    home: HomePage(),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      MyLocalizationsDelegate(),
    ],
    supportedLocales: [
      const Locale('en', 'US'),
      const Locale('zh', 'CN'),
      const Locale('ja', 'JP')
    ],
    localeListResolutionCallback: (locales, supportedLocales) {},
    routes: <String, WidgetBuilder>{
      // '/home_page': (BuildContext context) => HomePage(),
      // '/shot_editor_page': (BuildContext context) => ShotEditorPage(),
      // '/song_info_page': (BuildContext context) => SongInfoPage(),
      // '/formation_editor_page': (BuildContext context) => FormationEditorPage(),
      // '/song_list_page': (BuildContext context) => SongListPage(),
      // '/migrator_page': (BuildContext context) => MigratorPage(),
    },
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

  ProjectController projectController = Get.put(ProjectController(
      projectRepository, songRepository, attachmentRepository));
  SongController songController =
      Get.put(SongController(songRepository, attachmentRepository));
  LyricController lyricController =
      Get.put(LyricController(lyricRepository, attachmentRepository));
  ShotTableController shotTableController = Get.put(ShotTableController());
  ShotController shotController = Get.put(ShotController(
      songRepository, lyricRepository, shotRepository, attachmentRepository));
  FormationController formationController =
      Get.put(FormationController(formationRepository, attachmentRepository));
  MigratorController migratorController = Get.put(MigratorController(
      projectRepository,
      songRepository,
      shotTableRepository,
      shotRepository,
      attachmentRepository));
}

class APIService extends GetxService {
  Future<APIService> init() async {
    LeanCloud.initialize(
        'QLubFJnOVAq4nsON9K6SoV9X-gzGzoHsz', '6XtOUj6cgDICX6kVoHiO0qEs',
        server: 'https://qlubfjno.lc-cn-n1-shared.com',
        queryCache: new LCQueryCache());
    LCLogger.setLevel(LCLogger.DebugLevel);
    return this;
  }
}
