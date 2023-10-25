import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static const String themeKey = 'is_dark';
  static const String tableNumbKey = 'table_number';
  static final Future<SharedPreferences> getInstance =
      SharedPreferences.getInstance();

  Future<int> getTableNumber() async {
    final prefs = await getInstance;
    return prefs.getInt(tableNumbKey) ?? 0;
  }

  Future<bool> setTableNumber(int tableNumber) async {
    final prefs = await getInstance;
    return prefs.setInt(tableNumbKey, tableNumber);
  }

  Future<bool> getAppTheme() async {
    final prefs = await getInstance;
    return prefs.getBool(themeKey) ?? false;
  }

  Future<bool> setAppTheme(bool isDark) async {
    final prefs = await getInstance;
    return prefs.setBool(themeKey, !isDark);
  }
}
