import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_dto.dart';

import '../../data/remote/fire_store_services/fire_store_result.dart';
import '../repository/main_repository/repository.dart';

@immutable
class GetMenuListUseCase {
  final Repository repository;

  const GetMenuListUseCase({required this.repository});

  Future<FireStoreResult<List<MenuProductsListDto>>> call() async =>
      await repository.getMenuListFromDb();
}
