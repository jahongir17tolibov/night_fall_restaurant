import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static const String themeKey = 'is_dark';
  static final Future<SharedPreferences> getInstance =
      SharedPreferences.getInstance();

  Future<bool> getAppTheme() async {
    final prefs = await getInstance;
    return prefs.getBool(themeKey) ?? false;
  }

  Future<bool> setAppTheme(bool isDark) async {
    final prefs = await getInstance;
    return prefs.setBool(themeKey, !isDark);
  }
}
