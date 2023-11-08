import 'package:night_fall_restaurant/data/local/entities/menu_categories_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/table_passwords_entity.dart';

import '../../../core/result/result_handle.dart';

abstract class Repository {
  Future<void> syncMenuProductsList();

  Future<Result<List<MenuProductsEntity>>> getMenuListFromDb();

  Future<List<MenuCategoriesEntity>> getMenuCategoriesFromDb();

  Future<void> syncTablesPassword();

  Future<Result<List<TablePasswordsEntity>>> getTablesPasswordsFromDb();
}
