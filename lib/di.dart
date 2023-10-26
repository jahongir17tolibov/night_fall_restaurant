import 'package:get_it/get_it.dart';
import 'package:night_fall_restaurant/core/theme/theme_manager.dart';
import 'package:night_fall_restaurant/data/local/db/database_dao.dart';
import 'package:night_fall_restaurant/data/local/db/database_service.dart';
import 'package:night_fall_restaurant/data/local/db/orders_db_dao.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_service_impl.dart';
import 'package:night_fall_restaurant/data/shared/shared_preferences.dart';
import 'package:night_fall_restaurant/domain/repository/orders_repository/orders_repository_impl.dart';
import 'package:night_fall_restaurant/domain/repository/orders_repository/ordres_repository.dart';
import 'package:night_fall_restaurant/domain/use_cases/get_menu_categories_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_menu_products_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_tables_password_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/tables_password_use_case.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant/feature/main_tables/bloc/tables_bloc.dart';

import 'data/remote/fire_store_services/fire_store_service.dart';
import 'domain/repository/main_repository/repository.dart';
import 'domain/repository/main_repository/repository_impl.dart';
import 'domain/use_cases/get_menu_list_use_case.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  /// blocs
  getIt.registerFactory<HomeBloc>(() => HomeBloc(
        syncMenuProductsUseCase: getIt<SyncMenuProductsUseCase>(),
        getMenuListUseCase: getIt<GetMenuListUseCase>(),
        getMenuCategoriesUseCase: getIt<GetMenuCategoriesUseCase>(),
        sharedPreferences: getIt<AppSharedPreferences>(),
      ));

  getIt.registerFactory<TablesBloc>(() => TablesBloc(
        syncTablesPasswordUseCase: getIt<SyncTablesPasswordUseCase>(),
        tablesPasswordUseCase: getIt<TablesPasswordUseCase>(),
        sharedPreferences: getIt<AppSharedPreferences>(),
      ));

  /// repository
  getIt.registerLazySingleton<Repository>(() => RepositoryImpl(
      fireStoreService: getIt<FireStoreService>(), dao: getIt<DataBaseDao>()));

  getIt.registerLazySingleton<OrdersRepository>(
      () => OrdersRepositoryImpl(dao: getIt<OrdersDao>()));

  /// use cases
  getIt.registerLazySingleton<GetMenuListUseCase>(
      () => GetMenuListUseCase(repository: getIt<Repository>()));

  getIt.registerLazySingleton<TablesPasswordUseCase>(
      () => TablesPasswordUseCase(repository: getIt<Repository>()));

  getIt.registerLazySingleton<SyncMenuProductsUseCase>(
      () => SyncMenuProductsUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<SyncTablesPasswordUseCase>(
      () => SyncTablesPasswordUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<GetMenuCategoriesUseCase>(
      () => GetMenuCategoriesUseCase(getIt<Repository>()));

  /// database
  getIt.registerLazySingleton<DataBaseService>(
    () => DataBaseService.getInstance,
  );

  getIt.registerLazySingleton<DataBaseDao>(
      () => DataBaseDao(getIt<DataBaseService>()));

  getIt.registerLazySingleton<OrdersDao>(
      () => OrdersDao(getIt<DataBaseService>()));

  /// others
  getIt.registerLazySingleton<FireStoreService>(() => FireStoreServiceImpl());

  getIt.registerLazySingleton<ThemeManager>(() => ThemeManager());

  getIt.registerLazySingleton<AppSharedPreferences>(
      () => AppSharedPreferences());
}
