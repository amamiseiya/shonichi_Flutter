import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'l10n/localization_intl.dart';
import 'widget/loading.dart';
import 'page/homepage.dart';
import 'bloc/project/project_crud_bloc.dart';
import 'bloc/project/project_selection_bloc.dart';
import 'bloc/song/song_crud_bloc.dart';
import 'bloc/shot/shot_crud_bloc.dart';
import 'bloc/formation/formation_crud_bloc.dart';
import 'bloc/lyric/lyric_crud_bloc.dart';
import 'bloc/migrator/migrator_bloc.dart';
import 'repository/project_repository.dart';
import 'repository/song_repository.dart';
import 'repository/shot_repository.dart';
import 'repository/lyric_repository.dart';
import 'repository/storage_repository.dart';
import 'repository/formation_repository.dart';

//-------------------------main()-----------------------------
//------------------------------------------------------------
Future<void> main() async {
  final ProjectRepository projectRepository = ProjectRepository();
  final SongRepository songRepository = SongRepository();
  final LyricRepository lyricRepository = LyricRepository();
  final FormationRepository formationRepository = FormationRepository();
  final ShotRepository shotRepository = ShotRepository();
  final StorageRepository storageRepository = StorageRepository();

  LeanCloud.initialize(
      'QLubFJnOVAq4nsON9K6SoV9X-gzGzoHsz', '6XtOUj6cgDICX6kVoHiO0qEs',
      server: 'https://qlubfjno.lc-cn-n1-shared.com',
      queryCache: new LCQueryCache());
  LCLogger.setLevel(LCLogger.DebugLevel);

  LCObject object = LCObject('TestObject');
  object['words'] = 'Hello world!';
  await object.save();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<ProjectCrudBloc>(
      create: (context) =>
          ProjectCrudBloc(projectRepository, songRepository, storageRepository)
            ..add(InitializeApp()),
    ),
    BlocProvider<ProjectSelectionBloc>(
        create: (context) => ProjectSelectionBloc(projectRepository)),
    BlocProvider<SongCrudBloc>(
      create: (context) => SongCrudBloc(
          BlocProvider.of<ProjectCrudBloc>(context),
          BlocProvider.of<ProjectSelectionBloc>(context),
          songRepository,
          storageRepository),
    ),
    BlocProvider<LyricCrudBloc>(
      create: (context) => LyricCrudBloc(BlocProvider.of<SongCrudBloc>(context),
          lyricRepository, storageRepository),
    ),
    BlocProvider<FormationCrudBloc>(
      create: (context) => FormationCrudBloc(
          BlocProvider.of<ProjectSelectionBloc>(context),
          BlocProvider.of<SongCrudBloc>(context),
          BlocProvider.of<LyricCrudBloc>(context),
          formationRepository,
          storageRepository),
    ),
    BlocProvider<ShotCrudBloc>(
      create: (context) => ShotCrudBloc(
          BlocProvider.of<ProjectCrudBloc>(context),
          BlocProvider.of<ProjectSelectionBloc>(context),
          BlocProvider.of<SongCrudBloc>(context),
          BlocProvider.of<LyricCrudBloc>(context),
          songRepository,
          lyricRepository,
          shotRepository,
          storageRepository),
    ),
    BlocProvider<MigratorBloc>(
      create: (context) => MigratorBloc(
          BlocProvider.of<ProjectCrudBloc>(context),
          BlocProvider.of<SongCrudBloc>(context),
          projectRepository,
          songRepository,
          shotRepository,
          storageRepository),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'odottemita_satsuei_flutter',
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
    );
  }
}
