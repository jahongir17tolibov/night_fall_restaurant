import 'package:flutter/cupertino.dart';
import 'package:night_fall_restaurant/data/local/db/dao/menu_products_dao.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_entity.dart';

@immutable
class GetMenuProductsUseCase {
  final MenuProductsDao dao;

  const GetMenuProductsUseCase(this.dao);

  Future<List<MenuProductsEntity>> call() async =>
      await dao.getCachedMenuList();
}
