import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_categories_dto.dart';
import 'package:night_fall_restaurant/data/remote/fire_store_services/fire_store_result.dart';
import 'package:night_fall_restaurant/domain/repository/repository.dart';

@immutable
class GetMenuCategoriesUseCase {
  final Repository repository;

  const GetMenuCategoriesUseCase(this.repository);

  Future<FireStoreResult<List<MenuCategoriesDto>>> call() async =>
      await repository.getMenuCategoriesFromDb();
}
