import 'package:get_it/get_it.dart';
import 'package:night_fall_restaurant/core/theme/theme_bloc/theme_bloc.dart';
import 'package:night_fall_restaurant/core/theme/theme_manager.dart';
import 'package:night_fall_restaurant/data/local/database_dao.dart';
import 'package:night_fall_restaurant/data/local/database_service.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_service_impl.dart';
import 'package:night_fall_restaurant/data/shared/shared_preferences.dart';
import 'package:night_fall_restaurant/domain/use_cases/change_table_use_case.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant/feature/main_tables/bloc/tables_bloc.dart';

import 'data/remote/fire_store_services/fire_store_service.dart';
import 'domain/repository/repository.dart';
import 'domain/repository/repository_impl.dart';
import 'domain/use_cases/get_menu_list_use_case.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerFactory<HomeBloc>(() => HomeBloc(
        getMenuListUseCase: getIt<GetMenuListUseCase>(),
        sharedPreferences: getIt<AppSharedPreferences>(),
      ));

  getIt.registerFactory<TablesBloc>(
      () => TablesBloc(changeTableUseCase: getIt<ChangeTableUseCase>()));

  getIt.registerLazySingleton<Repository>(
      () => RepositoryImpl(fireStoreService: getIt<FireStoreService>()));

  getIt.registerLazySingleton<FireStoreService>(() => FireStoreServiceImpl());

  getIt.registerLazySingleton<GetMenuListUseCase>(
      () => GetMenuListUseCase(repository: getIt<Repository>()));

  getIt.registerLazySingleton<ChangeTableUseCase>(
      () => ChangeTableUseCase(repository: getIt<Repository>()));

  getIt.registerLazySingleton<DataBaseService>(
    () => DataBaseService.getInstance,
  );

  getIt.registerLazySingleton<DataBaseDao>(
      () => DataBaseDao(myDatabase: DataBaseService.getInstance));

  getIt.registerLazySingleton<ThemeManager>(() => ThemeManager());

  getIt.registerLazySingleton<AppSharedPreferences>(
      () => AppSharedPreferences());
}
