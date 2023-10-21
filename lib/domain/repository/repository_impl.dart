import 'package:night_fall_restaurant/data/local/models/menu_products_list_dto.dart';
import 'package:night_fall_restaurant/data/local/models/tables_password_dto.dart';
import 'package:night_fall_restaurant/domain/repository/repository.dart';

import '../../data/local/database_dao.dart';
import '../../data/remote/fire_store_services/fire_store_result.dart';
import '../../data/remote/fire_store_services/fire_store_service.dart';

class RepositoryImpl extends Repository {
  final FireStoreService fireStoreService;
  final DataBaseDao dao;

  RepositoryImpl({required this.fireStoreService, required this.dao});

  final Exception _ifEmptyDataException = Exception(
    "database is empty or check internet connection",
  );

  @override
  Future<void> syncMenuProductsList() async {
    final menuProductsFromFireStore = await fireStoreService.getMenuList();
    final getCachedMenuProductsList = await dao.getCachedMenuList();
    print(getCachedMenuProductsList);

    /// mapping fireStoreData to Database table
    final mappingMenuProductsList = menuProductsFromFireStore.menu_products.map(
        (data) =>
            MenuProductsListDto.fromMenuProductsListResponse(menuList: data));

    /// if is menuProductsList table empty insert data to table else update existing data
    mappingMenuProductsList.forEach((data) {
      if (getCachedMenuProductsList.isEmpty) {
        dao.insertMenuProductsList(data);
      } else {
        dao.updateMenuProductsList(data);
      }
    });
  }

  @override
  Future<void> syncTablesPassword() async {
    final tablesPasswordFromFireStore =
        await fireStoreService.getTablePasswords();
    final getCachedTablesPassword = await dao.getCachedTablesPassword();
    print(getCachedTablesPassword);

    /// mapping fireStoreData to Database table
    final mappingTablesPassword = tablesPasswordFromFireStore.map((data) =>
        TablesPasswordDto.fromTablesPasswordResponse(tablesResponse: data));

    /// if is tablesPassword table empty insert data to table else update existing data
    mappingTablesPassword.forEach((data) {
      if (getCachedTablesPassword.isEmpty) {
        dao.insertTablesPassword(data);
      } else {
        dao.updateTablesPassword(data);
      }
    });
  }

  @override
  Future<FireStoreResult<List<MenuProductsListDto>>> getMenuListFromDb() async {
    try {
      final getMenuProductsDto = await dao.getCachedMenuList();
      if (getMenuProductsDto.isNotEmpty) {
        return SUCCESS(data: getMenuProductsDto);
      } else {
        return FAILURE(exception: _ifEmptyDataException);
      }
    } on Exception catch (e) {
      return FAILURE(exception: e);
    }
  }

  @override
  Future<FireStoreResult<List<TablesPasswordDto>>>
      getTablesPasswordsFromDb() async {
    try {
      final getTablesPasswordDto = await dao.getCachedTablesPassword();
      if (getTablesPasswordDto.isNotEmpty) {
        return SUCCESS(data: getTablesPasswordDto);
      } else {
        return FAILURE(exception: _ifEmptyDataException);
      }
    } on Exception catch (e) {
      return FAILURE(exception: e);
    }
  }
}
