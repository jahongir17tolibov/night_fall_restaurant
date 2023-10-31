import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_categories_dto.dart';
import 'package:night_fall_restaurant/core/result/result_handle.dart';
import 'package:night_fall_restaurant/domain/repository/main_repository/repository.dart';

@immutable
class GetMenuCategoriesUseCase {
  final Repository repository;

  const GetMenuCategoriesUseCase(this.repository);

  Future<List<MenuCategoriesDto>> call() async =>
      await repository.getMenuCategoriesFromDb();
}
