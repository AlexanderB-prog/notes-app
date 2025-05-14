import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes/bloc/theme_bloc/theme_bloc.dart';
import 'package:notes/notes_list_page.dart';
import 'package:notes/repository/data_repository/data_repository.dart';
import 'package:notes/repository/shared_pref_repository/shared_pref_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MyApp(
      initialThemeMode: await SharedPreferencesStorage.getTheme(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.initialThemeMode,
  });

  final ThemeMode initialThemeMode;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              NotesBloc(dataRepository())..add(LoadNotesEvent()),
        ),
        BlocProvider(
          create: (context) =>
              ThemeBloc()..add(ThemeChangedEvent(initialThemeMode)),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.greenAccent,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.greenAccent,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: state.themeMode,
            home: const NotesListPage(),
          );
        },
      ),
    );
  }
}
