// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static const String THEME_KEY = 'is_dark';
  static const String TABLE_NUMBER_KEY = 'table_number';
  static final Future<SharedPreferences> getInstance =
      SharedPreferences.getInstance();

  Future<int> getTableNumber() async {
    final prefs = await getInstance;
    return prefs.getInt(TABLE_NUMBER_KEY) ?? 1;
  }

  Future<bool> setTableNumber(int tableNumber) async {
    final prefs = await getInstance;
    return prefs.setInt(TABLE_NUMBER_KEY, tableNumber);
  }

  Future<bool> getAppTheme() async {
    final prefs = await getInstance;
    return prefs.getBool(THEME_KEY) ?? false;
  }

  Future<bool> setAppTheme(bool isDark) async {
    final prefs = await getInstance;
    return prefs.setBool(THEME_KEY, !isDark);
  }
}
