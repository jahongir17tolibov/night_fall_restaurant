import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant/core/theme/theme.dart';

import '../../../data/shared/shared_preferences.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  final AppSharedPreferences sharedPreferences;

  ThemeBloc(this.sharedPreferences) : super(ThemeData.light()) {
    on<InitialThemeSetEvent>((event, emit) async {
      final bool hasDarkTheme = await sharedPreferences.getAppTheme();
      if (hasDarkTheme) {
        emit(ThemeData.dark());
      } else {
        emit(ThemeData.light());
      }
    });

    on<ToggleThemeEvent>((event, emit) async {
      final isDark = state == ThemeData.dark();
      emit(isDark ? ThemeData.light() : ThemeData.dark());
      await sharedPreferences.setAppTheme(isDark);
    });
  }
}
