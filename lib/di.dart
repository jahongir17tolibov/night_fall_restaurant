import 'package:get_it/get_it.dart';

import 'data/remote/fire_store_service.dart';
import 'domain/repository/repository.dart';
import 'domain/repository/repository_impl.dart';
import 'domain/use_cases/get_menu_list_use_case.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<Repository>(
      () => RepositoryImpl(fireStoreService: getIt<FireStoreService>()));

  getIt.registerLazySingleton<FireStoreService>(() => FireStoreService());

  getIt.registerLazySingleton<GetMenuListUseCase>(
      () => GetMenuListUseCase(repository: getIt<Repository>()));
}
