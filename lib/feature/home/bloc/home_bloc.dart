import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_categories_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';
import 'package:night_fall_restaurant/data/shared/shared_preferences.dart';
import 'package:night_fall_restaurant/domain/repository/orders_repository/orders_repository.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_menu_categories_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_menu_list_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_menu_products_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_order_products_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_single_product_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_menu_products_use_case.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SyncMenuProductsUseCase syncMenuProductsUseCase;
  final GetMenuListUseCase getMenuListUseCase;
  final GetMenuCategoriesUseCase getMenuCategoriesUseCase;
  final GetSingleProductUseCase getSingleProductUseCase;
  final AppSharedPreferences sharedPreferences;
  final OrdersRepository ordersRepository;
  final GetMenuProductsUseCase getMenuProductsUseCase;
  final GetOrderProductsUseCase getOrderProductsUseCase;

  HomeBloc({
    required this.syncMenuProductsUseCase,
    required this.getMenuListUseCase,
    required this.getMenuCategoriesUseCase,
    required this.getSingleProductUseCase,
    required this.sharedPreferences,
    required this.ordersRepository,
    required this.getOrderProductsUseCase,
    required this.getMenuProductsUseCase,
  }) : super(HomeLoadingState()) {
    on<HomeOnGetMenuListEvent>(_onGetMenuProductsEvent);

    on<HomeOnRefreshEvent>(_onRefreshEvent);

    on<HomeOnInsertOrDeleteOrdersEvent>(_ordersOperations);

    on<HomeOnNavigateBackEvent>(_navigateBackEvent);

    on<HomeOnNavigateToOrdersScreenEvent>(_navigateToOrdersEvent);
  }

  late int _categoryTabLength;

  int get categoryTabLength => _categoryTabLength;

  Future<void> _onGetMenuProductsEvent(
    HomeOnGetMenuListEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    await _getProductsMenu(event, emit);
  }

  Future<void> _onRefreshEvent(
    HomeOnRefreshEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    await _getProductsMenu(event, emit);
  }

  Future<void> _ordersOperations(
    HomeOnInsertOrDeleteOrdersEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final product = await getSingleProductUseCase.call(event.productId);
      final int uniqueFireId = DateTime.now().millisecondsSinceEpoch;
      if (event.state) {
        final OrdersEntity mappedProduct = OrdersEntity.fromMenuProductsListDto(
          menuProductsList: product,
          fireIdUnique: uniqueFireId.toString(),
        );

        await ordersRepository.insertProductToOrdersDb(mappedProduct);
        // shows snack bar message
        emit(
          HomeShowSnackMessageActionState('${product.name} added to orders'),
        );
      } else {
        await ordersRepository
            .deleteProductFromOrderDb(event.productId.toString());
        // shows snack bar message
        emit(HomeShowSnackMessageActionState(
          '${product.name} deleted from orders',
        ));
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _navigateBackEvent(
    HomeOnNavigateBackEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeNavigateBackActionState());
  }

  Future<void> _navigateToOrdersEvent(
    HomeOnNavigateToOrdersScreenEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeNavigateToOrdersScreenState());
  }

  Future<void> _getProductsMenu(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    final syncMenuProducts = await syncMenuProductsUseCase.call();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    try {
      if (hasConnection) {
        syncMenuProducts /* internet bor payt firebasedan datani olib databasega insert yoki update qiladi */;
        await _fetchMenuList(emit);
      } else {
        /* aks holda shunchaki databaseda bor narsani qaytaradi */
        await _fetchMenuList(emit);
      }
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }

  Future<void> _fetchMenuList(Emitter<HomeState> emit) async {
    final menuProducts = await getMenuListUseCase.call();
    final categories = await getMenuCategoriesUseCase.call();
    switch (menuProducts) {
      case SUCCESS():
        {
          _categoryTabLength = categories.length;
          emit(HomeSuccessState(
            menuProducts: menuProducts.data,
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
