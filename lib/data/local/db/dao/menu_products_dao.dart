import 'package:night_fall_restaurant/data/local/entities/menu_categories_entity.dart';
import 'package:night_fall_restaurant/data/local/entities/menu_products_list_entity.dart';
import 'package:sqflite/sqflite.dart';

class MenuProductsDao {
  final Database database;

  MenuProductsDao(this.database);

  /// insert operations

  Future<void> insertMenuProductsList(MenuProductsEntity menuList) async =>
      await _insertToDatabaseHelper(
        MenuProductsEntity.TABLE_NAME,
        menuList.toMap(),
      );

  Future<void> insertMenuCategories(MenuCategoriesEntity categories) async =>
      await _insertToDatabaseHelper(
        MenuCategoriesEntity.TABLE_NAME,
        categories.toMap(),
      );

  /// get operations

  Future<List<MenuProductsEntity>> getCachedMenuList() async {
    final List<Map<String, dynamic>> query = await _getFromDatabaseHelper(
      tableName: MenuProductsEntity.TABLE_NAME,
      orderBy: '${MenuProductsEntity.CM_PRODUCT_CATEGORY_ID} ASC',
    );
    return query.map((it) => MenuProductsEntity.fromMap(it)).toList();
  }

  Future<List<MenuCategoriesEntity>> getCachedMenuCategories() async {
    final List<Map<String, dynamic>> query = await _getFromDatabaseHelper(
      tableName: MenuCategoriesEntity.TABLE_NAME,
      orderBy: '${MenuCategoriesEntity.CM_ID} ASC',
    );
    return query.map((e) => MenuCategoriesEntity.fromMap(e)).toList();
  }

  Future<MenuProductsEntity> getSingleMenuProduct(int productId) async {
    String sqlQuery = """
      SELECT * FROM ${MenuProductsEntity.TABLE_NAME} WHERE ${MenuProductsEntity.CM_ID} = '$productId'  
    """;
    try {
      final List<Map<String, dynamic>> query =
          await database.rawQuery(sqlQuery);
      if (query.isNotEmpty) {
        return MenuProductsEntity.fromMap(query.first);
      } else {
        throw Exception('Menu product data is Empty');
      }
    } catch (_) {
      rethrow;
    }
  }

  /// update operations

  Future<void> updateMenuProductsList(MenuProductsEntity menuList) async {
    try {
      String sqlQuery = """
    UPDATE ${MenuProductsEntity.TABLE_NAME} 
        SET ${MenuProductsEntity.CM_PRODUCT_NAME} = '${menuList.name}',
            ${MenuProductsEntity.CM_PRICE} = '${menuList.price}',
            ${MenuProductsEntity.CM_IMAGE} = '${menuList.image}',
            ${MenuProductsEntity.CM_WEIGHT} = '${menuList.weight}',
            ${MenuProductsEntity.CM_PRODUCT_CATEGORY_ID} = '${menuList.productCategoryId}'
        WHERE ${MenuProductsEntity.CM_PRODUCT_NAME} = '${menuList.name}'
        """;
      await database.rawQuery(sqlQuery);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateMenuCategoriesList(MenuCategoriesEntity categories) async {
    try {
      String sqlQuery = """
    UPDATE ${MenuCategoriesEntity.TABLE_NAME} 
        SET ${MenuCategoriesEntity.CM_CATEGORY_NAME} = '${categories.categoryName}',
            ${MenuCategoriesEntity.CM_CATEGORY_ID} = '${categories.categoryId}',
      WHERE ${MenuCategoriesEntity.CM_CATEGORY_NAME} = '${categories.categoryName}',
          """;
      await database.rawQuery(sqlQuery);
    } catch (_) {
      rethrow;
    }
  }

  /// delete operations

  Future<void> clearMenuProducts() async {
    try {
      String sqlQuery = """
      DELETE FROM ${MenuProductsEntity.TABLE_NAME}
      """;
      await database.rawDelete(sqlQuery);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> clearMenuCategories() async {
    try {
      String sqlQuery = """
      DELETE FROM ${MenuCategoriesEntity.TABLE_NAME}
      """;
      await database.rawDelete(sqlQuery);
    } catch (_) {
      rethrow;
    }
  }

  /// helper for insert data to database
  Future<void> _insertToDatabaseHelper(
    String tableName,
    Map<String, dynamic> dataValues,
  ) async {
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

  /// helper for get data from database
  Future<List<Map<String, dynamic>>> _getFromDatabaseHelper({
    required String tableName,
    required String orderBy,
  }) async {
    try {
      return await database.query(tableName, orderBy: orderBy);
    } catch (_) {
      rethrow;
    }
  }
}
