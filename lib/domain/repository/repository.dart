import 'package:night_fall_restaurant/data/local/entities/menu_categories_dto.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_dto.dart';
import 'package:night_fall_restaurant/data/local/entities/tables_password_dto.dart';

import '../../data/remote/fire_store_services/fire_store_result.dart';

abstract class Repository {
  Future<void> syncMenuProductsList();

  Future<FireStoreResult<List<MenuProductsListDto>>> getMenuListFromDb();

  Future<FireStoreResult<List<MenuCategoriesDto>>> getMenuCategoriesFromDb();

  Future<void> syncTablesPassword();

  Future<FireStoreResult<List<TablesPasswordDto>>> getTablesPasswordsFromDb();
}
