import 'package:night_fall_restaurant/data/local/models/menu_products_list_dto.dart';
import 'package:night_fall_restaurant/data/local/models/tables_password_dto.dart';
import '../../data/remote/fire_store_services/fire_store_result.dart';

abstract class Repository {
  Future<void> syncMenuProductsList();

  Future<FireStoreResult<List<MenuProductsListDto>>> getMenuListFromDb();

  Future<void> syncTablesPassword();

  Future<FireStoreResult<List<TablesPasswordDto>>> getTablesPasswordsFromDb();
}
