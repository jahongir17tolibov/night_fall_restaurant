part of 'theme_bloc.dart';

@immutable
class ThemeState {
  final ThemeData themeData;

  const ThemeState({required this.themeData});

  static ThemeState get darkTheme => ThemeState(themeData: appDarkTheme);

  static ThemeState get lightTheme => ThemeState(themeData: appLightTheme);
}
