part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}


class ThemeChangedEvent extends ThemeEvent {
  final ThemeMode themeMode;

  ThemeChangedEvent(this.themeMode);
}