import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/localization_intl.dart';
import 'widget/loading.dart';
import 'page/homepage.dart';
import 'bloc/project_bloc.dart';
import 'bloc/song_bloc.dart';
import 'bloc/shot_bloc.dart';
import 'bloc/formation_bloc.dart';
import 'bloc/lyric_bloc.dart';
import 'bloc/migrator_bloc.dart';
import 'repository/project_repository.dart';
import 'repository/song_repository.dart';
import 'repository/shot_repository.dart';
import 'repository/lyric_repository.dart';
import 'repository/storage_repository.dart';
import 'repository/formation_repository.dart';

//-------------------------main()-----------------------------
//------------------------------------------------------------
void main() {
  final ProjectRepository projectRepository = ProjectRepository();
  final SongRepository songRepository = SongRepository();
  final LyricRepository lyricRepository = LyricRepository();
  final FormationRepository formationRepository = FormationRepository();
  final ShotRepository shotRepository = ShotRepository();
  final StorageRepository storageRepository = StorageRepository();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<ProjectBloc>(
      create: (context) =>
          ProjectBloc(projectRepository, songRepository, storageRepository)
            ..add(InitializeApp()),
    ),
    BlocProvider<SongBloc>(
      create: (context) => SongBloc(BlocProvider.of<ProjectBloc>(context),
          songRepository, storageRepository),
    ),
    BlocProvider<LyricBloc>(
      create: (context) => LyricBloc(BlocProvider.of<SongBloc>(context),
          lyricRepository, storageRepository),
    ),
    BlocProvider<FormationBloc>(
      create: (context) => FormationBloc(
          BlocProvider.of<ProjectBloc>(context),
          BlocProvider.of<SongBloc>(context),
          BlocProvider.of<LyricBloc>(context),
          formationRepository,
          storageRepository),
    ),
    BlocProvider<ShotBloc>(
      create: (context) => ShotBloc(
          BlocProvider.of<ProjectBloc>(context),
          BlocProvider.of<SongBloc>(context),
          BlocProvider.of<LyricBloc>(context),
          songRepository,
          lyricRepository,
          shotRepository,
          storageRepository),
    ),
    BlocProvider<MigratorBloc>(
      create: (context) => MigratorBloc(
          BlocProvider.of<ProjectBloc>(context),
          BlocProvider.of<SongBloc>(context),
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
