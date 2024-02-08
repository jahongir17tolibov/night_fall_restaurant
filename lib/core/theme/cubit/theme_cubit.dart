import 'package:bloc/bloc.dart';
import 'package:night_fall_restaurant/data/shared/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final AppSharedPreferences _sharedPrefs;

  ThemeCubit(this._sharedPrefs) : super(ThemeState(AppThemeMode.light));

  Future<void> initializeAppTheme() async {
    final savedTheme = await _sharedPrefs.getAppTheme();
    AppThemeMode initialTheme = savedTheme == AppThemeMode.light.toString()
        ? AppThemeMode.light
        : AppThemeMode.dark;
    emit(ThemeState(initialTheme));
  }

  void toggleAppTheme() {
    final newTheme = state.appThemeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;

    _sharedPrefs.setAppTheme(newTheme.toString());
    emit(ThemeState(newTheme));
  }
}
