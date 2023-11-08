import 'package:get_it/get_it.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_menu_products_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_order_products_use_case.dart';
import 'package:sqflite/sqflite.dart';
import 'package:night_fall_restaurant/core/theme/theme_manager.dart';
import 'package:night_fall_restaurant/data/local/db/app_database.dart';
import 'package:night_fall_restaurant/data/local/db/dao/menu_products_dao.dart';
import 'package:night_fall_restaurant/data/local/db/dao/orders_db_dao.dart';
import 'package:night_fall_restaurant/data/local/db/dao/tables_password_dao.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_service_impl.dart';
import 'package:night_fall_restaurant/data/shared/shared_preferences.dart';
import 'package:night_fall_restaurant/domain/repository/orders_repository/orders_repository.dart';
import 'package:night_fall_restaurant/domain/repository/orders_repository/orders_repository_impl.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_menu_categories_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_single_product_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/send_orders_to_fire_store_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_menu_products_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_tables_password_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/tables_password_use_case.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant/feature/main_tables/bloc/tables_bloc.dart';
import 'package:night_fall_restaurant/feature/orders/bloc/orders_bloc.dart';

import 'data/remote/fire_store_services/fire_store_service.dart';
import 'domain/repository/main_repository/repository.dart';
import 'domain/repository/main_repository/repository_impl.dart';
import 'domain/use_cases/get_menu_list_use_case.dart';
import 'domain/use_cases/get_tables_password_for_checking_use_case.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  /// blocs
  getIt.registerFactory<HomeBloc>(() => HomeBloc(
        syncMenuProductsUseCase: getIt<SyncMenuProductsUseCase>(),
        getMenuListUseCase: getIt<GetMenuListUseCase>(),
        getMenuCategoriesUseCase: getIt<GetMenuCategoriesUseCase>(),
        getSingleProductUseCase: getIt<GetSingleProductUseCase>(),
        sharedPreferences: getIt<AppSharedPreferences>(),
        ordersRepository: getIt<OrdersRepository>(),
        getOrderProductsUseCase: getIt<GetOrderProductsUseCase>(),
        getMenuProductsUseCase: getIt<GetMenuProductsUseCase>(),
      ));

  getIt.registerFactory<TablesBloc>(() => TablesBloc(
        syncTablesPasswordUseCase: getIt<SyncTablesPasswordUseCase>(),
        tablesPasswordUseCase: getIt<TablesPasswordUseCase>(),
        forChecking: getIt<GetTablesPasswordForCheckingUseCase>(),
        sharedPreferences: getIt<AppSharedPreferences>(),
      ));

  getIt.registerFactory<OrdersBloc>(() => OrdersBloc(
        repository: getIt<OrdersRepository>(),
        sharedPreferences: getIt<AppSharedPreferences>(),
      ));

  /// repository
  getIt.registerLazySingleton<Repository>(() => RepositoryImpl(
        fireStoreService: getIt<FireStoreService>(),
        menuListDao: getIt<MenuProductsDao>(),
        tablesDao: getIt<TablesPasswordDao>(),
      ));

  getIt.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(
        dao: getIt<OrdersDao>(),
        sendOrdersToFireStoreUseCase: getIt<SendOrdersToFireStoreUseCase>(),
      ));

  /// use cases
  getIt.registerLazySingleton<GetMenuListUseCase>(
      () => GetMenuListUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<TablesPasswordUseCase>(
      () => TablesPasswordUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<GetSingleProductUseCase>(
      () => GetSingleProductUseCase(getIt<MenuProductsDao>()));

  getIt.registerLazySingleton<SyncMenuProductsUseCase>(
      () => SyncMenuProductsUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<SyncTablesPasswordUseCase>(
      () => SyncTablesPasswordUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<GetMenuCategoriesUseCase>(
      () => GetMenuCategoriesUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<GetTablesPasswordForCheckingUseCase>(
      () => GetTablesPasswordForCheckingUseCase(getIt<TablesPasswordDao>()));

  getIt.registerLazySingleton<SendOrdersToFireStoreUseCase>(
      () => SendOrdersToFireStoreUseCase(getIt<FireStoreService>()));

  getIt.registerLazySingleton<GetOrderProductsUseCase>(
      () => GetOrderProductsUseCase(getIt<OrdersDao>()));

  getIt.registerLazySingleton<GetMenuProductsUseCase>(
      () => GetMenuProductsUseCase(getIt<MenuProductsDao>()));

  /// database
  getIt.registerSingleton<AppDatabase>(AppDatabase.getInstance);

  getIt.registerSingletonAsync<Database>(
      () => getIt<AppDatabase>().getDatabase());

  getIt.registerLazySingleton<MenuProductsDao>(
      () => MenuProductsDao(getIt<Database>()));

  getIt.registerLazySingleton<TablesPasswordDao>(
      () => TablesPasswordDao(getIt<Database>()));

  getIt.registerLazySingleton<OrdersDao>(() => OrdersDao(getIt<Database>()));

  /// others
  getIt.registerLazySingleton<FireStoreService>(() => FireStoreServiceImpl());

  getIt.registerLazySingleton<ThemeManager>(() => ThemeManager());

  getIt.registerLazySingleton<AppSharedPreferences>(
      () => AppSharedPreferences());
}
