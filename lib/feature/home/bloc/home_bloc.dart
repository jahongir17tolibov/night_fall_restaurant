import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_dto.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_menu_categories_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_single_product_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_menu_products_use_case.dart';
import 'package:night_fall_restaurant/utils/ui_components/show_snack_bar.dart';

import '../../../data/local/entities/menu_categories_dto.dart';
import '../../../data/shared/shared_preferences.dart';
import '../../../domain/repository/orders_repository/orders_repository.dart';
import '../../../domain/use_cases/get_menu_list_use_case.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SyncMenuProductsUseCase syncMenuProductsUseCase;
  final GetMenuListUseCase getMenuListUseCase;
  final GetMenuCategoriesUseCase getMenuCategoriesUseCase;
  final GetSingleProductUseCase getSingleProductUseCase;
  final AppSharedPreferences sharedPreferences;
  final OrdersRepository ordersRepository;

  HomeBloc({
    required this.syncMenuProductsUseCase,
    required this.getMenuListUseCase,
    required this.getMenuCategoriesUseCase,
    required this.getSingleProductUseCase,
    required this.sharedPreferences,
    required this.ordersRepository,
  }) : super(HomeLoadingState()) {
    on<HomeOnGetMenuListEvent>(onGetMenuProductsEvent);

    on<HomeOnRefreshEvent>(onRefreshEvent);

    on<HomeOnInsertOrDeleteOrdersEvent>(ordersOperations);

    on<HomeOnNavigateBackEvent>(navigateBackEvent);

    on<HomeOnNavigateToOrdersScreenEvent>(navigateToOrdersEvent);
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

  Future<void> ordersOperations(
    HomeOnInsertOrDeleteOrdersEvent event,
    Emitter<HomeState> emit,
  ) async {
    final product = await getSingleProductUseCase.call(event.productId);
    try {
      if (event.state) {
        final OrdersEntity mappedProduct =
            OrdersEntity.fromMenuProductsListDto(menuProductsList: product);
        await ordersRepository.insertProductToOrdersDb(mappedProduct);
        // shows snack bar message
        emit(
          HomeListenInsertToOrderActionState('${product.name} added to orders'),
        );
      } else {
        await ordersRepository
            .deleteProductFromOrderDb(event.productId.toString());
        // shows snack bar message
        emit(
          HomeListenDeleteFromOrderActionState(
            '${product.name} deleted from orders',
          ),
        );
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> navigateBackEvent(
    HomeOnNavigateBackEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeNavigateBackActionState());
  }

  Future<void> navigateToOrdersEvent(
    HomeOnNavigateToOrdersScreenEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeNavigateToOrdersScreenState());
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
    final categories = await getMenuCategoriesUseCase.call();
    switch (menuProducts) {
      case SUCCESS():
        {
          emit(HomeSuccessState(
            response: menuProducts.data,
            menuCategories: categories,
          ));
        }
        break;

      case FAILURE():
        emit(HomeErrorState(error: menuProducts.exception.toString()));
        break;
    }
  }
}
