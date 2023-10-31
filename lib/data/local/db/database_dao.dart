import 'package:night_fall_restaurant/data/local/db/database_service.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_categories_dto.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_dto.dart';
import 'package:night_fall_restaurant/data/local/entities/tables_password_dto.dart';
import 'package:sqflite/sqflite.dart';

import '../../../utils/constants.dart';

class DataBaseDao {
  final DataBaseService myDatabase;

  DataBaseDao(this.myDatabase);

  /// insert operations

  Future<void> insertMenuProductsList(MenuProductsListDto menuList) async =>
      await insertToDatabaseHelper(
        menuProductsTableName,
        menuList.toMap(),
      );

  Future<void> insertMenuCategories(MenuCategoriesDto categories) async =>
      await insertToDatabaseHelper(
        menuCategoriesTableName,
        categories.toMap(),
      );

  Future<void> insertTablesPassword(TablesPasswordDto tablesPassword) async =>
      await insertToDatabaseHelper(
        tablesPasswordsTableName,
        tablesPassword.toMap(),
      );

  /// get operations

  Future<List<MenuProductsListDto>> getCachedMenuList() async {
    final List<Map<String, dynamic>> query = await getFromDatabaseHelper(
      tableName: menuProductsTableName,
      orderBy: 'id ASC',
    );
    return query.map((e) => MenuProductsListDto.fromMap(e)).toList();
  }

  Future<List<MenuCategoriesDto>> getCachedMenuCategories() async {
    final List<Map<String, dynamic>> query = await getFromDatabaseHelper(
      tableName: menuCategoriesTableName,
      orderBy: 'id ASC',
    );
    return query.map((e) => MenuCategoriesDto.fromMap(e)).toList();
  }

  Future<List<TablesPasswordDto>> getCachedTablesPassword() async {
    final List<Map<String, dynamic>> query = await getFromDatabaseHelper(
      tableName: tablesPasswordsTableName,
      orderBy: 'tableNumber ASC',
    );
    return query.map((e) => TablesPasswordDto.fromMap(e)).toList();
  }

  Future<MenuProductsListDto> getSingleMenuProduct(int productId) async {
    final database = await myDatabase.getDb();
    try {
      final List<Map<String, dynamic>> query = await database.rawQuery(
        "SELECT * FROM $menuProductsTableName where id = $productId",
      );
      if (query.isNotEmpty) {
        return MenuProductsListDto.fromMap(query.first);
      } else {
        throw Exception('menu product data is Empty');
      }
    } catch (_) {
      rethrow;
    }
  }

  /// update operations

  Future<void> updateMenuProductsList(MenuProductsListDto menuList) async {
    final database = await myDatabase.getDb();
    const sqlQuery = """UPDATE $menuProductsTableName 
        SET name = ?, price = ?, image = ?, weight = ?, productCategoryId = ? WHERE id = ?""";
    try {
      await database.rawUpdate(sqlQuery, [
        menuList.name,
        menuList.price,
        menuList.image,
        menuList.weight,
        menuList.productCategoryId,
        menuList.id
      ]);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateMenuCategoriesList(MenuCategoriesDto categories) async {
    final database = await myDatabase.getDb();
    const sqlQuery = """UPDATE $menuCategoriesTableName 
        SET categoryName = ?, categoryId = ? WHERE id = ?""";
    try {
      await database.rawUpdate(sqlQuery, [
        categories.categoryName,
        categories.categoryId,
        categories.id,
      ]);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateTablesPassword(TablesPasswordDto tablesPasswords) async {
    final database = await myDatabase.getDb();
    const sqlQuery = """UPDATE $tablesPasswordsTableName 
        SET tableNumber = ?, tablePassword = ? WHERE id = ?""";
    try {
      print('^^^^^^^^^^${tablesPasswords.tablePassword} and ${tablesPasswords.tableNumber}');
      await database.rawQuery(sqlQuery, [
        tablesPasswords.tableNumber,
        tablesPasswords.tablePassword,
        tablesPasswords.id,
      ]);
    } catch (_) {
      rethrow;
    }
  }

  /// helper for insert data to database

  Future<void> insertToDatabaseHelper(
    String tableName,
    Map<String, dynamic> dataValues,
  ) async {
    final database = await myDatabase.getDb();
    try {
      await database.insert(
        tableName,
        dataValues,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      rethrow;
    }
  }

  // helper for get data from database
  Future<List<Map<String, dynamic>>> getFromDatabaseHelper({
    required String tableName,
    required String orderBy,
  }) async {
    final database = await myDatabase.getDb();
    try {
      return await database.query(tableName, orderBy: orderBy);
    } catch (_) {
      rethrow;
    }
  }
}
