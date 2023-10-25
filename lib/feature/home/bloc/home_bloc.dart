import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_dto.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_result.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_menu_categories_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_menu_products_use_case.dart';

import '../../../data/shared/shared_preferences.dart';
import '../../../domain/use_cases/get_menu_list_use_case.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SyncMenuProductsUseCase syncMenuProductsUseCase;
  final GetMenuListUseCase getMenuListUseCase;
  final GetMenuCategoriesUseCase getMenuCategoriesUseCase;
  final AppSharedPreferences sharedPreferences;

  HomeBloc({
    required this.syncMenuProductsUseCase,
    required this.getMenuListUseCase,
    required this.getMenuCategoriesUseCase,
    required this.sharedPreferences,
  }) : super(HomeLoadingState()) {
    on<HomeOnGetMenuListEvent>(onGetMenuProductsEvent);

    on<HomeOnRefreshEvent>(onRefreshEvent);
  }

  Future<void> onGetMenuProductsEvent(
    HomeOnGetMenuListEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    await getProductsMenu(event, emit);
  }

  Future<void> onRefreshEvent(
    HomeOnRefreshEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    await getProductsMenu(event, emit);
  }

  Future<void> getProductsMenu(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    final syncMenuProducts = await syncMenuProductsUseCase.call();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    try {
      if (hasConnection) {
        syncMenuProducts /* internet bor payt firebasedan datani olib databasega insert yoki update qiladi */;
        await fetchMenuList(emit);
      } else {
        /* aks holda shunchaki databaseda bor narsani qaytaradi */
        await fetchMenuList(emit);
      }
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }

  Future<void> fetchMenuList(Emitter<HomeState> emit) async {
    final menuProducts = await getMenuListUseCase.call();
    switch (menuProducts) {
      case SUCCESS():
        emit(HomeSuccessState(response: menuProducts.data));
        break;

      case FAILURE():
        emit(HomeErrorState(error: menuProducts.exception.toString()));
        break;
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
