import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes/repository/shared_pref_repository/shared_pref_repository.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.system)) {
    on<ThemeChangedEvent>(_onThemeChanged);
  }

  Future<void> _onThemeChanged(
      ThemeChangedEvent event, Emitter<ThemeState> emit) async {
    await SharedPreferencesStorage.setTheme(event.themeMode);
    emit(ThemeState(themeMode: event.themeMode));
  }
}
