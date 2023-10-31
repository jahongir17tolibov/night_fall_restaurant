import 'package:night_fall_restaurant/data/local/entities/menu_categories_dto.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_dto.dart';
import 'package:night_fall_restaurant/data/local/entities/tables_password_dto.dart';
import 'package:night_fall_restaurant/domain/repository/main_repository/repository.dart';

import '../../../data/local/db/database_dao.dart';
import '../../../core/result/result_handle.dart';
import '../../../data/remote/fire_store_services/fire_store_service.dart';

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
    final getCachedMenuCategories = await dao.getCachedMenuCategories();

    /// mapping fireStoreData to Database table
    final mappingMenuProductsList = menuProductsFromFireStore.menu_products.map(
        (data) =>
            MenuProductsListDto.fromMenuProductsListResponse(menuList: data));

    final mappingMenuCategories = menuProductsFromFireStore.menu_categories.map(
        (category) => MenuCategoriesDto.fromMenuProductsListResponse(
            categories: category));

    /// if is menuProductsList table empty insert data to table else update existing data
    for (var data in mappingMenuProductsList) {
      if (getCachedMenuProductsList.isEmpty) {
        await dao.insertMenuProductsList(data);
      } else {
        await dao.updateMenuProductsList(data);
      }
    }

    for (var data in mappingMenuCategories) {
      if (getCachedMenuCategories.isEmpty) {
        await dao.insertMenuCategories(data);
      } else {
        await dao.updateMenuCategoriesList(data);
      }
    }
  }

  @override
  Future<void> syncTablesPassword() async {
    final tablesPasswordFromFireStore =
        await fireStoreService.getTablePasswords();
    for (var it in tablesPasswordFromFireStore) {
      // print(
      //     '##### from fireStore #####${it.tablePassword} and ${it.tableNumber}');
    }

    final getCachedTablesPassword = await dao.getCachedTablesPassword();

    final mappingTablesPassword = tablesPasswordFromFireStore.map((data) {
      // print(
      //     '!!!!! in mapping !!!!!${data.tablePassword} and ${data.tableNumber}');
      return TablesPasswordDto.fromTablesPasswordResponse(tablesResponse: data);
    });

    /// if is tablesPassword table empty insert data to table else update existing data
    for (var data in mappingTablesPassword) {
      if (getCachedTablesPassword.isEmpty) {
        await dao.insertTablesPassword(data);
      } else if (getCachedTablesPassword.isNotEmpty) {
        print('update is works');
        await dao.updateTablesPassword(data);
      }
    }
  }

  @override
  Future<Result<List<MenuProductsListDto>>> getMenuListFromDb() async {
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
  Future<Result<List<TablesPasswordDto>>>
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

  @override
  Future<List<TablesPasswordDto>> getTablesPasswordsForChecking() async =>
      await dao.getCachedTablesPassword();

  @override
  Future<List<MenuCategoriesDto>> getMenuCategoriesFromDb() async {
    try {
      final getMenuCategoriesDto = await dao.getCachedMenuCategories();
      if (getMenuCategoriesDto.isNotEmpty) {
        return getMenuCategoriesDto;
      } else {
        throw Exception('categories List is empty');
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<MenuProductsListDto> getSingleProductFromDb(int productId) async =>
      await dao.getSingleMenuProduct(productId);
}
