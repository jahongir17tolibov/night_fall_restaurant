import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_dto.dart';

import '../../core/result/result_handle.dart';
import '../repository/main_repository/repository.dart';

@immutable
class GetMenuListUseCase {
  final Repository repository;

  const GetMenuListUseCase({required this.repository});

  Future<Result<List<MenuProductsListDto>>> call() async =>
      await repository.getMenuListFromDb();
}
