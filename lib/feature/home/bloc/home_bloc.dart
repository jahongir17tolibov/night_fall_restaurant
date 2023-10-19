import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_result.dart';

import '../../../core/theme/theme_manager.dart';
import '../../../data/remote/model/get_menu_list_response.dart';
import '../../../data/shared/shared_preferences.dart';
import '../../../domain/use_cases/get_menu_list_use_case.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMenuListUseCase getMenuListUseCase;
  final AppSharedPreferences sharedPreferences;

  HomeBloc({
    required this.getMenuListUseCase,
    required this.sharedPreferences,
  }) : super(HomeLoadingState()) {
    on<HomeOnGetMenuListEvent>(getProductsMenu);

    on<HomeOnGetThemeEvent>(initialSetTheme);
  }

  Future<void> getProductsMenu(
    HomeOnGetMenuListEvent event,
    Emitter<HomeState> emit,
  ) async {
    final menu = await getMenuListUseCase.call();
    try {
      switch (menu) {
        case SUCCESS():
          emit(HomeSuccessState(response: menu.data));
          break;

        case FAILURE():
          emit(HomeErrorState(error: menu.exception.toString()));
          break;
      }
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }

  Future<void> initialSetTheme(
    HomeOnGetThemeEvent event,
    Emitter<HomeState> emit,
  ) async {
    final bool hasDarkTheme = await sharedPreferences.getAppTheme();
    if (hasDarkTheme) {
      emit(ThemeState(ThemeData.dark()));
    } else {
      emit(ThemeState(ThemeData.light()));
    }
  }
}
