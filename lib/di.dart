import 'package:get_it/get_it.dart';
import 'package:night_fall_restaurant/core/theme/theme_manager.dart';
import 'package:night_fall_restaurant/data/local/database_dao.dart';
import 'package:night_fall_restaurant/data/local/database_service.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_service_impl.dart';
import 'package:night_fall_restaurant/data/shared/shared_preferences.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_menu_products_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/sync_tables_password_use_case.dart';
import 'package:night_fall_restaurant/domain/use_cases/tables_password_use_case.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant/feature/main_tables/bloc/tables_bloc.dart';

import 'data/remote/fire_store_services/fire_store_service.dart';
import 'domain/repository/repository.dart';
import 'domain/repository/repository_impl.dart';
import 'domain/use_cases/get_menu_list_use_case.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  /// blocs
  getIt.registerFactory<HomeBloc>(() => HomeBloc(
        syncMenuProductsUseCase: getIt<SyncMenuProductsUseCase>(),
        getMenuListUseCase: getIt<GetMenuListUseCase>(),
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

  /// use cases
  getIt.registerLazySingleton<GetMenuListUseCase>(
      () => GetMenuListUseCase(repository: getIt<Repository>()));

  getIt.registerLazySingleton<TablesPasswordUseCase>(
      () => TablesPasswordUseCase(repository: getIt<Repository>()));

  getIt.registerLazySingleton<SyncMenuProductsUseCase>(
      () => SyncMenuProductsUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<SyncTablesPasswordUseCase>(
      () => SyncTablesPasswordUseCase(getIt<Repository>()));

  /// database
  getIt.registerLazySingleton<DataBaseService>(
    () => DataBaseService.getInstance,
  );

  getIt.registerLazySingleton<DataBaseDao>(
      () => DataBaseDao(myDatabase: getIt<DataBaseService>()));

  /// others
  getIt.registerLazySingleton<FireStoreService>(() => FireStoreServiceImpl());

  getIt.registerLazySingleton<ThemeManager>(() => ThemeManager());

  getIt.registerLazySingleton<AppSharedPreferences>(
      () => AppSharedPreferences());
}
