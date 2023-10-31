import 'package:night_fall_restaurant/data/local/entities/menu_categories_dto.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_dto.dart';
import 'package:night_fall_restaurant/data/local/entities/orders_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/tables_password_dto.dart';

import '../../../core/result/result_handle.dart';

abstract class Repository {
  Future<void> syncMenuProductsList();

  Future<Result<List<MenuProductsListDto>>> getMenuListFromDb();

  Future<List<MenuCategoriesDto>> getMenuCategoriesFromDb();

  Future<void> syncTablesPassword();

  Future<Result<List<TablesPasswordDto>>> getTablesPasswordsFromDb();

  Future<List<TablesPasswordDto>> getTablesPasswordsForChecking();

  Future<MenuProductsListDto> getSingleProductFromDb(int productId);
}
