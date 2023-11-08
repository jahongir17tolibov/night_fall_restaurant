import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_entity.dart';

import '../../core/result/result_handle.dart';
import '../repository/main_repository/repository.dart';

@immutable
class GetMenuListUseCase {
  final Repository repository;

  const GetMenuListUseCase(this.repository);

  Future<Result<List<MenuProductsEntity>>> call() async =>
      await repository.getMenuListFromDb();
}
