import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/models/menu_products_list_dto.dart';

import '../../data/remote/fire_store_services/fire_store_result.dart';
import '../repository/repository.dart';

@immutable
class GetMenuListUseCase {
  final Repository repository;

  const GetMenuListUseCase({required this.repository});

  Future<FireStoreResult<List<MenuProductsListDto>>> call() async =>
      await repository.getMenuListFromDb();
}
